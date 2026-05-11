@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label : 'Demo: Task (interface child)'
define view entity ZI_DM_TASK
  as select from zdm_task
  association to parent ZI_DM_PROJECT as _Project on $projection.ProjectId = _Project.ProjectId
  composition [0..*] of ZI_DM_TIMEENTRY as _TimeEntries
{
  key task_id as TaskId,
  project_id as ProjectId,
  title as Title,
  description as Description,
  status as Status,
  priority as Priority,
  due_date as DueDate,
  assigned_to as AssignedTo,
  estimated_hours as EstimatedHours,
  erdat as Erdat,
  erzet as Erzet,
  ernam as Ernam,
  aedat as Aedat,
  aezet as Aezet,
  aenam as Aenam,
  _Project,
  _TimeEntries
}
