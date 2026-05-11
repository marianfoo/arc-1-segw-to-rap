@AccessControl.authorizationCheck : #NOT_REQUIRED
@EndUserText.label : 'Demo project — projection (root)'
@Metadata.allowExtensions: true

@Search.searchable: true

@ObjectModel.semanticKey: ['ProjectId']

@UI.headerInfo: {
  typeName       : 'Project',
  typeNamePlural : 'Projects',
  title          : { value: 'Title', type: #STANDARD },
  description    : { label: 'ID', type: #STANDARD, value: 'ProjectId' }
}

@UI.presentationVariant: [
  {
    qualifier : 'Standard',
    sortOrder : [{ by: 'StartDate', direction: #DESC }]
  }
]

define root view entity ZC_DM_PROJECT
  provider contract transactional_query
  as projection on ZI_DM_PROJECT
{
  key ProjectId,

  @Search.defaultSearchElement: true
  Title,

  Description,
  Status,
  StartDate,
  EndDate,
  Erdat,
  Erzet,
  Ernam,
  Aedat,
  Aezet,
  Aenam,
  CreationTimeStamp,
  LastChangedStamp,
  _Tasks : redirected to composition child ZC_DM_TASK
}
