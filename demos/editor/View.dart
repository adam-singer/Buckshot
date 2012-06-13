class View implements IView 
{
  FrameworkElement _rootVisual;
  
  View(){
    //parse view xml and create object reference
    _rootVisual = buckshot.defaultPresentationProvider.deserialize(buckshot.getTemplate('#view'));
    
  }
  FrameworkElement get rootVisual() => _rootVisual;
}
