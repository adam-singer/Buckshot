#library('stock_ticker_view_model');

#import('package:buckshot/buckshot.dart');
#import('../models/stock_ticker.dart');

class StockTickerViewModel extends ViewModelBase
{
  final _model = new StockTickerModel();

  FrameworkProperty tickerInputProperty;
  FrameworkProperty tickerOutputProperty;



  StockTickerViewModel(){
    _initStockTickerViewModelProperties();

    this.registerEventHandler('watch_ticker_click', watch_ticker_click);

    _model.stockUpdate + stock_update_handler;
  }


  void _initStockTickerViewModelProperties(){
    tickerInputProperty = new FrameworkProperty(this, 'tickerInput');

    tickerOutputProperty = new FrameworkProperty(this, 'tickerOutput',
        defaultValue: new ObservableList<DataTemplate>());
  }

  // Getters
  ObservableList<DataTemplate> get tickerOutput =>
      getValue(tickerOutputProperty);

  set tickerInput(String symbol) => setValue(tickerInputProperty, symbol);
  String get tickerInput => getValue(tickerInputProperty);

  // Event Handlers

  void stock_update_handler(sender, StockUpdateEventArgs args){
    if (tickerOutput.length == 10){
      tickerOutput.remove(tickerOutput[0]);
    }

    tickerOutput.add(
        new DataTemplate.fromMap(
            {
              'datetime' : '${args.timeStamp}',
              'symbol' : '${args.ticker}',
              'quote' : '${args.quote}',
              'isup' : '${args.isUp}'
              }
            ));

    print('${args.timeStamp}, Sym: ${args.ticker},  Quote: ${args.quote}, Up? ${args.isUp}');
  }

  void watch_ticker_click(sender, args){
    _model.watchSymbol(getValue(tickerInputProperty));
  }
}
