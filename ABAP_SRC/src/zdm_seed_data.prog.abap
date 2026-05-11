*&---------------------------------------------------------------------*
*& Report ZDM_SEED_DATA
*&---------------------------------------------------------------------*
*& Seed data for the legacy SEGW->RAP migration demo.
*& Populates ZDM_PROJECT, ZDM_TASK, ZDM_TIMEENTRY with realistic content.
*& Run once to set up the demo; toggle p_clear to refresh.
*&---------------------------------------------------------------------*
REPORT zdm_seed_data.

PARAMETERS p_clear AS CHECKBOX DEFAULT 'X'.

CONSTANTS gc_user TYPE syuname VALUE 'DEMOUSER'.

START-OF-SELECTION.
  IF p_clear = 'X'.
    DELETE FROM zdm_timeentry.
    DELETE FROM zdm_task.
    DELETE FROM zdm_project.
    COMMIT WORK.
    WRITE: / 'Cleared existing demo data.'.
  ENDIF.

  PERFORM insert_projects.
  PERFORM insert_tasks.
  PERFORM insert_timeentries.

  COMMIT WORK.
  WRITE: /, / 'Seed data inserted. Verify with SE16N on ZDM_PROJECT / ZDM_TASK / ZDM_TIMEENTRY.'.

*&---------------------------------------------------------------------*
*&      Form  insert_projects
*&---------------------------------------------------------------------*
FORM insert_projects.
  DATA lt TYPE STANDARD TABLE OF zdm_project.

  lt = VALUE #(
    erzet = '094500' ernam = gc_user
    ( mandt = sy-mandt project_id = 'PRJ-0001'
      title       = 'Mobile Banking App Redesign'
      description = 'Modernize the mobile banking application with new UX and security baseline'
      status      = 'A' start_date  = '20250115' end_date    = '20250630'
      erdat       = '20250115' )
    ( mandt = sy-mandt project_id = 'PRJ-0002'
      title       = 'ERP Cloud Migration'
      description = 'Migrate on-prem ECC system to S/4HANA Cloud Public Edition'
      status      = 'A' start_date  = '20250201' end_date    = '20251231'
      erdat       = '20250201' )
    ( mandt = sy-mandt project_id = 'PRJ-0003'
      title       = 'AI Customer Support Chatbot'
      description = 'Implement Joule-based customer support chatbot integration'
      status      = 'D' start_date  = '20250401' end_date    = '20250930'
      erdat       = '20250401' )
    ( mandt = sy-mandt project_id = 'PRJ-0004'
      title       = 'Warehouse Automation Phase 2'
      description = 'Roll out RFID-based picking across all distribution centers'
      status      = 'A' start_date  = '20240601' end_date    = '20251231'
      erdat       = '20240601' )
    ( mandt = sy-mandt project_id = 'PRJ-0005'
      title       = 'Compliance Reporting Refresh'
      description = 'Quarterly compliance report toolkit refresh after GL chart change'
      status      = 'X' start_date  = '20240901' end_date    = '20250131'
      erdat       = '20240901' )
  ).

  INSERT zdm_project FROM TABLE @lt.
  WRITE: / |{ sy-dbcnt } projects inserted.|.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  insert_tasks
*&---------------------------------------------------------------------*
FORM insert_tasks.
  DATA lt TYPE STANDARD TABLE OF zdm_task.

  lt = VALUE #(
    mandt = sy-mandt erzet = '100000' ernam = gc_user
    " PRJ-0001 (Mobile Banking)
    ( task_id = 'TSK-0001' project_id = 'PRJ-0001'
      title = 'UX Wireframes'
      description = 'Design new wireframes for the redesigned mobile screens'
      status = 'C' priority = '2' due_date = '20250215'
      assigned_to = 'BDESIGNER' estimated_hours = '40.00' erdat = '20250115' )
    ( task_id = 'TSK-0002' project_id = 'PRJ-0001'
      title = 'Backend API Refactor'
      description = 'Rebuild auth and account APIs on the new gateway'
      status = 'P' priority = '3' due_date = '20250501'
      assigned_to = 'BDEV1' estimated_hours = '120.00' erdat = '20250115' )
    ( task_id = 'TSK-0003' project_id = 'PRJ-0001'
      title = 'Penetration Testing'
      description = 'External pen test on the new app prior to release'
      status = 'O' priority = '3' due_date = '20250620'
      assigned_to = 'SECTEAM' estimated_hours = '60.00' erdat = '20250115' )

    " PRJ-0002 (ERP Migration)
    ( task_id = 'TSK-0004' project_id = 'PRJ-0002'
      title = 'Cloud Tenancy Setup'
      description = 'Provision S/4 Public Cloud test tenant and users'
      status = 'C' priority = '3' due_date = '20250228'
      assigned_to = 'BDEV2' estimated_hours = '20.00' erdat = '20250201' )
    ( task_id = 'TSK-0005' project_id = 'PRJ-0002'
      title = 'Custom Code Migration'
      description = 'Run ATC and adapt approximately 200 Z-objects for S/4 Public Cloud'
      status = 'P' priority = '3' due_date = '20250930'
      assigned_to = 'BDEV3' estimated_hours = '400.00' erdat = '20250201' )
    ( task_id = 'TSK-0006' project_id = 'PRJ-0002'
      title = 'User Training Material'
      description = 'Record and publish training videos for end users'
      status = 'O' priority = '1' due_date = '20251130'
      assigned_to = 'TRAINTEAM' estimated_hours = '80.00' erdat = '20250201' )

    " PRJ-0003 (Chatbot)
    ( task_id = 'TSK-0007' project_id = 'PRJ-0003'
      title = 'Use-Case Catalog'
      description = 'Identify the top 10 chatbot use cases via stakeholder workshops'
      status = 'O' priority = '2' due_date = '20250430'
      assigned_to = 'PMOFFICE' estimated_hours = '20.00' erdat = '20250401' )
    ( task_id = 'TSK-0008' project_id = 'PRJ-0003'
      title = 'Joule POC'
      description = 'Build a proof-of-concept chatbot using sample customer data'
      status = 'O' priority = '2' due_date = '20250515'
      assigned_to = 'BDEV4' estimated_hours = '60.00' erdat = '20250401' )
    ( task_id = 'TSK-0009' project_id = 'PRJ-0003'
      title = 'Stakeholder Review'
      description = 'Present POC to executive sponsors for go/no-go decision'
      status = 'O' priority = '2' due_date = '20250601'
      assigned_to = 'PMOFFICE' estimated_hours = '8.00' erdat = '20250401' )

    " PRJ-0004 (Warehouse)
    ( task_id = 'TSK-0010' project_id = 'PRJ-0004'
      title = 'RFID Hardware Rollout'
      description = 'Install RFID readers across distribution centers A, B, C'
      status = 'C' priority = '3' due_date = '20240901'
      assigned_to = 'OPSTEAM' estimated_hours = '200.00' erdat = '20240601' )
    ( task_id = 'TSK-0011' project_id = 'PRJ-0004'
      title = 'WMS Integration'
      description = 'Integrate RFID event stream with extended warehouse mgmt'
      status = 'P' priority = '3' due_date = '20251130'
      assigned_to = 'BDEV5' estimated_hours = '300.00' erdat = '20240601' )
    ( task_id = 'TSK-0012' project_id = 'PRJ-0004'
      title = 'Operations Training'
      description = 'Train 250 operators across 8 distribution centers'
      status = 'O' priority = '2' due_date = '20251231'
      assigned_to = 'TRAINTEAM' estimated_hours = '160.00' erdat = '20240601' )

    " PRJ-0005 (Compliance)
    ( task_id = 'TSK-0013' project_id = 'PRJ-0005'
      title = 'Q1 Report Run'
      description = 'Run and verify Q1 numbers with the new toolkit'
      status = 'C' priority = '1' due_date = '20241015'
      assigned_to = 'GLTEAM' estimated_hours = '12.00' erdat = '20240901' )
    ( task_id = 'TSK-0014' project_id = 'PRJ-0005'
      title = 'Toolkit Update'
      description = 'Refresh report queries for the new GL account structure'
      status = 'C' priority = '1' due_date = '20241130'
      assigned_to = 'GLTEAM' estimated_hours = '24.00' erdat = '20240901' )
    ( task_id = 'TSK-0015' project_id = 'PRJ-0005'
      title = 'Sign-Off Meeting'
      description = 'Final sign-off meeting with the controlling team'
      status = 'C' priority = '1' due_date = '20250131'
      assigned_to = 'CONTROLR' estimated_hours = '4.00' erdat = '20240901' )
  ).

  INSERT zdm_task FROM TABLE @lt.
  WRITE: / |{ sy-dbcnt } tasks inserted.|.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  insert_timeentries
*&---------------------------------------------------------------------*
FORM insert_timeentries.
  DATA lt TYPE STANDARD TABLE OF zdm_timeentry.

  lt = VALUE #(
    mandt = sy-mandt erzet = '170000'
    " TSK-0001 — UX Wireframes (completed)
    ( entry_id = 'ENT-00000001' task_id = 'TSK-0001' project_id = 'PRJ-0001'
      work_date = '20250120' work_hours = '8.00'
      description = 'Initial wireframe drafts for login and dashboard'
      username = 'BDESIGNER' erdat = '20250120' ernam = 'BDESIGNER' )
    ( entry_id = 'ENT-00000002' task_id = 'TSK-0001' project_id = 'PRJ-0001'
      work_date = '20250127' work_hours = '8.00'
      description = 'Wireframes for transactions list and filter'
      username = 'BDESIGNER' erdat = '20250127' ernam = 'BDESIGNER' )
    ( entry_id = 'ENT-00000003' task_id = 'TSK-0001' project_id = 'PRJ-0001'
      work_date = '20250203' work_hours = '6.50'
      description = 'Wireframes for transfer and payee management'
      username = 'BDESIGNER' erdat = '20250203' ernam = 'BDESIGNER' )
    ( entry_id = 'ENT-00000004' task_id = 'TSK-0001' project_id = 'PRJ-0001'
      work_date = '20250210' work_hours = '7.00'
      description = 'Stakeholder review and revisions'
      username = 'BDESIGNER' erdat = '20250210' ernam = 'BDESIGNER' )

    " TSK-0002 — Backend API Refactor (in progress)
    ( entry_id = 'ENT-00000005' task_id = 'TSK-0002' project_id = 'PRJ-0001'
      work_date = '20250203' work_hours = '8.00'
      description = 'Architecture spike on new gateway'
      username = 'BDEV1' erdat = '20250203' ernam = 'BDEV1' )
    ( entry_id = 'ENT-00000006' task_id = 'TSK-0002' project_id = 'PRJ-0001'
      work_date = '20250210' work_hours = '8.00'
      description = 'Auth API skeleton and JWT plumbing'
      username = 'BDEV1' erdat = '20250210' ernam = 'BDEV1' )
    ( entry_id = 'ENT-00000007' task_id = 'TSK-0002' project_id = 'PRJ-0001'
      work_date = '20250217' work_hours = '8.00'
      description = 'Account API endpoints with unit tests'
      username = 'BDEV1' erdat = '20250217' ernam = 'BDEV1' )
    ( entry_id = 'ENT-00000008' task_id = 'TSK-0002' project_id = 'PRJ-0001'
      work_date = '20250224' work_hours = '8.00'
      description = 'Account API: balance and statements'
      username = 'BDEV1' erdat = '20250224' ernam = 'BDEV1' )
    ( entry_id = 'ENT-00000009' task_id = 'TSK-0002' project_id = 'PRJ-0001'
      work_date = '20250303' work_hours = '8.00'
      description = 'Performance tuning of account endpoints'
      username = 'BDEV1' erdat = '20250303' ernam = 'BDEV1' )

    " TSK-0004 — Cloud Tenancy Setup (completed)
    ( entry_id = 'ENT-00000010' task_id = 'TSK-0004' project_id = 'PRJ-0002'
      work_date = '20250205' work_hours = '6.00'
      description = 'Tenant provisioning and initial system setup'
      username = 'BDEV2' erdat = '20250205' ernam = 'BDEV2' )
    ( entry_id = 'ENT-00000011' task_id = 'TSK-0004' project_id = 'PRJ-0002'
      work_date = '20250212' work_hours = '4.00'
      description = 'User onboarding and role assignment'
      username = 'BDEV2' erdat = '20250212' ernam = 'BDEV2' )

    " TSK-0005 — Custom Code Migration (in progress)
    ( entry_id = 'ENT-00000012' task_id = 'TSK-0005' project_id = 'PRJ-0002'
      work_date = '20250303' work_hours = '8.00'
      description = 'ATC baseline run on Z objects'
      username = 'BDEV3' erdat = '20250303' ernam = 'BDEV3' )
    ( entry_id = 'ENT-00000013' task_id = 'TSK-0005' project_id = 'PRJ-0002'
      work_date = '20250310' work_hours = '8.00'
      description = 'Fix priority-1 ATC errors batch 1'
      username = 'BDEV3' erdat = '20250310' ernam = 'BDEV3' )
    ( entry_id = 'ENT-00000014' task_id = 'TSK-0005' project_id = 'PRJ-0002'
      work_date = '20250317' work_hours = '8.00'
      description = 'Fix priority-1 ATC errors batch 2'
      username = 'BDEV3' erdat = '20250317' ernam = 'BDEV3' )
    ( entry_id = 'ENT-00000015' task_id = 'TSK-0005' project_id = 'PRJ-0002'
      work_date = '20250324' work_hours = '8.00'
      description = 'Released-API replacement work'
      username = 'BDEV3' erdat = '20250324' ernam = 'BDEV3' )

    " TSK-0010 — RFID Hardware Rollout (completed)
    ( entry_id = 'ENT-00000016' task_id = 'TSK-0010' project_id = 'PRJ-0004'
      work_date = '20240715' work_hours = '8.00'
      description = 'Reader install at DC A'
      username = 'OPSTEAM' erdat = '20240715' ernam = 'OPSTEAM' )
    ( entry_id = 'ENT-00000017' task_id = 'TSK-0010' project_id = 'PRJ-0004'
      work_date = '20240805' work_hours = '8.00'
      description = 'Reader install at DC B with cabling'
      username = 'OPSTEAM' erdat = '20240805' ernam = 'OPSTEAM' )
    ( entry_id = 'ENT-00000018' task_id = 'TSK-0010' project_id = 'PRJ-0004'
      work_date = '20240826' work_hours = '8.00'
      description = 'Reader install at DC C with commissioning'
      username = 'OPSTEAM' erdat = '20240826' ernam = 'OPSTEAM' )

    " TSK-0011 — WMS Integration (in progress)
    ( entry_id = 'ENT-00000019' task_id = 'TSK-0011' project_id = 'PRJ-0004'
      work_date = '20250901' work_hours = '8.00'
      description = 'Event-bus design and payload schema'
      username = 'BDEV5' erdat = '20250901' ernam = 'BDEV5' )
    ( entry_id = 'ENT-00000020' task_id = 'TSK-0011' project_id = 'PRJ-0004'
      work_date = '20250908' work_hours = '8.00'
      description = 'EWM integration adapter prototype'
      username = 'BDEV5' erdat = '20250908' ernam = 'BDEV5' )
    ( entry_id = 'ENT-00000021' task_id = 'TSK-0011' project_id = 'PRJ-0004'
      work_date = '20250915' work_hours = '8.00'
      description = 'End-to-end test of pick and put-away events'
      username = 'BDEV5' erdat = '20250915' ernam = 'BDEV5' )

    " TSK-0013, 0014, 0015 — Compliance reporting (completed)
    ( entry_id = 'ENT-00000022' task_id = 'TSK-0013' project_id = 'PRJ-0005'
      work_date = '20240920' work_hours = '6.00'
      description = 'Q1 numbers reconciliation pass 1'
      username = 'GLTEAM' erdat = '20240920' ernam = 'GLTEAM' )
    ( entry_id = 'ENT-00000023' task_id = 'TSK-0013' project_id = 'PRJ-0005'
      work_date = '20241008' work_hours = '6.00'
      description = 'Q1 numbers reconciliation pass 2'
      username = 'GLTEAM' erdat = '20241008' ernam = 'GLTEAM' )
    ( entry_id = 'ENT-00000024' task_id = 'TSK-0014' project_id = 'PRJ-0005'
      work_date = '20241101' work_hours = '8.00'
      description = 'Toolkit query refresh and smoke test'
      username = 'GLTEAM' erdat = '20241101' ernam = 'GLTEAM' )
    ( entry_id = 'ENT-00000025' task_id = 'TSK-0015' project_id = 'PRJ-0005'
      work_date = '20250130' work_hours = '4.00'
      description = 'Sign-off meeting and minutes'
      username = 'CONTROLR' erdat = '20250130' ernam = 'CONTROLR' )
  ).

  INSERT zdm_timeentry FROM TABLE @lt.
  WRITE: / |{ sy-dbcnt } time entries inserted.|.
ENDFORM.
