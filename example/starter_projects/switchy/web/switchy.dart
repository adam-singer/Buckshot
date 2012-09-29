#import('package:buckshot/buckshot.dart');

// Import control extensions we want to use for this app
#import('package:buckshot/extensions/controls/menus/menu_lib.dart');
#import('package:buckshot/extensions/controls/dock_panel.dart');

#source('views/master.dart');
#source('viewmodels/master_viewmodel.dart');

void main() {
  // we have to register our control extensions until Dart supports
  // reflection on all platforms...
  if (!reflectionEnabled){

    // IMPORTANT: When registering controls, be sure to call the .register()
    // constructor, NOT the default constructor.
    buckshot.registerElement(new DockPanel.register());

    // menu_lib has a convenience function to register controls since
    // there are several components used in menus.
    registerMenuControls();
  }

  // setView() renders a View into the web page at a DIV with the id
  // of 'BuckshotHost'.  You can also specify a different id if you want to.
  setView(new Master())
    .then((viewObject){
      bind(buckshot.windowHeightProperty,
          (viewObject.parent as Border).heightProperty);
    });
}
