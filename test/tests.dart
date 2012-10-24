import 'dart:html';
import 'package:buckshot/buckshot_browser.dart';
import 'package:xml/xml.dart';
import 'package:buckshot/web/web.dart';
import 'package:dartnet_event_model/events.dart';
import 'package:buckshot/extensions/controls/dock_panel.dart';
import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';

import 'layout_tests.dart' as layout;
import 'dart_tests.dart' as dart;
import 'binding_tests.dart' as binding;
import 'border_tests.dart' as border;
import 'polly_tests.dart' as polly;
import 'animation_tests.dart' as animation;
import 'framework_element_tests.dart' as frameworkelement;
import 'template_tests.dart' as template;
import 'framework_object_tests.dart' as frameworkobject;
import 'framework_property_tests.dart' as frameworkproperty;
import 'text_box_tests.dart' as textbox;
import 'grid_tests.dart' as grid;
import 'panel_tests.dart' as panel;
import 'radio_button_group_tests.dart' as radiobuttongroup;
import 'style_template_tests.dart' as styletemplates;
import 'string_to_grid_length_converter_tests.dart' as stringtogridlength;
import 'var_resource_tests.dart' as varresource;

void main() {

  useHtmlEnhancedConfiguration();

  layout.run();
//  dart.run();
  binding.run();
  border.run();
  polly.run();
//  animation.run();
  frameworkelement.run();
  template.run();
  frameworkobject.run();
  frameworkproperty.run();
  textbox.run();
  grid.run();
  panel.run();
  radiobuttongroup.run();
  styletemplates.run();
  stringtogridlength.run();
  varresource.run();
}
