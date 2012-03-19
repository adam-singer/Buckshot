class View implements IView
{
  FrameworkElement _rootVisual;
  
  // declarative view with databinding to ViewModel properties
  final String _viewTemplate = 
'''
<stackpanel margin="5">
  <textblock text="TO-DO List" fontsize="24"></textblock>

  <textblock text="Enter TO-DO Item And Click Submit" fontsize="18" margin="0,5"></textblock>
  
  <stackpanel orientation="horizontal">
    <textblock>Task:</textblock>
    <textbox placeholder="Enter Task Here" text="{data taskName, mode=twoway}" width="200" margin="0,0,0,10"></textbox>
  </stackpanel>
  
  <stackpanel orientation="horizontal">
    <textblock>Due Date:</textblock>
    <textbox placeholder="MM/DD/YY" text="{data dueDate, mode=twoway}" width="75" margin="0,0,0,10"></textbox>
  </stackpanel>
  
  <button name="btnSubmit" content="Add Task" width="75" margin="5,0,0,0"></button>
  
  <textblock foreground="{data statusColor}" text="{data statusText, mode=twoway}"></textblock>
  
  <textblock text="Tasks:" margin="15,0,0,0"></textblock>
  
  <border bordercolor="Black" borderthickness="1" padding="5" background="#667788">
    <stackpanel>
      <stackpanel orientation="horizontal">
        <textblock foreground="White" width="85" margin="5,0" text="Due Date"></textblock>
        <textblock foreground="White" width="200" margin="5,0" text="Task"></textblock>
      </stackpanel>
      <collectionpresenter datacontext="{data items}">
        <itemstemplate>
          <stackpanel orientation="horizontal" margin="2,0,0,0">
            <textblock background="#334455" foreground="White" width="85" margin="5,0" text="{data date}"></textblock>
            <textblock background="#334455" foreground="White" width="200" margin="5,0" text="{data task}"></textblock>
          </stackpanel>
        </itemstemplate>
      </collectionpresenter>
    </stackpanel>
  </border>
</stackpanel>
''';
  
  View(){
    
    //parse view xml and create object reference
    _rootVisual = BuckshotSystem.defaultPresentationProvider.deserialize(_viewTemplate);
    
    // bind the view model
    _rootVisual.dataContext = new ViewModel();
    
    // grab a reference to the button and 
    // ask view model to add a new entry when button is clicked
    Button b = BuckshotSystem.namedElements["btnSubmit"];
    b.click + (_, __) => _rootVisual.dataContext.addNewEntry();
  }
  
  FrameworkElement get rootVisual() => _rootVisual;
}
