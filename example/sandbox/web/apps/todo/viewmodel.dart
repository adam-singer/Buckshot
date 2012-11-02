part of todo_apps_buckshot;


/// ViewModelBase allows the class to implement [FrameworkProperty]s
class ViewModel extends ViewModelBase
{
  FrameworkProperty<String> dueDate;
  FrameworkProperty<String> taskName;
  FrameworkProperty<String> statusText;
  FrameworkProperty<Color> statusColor;
  FrameworkProperty<ObservableList<DataTemplate>> items;

  final Color bad = new Color.predefined(Colors.Red);
  final Color good = new Color.predefined(Colors.Green);

  ViewModel()
  {

    taskName = new FrameworkProperty(this, "taskName", defaultValue:"");

    dueDate = new FrameworkProperty(this, "dueDate", defaultValue:"");

    statusText = new FrameworkProperty(this, "statusText", defaultValue:"");

    statusColor = new FrameworkProperty(this, "statusColor", defaultValue:good);

    items = new FrameworkProperty(this, "items",
        defaultValue:new ObservableList<DataTemplate>());

    registerEventHandler('onsubmit_handler', onSubmit_handler);
  }

  void addNewEntry(){
    if (taskName.value.isEmpty || dueDate.value.isEmpty){
      statusColor.value = bad;
      statusText.value = "Please make sure Task and Due Date are filled in.";
    }else{
      statusColor.value = good;
      statusText.value = "Task Added.";

      //using a DataTemplate so the view can bind to the list by referening the
      //property names in the map.
      // This saves the task of having to create a dedicated class
      items.value.add(
          new DataTemplate
          .fromMap({"date" : dueDate.value, "task" : taskName.value}));

      taskName.value = "";
      dueDate.value = "";
    }
  }

  void onSubmit_handler(sender, args){
    addNewEntry();
  }
}
