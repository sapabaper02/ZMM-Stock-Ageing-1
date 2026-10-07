@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Stock Ageing Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_STOCK_AGEING_DATA
  as select from ZI_STOCK_AGEING_REPORT
{
  key ItemCode,
  key Plant,
  key Batch,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      sum( TotalQuantity ) as TotalQuantity,
      Uom
}
group by
  ItemCode,
  Plant,
  Batch,
  Uom
