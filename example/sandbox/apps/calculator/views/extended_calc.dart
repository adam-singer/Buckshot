/**
* Represents the view of an extended calculator keypad layout.
*/
class ExtendedCalc extends View {

  ExtendedCalc()
  {
    // Retrieve the template from the HTML page and deserialize it.
    Template
    .deserialize(Template.getTemplate('#keypad_extended'))
    .then((t){
      rootVisual = t;
    });
  }
}
