class Main extends View
{

  Main()
  {
    Template
      .deserialize(Template.getTemplate('#main2'))
      .then((t){
        rootVisual = t;

        // Assign the view model to the datacontext so that template
        // bindings will hook up.
        rootVisual.dataContext = new ViewModel();
      });
  }
}
