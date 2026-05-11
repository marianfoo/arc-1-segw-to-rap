# SAP Migration Demo Workspace

Open this folder in **Cursor** (or Claude Code, or VS Code) — you've inherited a working SAP
landscape with a legacy SEGW service plus an old UI5 freestyle app, and three skills that walk
you through modernizing both.

## What's already on the SAP system

| | |
|---|---|
| System | `example-s4hana.local:50000` (S/4HANA 2023, NW 7.58, on-prem trial) |
| Client / User | `001` / `DEMOUSER` |
| Legacy backend package | `ZDEMO_MIG` — 3 tables (`ZDM_PROJECT` / `ZDM_TASK` / `ZDM_TIMEENTRY`), seeded with 5 projects / 15 tasks / 25 time entries |
| Legacy SEGW service | `ZDEMO_MIG_PROJECTS_SRV` at `/sap/opu/odata/sap/ZDEMO_MIG_PROJECTS_SRV` — 3 entity sets, 2 navigations (`Tasks`, `TimeEntries`), 1 function import (`ApproveProject`) |
| Generated SEGW classes | `ZCL_ZDEMO_MIG_PROJECTS_MPC` / `_MPC_EXT` / `_DPC` / `_DPC_EXT` (worst-practice 2017-era ABAP in DPC_EXT — `SELECT…ENDSELECT`, manual filter parsing, no auth checks, mixed-language comments) |
| **Migration target package** | `ZDEMO_MIG_RAP` — empty, awaits skill output |
| **Migration transport** | `A4HK903875` — dedicated, resettable |

## What's in this workspace

```
arc-1-legacy-ui5-rap-conversion/
├── README.md                                ← you are here
├── legacy-ui5-app/                          UI5 1.84.59 freestyle JS app, runs against the SEGW service
│   └── README.md                            run instructions + worst-practice catalogue
├── modern-ui5-app/                          empty — populated by `modernize-ui5-app` skill
└── skills/
    ├── migrate-segw-to-rap.md               legacy SEGW ➜ modern RAP service
    ├── modernize-ui5-app.md                 UI5 freestyle JS ➜ modern UI5 TS
    └── convert-ui5-to-fiori-elements.md     modern TS ➜ Fiori Elements with extensions
```

## Run order

1. **Run the legacy app once** to confirm the baseline:
   ```bash
   cd legacy-ui5-app
   npm install         # one-time
   npm start           # serves on http://localhost:8080 (or 8081 if 8080 is taken)
   ```
   Browser asks for basic auth → enter `DEMOUSER` + your SAP password. You should see 5 projects.

2. **Invoke `skills/migrate-segw-to-rap.md`** in Cursor. It will:
   - Read the legacy MPC + DPC_EXT classes via ARC-1
   - Extract the OData model (entity types, associations, function imports)
   - Design the RAP equivalent (CDS root + projection + BDEF + SRVD + SRVB + behavior pool)
   - Create everything in `ZDEMO_MIG_RAP` on transport `A4HK903875`
   - Smoke-test the new V4 service alongside the legacy V2

3. **Invoke `skills/modernize-ui5-app.md`** in Cursor. It will scaffold `modern-ui5-app/`
   pointing at the **same OData V2 service** (so backend migration isn't a prerequisite),
   then translate the legacy patterns to TypeScript with proper async/manifest/BaseController.

4. **(Stretch) Invoke `skills/convert-ui5-to-fiori-elements.md`**. It rebuilds the modern TS
   app as a Fiori Elements V4 list-report + object-page consuming the **new** RAP service
   (annotations live in the CDS) plus a few extension API hooks for custom behavior.

## Reset between skill runs

The migration skill is meant to be run multiple times while you tune it. Reset the RAP side
without touching the legacy SEGW side:

**Option A — let the skill do it:** Re-running `migrate-segw-to-rap.md` deletes existing
objects in `ZDEMO_MIG_RAP` (in dependency order) before creating the new ones. No manual step.

**Option B — manual nuke (if the skill fails mid-way):**
```text
SE80 → Package ZDEMO_MIG_RAP → right-click → Delete (cascades to all contained objects)
SE09 → Transport A4HK903875 → release tasks → release transport
```
Then re-create the package + transport (the skill's Phase 0 will offer to do this for you).

The legacy `ZDEMO_MIG` package and `A4HK903801` transport are **never touched** by any skill —
that's your stable baseline.

## Required MCP servers

The skills assume the following MCPs are configured in Cursor (`.cursor/mcp.json`):

| MCP | Used for |
|---|---|
| `arc1` | All SAP system reads/writes (ABAP, CDS, BDEF, SRVD, SRVB, transports) |
| `sap-docs` | RAP/CDS reference, deprecated-API lookups, ABAP feature matrix |
| `sapui5-mcp-server` | UI5 best practices, TS conversion guidelines, manifest validation, ui5-linter |

See `.cursor/mcp.json.example` (next to this README) for a copy-paste config.

## What's NOT here

The infrastructure that **created** the SAP backend (table DDL, seed-data ABAP, SEGW guide,
worst-practice DPC_EXT source) lives in the `arc-1` repo under `demo/` — it's reference
material for the skill author, not part of the customer workspace.
