@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label : 'Demo: TimeEntry (interface leaf)'
define view entity ZI_DM_TIMEENTRY
  as select from zdm_timeentry
  association to parent ZI_DM_TASK as _Task on $projection.TaskId = _Task.TaskId
  association to ZI_DM_PROJECT as _Project on $projection.ProjectId = _Project.ProjectId
{
  key entry_id as EntryId,
  task_id as TaskId,
  project_id as ProjectId,
  work_date as WorkDate,
  work_hours as WorkHours,
  description as Description,
  username as Username,
  erdat as Erdat,
  erzet as Erzet,
  ernam as Ernam,
  aedat as Aedat,
  aezet as Aezet,
  aenam as Aenam,
  _Task,
  _Project
}
