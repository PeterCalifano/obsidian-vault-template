#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
template_root="$(cd -- "$script_dir/.." && pwd)"
bundled_plugin_root="$template_root/.obsidian/plugins"
optional_plugin_root="$template_root/.optional-plugins"
target_root="$template_root"
dry_run=false
list_only=false
install_all=false
requested_ids=()

usage() {
    cat <<'EOF'
Usage:
  scripts/install-optional-plugins.sh --list
  scripts/install-optional-plugins.sh --all [--target VAULT] [--dry-run]
  scripts/install-optional-plugins.sh PLUGIN_ID... [--target VAULT] [--dry-run]

Options:
  --list          List every plugin available from this template.
  --all           Install every available plugin.
  --target PATH   Existing vault to update (defaults to this template).
  --dry-run       Show the changes without writing files.
  --help          Show this help text.

Plugin IDs must be supplied explicitly. Running the script without --all or
plugin IDs performs no installation.
EOF
}

die() {
    printf 'Error: %s\n' "$1" >&2
    exit 1
}

available_plugin_ids() {
    {
        find "$bundled_plugin_root" -mindepth 1 -maxdepth 1 -type d -print 2>/dev/null || true
        find "$optional_plugin_root" -mindepth 1 -maxdepth 1 -type d -print 2>/dev/null || true
    } | while IFS= read -r plugin_dir; do
        if [[ -f "$plugin_dir/manifest.json" ]]; then
            basename -- "$plugin_dir"
        fi
    done | sort -u
}

resolve_plugin_source() {
    local plugin_id="$1"

    if [[ -f "$optional_plugin_root/$plugin_id/manifest.json" ]]; then
        printf '%s\n' "$optional_plugin_root/$plugin_id"
    elif [[ -f "$bundled_plugin_root/$plugin_id/manifest.json" ]]; then
        printf '%s\n' "$bundled_plugin_root/$plugin_id"
    else
        return 1
    fi
}

list_plugins() {
    python3 - "$bundled_plugin_root" "$optional_plugin_root" <<'PY'
import json
import sys
from pathlib import Path

plugins = {}

# Optional payloads are visited after the baseline bundles, so they take
# precedence if a future update intentionally replaces one of them.
for root_name in sys.argv[1:]:
    root = Path(root_name)
    if not root.is_dir():
        continue
    for plugin_dir in sorted(root.iterdir()):
        manifest_path = plugin_dir / "manifest.json"
        if not plugin_dir.is_dir() or not manifest_path.is_file():
            continue
        manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
        plugin_id = manifest.get("id")
        if not isinstance(plugin_id, str) or not plugin_id:
            raise SystemExit(f"Invalid plugin manifest: {manifest_path}")
        plugins[plugin_id] = (
            manifest.get("name", ""),
            manifest.get("version", ""),
            "desktop-only" if manifest.get("isDesktopOnly", False) else "cross-platform",
        )

for plugin_id in sorted(plugins):
    name, version, platform = plugins[plugin_id]
    print(f"{plugin_id}\t{name}\t{version}\t{platform}")
PY
}

validate_community_plugins() {
    local community_file="$1"

    [[ -e "$community_file" ]] || return 0
    [[ -f "$community_file" ]] || die "$community_file exists but is not a regular file"

    python3 - "$community_file" <<'PY'
import json
import sys
from pathlib import Path

path = Path(sys.argv[1])
try:
    value = json.loads(path.read_text(encoding="utf-8"))
except (OSError, json.JSONDecodeError) as exc:
    raise SystemExit(f"Invalid community-plugins.json: {exc}")

if not isinstance(value, list) or any(not isinstance(item, str) for item in value):
    raise SystemExit("community-plugins.json must contain a JSON array of plugin IDs")
PY
}

validate_plugin_manifest() {
    local plugin_id="$1"
    local source_dir="$2"

    python3 - "$plugin_id" "$source_dir/manifest.json" <<'PY'
import json
import sys
from pathlib import Path

expected_id = sys.argv[1]
manifest_path = Path(sys.argv[2])
try:
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
except (OSError, json.JSONDecodeError) as exc:
    raise SystemExit(f"Invalid plugin manifest {manifest_path}: {exc}")

if manifest.get("id") != expected_id:
    raise SystemExit(f"Plugin directory and manifest ID differ: {manifest_path}")
PY
}

copy_plugin() {
    local plugin_id="$1"
    local source_dir="$2"
    local destination_dir="$target_root/.obsidian/plugins/$plugin_id"

    if [[ "$dry_run" == true ]]; then
        printf '[dry-run] install %s from %s\n' "$plugin_id" "$source_dir"
        return 0
    fi

    mkdir -p -- "$destination_dir"
    while IFS= read -r -d '' source_file; do
        local relative_path="${source_file#"$source_dir/"}"
        local destination_file="$destination_dir/$relative_path"

        # Backup files are local runtime artifacts, not plugin payloads.
        [[ "$relative_path" == *.bak ]] && continue

        # A new vault receives the bundled settings. Existing vault settings
        # remain local to that vault and are not overwritten by an install.
        if [[ "$(basename -- "$relative_path")" == "data.json" && -e "$destination_file" ]]; then
            printf 'Preserving existing settings: %s\n' "$destination_file"
            continue
        fi

        mkdir -p -- "$(dirname -- "$destination_file")"
        cp -p -- "$source_file" "$destination_file"
    done < <(find "$source_dir" -type f -print0 | sort -z)
}

update_community_plugins() {
    local community_file="$target_root/.obsidian/community-plugins.json"

    if [[ "$dry_run" == true ]]; then
        printf '[dry-run] merge %d plugin IDs into %s\n' "${#selected_ids[@]}" "$community_file"
        return 0
    fi

    mkdir -p -- "$(dirname -- "$community_file")"
    python3 - "$community_file" "${selected_ids[@]}" <<'PY'
import json
import sys
from pathlib import Path

path = Path(sys.argv[1])
requested_ids = sys.argv[2:]

if path.exists():
    values = json.loads(path.read_text(encoding="utf-8"))
else:
    values = []

for plugin_id in requested_ids:
    if plugin_id not in values:
        values.append(plugin_id)

path.write_text(json.dumps(values, indent=2) + "\n", encoding="utf-8")
PY
}

while (($# > 0)); do
    case "$1" in
        --all)
            install_all=true
            shift
            ;;
        --dry-run)
            dry_run=true
            shift
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        --list)
            list_only=true
            shift
            ;;
        --target)
            (($# >= 2)) || die '--target requires a vault path'
            target_root="$2"
            shift 2
            ;;
        --*)
            die "unknown option: $1"
            ;;
        *)
            requested_ids+=("$1")
            shift
            ;;
    esac
done

if [[ "$list_only" == true ]]; then
    [[ "$install_all" == false && ${#requested_ids[@]} -eq 0 ]] || die '--list cannot be combined with an installation selection'
    command -v python3 >/dev/null 2>&1 || die 'python3 is required to list plugin metadata'
    list_plugins
    exit 0
fi

if [[ "$install_all" == true && ${#requested_ids[@]} -gt 0 ]]; then
    die '--all cannot be combined with explicit plugin IDs'
fi

if [[ "$install_all" == false && ${#requested_ids[@]} -eq 0 ]]; then
    usage >&2
    exit 2
fi

command -v python3 >/dev/null 2>&1 || die 'python3 is required to update community-plugins.json'
[[ -d "$target_root" ]] || die "target vault does not exist: $target_root"
target_root="$(cd -- "$target_root" && pwd)"
target_community_file="$target_root/.obsidian/community-plugins.json"
validate_community_plugins "$target_community_file"

mapfile -t available_ids < <(available_plugin_ids)
selected_ids=()
declare -A seen_ids=()

if [[ "$install_all" == true ]]; then
    selected_ids=("${available_ids[@]}")
else
    for plugin_id in "${requested_ids[@]}"; do
        [[ "$plugin_id" != */* && "$plugin_id" != .* ]] || die "invalid plugin ID: $plugin_id"
        if [[ -z "${seen_ids[$plugin_id]+present}" ]]; then
            selected_ids+=("$plugin_id")
            seen_ids["$plugin_id"]=1
        fi
    done
fi

declare -A source_dirs=()
for plugin_id in "${selected_ids[@]}"; do
    source_dir="$(resolve_plugin_source "$plugin_id" || true)"
    [[ -n "$source_dir" ]] || die "plugin is not available in this template: $plugin_id"
    validate_plugin_manifest "$plugin_id" "$source_dir"
    source_dirs["$plugin_id"]="$source_dir"
done

if [[ "$dry_run" == false ]]; then
    mkdir -p -- "$target_root/.obsidian/plugins"
fi

for plugin_id in "${selected_ids[@]}"; do
    copy_plugin "$plugin_id" "${source_dirs[$plugin_id]}"
done
update_community_plugins

if [[ "$dry_run" == true ]]; then
    printf '[dry-run] no files were changed\n'
else
    printf 'Installed and enabled %d plugin(s) in %s\n' "${#selected_ids[@]}" "$target_root"
fi
