class Calculator extends View
{

  Calculator() : super.fromResource('#calculator_main')
  {
    ready.then((t){
      rootVisual.dataContext = new CalculatorViewModel();
    });
  }
}
