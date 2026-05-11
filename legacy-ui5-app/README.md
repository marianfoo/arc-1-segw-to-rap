# Legacy UI5 1.84.59 freestyle JS app

Worst-practice 2020-era UI5 app for the SEGW → RAP migration demo.
Connects to the legacy OData V2 service `ZDEMO_MIG_PROJECTS_SRV` on the local SAP test system.

## Run locally

```bash
cd legacy-ui5-app
npm install      # installs @ui5/cli@^2 + ui5-middleware-simpleproxy
npm start        # ui5 serve, opens http://localhost:8080
```

The dev server proxies `/sap/*` to `http://example-s4hana.local:50000`. Basic auth for the proxy is
read from a local `.env` file:

```shell
UI5_MIDDLEWARE_SIMPLE_PROXY_USERNAME=
UI5_MIDDLEWARE_SIMPLE_PROXY_PASSWORD=
```

## What's intentionally awful (the demo material)

| File | Worst practice | Modern equivalent |
|---|---|---|
| `webapp/Component.js` | Hardcoded `SERVICE_URL`, manual `new ODataModel()` in `init` | `manifest.json > sap.app.dataSources` + `sap.ui5.models` declarative |
| `webapp/Component.js` | `jQuery.sap.require("...formatter")` (deprecated since 1.27) | `sap.ui.define` with explicit dependencies |
| `webapp/index.html` | `data-sap-ui-async="false"` synchronous bootstrap | `data-sap-ui-async="true"` |
| `webapp/index.html` | `data-sap-ui-libs` listing libs (legacy) | Use only manifest dependencies |
| `webapp/index.html` | `data-sap-ui-compatVersion="edge"` | Pin to a UI5 version |
| `webapp/model/formatter.js` | `jQuery.sap.declare` + globals on `window` | `sap.ui.define` returning an object |
| `webapp/model/formatter.js` | Used in views via `'window.com.demo.migration.projects.legacy.model.formatter.X'` | Controller-relative `'.formatter.X'` with require'd module |
| `webapp/controller/Master.controller.js` | `var that = this;` closure pattern, `sap.ui.model.Filter` referenced via globals | `const that = this;` (or arrow fns / `bind`), explicit imports |
| `webapp/controller/Master.controller.js` | Path-string parsing to extract `ProjectId` from `/ProjectSet('PRJ-0001')` | `oCtx.getProperty("ProjectId")` |
| `webapp/controller/Detail.controller.js` | `setTimeout(..., 500)` to wait for binding update | Listen to `updateFinished` / `dataReceived` events properly |
| `webapp/controller/Detail.controller.js` | `console.log` everywhere | `Log` from `sap/base/Log` with proper levels (or remove) |
| `webapp/controller/*.js` | No `BaseController` extension | Shared `BaseController` with `getRouter`, `getModel`, `getResourceBundle` helpers |
| `webapp/view/Master.view.xml` | Globals-formatter path: `'window.com.demo...formatter.statusText'` | Controller-relative `'.formatter.statusText'` |
| `webapp/view/Master.view.xml` | `mode="SingleSelectMaster"` + double-binding `selectionChange` + `press` | Either selection OR press — not both |
| `webapp/view/Detail.view.xml` | `IconTabBar` instead of `sap.uxap.ObjectPageLayout` (which fits FE later) | `ObjectPageLayout` with section facets |
| `webapp/view/Detail.view.xml` | TimeEntries tab uses a **separate JSON model `view>/timeEntriesPath`** that gets pointed at a deep path manually | Use the OData binding directly with proper model path |
| `webapp/Component.js` | `useBatch: false` | `useBatch: true` (default since 1.30+) |
| `webapp/Component.js` | No `$metadata` retry, no error handling | Proper `metadataLoaded()` + error propagation |
| Code style | ES5 only, `var`, no arrow functions, no destructuring | ES2018+, then TypeScript |
| Code style | No tests at all | OPA5 + QUnit, then `wdi5` |
| Code style | Mixed German/English comments (`// hat sich nie jemand drum gekümmert`) | English-only, professional, doc comments where useful |

## Smoke test once it runs

| URL/action | Expected |
|---|---|
| `http://localhost:8080/index.html` | Auth dialog → app loads with 5 projects in master list |
| Click PRJ-0001 (Mobile Banking) | Detail page shows ObjectHeader + Tasks tab with 3 tasks |
| Click TSK-0001 in tasks table | Time Entries tab badge updates, shows 4 entries |
| PRJ-0003 → "Approve Project" | Toast "Project PRJ-0003 approved.", header status flips Draft → Approved |

## Why the conversion targets in the talk

The migration skill takes this app + the SEGW backend and produces:

1. **Backend**: SEGW service ➜ RAP service (`ZR_DM_PROJECT` root, projection, BDEF, SRVD, SRVB)
2. **Frontend**: this app ➜ modern UI5 1.147.2 TypeScript app in `../modern-ui5-app/` (same OData
   contract, no BSP redeploy needed during the talk)
3. **Stretch**: modern TS app ➜ Fiori Elements V4 with extensions (using FE annotations from
   the new RAP service)
