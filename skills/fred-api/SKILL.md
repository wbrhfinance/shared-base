---
name: fred-api
description: "FRED (Federal Reserve Economic Data) API integration guide. Use this skill whenever working on a project that fetches macroeconomic data — interest rates, spreads, policy rates — from the St. Louis Fed API. Triggers include: 'add FRED data', 'integrate FRED', 'FRED API key', 'rates not showing', 'FRED returning 400', 'set up FRED_API_KEY in Vercel', or any time macroeconomic series from api.stlouisfed.org need to be added, debugged, or configured."
---

# FRED API Integration

Reference guide for adding FRED as a data source, setting the API key in Vercel, and debugging connectivity.

---

## Getting a FRED API Key

Register at https://fred.stlouisfed.org/docs/api/api_key.html — the key is a **32-character lowercase hex string** (e.g. `abcdef0123456789abcdef0123456789`).

Verify the key works before doing anything else — open this URL in a browser:
```
https://api.stlouisfed.org/fred/series/observations?series_id=DGS10&api_key=YOUR_KEY&file_type=json&limit=1
```
A valid key returns JSON with an `observations` array. A 400 means the key is wrong or absent.

---

## Using the FredClient Adapter

The adapter lives at `packages/fred-adapter/src/index.ts`.

```typescript
import { FredClient } from "packages/fred-adapter/dist/index.js";
const fred = new FredClient(process.env.FRED_API_KEY ?? "");
const series = await fred.fetchSeries("DGS10", { name: "US 10Y", assetClass: "rate" });
```

Always read the key from `process.env.FRED_API_KEY`. Never hardcode it.

---

## Setting FRED_API_KEY in Vercel

**Use the Vercel dashboard — not the CLI.** The CLI interactive prompt silently truncates pasted values.

1. Go to: `vercel.com/<org>/<project>/settings/environment-variables`
2. Click **Add Environment Variable**
3. Fill in **two separate fields**:
   - **Key** (top field): `FRED_API_KEY` ← always this exact string
   - **Value** (bottom field): your 32-character key ← paste the key HERE
4. Select **Production** (and Preview if needed)
5. Tick **Sensitive** → yes
6. Save, then **redeploy** — env var changes require a new deployment

**Recurring mistake:** the API key gets typed into the Key field instead of the Value field. This creates a variable named after the key, leaving `FRED_API_KEY` unset. The symptom is `keyLength: 0` or `keyLength: 3` in the debug output below.

---

## Verifying the Key Reaches the Function

Add a temporary debug endpoint to `api/[...path].ts`, deploy, then call it:

```typescript
if (method === "GET" && pathname === "/api/debug/fred") {
  const key = process.env.FRED_API_KEY ?? "";
  const url = new URL("https://api.stlouisfed.org/fred/series/observations");
  url.searchParams.set("series_id", "DGS10");
  url.searchParams.set("api_key", key);
  url.searchParams.set("file_type", "json");
  url.searchParams.set("limit", "1");
  const r = await fetch(url.toString());
  const body = await r.text();
  sendJson(res, 200, {
    keyLength: key.length,
    keyPresent: key.length > 0,
    fredStatus: r.status,
    fredBody: body.slice(0, 300),
  });
  return;
}
```

```powershell
(Invoke-WebRequest -Uri "https://<domain>/api/debug/fred" -UseBasicParsing).Content
```

Expected: `{"keyLength":32,"keyPresent":true,"fredStatus":200,...}`

If `keyLength` is 0 or small: delete the variable in Vercel dashboard, re-add it carefully, redeploy.
**Remove this endpoint once the key is confirmed.**

---

## Common FRED Series IDs

| Series ID | Description | Frequency |
|-----------|-------------|-----------|
| `DGS10` | US 10Y Treasury yield | Daily |
| `DGS2` | US 2Y Treasury yield | Daily |
| `IRLTLT01DEM156N` | Germany 10Y (Bund) | Monthly |
| `IRLTLT01FRM156N` | France 10Y (OAT) | Monthly |
| `IRLTLT01GBM156N` | UK 10Y (Gilt) | Monthly |
| `IRLTLT01JPM156N` | Japan 10Y | Monthly |
| `BAMLH0A0HYM2` | US HY OAS spread | Daily |
| `BAMLC0A0CM` | US IG OAS spread | Daily |
| `BAMLC1A0C35Y` | US 5Y IG OAS spread | Daily |
| `ECBDFR` | ECB Deposit Facility Rate | Daily |

---

## Monthly Data — MoM/MTD Zero Bug

International yield series (e.g. `IRLTLT01DEM156N`) are **monthly**, with observations on the 1st of each month and a ~1-month publication lag. This causes period changes (MoM, MTD) to silently show `0` near month-end, because both "today" and "1 month ago" resolve to the same monthly observation.

**Fix** in `computePeriodValue`:
```typescript
const current = getPriceOnOrBefore(prices, today);
const start   = getPriceOnOrBefore(prices, startDate);
if (!current || !start) return null;
if (current.date === start.date) return null; // same obs → show — not 0
```

This shows `—` instead of a misleading zero.

---

## Exposing the Error Body on HTTP 400

By default the adapter only throws `HTTP 400: Bad Request` with no detail. Patch `packages/fred-adapter/src/index.ts` to expose the response body:

```typescript
if (!res.ok) {
  const body = await res.text().catch(() => "");
  throw new Error(`HTTP ${res.status}: ${res.statusText} — ${body.slice(0, 300)}`);
}
```

Common 400 messages from FRED:
- *"api_key is not a 32 character alpha-numeric lower-case string"* → key wrong or truncated
- Generic `Bad Request` → series_id is invalid or doesn't exist
