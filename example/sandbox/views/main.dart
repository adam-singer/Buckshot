// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

class Main extends View
{
  Main(){
    Template.deserialize('#main')
    .then((t){
      rootVisual = t;

      // Assign the view model to the datacontext so that template
      // bindings will hook up.
      rootVisual.dataContext = new DemoViewModel.withView(this);
    });
  }
}


