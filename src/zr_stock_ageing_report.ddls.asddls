@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Stock Ageing Root View'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZR_STOCK_AGEING_REPORT
  as select from ZI_STOCK_AGEING_REPORT as StockAgeing
    inner join   ZI_STOCK_AGEING_DATA   as StockAgeingData on  StockAgeing.ItemCode = StockAgeingData.ItemCode
                                                           and StockAgeing.Batch    = StockAgeingData.Batch
                                                           and StockAgeing.Plant    = StockAgeingData.Plant

{
  key StockAgeing.ItemCode,
  key StockAgeing.Plant,
  key StockAgeing.Batch,
  key min(StockAgeing.PostingDate) as PostingDate,
  key StockAgeing.StorageLocation,
      StockAgeing.MaterialGroup,
      StockAgeing.ItemDescription,
      StockAgeing.AgeingDate,
      StockAgeing.CompanyCode,
      cast(StockAgeingData.TotalQuantity as abap.dec( 31, 3 ) ) as TotalQuantity,
      StockAgeing.Uom,
      @Semantics.amount.currencyCode: 'Currencycode'
      StockAgeing.Value,
      StockAgeing.Currencycode,
      cast(
           case
           when dats_days_between(min(StockAgeing.PostingDate), StockAgeing.AgeingDate ) >= 0
           and dats_days_between(min(StockAgeing.PostingDate), StockAgeing.AgeingDate) < 7
           then cast(StockAgeingData.TotalQuantity as abap.dec( 31, 14 ) )
           else 0
           end as abap.dec(31, 3)
           )                                                    as Days0to7,

      cast(
           case
           when dats_days_between(min(StockAgeing.PostingDate), StockAgeing.AgeingDate) >= 7
           and dats_days_between(min(StockAgeing.PostingDate), StockAgeing.AgeingDate) < 15
           then cast(StockAgeingData.TotalQuantity as abap.dec( 31, 14 ) )
           else 0
           end as abap.dec(31, 3)
           )                                                    as Days7to15,

      cast(
           case
           when dats_days_between(min(StockAgeing.PostingDate), StockAgeing.AgeingDate) >= 15
           and dats_days_between(min(StockAgeing.PostingDate), StockAgeing.AgeingDate) < 30
           then cast(StockAgeingData.TotalQuantity as abap.dec( 31, 14 ) )
           else 0
           end as abap.dec(31, 3)
           )                                                    as Days15to30,

      cast(
           case
           when dats_days_between(min(StockAgeing.PostingDate), StockAgeing.AgeingDate) >= 30
           and dats_days_between(min(StockAgeing.PostingDate), StockAgeing.AgeingDate) < 60
           then cast(StockAgeingData.TotalQuantity as abap.dec( 31, 14 ) )
           else 0
           end as abap.dec(31, 3)
           )                                                    as Days30to60,

      cast(
           case
           when dats_days_between(min(StockAgeing.PostingDate), StockAgeing.AgeingDate) >= 60
           and dats_days_between(min(StockAgeing.PostingDate), StockAgeing.AgeingDate) < 90
           then cast(StockAgeingData.TotalQuantity as abap.dec( 31, 14 ) )
           else 0
           end as abap.dec(31, 3)
           )                                                    as Days60to90,

      cast(
           case
           when dats_days_between(min(StockAgeing.PostingDate), StockAgeing.AgeingDate) >= 90
           and dats_days_between(min(StockAgeing.PostingDate), StockAgeing.AgeingDate) < 120
           then cast(StockAgeingData.TotalQuantity as abap.dec( 31, 14 ) )
           else 0
           end as abap.dec(31, 3)
           )                                                    as Days90to120,

      cast(
           case
           when dats_days_between(min(StockAgeing.PostingDate), StockAgeing.AgeingDate) >= 120
           and dats_days_between(min(StockAgeing.PostingDate), StockAgeing.AgeingDate) < 180
           then cast(StockAgeingData.TotalQuantity as abap.dec( 31, 14 ) )
           else 0
           end as abap.dec(31, 3)
           )                                                    as Days120to180,

      cast(
           case
           when dats_days_between(min(StockAgeing.PostingDate), StockAgeing.AgeingDate) >= 180
           then cast(StockAgeingData.TotalQuantity as abap.dec( 31, 14 ) )
           else 0
           end as abap.dec(31, 3)
           )                                                    as above180Days,
      cast(
      cast(StockAgeingData.TotalQuantity as abap.dec(18, 3)) *
      cast(StockAgeing.Value as abap.dec(18, 3))
      as abap.dec(31, 3)
      )                                                         as TotalValue
}
group by
  StockAgeing.ItemCode,
  StockAgeing.Batch,
  StockAgeing.Plant,
  StockAgeing.AgeingDate,
  StockAgeing.StorageLocation,
  StockAgeing.MaterialGroup,
  StockAgeing.ItemDescription,
  StockAgeing.CompanyCode,
  StockAgeingData.TotalQuantity,
  StockAgeing.Uom,
  StockAgeing.Value,
  StockAgeing.Currencycode
having
  StockAgeingData.TotalQuantity > 0
