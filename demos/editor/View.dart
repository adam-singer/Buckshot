class View implements BuckshotUI.IView 
{
  BuckshotUI.FrameworkElement _rootVisual;
  
  View(){
    //parse view xml and create object reference
    _rootVisual = BuckshotUI.buckshot.defaultPresentationProvider.deserialize(BuckshotUI.buckshot.getTemplate('#view'));
    
  }
  BuckshotUI.FrameworkElement get rootVisual() => _rootVisual;
}
