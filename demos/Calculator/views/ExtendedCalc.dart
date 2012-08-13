/**
* Represents the view of an extended calculator keypad layout.
*/
class ExtendedCalc extends IView {

  ExtendedCalc()
  {

    // Retrieve the template from the HTML page and deserialize it.
    Template
    .deserialize(Template.getTemplate('#keypad_extended'))
    .then((t){

      rootVisual = t;

      // When Dart has reflection, we won't need to hook these events manually.
      // we'll be able to do it via template.
      var g = buckshot.namedElements['gridExtended'];

      g.dynamic.children
      .filter((child) => child is Button)
      .forEach((child){
        child.click + handleClick;
      });

    });
  }

  // This function takes a click event from any of the buttons on the calculator
  // and sends along the string equivalent of that button to the view model.
  //
  // When Dart has reflection, we won't need to hook these events manually.
  // we'll be able to do it via template.
  void handleClick(Button sender, _){

    //this is ok, the ViewModel is a singleton
    var vm = new ViewModel();

    assert(sender is Button);
    assert(sender.content is String);

    vm.input(sender.content);
  }

}
