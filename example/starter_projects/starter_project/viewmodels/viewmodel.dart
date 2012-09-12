
class ViewModel extends ViewModelBase
{
  FrameworkProperty messageProperty;
  FrameworkProperty resultProperty;
  FrameworkProperty entryProperty;
  
  final Model _model;
  
  ViewModel() :
    _model = new Model()
  {
    _initViewModelProperties();
    _initEventHandlers();
  }
  
  void _initEventHandlers(){
    if (reflectionEnabled) return;
    
    registerEventHandler('click_handler', click_handler);
  }
  
  void _initViewModelProperties(){
    messageProperty = new FrameworkProperty(this, 'message', 
        defaultValue:_model.title);
    
    resultProperty = new FrameworkProperty(this, 'result',
        defaultValue: '');
    
    entryProperty = new FrameworkProperty(this, 'entry');
  }
  
  void click_handler(sender, args){
    final v = getValue(entryProperty);
    
    setValue(resultProperty, 
        v.isEmpty() ? '' : 'You entered: "${getValue(entryProperty)}".');
  }
}
