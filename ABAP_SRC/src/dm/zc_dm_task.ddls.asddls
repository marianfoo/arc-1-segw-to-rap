@AccessControl.authorizationCheck : #NOT_REQUIRED
@EndUserText.label : 'Demo task — projection'
@Metadata.allowExtensions: true

@Search.searchable: true

@ObjectModel.semanticKey: ['ProjectId', 'TaskId']

@UI.headerInfo: {
  typeName       : 'Task',
  typeNamePlural : 'Tasks',
  title          : { value: 'Title', type: #STANDARD },
  description    : { label: 'Task', type: #STANDARD, value: 'TaskId' }
}

define view entity ZC_DM_TASK
  as projection on ZI_DM_TASK
{
  key TaskId,

  @Search.defaultSearchElement: true
  ProjectId,

  Title,
  Description,
  Status,
  Priority,
  DueDate,
  AssignedTo,
  EstimatedHours,
  Erdat,
  Erzet,
  Ernam,
  Aedat,
  Aezet,
  Aenam,
  _Project       : redirected to parent ZC_DM_PROJECT,
  _TimeEntries   : redirected to composition child ZC_DM_TIMEENTRY
}
