@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Stock Ageing Interface View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_STOCK_AGEING_REPORT
  as select from I_Batch as _batch
  association [0..*] to I_MaterialStock_2       as _Materialstock on  _Materialstock.Batch                     = _batch.Batch
                                                                  and _Materialstock.Material                  = _batch.Material
                                                                  and _Materialstock.Plant                     = _batch.Plant
                                                                  and _Materialstock.InventorySpecialStockType is initial
  association [0..*] to I_ProductValuationBasic as _Productvalue  on  _batch.Material = _Productvalue.Product
{
  key _batch.Material                                                                   as ItemCode,
  key _batch.Plant                                                                      as Plant,
  key _batch.Batch                                                                      as Batch,
  key _Materialstock.MatlDocLatestPostgDate                                             as PostingDate,
  key _Materialstock.StorageLocation                                                    as StorageLocation,
      _Materialstock._Material.ProductGroup                                             as MaterialGroup,
      _Materialstock._Material._Text[ Language = $session.system_language ].ProductName as ItemDescription,
      $session.system_date                                                              as AgeingDate,
      _Materialstock.CompanyCode                                                        as CompanyCode,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      _Materialstock.MatlWrhsStkQtyInMatlBaseUnit                                       as TotalQuantity,
      _Materialstock.MaterialBaseUnit                                                   as Uom,
      @Semantics.amount.currencyCode: 'Currencycode'
      _Productvalue.MovingAveragePrice                                                  as Value,
      _Productvalue.Currency                                                            as Currencycode

}
where
  _batch.Plant is not initial;
