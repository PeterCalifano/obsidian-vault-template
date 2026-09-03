# Obsidian Vault Template

A reusable [Obsidian](https://obsidian.md) vault for projects, research,
study, and collaborative work. It keeps notes in plain Markdown so the vault
can be versioned, shared, and edited outside Obsidian.

## What’s included

- A domain-neutral folder structure for knowledge, projects, meetings,
  decisions, references, assets, temporary notes, and archives.
- Seven note templates with consistent YAML properties.
- An [Open actions](Open%20actions.md) dashboard powered by the Tasks plugin.
- Git synchronization configured for periodic pull, commit, and push.
- Community plugins for Git, Tasks, Excalidraw, Terminal, and optional Claudian
  AI assistance.
- An opt-in installer for the complete community-plugin set used by the Food
  Waste Project vault.

## Get started

1. Create a new repository from this template on GitHub, or copy this folder
   to a new location.
2. Clone the new repository if it is hosted on GitHub.
3. Open the folder in Obsidian with **Open folder as vault**.
4. Trust the vault when Obsidian asks whether to enable community plugins.
5. Open [Getting started](Getting%20started.md) and complete the checklist.

The template is intentionally domain-neutral. Rename or remove folders as
your vault requires, but keep `Templates/` and `Assets/` unless you also update
the corresponding Obsidian settings.

## Folder guide

| Content | Location |
| --- | --- |
| General knowledge and guides | `Knowledge/` |
| Projects | `Projects/` |
| Meeting notes | `Meetings/` |
| Decisions | `Decisions/` |
| Papers, links, and sources | `References/` |
| Note templates | `Templates/` |
| Images and small attachments | `Assets/` |
| Temporary or uncategorized notes | `TempMisc/` |
| Finished or obsolete material | `Archive/` |

Keep large documents, datasets, videos, and generated deliverables in a
purpose-built storage location and link to them from the relevant note.

## Daily workflow

- Start structured notes with a template from `Templates/`.
- Write action items in the note where they arise; [Open actions](Open%20actions.md)
  collects every unfinished checkbox automatically.
- Link related notes instead of duplicating information.
- Pull before making large edits when several people share the repository.
- Commit and push after a work session, or let the Git plugin sync on its
  configured schedule.

## Templates and properties

Use **Insert template** from the command palette to start a note. Templates
provide a small, consistent property block:

| Property | Meaning |
| --- | --- |
| `type` | `note`, `project`, `experiment`, `meeting`, `decision`, `reference`, or `procedure` |
| `project` | Optional link to the project note |
| `status` | `draft`, `active`, `completed`, `superseded`, or `archived` |
| `created` | Creation date in `YYYY-MM-DD` format |
| `tags` | Free-form keywords |

See [Note conventions](Knowledge/How-To/Note%20conventions.md) for the full
guidance.

## Tasks and action items

Write ordinary Markdown checkboxes in meetings, projects, decisions, and
other notes. Optional due dates and project tags make the dashboard more
useful:

```markdown
- [ ] Review the draft (Owner) 📅 2026-09-05 #project/example
```

Open [Open actions](Open%20actions.md) for the vault-wide view. See
[Action items](Knowledge/How-To/Action%20items.md) for the convention.

## Git synchronization

The bundled Git plugin is configured for periodic pull, commit, and push. For
manual synchronization, use the command palette:

- `Git: Pull` before starting collaborative work.
- `Git: Commit-and-sync` after making changes.

Do not store passwords, access tokens, or private keys in the vault. Handle
GitHub authentication through Git, GitHub Desktop, or your operating system’s
credential manager.

## Optional plugins

The template starts with these five plugins enabled:

- **Git** for version control and synchronization.
- **Tasks** for live task queries.
- **Excalidraw** for diagrams and free-form drawings.
- **Terminal** for an integrated shell.
- **Claudian** for optional AI-assisted work on the vault.

Claudian is desktop-only and requires a supported command-line provider to be
installed and configured locally. Review plugin permissions before using it on
a shared or sensitive vault.

The repository also carries the exact plugin payloads used by the project vault
for optional installation. The available additional plugins are Image
Converter, Importer, Latex Suite, Linter, Pandoc Plugin, Zotero Integration,
Recent Files, Smart Connections, Advanced Tables, Tag Wrangler, and Templater.
Pandoc, Zotero Integration, and Claudian are desktop-only; Pandoc and Zotero
also require their corresponding local applications or command-line tools.

| Plugin | ID | Bundled version |
| --- | --- | --- |
| Image Converter | `image-converter` | 1.4.6 |
| Importer | `obsidian-importer` | 3.0.0 |
| Latex Suite | `obsidian-latex-suite` | 1.12.8 |
| Linter | `obsidian-linter` | 1.32.0 |
| Pandoc Plugin | `obsidian-pandoc` | 0.4.1 |
| Zotero Integration | `obsidian-zotero-desktop-connector` | 3.2.1 |
| Recent Files | `recent-files-obsidian` | 1.7.10 |
| Smart Connections | `smart-connections` | 4.7.2 |
| Advanced Tables | `table-editor-obsidian` | 0.23.2 |
| Tag Wrangler | `tag-wrangler` | 0.6.5 |
| Templater | `templater-obsidian` | 2.25.0 |

The installer is never run automatically. List the available plugins first:

```bash
./scripts/install-optional-plugins.sh --list
```

Install selected plugins into this template:

```bash
./scripts/install-optional-plugins.sh image-converter table-editor-obsidian
```

Install every available plugin into another vault derived from this template:

```bash
./scripts/install-optional-plugins.sh --all --target /path/to/vault
```

Use `--dry-run` to inspect the changes without writing files. The installer
requires Python 3 to validate and update `community-plugins.json`. Existing
plugin `data.json` settings in the target vault are preserved; bundled settings
are used when a plugin is installed into a fresh target.

## Rules of thumb

- Keep notes small enough to merge comfortably.
- Link instead of copying the same fact into multiple notes.
- Mark outdated notes as `superseded` or `archived` instead of deleting useful history.
- Keep credentials and sensitive data out of the repository.
- Agree on major folder or property changes before applying them to a shared vault.

## Guides

- [Getting started](Getting%20started.md)
- [Note conventions](Knowledge/How-To/Note%20conventions.md)
- [Action items](Knowledge/How-To/Action%20items.md)
- [External resources](References/External%20resources.md)
