class Main implements IView
{
  final FrameworkElement _rootVisual;
  final DropDownList ddlMode;
  
  FrameworkElement get rootVisual() => _rootVisual;
  
  Main()
  :
    _rootVisual = buckshot.deserialize(buckshot.getTemplate('#main')),
    ddlMode = buckshot.namedElements['ddlMode']
  {
    var vm = new ViewModel();
    
    // Assign the view model to the datacontext so that template
    // bindings will hook up.
    _rootVisual.dataContext = vm;  
    
    // Call the view model setMode() method whenever the drop down list
    // value changes.
    ddlMode.selectionChanged + (_, SelectedItemChangedEventArgs args) => 
        vm.setMode(args.selectedItem.value);  
  }
}
