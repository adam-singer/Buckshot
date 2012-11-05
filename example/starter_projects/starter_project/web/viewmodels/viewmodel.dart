part of starter_project;

class ViewModel extends ViewModelBase
{
  FrameworkProperty message;
  FrameworkProperty result;
  FrameworkProperty entry;

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
    message = new FrameworkProperty(this, 'message',
        defaultValue:_model.title);

    result = new FrameworkProperty(this, 'result',
        defaultValue: '');

    entry = new FrameworkProperty(this, 'entry');
  }

  void click_handler(sender, args){
    final v = entry.value;

    result.value = v.isEmpty() ? '' : 'You entered: "${entry.value}".';
  }
}
