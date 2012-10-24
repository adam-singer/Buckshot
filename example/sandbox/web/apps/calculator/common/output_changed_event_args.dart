part of calculator_apps_buckshot;


/**
* Event-handler object to support the [FrameworkEvent]s in [ICalculator].
*/
class OutputChangedEventArgs extends EventArgs{
  /// The changed output.
  final String output;
  
  OutputChangedEventArgs(this.output);
}