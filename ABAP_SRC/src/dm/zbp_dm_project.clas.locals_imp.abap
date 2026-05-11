*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lhc_project DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS approve_project FOR MODIFY
      IMPORTING keys FOR ACTION Project~approve_project RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Project RESULT result.

ENDCLASS.

CLASS lhc_project IMPLEMENTATION.
    METHOD approve_project.
      READ ENTITIES OF zi_dm_project IN LOCAL MODE
        ENTITY Project FIELDS ( ProjectId Status Aedat Aezet Aenam )
          WITH CORRESPONDING #( keys )
        RESULT DATA(projects).

      MODIFY ENTITIES OF zi_dm_project IN LOCAL MODE
        ENTITY Project
          UPDATE FIELDS ( Status Aedat Aezet Aenam )
          WITH VALUE #( FOR p IN projects (
            %tky    = p-%tky
            Status  = 'A'
            Aedat   = sy-datum
            Aezet   = sy-uzeit
            Aenam   = sy-uname
          ) ).

      READ ENTITIES OF zi_dm_project IN LOCAL MODE
        ENTITY Project ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(updated).

      result = VALUE #( FOR u IN updated ( %tky = u-%tky %param = u ) ).
    ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
