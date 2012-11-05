part of switchy;

/** Represents a view for a stock ticker widget. */
class StockTicker extends View
{
  StockTicker() : super.fromResource('web/views/templates/ticker.xml'){
    ready.then((t){
      t.dataContext.value = new StockTickerViewModel.with(this);
    });
  }
}
