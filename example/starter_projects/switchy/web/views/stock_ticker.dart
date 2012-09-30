
/** Represents a view for a stock ticker widget. */
class StockTicker extends View
{
  StockTicker() : super.fromResource('#ticker'){
    ready.then((t){
      t.dataContext = new StockTickerViewModel();
    });
  }
}
