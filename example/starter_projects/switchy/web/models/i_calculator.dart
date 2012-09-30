
/**
* Provides a contract for calculator implementations to work within
* this application.
*/
interface ICalculator{
  
  /**
  * Receives input from the environment and applies it to
  * the current calculator state.
  */
  void put(String value);
  
  /** 
  * An event which fires when the calculator implementation 
  * changes the primary output.
  */
  final FrameworkEvent<OutputChangedEventArgs> mainOutputChanged;
  
  /** 
  * An event which fires when the calculator implementation 
  * changes the sub-output.
  *
  * The sub-output is a convience output to indicate previously
  * stored information in the current expression.  For example:
  *     5 +
  * which indicates to the user that 5 is already stored, and the
  * addition operator will be applied to it and the second operand.
  */
  final FrameworkEvent<OutputChangedEventArgs> subOutputChanged;
  
  /**
  * An event which fires when the calculator changes the memory-
  * marker state.
  *
  * Depending on user input, the calculator may store a value in
  * it's memory register, for later recall.  This event fires with
  * either an empty string or "M" to indicate if the memory register
  * contains a value.
  */
  final FrameworkEvent<OutputChangedEventArgs> memoryMarkerChanged;
}