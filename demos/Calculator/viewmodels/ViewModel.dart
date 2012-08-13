/**
* Primary singleton view model for the application.
*
* Note that ViewModel extends from [ViewModelBase], which allows it to
* participate in the Buckshot property binding system.
*/
class ViewModel extends ViewModelBase
{
  /// Represents the standard calculator layout [IView].
  final StandardCalc standardCalc;

  /// Represents the extended calculator layout [IView].
  final ExtendedCalc extendedCalc;

  /// Represents the calculator implementation being used by the application.
  final ICalculator model;

  /// Represents the keypad view of the calculator (standard or extended).
  FrameworkProperty keypadProperty;

  /// Represents the primary output text of the calculator.
  FrameworkProperty outputProperty;

  /// Represents the sub-output text of the calculator.
  FrameworkProperty subOutputProperty;

  /// Represents the marker indicating whether the calculator is holding a
  /// value in memory.
  FrameworkProperty memoryMarkerProperty;

  FrameworkProperty widthProperty;

  /* Singleton */
  static ViewModel _vm;

  factory ViewModel()
  {
    if (_vm != null) return _vm;

    _vm = new ViewModel._internal();
    return _vm;
  }
  /* End Singleton */

  ViewModel._internal()
  :
    standardCalc = new StandardCalc(),
    extendedCalc = new ExtendedCalc(),
    model = new Calc()
  {
    _initProperties();

    // Subscribe to the model events that we are interested in.
    model.mainOutputChanged + updateOutput;
    model.subOutputChanged + updateSubOutput;
    model.memoryMarkerChanged + updateMemoryMarker;
  }

  void _initProperties(){

    // Initialize the framework properties with default values.

    keypadProperty = new FrameworkProperty(this, 'keypad',
        defaultValue:standardCalc.rootVisual);

    outputProperty = new FrameworkProperty(this, 'output', defaultValue:'0');

    subOutputProperty = new FrameworkProperty(this, 'subOutput',
        defaultValue:'');

    memoryMarkerProperty = new FrameworkProperty(this, 'memoryMarker',
        defaultValue:'');

    widthProperty = new FrameworkProperty(this, 'width',
        defaultValue:300);
  }

  /**
  * [FrameworkEvent] handler that is called when the model fires a primary
  * output update.
  */
  void updateOutput(_, OutputChangedEventArgs args){
    output = args.output;
  }

  /**
  * [FrameworkEvent] handler that is called when the model fires a
  * sub-output update.
  */
  void updateSubOutput(_, OutputChangedEventArgs args){
    subOutput = args.output;
  }

  /**
  * [FrameworkEvent] handler that is called when the model fires a
  * memory marker update.
  */
  void updateMemoryMarker(_, OutputChangedEventArgs args){
    memoryMarker = args.output;
  }

  /**
  * Takes an input [String] and passes it to the [ICalculator] for processing.
  */
  void input(String i)
  {
    model.put(i);
  }

  /**
  * Changes the visual mode of the calculator.  Currently accepts "Standard"
  * or "Extended" as valid modes.
  */
  void setMode(String mode){
    switch(mode){
      case 'Standard':
        keypad = standardCalc.rootVisual;
        width = 300;
        break;
      case 'Extended':
        keypad = extendedCalc.rootVisual;
        width = 330;
        break;
      default:
        keypad = standardCalc.rootVisual;
        width = 300;
        break;
    }
  }


  /*
  * The getters and setters below are for convenience and readability,
  * but not necessarily required.  By convention, it is recommended that
  * any defined FrameworkProperty should have a getter/setter pair as below.
  */

  num get width() => getValue(widthProperty);
  set width(num value) => setValue(widthProperty, value);

  /// Gets the [String] value of the [outputProperty] [FrameworkProperty].
  String get output() => getValue(outputProperty);
  /// Sets the [String] value for the [outputProperty] [FrameworkProperty].
  set output(String value) => setValue(outputProperty, value);

  /// Gets the [String] value of the [subOutputProperty] [FrameworkProperty].
  String get subOutput() => getValue(subOutputProperty);
  /// Sets the [String] value for the [subOutputProperty] [FrameworkProperty].
  set subOutput(String value) => setValue(subOutputProperty, value);

  /// Gets the [String] value of the [memoryMarkerProperty] [FrameworkProperty].
  String get memoryMarker() => getValue(memoryMarkerProperty);
  /// Sets the [String] value for the [memoryMarkerProperty]
  /// [FrameworkProperty].
  set memoryMarker(String value) => setValue(memoryMarkerProperty, value);

  /// Gets the [FrameworkElement] value of the [keypadProperty]
  /// [FrameworkProperty].
  FrameworkElement get keypad() => getValue(keypadProperty);
  /// Sets the [FrameworkElement] value for the [keypadProperty]
  /// [FrameworkProperty].
  set keypad(FrameworkElement value) => setValue(keypadProperty, value);

}
