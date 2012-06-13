
/// ViewModelBase allows the class to implement [FrameworkProperty]s
class ViewModel extends ViewModelBase 
{
  FrameworkProperty dueDateProperty;
  FrameworkProperty taskNameProperty;
  FrameworkProperty statusTextProperty;
  FrameworkProperty statusColorProperty;
  FrameworkProperty itemsProperty;
  
  final Brush bad;
  final Brush good;
  
  ViewModel()
  :
    bad = new SolidColorBrush(new Color.predefined(Colors.Red)),
    good = new SolidColorBrush(new Color.predefined(Colors.Green))
  {
    
    taskNameProperty = new FrameworkProperty(this, "taskName", (_){}, "");
    
    dueDateProperty = new FrameworkProperty(this, "dueDate", (_){}, "");
    
    statusTextProperty = new FrameworkProperty(this, "statusText", (_){}, "");
    
    statusColorProperty = new FrameworkProperty(this, "statusColor", (_){}, good);
    
    itemsProperty = new FrameworkProperty(this, "items", (_){}, new ObservableList());
  }
  
  void addNewEntry(){
    if (taskName.isEmpty() || dueDate.isEmpty()){
      statusColor = bad;
      statusText = "Please make sure Task and Due Date are filled in.";
    }else{
      statusColor = good;
      statusText = "Task Added.";
      
      //using a DataTemplate so the view can bind to the list by referening the
      //property names in the map.
      // This saves the task of having to create a dedicated class
      items.add(new DataTemplate.fromMap({"date" : dueDate, "task" : taskName}));
      
      taskName = "";
      dueDate = "";
    }
  }
  
  //convenience getters/setters for our properties.
  
  ObservableList get items() => getValue(itemsProperty);
  
  String get taskName() => getValue(taskNameProperty);
  set taskName(String value) => setValue(taskNameProperty, value);
  
  String get dueDate() => getValue(dueDateProperty);
  set dueDate(String value) => setValue(dueDateProperty, value);
  
  String get statusText() => getValue(statusTextProperty);
  set statusText(String value) => setValue(statusTextProperty, value);
  
  Brush get statusColor() => getValue(statusColorProperty);
  set statusColor(Brush value) => setValue(statusColorProperty, value);
  
}
