#import('dart:html');
#import('package:buckshot/buckshot.dart');
#import('package:xml/xml.dart');
#import('package:buckshot/web/web.dart');
#import('package:dartnet_event_model/events.dart');
#import('package:buckshot/extensions/controls/dock_panel.dart');
#import('package:unittest/unittest.dart');
#import('package:unittest/html_enhanced_config.dart');

#import('layout_tests.dart', prefix:'layout');
#import('dart_tests.dart', prefix:'dart');
#import('binding_tests.dart', prefix:'binding');
#import('border_tests.dart', prefix:'border');
#import('polly_tests.dart', prefix:'polly');
#import('animation_tests.dart', prefix:'animation');
#import('framework_element_tests.dart', prefix:'frameworkelement');
#import('template_tests.dart', prefix:'template');
#import('framework_object_tests.dart', prefix:'frameworkobject');
#import('framework_property_tests.dart', prefix:'frameworkproperty');
#import('text_box_tests.dart', prefix:'textbox');
#import('grid_tests.dart', prefix:'grid');
#import('panel_tests.dart', prefix:'panel');
#import('radio_button_group_tests.dart', prefix:'radiobuttongroup');
#import('style_template_tests.dart', prefix:'styletemplates');
#import('string_to_grid_length_converter_tests.dart', prefix:'stringtogridlength');
#import('var_resource_tests.dart', prefix:'varresource');

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
