#import('package:buckshot/buckshot.dart');
#import('package:dartnet_event_model/events.dart');

#import('dart:html');
#import('dart:isolate');

// Import control extensions we want to use for this app
#import('package:buckshot/extensions/controls/menus/menu_lib.dart');
#import('package:buckshot/extensions/controls/dock_panel.dart');
#import('package:buckshot/extensions/controls/modal_dialog.dart');

#import('viewmodels/stock_ticker_viewmodel.dart');
#import('viewmodels/calculator_viewmodel.dart');

#source('views/master.dart');
#source('views/stock_ticker.dart');
#source('views/home.dart');
#source('views/calculator/calculator.dart');
#source('views/clock.dart');


#source('viewmodels/master_viewmodel.dart');
#source('viewmodels/clock_viewmodel.dart');

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

  // 1. Deserialize the resources template so it's loaded first.
  // 2. Set the view to the Master View
  // 3. Create a binding to make the app full-window.
  Template
    .deserialize('web/views/templates/resources.xml')   // #1
    .chain((_) => setView(new Master()))                // #2
    .then((viewObject){                                 // #3
        bind(buckshot.windowHeightProperty,
            (viewObject.parent as Border).heightProperty);
        bind(buckshot.windowWidthProperty,
            (viewObject.parent as Border).widthProperty);
      });
}