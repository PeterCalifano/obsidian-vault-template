# Obsidian Vault Template

This repository is a reusable [Obsidian](https://obsidian.md) vault template
for projects, research, study, and collaborative work. It stores notes as
plain Markdown files and can be versioned and shared through GitHub.

The template includes consistent note templates, a live task dashboard, Git
sync settings, Excalidraw, Terminal, Tasks, and optional Claudian AI support.

## Create a new vault

1. Create a new repository from this template on GitHub, or copy this folder
   to a new location.
2. Clone the new repository if it is hosted on GitHub.
3. Open the cloned folder in Obsidian with **Open folder as vault**.
4. Trust the vault when Obsidian asks whether to enable community plugins.
5. Open `Getting started` and follow the short checklist.

The template is intentionally domain-neutral. Rename or remove folders as the
new vault requires, but keep `Templates/` and `Assets/` unless you also update
the corresponding Obsidian settings.

## Daily workflow

- Write notes in the folder that best matches their purpose.
- Use a template from `Templates/` when starting a structured note.
- Put action items in the note where they arise; [[Open actions]] collects
  every unfinished checkbox automatically.
- Link related notes rather than duplicating information.
- Pull before making large edits when several people share the repository.
- Commit and push after a work session, or let the Git plugin sync on its
  configured interval.

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
purpose-built storage location and link to them from the note.

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

See [[Note conventions]] for the full guidance.

## Tasks and action items

Write ordinary Markdown checkboxes in meetings, projects, decisions, and
other notes. Optional due dates and project tags make the dashboard more
useful:

```markdown
- [ ] Review the draft (Owner) 📅 2026-09-05 #project/example
```

Open [[Open actions]] for the vault-wide view. See [[Action items]] for the
convention.

## Git synchronization

The bundled Git plugin is configured for periodic pull, commit, and push. For
manual synchronization, use the command palette:

- `Git: Pull` before starting collaborative work.
- `Git: Commit-and-sync` after making changes.

Do not store passwords, access tokens, or private keys in the vault. GitHub
authentication should be handled by Git, GitHub Desktop, or the operating
system credential manager.

## Optional plugins

The repository bundles these community plugins:

- **Git** for version control and synchronization.
- **Tasks** for live task queries.
- **Excalidraw** for diagrams and free-form drawings.
- **Terminal** for an integrated shell.
- **Claudian** for optional AI-assisted work on the vault.

Claudian is desktop-oriented and requires its supported command-line provider
to be installed and configured locally. Review its permissions before using
it on a shared or sensitive vault.

## Rules of thumb

- Keep notes small enough to merge comfortably.
- Link instead of copying the same fact into multiple notes.
- Mark outdated notes as `superseded` or `archived` instead of deleting useful history.
- Do not commit credentials or sensitive data.
- Agree on major folder or property changes before applying them to a shared vault.

## Guides

- [[Getting started]]
- [[Note conventions]]
- [[Action items]]
- [[External resources]]
