---
name: vercel-deploy
description: "Vercel deployment guide for monorepo projects. Use this skill whenever deploying a project to Vercel, setting environment variables, debugging why a deploy didn't take effect, or understanding why GitHub auto-deploy isn't triggering. Triggers include: 'deploy to Vercel', 'Vercel not updating', 'push to prod', 'env var not working in Vercel', 'GitHub auto-deploy broken', 'add API key to Vercel', 'flush cache after deploy', or any time the journey from a local code change to a live Vercel production URL needs to be walked through."
---

# Vercel Deployment Guide

End-to-end reference for deploying a monorepo project to Vercel, managing environment variables, and verifying the deployment worked.

---

## Deploying to Production

GitHub auto-deploy is **not reliably connected** on this project. Always deploy manually from the terminal:

```powershell
# ALWAYS run from the MONOREPO ROOT — never from a subdirectory
cd c:\Code\brh\wbr-market-dashboard
npx vercel --prod
```

Running from `apps/brh-demo` instead of the repo root causes a path-doubling error. The Vercel CLI must be run from the root where `vercel.json` lives (or where the project was linked).

---

## Environment Variables

### Setting via Dashboard (recommended)

The CLI `vercel env add` interactive prompt silently truncates pasted values. Use the dashboard instead:

1. Go to: `vercel.com/<org>/<project>/settings/environment-variables`
2. Click **Add Environment Variable**
3. Two separate fields:
   - **Key** (name of the variable): e.g. `FRED_API_KEY`
   - **Value** (the secret itself): paste your key here
4. Select environment: **Production** (and Preview if needed)
5. Mark **Sensitive** for API keys and secrets
6. **Redeploy after saving** — env var changes do not apply until the next deployment

### Common mistakes

- Pasting the secret into the **Key** field instead of Value — creates a variable named after your secret, leaving the real variable unset
- Forgetting to redeploy after adding or updating a variable
- Using `vercel env add` in PowerShell and getting truncated values

### Listing current variables

```powershell
cd c:\Code\brh\wbr-market-dashboard
npx vercel env ls
```

### Removing a variable

```powershell
npx vercel env rm VARIABLE_NAME production --yes
npx vercel env rm VARIABLE_NAME preview --yes   # if set there too
```

---

## Verifying an Env Var Actually Reaches the Function

`vercel env ls` shows a variable exists but doesn't confirm the value. Add a temporary debug endpoint to verify at runtime:

```typescript
if (method === "GET" && pathname === "/api/debug/env") {
  const val = process.env.MY_VAR ?? "";
  sendJson(res, 200, { length: val.length, present: val.length > 0 });
  return;
}
```

```powershell
(Invoke-WebRequest -Uri "https://<domain>/api/debug/env" -UseBasicParsing).Content
```

If `length` is 0 after a fresh deploy: the value was not saved correctly — delete and re-add via the dashboard.
**Remove the endpoint once confirmed.**

---

## After Every Deploy: Flush Server-Side Cache

The snapshot server has a 10-minute in-memory cache. Warm it immediately after a deploy:

```powershell
Invoke-WebRequest -Uri "https://<domain>/api/snapshot/refresh" -Method POST -UseBasicParsing
```

Expected: `{"success":true,"fetchedAt":...,"rows":38}`

The row count is a useful sanity check — if FRED data is loading correctly, rows should be ~38–40.

---

## Equities Data — Static File vs In-Memory

The equities store (`equities-data.json`) is bundled as a static file at deploy time. In-memory refreshes (`POST /api/equities/refresh`) are **ephemeral** — they reset on every cold start (~15–20 min of inactivity).

To make an equities refresh permanent:

```powershell
# 1. Regenerate the static file (run from apps/brh-demo)
cd c:\Code\brh\wbr-market-dashboard\apps\brh-demo
pnpm run refresh-daily

# 2. Commit and deploy
cd c:\Code\brh\wbr-market-dashboard
git add apps/brh-demo/equities-data.json
git commit -m "chore: refresh equities data $(Get-Date -Format 'yyyy-MM-dd')"
npx vercel --prod
```

Takes about 30 seconds to run. Do this whenever equities data feels stale.

---

## Checking Logs

`vercel logs <deployment-url>` often returns "No logs found" even after requests. More reliable approaches:

1. Hit an API endpoint directly with PowerShell to trigger the function, then check the Vercel dashboard Inspector URL
2. Add `console.log(...)` diagnostics to the serverless function and read them from the Vercel dashboard → Functions tab
3. Use a debug endpoint (see above) to surface diagnostic info directly in the HTTP response

---

## Project Structure Reference

```
c:\Code\brh\wbr-market-dashboard\        ← monorepo root (deploy from here)
  apps\brh-demo\
    vercel.json                           ← build config
    api\[...path].ts                      ← single catch-all serverless function
    equities-data.json                    ← bundled equities static snapshot
    refresh-daily.ts                      ← script to regenerate equities file
  packages\
    fred-adapter\                         ← FRED API client
    yahoo-finance-adapter\                ← Yahoo Finance client
    market-data-core\                     ← shared types
```

Production URL: `https://wbr-market-dashboard-brh-demo.vercel.app`
Vercel project: `wbrhfinances-projects/wbr-market-dashboard-brh-demo`

---

## Deployment Checklist

- [ ] Changes committed and pushed to `main`
- [ ] Run `npx vercel --prod` from the monorepo root
- [ ] Confirm deployment URL and ready state in CLI output
- [ ] If env vars were changed: verify with debug endpoint
- [ ] POST to `/api/snapshot/refresh` to warm the cache
- [ ] Check row count matches expectation (~38–40)
- [ ] If equities changed: run `refresh-daily`, commit, redeploy
