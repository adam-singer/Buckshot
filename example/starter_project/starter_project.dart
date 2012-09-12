
#import('package:buckshot/buckshot.dart');

// Switch to this import after you copy your project.
// #import('package:Buckshot/buckshot.dart');

#source('views/main_view.dart');
#source('viewmodels/viewmodel.dart');
#source('models/model.dart');


main(){
  final view = new MainView();
  
  setView(view)
     .then((_){
       // Since we want the app to take up the entire browser window,
       // we'll setup some manual bindings to the implicit Border
       // that our view is contained within.

       new Binding(buckshot.windowWidthProperty, 
           (view.rootVisual.parent as Border).widthProperty);
       
       new Binding(buckshot.windowHeightProperty, 
           (view.rootVisual.parent as Border).heightProperty);
     });
}