library stock_ticker_view_model;

import 'package:buckshot/buckshot_browser.dart';
import '../models/stock_ticker.dart';

class StockTickerViewModel extends ViewModelBase
{
  final _model = new StockTickerModel();

  /**
   * Holds textual input from the user regarding which
   * stock symbol to begin watching.  A view can use two-way binding to
   * this property to send input back from the user.
   */
  FrameworkProperty<String> tickerInput;

  /**
   * Holds an ObservableList<DataTemplate>, representing the current
   * listing of stock ticker results.
   */
  FrameworkProperty<ObservableList<DataTemplate>> tickerOutput;

  /**
   * Holds an ObservableList<String> of symbols being watched by the ticker
   * application.
   */
  FrameworkProperty<ObservableList<String>> watchList;

  /**
   * Holds a reference to the view that is using this view model instance.
   */
  final View view;

  StockTickerViewModel.with(this.view){
    // Initialize the framework properties.
    _initStockTickerViewModelProperties();

    // Register an event handler that a view can declaratively bind to
    // with "on.click='watch_ticker_click'"
    registerEventHandler('watch_ticker_click', watch_ticker_click);

    // Subscribe to the model's update event.
    _model.stockUpdate + stock_update_handler;

    // start and stop the model based on whether the view is loaded or not.
    view.rootVisual.loaded + (_, __) => _model.start();
    view.rootVisual.unloaded + (_, __) => _model.stop();
  }

  void _initStockTickerViewModelProperties(){
    tickerInput = new FrameworkProperty(this, 'tickerInput');

    tickerOutput = new FrameworkProperty(this, 'tickerOutput',
        defaultValue: new ObservableList<DataTemplate>());

    watchList = new FrameworkProperty(this, 'watchList',
        defaultValue: new ObservableList<String>());
  }

  // Event Handlers

  /**
   * Handles any ticker updates coming from the model.
   */
  void stock_update_handler(sender, StockUpdateEventArgs args){

    /*
     * We are going to constrain the list length to 13 elements.
     */
    if (tickerOutput.value.length == 13){
      tickerOutput.value.remove(tickerOutput.value[0]);
    }

    /*
     * Here we create a DataTemplate object that is formatted to be consumed
     * by a the view.  DataTemplate creates a bindable FrameworkObject on the
     * fly, which saves the developer from having to create dedicated classes
     * just to contain bindable data elements.
     *
     * Once the object is created, we add it to the tickerOutputProperty, which
     * a view can use to to any collection control, such as CollectionPresenter.
     *
     * See the stock_ticker.xml template for an example of how this binding
     * works.
     */
    tickerOutput.value.add(
        new DataTemplate.fromMap(
            {
              'datetime' : '${args.timeStamp.hour}:'
                            '${adjustTimeValue(args.timeStamp.minute)}:'
                            '${adjustTimeValue(args.timeStamp.second)}',
              'symbol' : '${args.ticker}',
              'quote' : '\$${roundTo2(args.quote)}',
              'directionColor' : '${args.isUp ? "Lime" : "Red"}'
              }
            ));
  }

  /**
   * Handles a submit button click event.
   */
  void watch_ticker_click(sender, args){
    // Send the symbol to the model.
    _model.watchSymbol(tickerInput.value);

    // Add it to our watch list collection, which a view can bind to
    // to display the list of watched stock symbols.
    watchList.value.add(tickerInput.value.toUpperCase());

    tickerInput.value = '';
  }
}


/// Adds a leading 0 if the time component is less than 10 and returns as
/// String.
String adjustTimeValue(num minute) =>
    (minute < 10) ? '0${minute}' : '$minute';

/// Rounds a given [value] to 2 decimal places and returns as String.
String roundTo2(num value){
  final vstr = value.toString();

  if (!vstr.contains('.')) return vstr;
  final len = vstr.length;
  final i = vstr.indexOf('.', 0);
  if (len - i == 2) return vstr;

  return vstr.substring(0, i + 3);

}
