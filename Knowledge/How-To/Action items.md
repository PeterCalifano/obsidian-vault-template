---
type: procedure
status: active
created: 2026-08-22
tags:
  - how-to
---

# Action items

Write action items as ordinary Markdown checkboxes in the note where they
arise. [[Open actions]] collects every unfinished checkbox across the vault.

## Format

```markdown
- [ ] Review the draft (Owner) 📅 2026-09-05 #project/example
```

The optional parts are:

| Part | Meaning |
| --- | --- |
| `- [ ]` | The required unfinished checkbox |
| Plain text | The action and, if useful, its owner |
| `📅 YYYY-MM-DD` | Due date used by the dashboard |
| `#project/<slug>` | Project tag used for grouping |

Items without dates or project tags still appear on [[Open actions]]. Tick the
checkbox in its original note when the work is complete.

## Where to put them

- Meeting actions go under the meeting’s `Actions` heading.
- Project actions go under the project’s `Actions` heading.
- Decision follow-ups go under the decision’s `Actions` heading.
- Other actions can live in the relevant note.

The task dashboard is a view, not a second list to maintain manually.

## Related

- [[Open actions]]
- [[Note conventions]]
- [[README]]
