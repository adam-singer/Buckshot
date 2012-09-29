#library('stock_ticker_model');

#import('dart:math');

/** A simple stock ticker model, */
class StockTickerModel
{

}


class StockTickerInfo
{
  final Date timeStamp;
  final String ticker;
  final double quote;

  StockTickerInfo(this.ticker, this.quote) :
    timeStamp = new Date.now();
}