// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

part of sandbox;
class Main extends View
{
  Main() : super.fromResource('web/views/templates/master.xml')
  {
    ready.then((t){
      // Assign the view model to the datacontext so that template
      // bindings will hook up.
      t.dataContext.value = new MasterViewModel.withView(this);

    });
  }
}


