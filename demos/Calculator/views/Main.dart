class Main extends View
{
  DropDownList ddlMode;

  Main()
  {

    Template
      .deserialize(Template.getTemplate('#main2'))
      .then((t){
        rootVisual = t;
        ddlMode = buckshot.namedElements['ddlMode'];

        final vm = new ViewModel();

        // Assign the view model to the datacontext so that template
        // bindings will hook up.
        rootVisual.dataContext = vm;

        // Call the view model setMode() method whenever the drop down list
        // value changes.
        ddlMode.selectionChanged + (_, SelectedItemChangedEventArgs args) =>
            vm.setMode(args.selectedItem.value);

      });

  }
}
