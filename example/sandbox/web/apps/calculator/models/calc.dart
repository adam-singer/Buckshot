part of calculator_apps_buckshot;


/**
* A naive calculator implementation.
*/
class Calc implements ICalculator
{
  static const int EMPTY = 0;
  static const int FOPERAND = 1;
  static const int OP = 2;
  static const int SOPERAND = 3;

  static const num PI = 3.1415926535897;

  final List<Function> registeredMain;
  final List<Function> registeredSub;
  final StringBuffer numBuffer1;
  final StringBuffer numBuffer2;

  Map<String, Function> operators;
  String currentOp = '';
  String memory = '0';

  Calc()
  :
    registeredMain = [],
    registeredSub = [],
    numBuffer1 = new StringBuffer(),
    numBuffer2 = new StringBuffer(),
    mainOutputChanged = new FrameworkEvent<OutputChangedEventArgs>(),
    subOutputChanged = new FrameworkEvent<OutputChangedEventArgs>(),
    memoryMarkerChanged = new FrameworkEvent<OutputChangedEventArgs>()
  {
    operators =
      {
      '+-' : neg,
      'C' : clear,
      'CE' : clearEntry,
      '<--' : backspace,
      '.' : decimal,
      'SQRT' : squareRoot,
      '=' : eq,
      '+' : add,
      '-' : sub,
      '*' : mul,
      '/' : div,
      '%' : percent,
      '1/x' : reciproc,
      'MC' : mc,
      'MR' : mr,
      'MS' : ms,
      'M-' : mp,
      'M+' : mm,
      'cos' : cos,
      'sin' : sin,
      'x^2' : pow2,
      'x^3' : pow3,
      'pi' : pi
     };
  }

  /* Begin ICalculator Interface */

  final FrameworkEvent<OutputChangedEventArgs> mainOutputChanged;
  final FrameworkEvent<OutputChangedEventArgs> subOutputChanged;
  final FrameworkEvent<OutputChangedEventArgs> memoryMarkerChanged;

  void put(String something){
    if (_isNumber(something)){
      handleNumber(something);
    }else{
      handleOperator(something);
    }
  }

  /* End ICalculator Interface */


  // These helper methods are called by the implementation to fire the
  // corresponding event from the ICalculator interface.

  void onMemoryMarkerChanged(String output){
    memoryMarkerChanged.invoke(this, new OutputChangedEventArgs(output));
  }

  void onSubOutputChanged(String output){
    subOutputChanged.invoke(this, new OutputChangedEventArgs(output));
  }

  void onMainOutputChanged(String output){
    mainOutputChanged.invoke(this, new OutputChangedEventArgs(output));
  }


  /*
   * Implementation
   */

  void handleOperator(String op){
    switch(op){
      case 'C':
      case 'CE':
      case '<--':
      case '.':
      case '+-':
      case 'SQRT':
      case '=':
      case '%':
      case '1/x':
      case 'MS':
      case 'MC':
      case 'MR':
      case 'M-':
      case 'M+':
      case 'pi':
      case 'cos':
      case 'sin':
      case 'x^2':
      case 'x^3':
        // Execute immediately.
        operators[op]();
        break;
      default:
        if (operators.containsKey(op)){
          // Store for later execution when user presses '='.
          currentOp = op;
          _updateOutput();
        }
    }
  }

  void handleNumber(String number){
    if (_state < OP){
      if (numBuffer1.length == 15) return;
      numBuffer1.add(number);
    }else{
      if (numBuffer2.length == 15) return;
      numBuffer2.add(number);
    }

    _updateOutput();
  }

  int get _state {
    if (!numBuffer2.isEmpty) return SOPERAND;
    if (!currentOp.isEmpty) return OP;
    if (!numBuffer1.isEmpty) return FOPERAND;
    return EMPTY;
  }

  bool _isNumber(String value){
    final String test = '1234567890';

    return (test.contains(value));
  }

  void _updateOutput(){

    String str;

    if (_state == EMPTY){
      str = '0';
    }else if (_state == FOPERAND){
      str = numBuffer1.toString();
    }else if (_state == OP && !numBuffer2.isEmpty){
      str = numBuffer2.toString();
    }else if (_state == OP && numBuffer2.isEmpty){
      str = numBuffer1.toString();
    }else if (_state == SOPERAND){
      str = numBuffer2.toString();
    }

    //TODO perform rounding/precision instead of truncating
    if (str.length > 15){
      str = str.substring(0, 14);
    }

    onMainOutputChanged(str);

    onSubOutputChanged(
      _state >= OP ? '${numBuffer1.toString()} ${currentOp}' : '');

    onMemoryMarkerChanged(memory == '0' ? '' : 'M');
  }

  void _putNumber(num number){
    if (_state != FOPERAND && _state != SOPERAND) return;

    if (number == number.floor()){
      number = int.parse(number.toString().replaceAll('.0', ''));
    }

    if (_state == FOPERAND){
      numBuffer1.clear();
      numBuffer1.add(number.toString());
    }else{
      numBuffer2.clear();
      numBuffer2.add(number.toString());
    }
  }

  num _getNumber(){
    if (_state != FOPERAND && _state != SOPERAND) return null;

    var str = (_state == FOPERAND) ? numBuffer1.toString() : numBuffer2.toString();
    if (str.endsWith('.')){
      str = str.substring(0, str.length - 1);
    }
    return  str.contains('.') ? double.parse(str) : int.parse(str);
  }

  num _getNumberFrom(String str){

    if (str.endsWith('.')){
      str = str.substring(0, str.length - 1);
    }

    return str.contains('.') ? double.parse(str) : int.parse(str);
  }

  /* Operators */

  void neg(){
    bool isNeg(String str) => str.startsWith('-');

    if (_state == FOPERAND){
      var str = numBuffer1.toString();
      numBuffer1.clear();
      if (isNeg(str)){
        numBuffer1.add(str.replaceFirst('-', ''));
      }else{
        numBuffer1.add('-$str');
      }
    }else if (_state == SOPERAND){
      var str = numBuffer2.toString();
      numBuffer2.clear();
      if (isNeg(str)){
        numBuffer2.add(str.replaceFirst('-', ''));
      }else{
        numBuffer2.add('-$str');
      }
    }
    _updateOutput();
  }

  void clear(){
    numBuffer1.clear();
    numBuffer2.clear();
    currentOp = '';
    _updateOutput();
  }

  void clearEntry(){
    if (_state == FOPERAND){
      numBuffer1.clear();
    }else if (_state == SOPERAND){
      print('hi');
      numBuffer2.clear();
    }
    _updateOutput();
  }

  void backspace(){
    switch(_state){
      case FOPERAND:
        var buff = numBuffer1.toString().substring(0, numBuffer1.toString().length - 1);
        numBuffer1.clear();
        numBuffer1.add(buff);
        break;
      case SOPERAND:
        var buff = numBuffer2.toString().substring(0, numBuffer2.toString().length - 1);
        numBuffer2.clear();
        numBuffer2.add(buff);
        break;
      case OP:
        currentOp = '';
        break;
    }

    _updateOutput();
  }

  void squareRoot(){
    num v = _getNumber();

    if (v == null) return;

    _putNumber(Math.sqrt(v));

    _updateOutput();
  }

  void reciproc(){
    num v = _getNumber();

    if (v == null || v == 0) return;

    _putNumber(1 / v);

    _updateOutput();
  }

  void sin(){
    num v = _getNumber();
    if (v == null) return;

    _putNumber(Math.sin(v));
    _updateOutput();
  }

  void cos(){
    num v = _getNumber();
    if (v == null) return;

    _putNumber(Math.cos(v));
    _updateOutput();
  }

  void pi(){
    _putNumber(PI);
    _updateOutput();
  }

  void pow2(){
    num v = _getNumber();
    if (v == null) return;

    _putNumber(v * v);
    _updateOutput();
  }

  void pow3(){
    num v = _getNumber();
    if (v == null) return;

    _putNumber(v * v * v);
    _updateOutput();
  }

  void mc(){
    this.memory = '0';
    _updateOutput();
  }

  void mr(){
    if (_state <= FOPERAND){
      numBuffer1.clear();
      if (memory != '0'){
        numBuffer1.add(memory);
      }
    }else{
      numBuffer2.clear();
      if (memory != '0'){
        numBuffer2.add(memory);
      }
    }
    _updateOutput();
  }

  void ms(){
    num v = _getNumber();
    memory = v.toString();
    _updateOutput();
  }

  void mp(){
    num v = _getNumber();
    num m = _getNumberFrom(memory);

    memory = (m - v).toString();

    _updateOutput();

  }

  void mm(){
    num v = _getNumber();
    num m = _getNumberFrom(memory);

    print(v);

    memory = (m - v).toString();

    _updateOutput();
  }

  void eq(){
    if (_state < OP) return;

    if (_state == OP){
      numBuffer2.add(numBuffer1.toString());
    }

    var result = operators[currentOp]();
    if (result == result.floor()){
      result = int.parse(result.toString().replaceAll('.0', ''));
    }
    clear();

    numBuffer1.add(result.toString());
    _updateOutput();
  }

  void percent(){
    if (_state < SOPERAND) return;

    var fo = _getNumberFrom(numBuffer1.toString());

    var so = _getNumberFrom(numBuffer2.toString());

    var result = fo * (so * .01);

    numBuffer2.clear();
    numBuffer2.add(result.toString());
    _updateOutput();
  }

  num add(){
    return _getNumberFrom(numBuffer1.toString())
        + _getNumberFrom(numBuffer2.toString());
  }

  num sub(){
    return _getNumberFrom(numBuffer1.toString())
        - _getNumberFrom(numBuffer2.toString());
  }

  num mul(){
    return _getNumberFrom(numBuffer1.toString())
        * _getNumberFrom(numBuffer2.toString());
  }

  num div(){
    var denom = _getNumberFrom(numBuffer2.toString());
    if (denom == 0) return 0;

    return _getNumberFrom(numBuffer1.toString())
        / _getNumberFrom(numBuffer2.toString());
  }

  void decimal(){
    bool hasDecimal(String str) => str.contains('.');

    if (_state == FOPERAND || _state == EMPTY){
      if (hasDecimal(numBuffer1.toString())) return;
      numBuffer1.add('.');
    }else if (_state == SOPERAND){
      if (hasDecimal(numBuffer1.toString())) return;
      numBuffer2.add('.');
    }
    _updateOutput();
  }

}



