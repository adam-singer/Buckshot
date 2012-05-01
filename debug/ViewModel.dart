/**
* View(s) will bind to properties in this view model */
class ViewModel extends ViewModelBase implements IMainViewModel {

FrameworkProperty titleProperty;

ViewModel(){
  titleProperty = new FrameworkProperty(this, "title", (_){});
}

String get title() => getValue(titleProperty);
set title(String value) => setValue(titleProperty, value);
}

//view model contract
interface IMainViewModel{

  FrameworkProperty titleProperty;

  String get title();
  set title(String value);
}