class View extends IView
{

  View(){

    Template
      .deserialize(Template.getTemplate('#view'))
      .then((t){
        rootVisual = t;

        // bind the view model
        rootVisual.dataContext = new ViewModel();

        // grab a reference to the button and
        // ask view model to add a new entry when button is clicked
        Button b = buckshot.namedElements["btnSubmit"];
        b.click + (_, __) => rootVisual.dataContext.addNewEntry();

      });
  }
}
