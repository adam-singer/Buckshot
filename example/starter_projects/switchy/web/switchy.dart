library switchy;

import 'package:buckshot/buckshot_browser.dart';
import 'package:dartnet_event_model/events.dart';
import 'dart:html';
import 'dart:isolate';
// Import control extensions we want to use for this app
import 'package:buckshot/extensions/controls/menus/menu_lib.dart';
import 'package:buckshot/extensions/controls/dock_panel.dart';
import 'package:buckshot/extensions/controls/modal_dialog.dart';
import 'viewmodels/stock_ticker_viewmodel.dart';
import 'viewmodels/calculator_viewmodel.dart';

part 'views/master.dart';
part 'views/stock_ticker.dart';
part 'views/home.dart';
part 'views/calculator/calculator.dart';
part 'views/clock.dart';
part 'viewmodels/master_viewmodel.dart';
part 'viewmodels/clock_viewmodel.dart';

void main() {
  // we have to register our control extensions until Dart supports
  // reflection on all platforms...
  if (!reflectionEnabled){

    // IMPORTANT: When registering controls, be sure to call the .register()
    // constructor, NOT the default constructor.
    registerElement(new DockPanel.register());

    // menu_lib has a convenience function to register controls since
    // there are several components used in menus.
    registerMenuControls();
  }

  // 1. Set the view to the Master View
  // 2. Create a binding to make the app full-window.
  // 3. Bind the root container to the dimensions of the window.
  setView(new Master())                                 // #1
    .then((viewObject){                                 // #2
      bindToWindowDimensions(viewObject.parent);        // #3
    });
}