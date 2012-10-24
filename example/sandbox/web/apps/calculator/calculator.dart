library calculator_apps_buckshot;

import 'dart:html';
import 'dart:math' as Math;
import 'package:buckshot/buckshot_browser.dart';
import 'package:dartnet_event_model/events.dart';

part 'common/i_calculator.dart';
part 'common/output_changed_event_args.dart';
part 'views/main.dart';
part 'views/standard_calc.dart';
part 'views/extended_calc.dart';
part 'viewmodels/view_model.dart';
part 'models/calc.dart';


/**
* ## Buckshot Calculator ##
* A calculator widget to demonstrate the Buckshot UI framework.
*
* This demo only supports mouse input.
*
* Video Walkthrough: http://www.youtube.com/watch?v=lbUO0E3kgdk
*
* ### Benefits of Buckshot and the MVVM Pattern ###
* * A template & data focused application (minimal infrastructure noise).
* * Clean separation of concerns between design and implementation.
* * Easy visual content switching (between calculator keypad layouts).
* * Unit testable (unit tests drive the view model and inspect results).
* * Extensible by implementing [ICalculator].
*/
void main() {
  setView(new Main());

}

