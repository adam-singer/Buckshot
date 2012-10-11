
#import('package:buckshot/buckshot.dart');

#source('views/main_view.dart');
#source('viewmodels/viewmodel.dart');
#source('models/model.dart');


main(){

  setView(new MainView())
     .then((rootVisual){
       // Since we want the app to take up the entire browser window,
       // we'll setup some manual bindings to the implicit Border
       // that our view is contained within.

       bind(buckshot.windowWidthProperty,
           (rootVisual.parent as Border).widthProperty);

       bind(buckshot.windowHeightProperty,
           (rootVisual.parent as Border).heightProperty);
     });
}