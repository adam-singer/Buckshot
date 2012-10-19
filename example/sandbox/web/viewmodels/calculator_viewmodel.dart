#library('calculator_view_model');

#import('package:buckshot/buckshot.dart');
#import('../models/calc.dart');

#source('../views/calculator/standard_calc.dart');
#source('../views/calculator/extended_calc.dart');

/**
* Note that ViewModel extends from [ViewModelBase], which allows it to
* participate in the Buckshot property binding system.
*/
class CalculatorViewModel extends ViewModelBase
{
  /// Represents the standard calculator layout [IView].
  final StandardCalc standardCalc;

  /// Represents the extended calculator layout [IView].
  final ExtendedCalc extendedCalc;

  /// Represents the calculator implementation being used by the application.
  final ICalculator model;

  /// Represents the keypad view of the calculator (standard or extended).
  FrameworkProperty<FrameworkElement> keypad;

  /// Represents the primary output text of the calculator.
  FrameworkProperty<String> output;

  /// Represents the sub-output text of the calculator.
  FrameworkProperty<String> subOutput;

  /// Represents the marker indicating whether the calculator is holding a
  /// value in memory.
  FrameworkProperty<String> memoryMarker;

  FrameworkProperty<num> width;

  /* End Singleton */

  CalculatorViewModel()
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

    keypad = new FrameworkProperty(this, 'keypad',
        defaultValue:standardCalc.rootVisual);

    output = new FrameworkProperty(this, 'output', defaultValue:'0');

    subOutput = new FrameworkProperty(this, 'subOutput',
        defaultValue:'');

    memoryMarker = new FrameworkProperty(this, 'memoryMarker',
        defaultValue:'');

    width= new FrameworkProperty(this, 'width',
        defaultValue:300);

    registerEventHandler('buttonclick_handler', buttonClick_handler);
    registerEventHandler('selectionchanged_handler', selectionChanged_handler);
  }

  /**
  * [FrameworkEvent] handler that is called when the model fires a primary
  * output update.
  */
  void updateOutput(_, OutputChangedEventArgs args){
    output.value = args.output;
  }

  /**
  * [FrameworkEvent] handler that is called when the model fires a
  * sub-output update.
  */
  void updateSubOutput(_, OutputChangedEventArgs args){
    subOutput.value = args.output;
  }

  /**
  * [FrameworkEvent] handler that is called when the model fires a
  * memory marker update.
  */
  void updateMemoryMarker(_, OutputChangedEventArgs args){
    memoryMarker.value = args.output;
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
        keypad.value = standardCalc.rootVisual;
        width.value = 300;
        break;
      case 'Extended':
        keypad.value = extendedCalc.rootVisual;
        width.value = 330;
        break;
      default:
        keypad.value = standardCalc.rootVisual;
        width.value = 300;
        break;
    }
  }

  /**
   * Event handler that handles button clicks coming from the calculator.
   */
  void buttonClick_handler(Button sender, _){
    input(sender.content.value);
  }

  /**
   * Event handler that handles selection changed events coming from the
   * mode selector on the calculator.
   */
  void selectionChanged_handler(sender, args){
    setMode(args.selectedItem.item.value);
  }
}
