@AccessControl.authorizationCheck : #NOT_REQUIRED
@EndUserText.label : 'Demo: Project (interface root BO)'
define root view entity ZI_DM_PROJECT
  as select from zdm_project
  composition [0..*] of ZI_DM_TASK as _Tasks
{
  key project_id as ProjectId,
  title as Title,
  description as Description,
  status as Status,
  start_date as StartDate,
  end_date as EndDate,
  erdat as Erdat,
  erzet as Erzet,
  ernam as Ernam,
  aedat as Aedat,
  aezet as Aezet,
  aenam as Aenam,
  @Semantics.systemDateTime.createdAt: true
  dats_tims_to_tstmp(
    zdm_project.erdat,
    zdm_project.erzet,
    abap_system_timezone($session.client, 'NULL'),
    $session.client,
    'NULL'
  ) as CreationTimeStamp,
  @Semantics.systemDateTime.lastChangedAt: true
  dats_tims_to_tstmp(
    case zdm_project.aedat when '00000000' then zdm_project.erdat else zdm_project.aedat end,
    case zdm_project.aedat when '00000000' then zdm_project.erzet else zdm_project.aezet end,
    abap_system_timezone($session.client, 'NULL'),
    $session.client,
    'NULL'
  ) as LastChangedStamp,
  _Tasks
}
