library stock_ticker_model;

import 'dart:math';
import 'dart:isolate';
import 'package:dartnet_event_model/events.dart';

/**
 * A simple stock ticker service.
 *
 * This is a mock-model of data that would typically come from a
 * remote service.
 * */
class StockTickerModel
{
  final Random _rng = new Random();

  final FrameworkEvent<StockUpdateEventArgs> stockUpdate =
      new FrameworkEvent<StockUpdateEventArgs>();

  Timer _timer;
  num _interval = 1000;

  final Map<String, num> _tickerSymbols = new Map<String, num>();

  StockTickerModel(){
    _start();
  }

  /**
   * Sets the polling interval of the ticker service.  Values < 0 will be
   * ignored.
   */
  set updateInterval(num interval){
    if (interval < 0) return;
    stop();
    _interval = interval;
    start();
  }

  void stop(){
    _timer.cancel();
  }

  void start(){
    _timer = new Timer.repeating(_interval, _updateTickers);
  }

  /**
   * Starts retrieving information for a given stock [symbol].  Updates will
   * arrive via the [stockUpdate] event.
   */
  void watchSymbol(String symbol){
    if (symbol == null || symbol.isEmpty) return;

    if (symbol.length > 4){
      symbol = symbol.substring(0, 3);
    }

    symbol = symbol.toUpperCase();

    // starting between 1 & 100 dollars
    _tickerSymbols[symbol] = _rng.nextDouble() * 100 + 1;
  }

  void _start(){
    // default check for updates every second
    _timer = new Timer.repeating(_interval, _updateTickers);
  }

  void _updateTickers(_){
    if (_tickerSymbols.isEmpty) return;

    _tickerSymbols.forEach((symbol, currentPrice){
      if (!(_rng.nextInt(100) > 50)) return; // 50% chance to spawn a symbol update

      // some value within 10% of the current price.
      var variance = (currentPrice * .1) * _rng.nextDouble();

      // up or down
      variance *= _rng.nextInt(100) > 50 ? -1 : 1;

      final newPrice = currentPrice + variance;

      _tickerSymbols[symbol] = newPrice;

      // fire the event with the new info
      stockUpdate.invokeAsync(this,
          new StockUpdateEventArgs(symbol, newPrice, newPrice > currentPrice));
    });
  }
}

class StockUpdateEventArgs extends EventArgs
{
  /// date/time stamp of this quote
  final Date timeStamp;
  /// the stock symbol
  final String ticker;
  /// the updated quote
  final double quote;
  /// true if the price is up from the previous quote.
  final bool isUp;

  StockUpdateEventArgs(this.ticker, this.quote, this.isUp) :
    timeStamp = new Date.now();

}