
class MainView extends View
{
  MainView() : super.fromResource('#main'){

    // When the view is ready, bind the viewmodel to the root object's
    // dataContext.  This crucial step is what allows the view model to
    // bind with the template.
    ready.then((_){
      rootVisual.dataContext.value = new ViewModel();
    });
  }
}
