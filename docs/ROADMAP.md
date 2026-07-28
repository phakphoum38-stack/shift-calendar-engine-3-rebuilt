# SCE 3.0 Roadmap

| Phase | Scope | Status |
|---|---|---|
| 0 | Foundation, canonical schedule, DI, responsive shell, l10n, CI | Complete |
| 1 | Navigation surfaces, Dashboard, roster, employees, exchange, reports, settings | In progress |
| 2 | Employee directory, shift templates, manual roster builder, persistence, A4 grid | Complete |
| 3 | Rule, conflict, policy, and preview engines | Complete |
| 4 | Shift exchange, approval, audit history, notifications | In progress |
| 5 | Payroll, OT, allowances, monthly summaries, exports | In progress |
| 6 | Excel and Google Sheets import, mapping, relationship engine, diff | In progress |
| 7 | Google Calendar preview, sync, retry, resume, history | In progress |
| 8 | Workspace, hospital/personal profiles, backup and restore | Planned |
| 9 | Integration tests, performance, security, offline support, release | Planned |

## Completion rule

A capability is complete only when its model, repository boundary, service or
use case, controller, UI, documentation, and focused tests are present and the
full CI matrix is green.

## Delivered Phase 2 foundation

- versioned canonical schedule serialization
- staged two-slot local persistence that retains the last valid payload
- persistent employee and shift-template repositories
- searchable employee management
- configurable shift-template management
- manual canonical roster editing with preview and explicit persistence

The monthly report now maps the canonical schedule into a deterministic A4
landscape grid with Thai/English labels, statistics, legend, preview, printing,
and PDF sharing.

## Delivered Phase 4 foundation

- atomic local persistence for cover and swap requests
- submitted, accepted, approved, rejected, and cancelled request states
- overlap and minimum-rest preview before approval
- canonical assignment ownership changes only after approval
- rollback to the previous schedule if final request persistence fails

User identity/roles, attachments, notifications, a full audit timeline,
and role-based approval remain planned.

## Delivered Phase 3 rules

- one central engine detects duplicate and overlapping shifts
- minimum rest and maximum continuous-hour limits
- daily, weekly, and monthly shift-count limits
- configurable policy persisted with application settings
- roster saves and exchange previews use the same policy

## Delivered Phase 5 foundation

- approved-shift base compensation
- overtime threshold and multiplier
- holiday multiplier
- Dashboard base income and OT summary

Allowances, deductions, payroll-period closing, approval history, and exports
remain planned.

## Delivered Phase 6 foundation

- reads the selected Drive file's original `createdTime`
- reads up to 200 current rows from the first worksheet
- configurable header row and exchange-field column mapping
- automatic Thai/English mapping suggestions
- cover-request creation when giver, receiver, date, and shift match the
  canonical employee directory and roster unambiguously
- in-memory CSV, TSV, and XLSX original-file attachment with SHA-256 metadata
- cell and row comparison between the local original and selected Sheet

Historical Google Sheets cell revisions, multi-tab selection, two-way swap
pair import, full roster import/diff, and Excel import remain planned.

## Delivered Phase 7 foundation

- employee-scoped Google Calendar preview
- Create, Update, Delete, and Unchanged classifications
- approved shifts only
- private schedule, employee, and assignment identifiers for idempotent sync
- only events created by this application are updated or deleted

Retry queues, resume checkpoints, sync history, and background sync remain
planned.

## Parallel production migration

The existing `phakphum-calendar` repository remains the active production
migration track. Proven clean components may move there only through reviewed
adapters and without resetting or deleting its legacy compatibility paths.
