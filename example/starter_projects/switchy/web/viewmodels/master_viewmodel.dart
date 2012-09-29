
class MasterViewModel extends ViewModelBase
{
  FrameworkProperty statusMessageProperty;

  MasterViewModel(){
    _initMasterViewModelProperties();
  }

  void _initMasterViewModelProperties(){
    statusMessageProperty = new FrameworkProperty(this, 'statusMessage',
        defaultValue: 'Welcome to Switchy! A demo content switching'
          ' application for Buckshot.');
  }
}
