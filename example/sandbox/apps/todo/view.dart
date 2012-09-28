class Main extends View
{

  Main() : super.fromTemplate(_view)
  {
      ready.then((t){
        // bind the view model
        rootVisual.dataContext = new ViewModel();
      });
  }
}

// Setting the template in text in addition to the HTML file so that the app
// can be embedded into the Sandbox demo.  Alternatives to this would be to
// put template into the sandbox html page, or load it from a Uri.
String _view =
@'''
<border bordercolor='Black' borderthickness='1' padding='5'>
    <stackpanel>
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
      
      <button on.click='onSubmit_handler' content="Add Task" width="75" margin="5,0,0,0"></button>
      
      <textblock margin='5,0,0,0' foreground="{data statusColor}" text="{data statusText, mode=twoway}"></textblock>
      
      <textblock text="Tasks:" margin="10,0,0,0"></textblock>
      
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
</border>
''';