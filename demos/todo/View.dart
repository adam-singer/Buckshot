class View implements IView
{
  FrameworkElement _rootVisual;
  
  View(){
    
    //parse view xml and create object reference
    _rootVisual = Template.deserialize(Template.getTemplate('#view'));
    
    // bind the view model
    _rootVisual.dataContext = new ViewModel();
    
    // grab a reference to the button and 
    // ask view model to add a new entry when button is clicked
    Button b = buckshot.namedElements["btnSubmit"];
    b.click + (_, __) => _rootVisual.dataContext.addNewEntry();
  }
  
  FrameworkElement get rootVisual() => _rootVisual;
}
