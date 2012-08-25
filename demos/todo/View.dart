class Main extends View
{

  Main(){

    Template
      .deserialize(Template.getTemplate('#view'))
      .then((t){
        rootVisual = t;

        // bind the view model
        rootVisual.dataContext = new ViewModel();
      });
  }
}
