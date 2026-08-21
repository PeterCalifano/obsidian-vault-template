---
type: procedure
status: active
created: 2026-08-22
tags:
  - how-to
---

# Note conventions

Every structured note starts with a small block of properties. These make
notes easier to filter, search, and understand later without creating a large
taxonomy that nobody maintains.

## Properties

| Property | Meaning | Example |
| --- | --- | --- |
| `type` | What kind of note this is | `experiment` |
| `project` | Optional project link | `"[[Example project]]"` |
| `status` | Where the note stands | `active` |
| `created` | Date written | `2026-08-22` |
| `tags` | Free-form keywords | `research`, `planning` |

## Types

| Value | Use it for |
| --- | --- |
| `note` | A general note or idea |
| `project` | The overview page for a project |
| `experiment` | One trial, test, or measurement |
| `meeting` | Minutes from one meeting |
| `decision` | A decision and its reasoning |
| `reference` | A paper, article, standard, or external source |
| `procedure` | Step-by-step instructions |

## Statuses

| Value | Meaning |
| --- | --- |
| `draft` | Started but not ready to rely on |
| `active` | Current and in use |
| `completed` | Finished and still accurate |
| `superseded` | Replaced by a newer note |
| `archived` | No longer active but worth keeping |

Use a template to pre-fill the properties. Keep the vocabulary stable unless
the vault has a deliberate reason to change it.

## Related notes

Add links in a `Related` section when another note provides context, records a
decision, or continues the subject. Link to the source of truth instead of
duplicating it.

## External resources

Keep large files outside the Markdown repository and add links in an
`External resources` section. See [[External resources]].

## Related

- [[README]]
- [[Action items]]
