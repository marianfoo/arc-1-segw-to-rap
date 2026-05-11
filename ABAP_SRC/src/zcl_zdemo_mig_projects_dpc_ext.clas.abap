class ZCL_ZDEMO_MIG_PROJECTS_DPC_EXT definition
  public
  inheriting from ZCL_ZDEMO_MIG_PROJECTS_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~EXECUTE_ACTION
    redefinition .

protected section.

  methods PROJECTSET_GET_ENTITYSET
    redefinition .
  methods PROJECTSET_GET_ENTITY
    redefinition .
  methods TASKSET_GET_ENTITYSET
    redefinition .
  methods TASKSET_GET_ENTITY
    redefinition .
  methods TIMEENTRYSET_GET_ENTITYSET
    redefinition .
  methods TIMEENTRYSET_GET_ENTITY
    redefinition .

private section.
ENDCLASS.



CLASS ZCL_ZDEMO_MIG_PROJECTS_DPC_EXT IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ZDEMO_MIG_PROJECTS_DPC_EXT->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~EXECUTE_ACTION
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ACTION_NAME                  TYPE        STRING
* | [--->] IT_PARAMETER                    TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [--->] IO_TECH_REQUEST_CONTEXT         TYPE REF TO /IWBEP/IF_MGW_REQ_FUNC_IMPORT
* | [<-->] ER_DATA                         TYPE REF TO DATA
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD /iwbep/if_mgw_appl_srv_runtime~execute_action.

    " ApproveProject: setzt Status auf 'A' für das übergebene Projekt
    " und gibt das aktualisierte Projekt zurück.

    DATA: ls_param   LIKE LINE OF it_parameter,
          lv_project TYPE zdm_project-project_id,
          ls_project TYPE zdm_project.

    " Parameter ProjectId rauspicken
    LOOP AT it_parameter INTO ls_param.
      IF ls_param-name = 'ProjectId'.
        lv_project = ls_param-value.
      ENDIF.
    ENDLOOP.

    IF iv_action_name = 'ApproveProject'.

      " Status setzen — kein lock, kein authority check, einfach durch
      UPDATE zdm_project
        SET status = 'A'
            aedat  = sy-datum
            aezet  = sy-uzeit
            aenam  = sy-uname
        WHERE project_id = lv_project.

      COMMIT WORK.

      " danach nochmal lesen für den Return
      SELECT SINGLE * FROM zdm_project INTO ls_project
        WHERE project_id = lv_project.

      copy_data_to_ref(
        EXPORTING
          is_data = ls_project
        CHANGING
          cr_data = er_data
      ).

    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZDEMO_MIG_PROJECTS_DPC_EXT->PROJECTSET_GET_ENTITYSET
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENTITY_NAME                  TYPE        STRING
* | [--->] IV_ENTITY_SET_NAME              TYPE        STRING
* | [--->] IV_SOURCE_NAME                  TYPE        STRING
* | [--->] IT_FILTER_SELECT_OPTIONS        TYPE        /IWBEP/T_MGW_SELECT_OPTION
* | [--->] IS_PAGING                       TYPE        /IWBEP/S_MGW_PAGING
* | [--->] IT_KEY_TAB                      TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [--->] IT_NAVIGATION_PATH              TYPE        /IWBEP/T_MGW_NAVIGATION_PATH
* | [--->] IT_ORDER                        TYPE        /IWBEP/T_MGW_SORTING_ORDER
* | [--->] IV_FILTER_STRING                TYPE        STRING
* | [--->] IV_SEARCH_STRING                TYPE        STRING
* | [--->] IO_TECH_REQUEST_CONTEXT         TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITYSET
* | [<---] ET_ENTITYSET                    TYPE        TT_PROJECT
* | [<---] ES_RESPONSE_CONTEXT             TYPE        /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_ENTITYSET_CNTXT
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD projectset_get_entityset.

    " Liefert alle Projekte aus ZDM_PROJECT.
    " TODO ($filter, $top, $skip, $orderby werden bewusst ignoriert — kommt im Refactor.)

    DATA: ls_project TYPE zdm_project,
          ls_entity  TYPE zdm_project.

    SELECT * FROM zdm_project INTO ls_project.

      CLEAR ls_entity.
      ls_entity-project_id  = ls_project-project_id.
      ls_entity-title       = ls_project-title.
      ls_entity-description = ls_project-description.
      ls_entity-status      = ls_project-status.
      ls_entity-start_date  = ls_project-start_date.
      ls_entity-end_date    = ls_project-end_date.
      ls_entity-erdat       = ls_project-erdat.
      ls_entity-erzet       = ls_project-erzet.
      ls_entity-ernam       = ls_project-ernam.
      ls_entity-aedat       = ls_project-aedat.
      ls_entity-aezet       = ls_project-aezet.
      ls_entity-aenam       = ls_project-aenam.

      " wenn aedat noch leer dann mit erdat füllen — sonst meckert OData
      IF ls_entity-aedat IS INITIAL.
        ls_entity-aedat = ls_entity-erdat.
        ls_entity-aezet = ls_entity-erzet.
        ls_entity-aenam = ls_entity-ernam.
      ENDIF.

      APPEND ls_entity TO et_entityset.

    ENDSELECT.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZDEMO_MIG_PROJECTS_DPC_EXT->PROJECTSET_GET_ENTITY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENTITY_NAME                  TYPE        STRING
* | [--->] IV_ENTITY_SET_NAME              TYPE        STRING
* | [--->] IV_SOURCE_NAME                  TYPE        STRING
* | [--->] IT_KEY_TAB                      TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [--->] IT_NAVIGATION_PATH              TYPE        /IWBEP/T_MGW_NAVIGATION_PATH
* | [--->] IO_TECH_REQUEST_CONTEXT         TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITY
* | [<---] ER_ENTITY                       TYPE        TS_PROJECT
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD projectset_get_entity.

    DATA: ls_key      LIKE LINE OF it_key_tab,
          lv_proj_id  TYPE zdm_project-project_id,
          ls_project  TYPE zdm_project.

    " Schlüssel manuell aus URL holen
    LOOP AT it_key_tab INTO ls_key.
      CASE ls_key-name.
        WHEN 'ProjectId'.
          lv_proj_id = ls_key-value.
      ENDCASE.
    ENDLOOP.

    SELECT SINGLE * FROM zdm_project INTO ls_project
      WHERE project_id = lv_proj_id.

    IF sy-subrc = 0.
      MOVE-CORRESPONDING ls_project TO er_entity.
      " hack: aedat darf nicht 00000000 sein
      IF er_entity-aedat IS INITIAL.
        er_entity-aedat = er_entity-erdat.
        er_entity-aezet = er_entity-erzet.
        er_entity-aenam = er_entity-ernam.
      ENDIF.
    ENDIF.
    " wenn nicht gefunden, einfach leer zurückgeben — frontend muss damit klarkommen

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZDEMO_MIG_PROJECTS_DPC_EXT->TASKSET_GET_ENTITYSET
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENTITY_NAME                  TYPE        STRING
* | [--->] IV_ENTITY_SET_NAME              TYPE        STRING
* | [--->] IV_SOURCE_NAME                  TYPE        STRING
* | [--->] IT_FILTER_SELECT_OPTIONS        TYPE        /IWBEP/T_MGW_SELECT_OPTION
* | [--->] IS_PAGING                       TYPE        /IWBEP/S_MGW_PAGING
* | [--->] IT_KEY_TAB                      TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [--->] IT_NAVIGATION_PATH              TYPE        /IWBEP/T_MGW_NAVIGATION_PATH
* | [--->] IT_ORDER                        TYPE        /IWBEP/T_MGW_SORTING_ORDER
* | [--->] IV_FILTER_STRING                TYPE        STRING
* | [--->] IV_SEARCH_STRING                TYPE        STRING
* | [--->] IO_TECH_REQUEST_CONTEXT         TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITYSET
* | [<---] ET_ENTITYSET                    TYPE        TT_TASK
* | [<---] ES_RESPONSE_CONTEXT             TYPE        /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_ENTITYSET_CNTXT
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD taskset_get_entityset.

    " Liefert Tasks. Wenn aus Navigation /ProjectSet('X')/Tasks aufgerufen,
    " filtern wir auf project_id (im it_key_tab).
    " TODO Sort/Filter/Paging später.

    DATA: ls_task    TYPE zdm_task,
          ls_entity  TYPE zdm_task,
          lt_task    TYPE TABLE OF zdm_task,
          ls_key     LIKE LINE OF it_key_tab,
          lv_project TYPE zdm_task-project_id.

    " navigation? schauen wir mal in die keys
    LOOP AT it_key_tab INTO ls_key.
      IF ls_key-name = 'ProjectId'.
        lv_project = ls_key-value.
      ENDIF.
    ENDLOOP.

    " erst alles holen, danach im ABAP filtern (geht ja schnell genug)
    SELECT * FROM zdm_task INTO TABLE lt_task.

    LOOP AT lt_task INTO ls_task.
      IF lv_project IS NOT INITIAL AND ls_task-project_id <> lv_project.
        CONTINUE.
      ENDIF.
      MOVE-CORRESPONDING ls_task TO ls_entity.
      IF ls_entity-aedat IS INITIAL.
        ls_entity-aedat = ls_entity-erdat.
        ls_entity-aezet = ls_entity-erzet.
        ls_entity-aenam = ls_entity-ernam.
      ENDIF.
      APPEND ls_entity TO et_entityset.
    ENDLOOP.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZDEMO_MIG_PROJECTS_DPC_EXT->TASKSET_GET_ENTITY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENTITY_NAME                  TYPE        STRING
* | [--->] IV_ENTITY_SET_NAME              TYPE        STRING
* | [--->] IV_SOURCE_NAME                  TYPE        STRING
* | [--->] IT_KEY_TAB                      TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [--->] IT_NAVIGATION_PATH              TYPE        /IWBEP/T_MGW_NAVIGATION_PATH
* | [--->] IO_TECH_REQUEST_CONTEXT         TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITY
* | [<---] ER_ENTITY                       TYPE        TS_TASK
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD taskset_get_entity.

    DATA: ls_key    LIKE LINE OF it_key_tab,
          lv_taskid TYPE zdm_task-task_id,
          ls_task   TYPE zdm_task.

    LOOP AT it_key_tab INTO ls_key.
      IF ls_key-name = 'TaskId'.
        lv_taskid = ls_key-value.
      ENDIF.
    ENDLOOP.

    SELECT SINGLE * FROM zdm_task INTO ls_task
      WHERE task_id = lv_taskid.

    IF sy-subrc = 0.
      MOVE-CORRESPONDING ls_task TO er_entity.
      IF er_entity-aedat IS INITIAL.
        er_entity-aedat = er_entity-erdat.
        er_entity-aezet = er_entity-erzet.
        er_entity-aenam = er_entity-ernam.
      ENDIF.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZDEMO_MIG_PROJECTS_DPC_EXT->TIMEENTRYSET_GET_ENTITYSET
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENTITY_NAME                  TYPE        STRING
* | [--->] IV_ENTITY_SET_NAME              TYPE        STRING
* | [--->] IV_SOURCE_NAME                  TYPE        STRING
* | [--->] IT_FILTER_SELECT_OPTIONS        TYPE        /IWBEP/T_MGW_SELECT_OPTION
* | [--->] IS_PAGING                       TYPE        /IWBEP/S_MGW_PAGING
* | [--->] IT_KEY_TAB                      TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [--->] IT_NAVIGATION_PATH              TYPE        /IWBEP/T_MGW_NAVIGATION_PATH
* | [--->] IT_ORDER                        TYPE        /IWBEP/T_MGW_SORTING_ORDER
* | [--->] IV_FILTER_STRING                TYPE        STRING
* | [--->] IV_SEARCH_STRING                TYPE        STRING
* | [--->] IO_TECH_REQUEST_CONTEXT         TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITYSET
* | [<---] ET_ENTITYSET                    TYPE        TT_TIMEENTRY
* | [<---] ES_RESPONSE_CONTEXT             TYPE        /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_ENTITYSET_CNTXT
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD timeentryset_get_entityset.

    DATA: ls_entry  TYPE zdm_timeentry,
          ls_entity TYPE zdm_timeentry,
          ls_key    LIKE LINE OF it_key_tab,
          lv_task   TYPE zdm_timeentry-task_id.

    " navigation /TaskSet('X')/TimeEntries — TaskId aus URL holen
    LOOP AT it_key_tab INTO ls_key.
      IF ls_key-name = 'TaskId'.
        lv_task = ls_key-value.
      ENDIF.
    ENDLOOP.

    " full table read mit SELECT ENDSELECT — quick and dirty
    SELECT * FROM zdm_timeentry INTO ls_entry.
      IF lv_task IS NOT INITIAL AND ls_entry-task_id <> lv_task.
        CONTINUE.
      ENDIF.
      MOVE-CORRESPONDING ls_entry TO ls_entity.
      IF ls_entity-aedat IS INITIAL.
        ls_entity-aedat = ls_entity-erdat.
        ls_entity-aezet = ls_entity-erzet.
        ls_entity-aenam = ls_entity-ernam.
      ENDIF.
      APPEND ls_entity TO et_entityset.
    ENDSELECT.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZDEMO_MIG_PROJECTS_DPC_EXT->TIMEENTRYSET_GET_ENTITY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENTITY_NAME                  TYPE        STRING
* | [--->] IV_ENTITY_SET_NAME              TYPE        STRING
* | [--->] IV_SOURCE_NAME                  TYPE        STRING
* | [--->] IT_KEY_TAB                      TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [--->] IT_NAVIGATION_PATH              TYPE        /IWBEP/T_MGW_NAVIGATION_PATH
* | [--->] IO_TECH_REQUEST_CONTEXT         TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITY
* | [<---] ER_ENTITY                       TYPE        TS_TIMEENTRY
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD timeentryset_get_entity.

    DATA: ls_key    LIKE LINE OF it_key_tab,
          lv_entry  TYPE zdm_timeentry-entry_id,
          ls_entry  TYPE zdm_timeentry.

    LOOP AT it_key_tab INTO ls_key.
      IF ls_key-name = 'EntryId'.
        lv_entry = ls_key-value.
      ENDIF.
    ENDLOOP.

    SELECT SINGLE * FROM zdm_timeentry INTO ls_entry
      WHERE entry_id = lv_entry.

    IF sy-subrc = 0.
      MOVE-CORRESPONDING ls_entry TO er_entity.
      IF er_entity-aedat IS INITIAL.
        er_entity-aedat = er_entity-erdat.
        er_entity-aezet = er_entity-erzet.
        er_entity-aenam = er_entity-ernam.
      ENDIF.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
