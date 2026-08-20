# C:\Code sync — how it works

One system, versioned in this repo, identical on every machine. Set up 2026-08-20.

**The rule: never copy scripts between machines again.** Everything lives in
`shared-base/sync/` and travels via git.

## Components

| File | Role |
|---|---|
| `sync/repos.json` | The single repo list + per-repo mode. Edit here, commit; all machines follow. |
| `sync/pull.ps1` | The sync engine. Scheduled twice daily (CodeSync-AM 09:00, CodeSync-PM 15:00). Syncs shared-base first, so it self-updates before doing anything else. |
| `sync/bootstrap.ps1` | One-time per-machine installer. Idempotent, safe to re-run. |

## Modes

- **sync** (shared-base, cape-toolbox, brh-toolbox): local edits are auto-committed
  (`auto-sync: MACHINE date`), rebased on origin, pushed. These are knowledge bases;
  nothing should ever sit uncommitted for weeks.
- **pull** (all code repos): fast-forward only. Local edits are never touched;
  the repo is reported `[DIRTY]` in the log until you commit and push manually.

## Where to look when something is off

- `C:\Code\bin\last-status.txt` — one line per repo from the last run.
- `C:\Code\bin\pull.log` — rolling history (auto-trimmed).

States that need action: `FAIL` (network/access/URL), `CONFLICT` (rebase conflict,
resolve by hand), `PUSHFAIL` (commit stuck locally, usually credentials),
`DIRTY` (your own uncommitted code edits), `LOCKED` (another git process),
`MISSING` (folder absent and no URL to clone from).

## Adding a machine

Clone shared-base to `C:\Code\shared-base`, then run:

```
powershell -NoProfile -ExecutionPolicy Bypass -File C:\Code\shared-base\sync\bootstrap.ps1
```

It clones every missing repo from `repos.json` and installs the schedule.

## Adding or removing a repo

Edit `sync/repos.json` on any machine, commit (or let auto-sync commit it).
Every other machine applies it on its next run — including cloning a newly
added repo. Removal only stops syncing; it never deletes a local folder.

## GitHub access notes

- Every remote is HTTPS via Git Credential Manager, one credential per machine.
- The Cape PC's GitHub account must be a collaborator on the private
  `wbrhfinance` repos it syncs (this was the cause of the brh-toolbox 404s).
