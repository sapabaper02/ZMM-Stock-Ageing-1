@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Stock Ageing Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_STOCK_AGEING_REPORT
  provider contract transactional_query
  as projection on ZR_STOCK_AGEING_REPORT
{
  key ItemCode,
  key Plant,
  key Batch,
  key PostingDate,
  key StorageLocation,
      MaterialGroup,
      ItemDescription,
      AgeingDate,
      CompanyCode,
      TotalQuantity,
      Uom,
      @Semantics.amount.currencyCode: 'Currencycode'
      Value,
      Currencycode,
      Days0to7,
      Days7to15,
      Days15to30,
      Days30to60,
      Days60to90,
      Days90to120,
      Days120to180,
      above180Days,
      TotalValue
}
