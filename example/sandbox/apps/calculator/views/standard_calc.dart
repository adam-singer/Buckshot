/**
* Represents the view of an standard calculator keypad layout.
*/
class StandardCalc extends View
{

  StandardCalc()
  {

    // Retrieve the template from the HTML page and deserialize it.
    Template
    .deserialize(Template.getTemplate('#keypad_default'))
    .then((t){
      rootVisual = t;
    });
  }
}
