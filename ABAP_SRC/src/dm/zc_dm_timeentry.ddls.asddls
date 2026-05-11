@AccessControl.authorizationCheck : #NOT_REQUIRED
@EndUserText.label : 'Demo time entry — projection'
@Metadata.allowExtensions: true

@Search.searchable: true

@ObjectModel.semanticKey: ['EntryId']

@UI.headerInfo: {
  typeName       : 'Time Entry',
  typeNamePlural : 'Time Entries',
  title          : { value: 'Description', type: #STANDARD },
  description    : { label: 'ID', type: #STANDARD, value: 'EntryId' }
}

define view entity ZC_DM_TIMEENTRY
  as projection on ZI_DM_TIMEENTRY
{
  key EntryId,

  @Search.defaultSearchElement: true
  Description,

  TaskId,
  ProjectId,
  WorkDate,
  WorkHours,
  Username,
  Erdat,
  Erzet,
  Ernam,
  Aedat,
  Aezet,
  Aenam,
  _Task    : redirected to parent ZC_DM_TASK,
  _Project : redirected to ZC_DM_PROJECT
}
