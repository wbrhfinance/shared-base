# New PC Setup Runbook

> Moved 2026-06-11 from OneDrive `Business\AI\new-pc-setup-runbook.md` into shared-base.
> Paths updated to the canonical `C:\Code` root. The repo list in Phase 5 is the minimum
> set; the full current map lives in `00-shared-base.md` (Repository and folder map).

Step-by-step for setting up the Cape-issued new PC. Allow about 2 hours, mostly install waits and OneDrive sync.

---

## Phase 1: First boot and OS hygiene

1. Boot the new PC. Sign in with whatever local Windows account Cape set up.
2. Run Windows Update until nothing else is pending. Reboot when prompted.
3. Turn on BitLocker. Start menu, type "Manage BitLocker", turn on for C:. Save the recovery key somewhere outside this PC (1Password, paper, or another secure location).
4. Confirm auto-updates are on: Settings, Windows Update, Advanced options.

## Phase 2: Personal accounts only

Critical principle: do not sign into Cape's Outlook, Teams, SharePoint, or Cape-managed Microsoft accounts on this PC.

1. Open the OneDrive icon in the system tray. Sign in with `william@brhfinance.com`.
2. Accept the default local location (`C:\Users\<name>\OneDrive`).
3. In OneDrive settings, Account, Choose folders. Sync only `Business\` for now.
4. Let OneDrive run in the background. The first sync of `Business\AI\` takes 15-30 minutes depending on connection.
5. While that runs, continue with Phase 3.

## Phase 3: Browser

1. Install Chrome.
2. Create a dedicated Chrome profile named "Cape work" (or whatever). Sign that profile into your personal Google account.
3. Install the Claude extension if you use Claude-in-Chrome.

Do not install Cape-specific browser extensions or password manager vaults that hold Cape secrets on this PC.

## Phase 4: Dev tools

Open Windows PowerShell as administrator:

```powershell
winget install --id Git.Git -e
winget install --id Microsoft.VisualStudioCode -e
winget install --id OpenJS.NodeJS.LTS -e
winget install --id Python.Python.3.12 -e
winget install --id pnpm.pnpm -e
```

Close PowerShell, open Git Bash. Configure git:

```bash
git config --global user.name "William Bowdler-Raynar"
git config --global user.email "william@brhfinance.com"
git config --global core.autocrlf false
git config --global core.eol lf
```

Generate SSH key:

```bash
ssh-keygen -t ed25519 -C "william@brhfinance.com"
cat ~/.ssh/id_ed25519.pub
```

Copy the printed key. On `github.com`, top-right avatar, Settings, SSH and GPG keys, New SSH key. Paste, name it "Cape new PC", save.

Test:

```bash
ssh -T git@github.com
# Should say "Hi wbrhfinance! You've successfully authenticated"
```

## Phase 5: Clone the repos

Canonical root is `C:\Code` (not a user-home path). Mirror the folder layout exactly:

```bash
mkdir -p /c/Code/cape /c/Code/brh /c/Code/bin
cd /c/Code

git clone git@github.com:wbrhfinance/shared-base.git shared-base
git clone git@github.com:CapeCapitalDev/Cape-Toolbox.git cape/cape-toolbox
git clone git@github.com:wbrhfinance/brh-toolbox.git brh/brh-toolbox
git clone git@github.com:wbrhfinance/wbr-market-dashboard.git brh/wbr-market-dashboard
```

Clone the remaining repos as needed (see the Repository and folder map in `00-shared-base.md`).

For the dashboard, install its dependencies (only needed when you want to run it locally):

```bash
cd brh/wbr-market-dashboard
pnpm install
```

## Phase 6: VS Code setup

1. Open VS Code.
2. Sign in with your GitHub account (top-right account icon). Enables Settings Sync.
3. Install extensions: GitLens, GitHub Pull Requests, Python, ESLint, Prettier, Markdown All in One.
4. File, Open Folder, open each cloned folder to confirm they load cleanly.
5. Optional: create multi-root workspaces (Cape.code-workspace, BRH.code-workspace) saved in `C:\Code\`.

## Phase 7: Claude Cowork

1. Install Cowork desktop from claude.com.
2. Sign in with your Cape Claude account.
3. Paste your custom instructions. Copy from your old PC's Cowork settings, Custom Instructions field, paste into the new PC's same place.
4. Reinstall plugins and any custom skills that live outside the repos.
5. Connect MCPs:
   - **External research**: Perplexity, ChatGPT, Grok
   - **Cape data adapters** (already in cape-toolbox): Yahoo Finance, FRED, alpha-vantage, polymarket
   - **Anything else you use day to day from external sources**

   Do NOT connect Cape Slack, Teams, SharePoint, or Outlook on this PC.

6. Mount folders in Cowork:
   - `C:\Code\` (toolbox repos)
   - `C:\Users\<name>\OneDrive\Business\Cape Capital\` (research source data, if needed)

## Phase 8: Verify

1. In Cowork, start a new session. Mount `C:\Code`. Ask Claude to summarise cape-toolbox. It should pick up `CLAUDE.md` and report the layout.
2. Same with `brh-toolbox`.
3. Open VS Code on `wbr-market-dashboard`. Run `pnpm dev` (check `package.json` for the right script name) and confirm the dashboard loads in a browser.
4. Try a small commit and push from one of the repos to confirm git auth works end to end.
5. Set up the scheduled task for `C:\Code\bin\daily-pull.ps1` (Task Scheduler, daily 08:00).

## Phase 9: Decommission the old PC

Once the new PC is fully working:

1. Push anything still uncommitted from `C:\Code` on the old PC. Run `C:\Code\bin\sync-status.ps1` to check.
2. Sign out of OneDrive on the old PC.
3. Wipe Claude credentials and any browser profiles holding personal logins.
4. Hand the old PC back to Cape or wipe it per their policy.

---

## Things to consciously NOT do on the new PC

- Sign into Cape Outlook, Teams, or SharePoint.
- Connect Cape internal MCPs to Claude (Slack, Teams, internal data sources).
- Import Cape password vaults.
- Sync any Cape-managed OneDrive (the one tied to your Cape email).
