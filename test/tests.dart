
#import('dart:html');
#import('package:buckshot/buckshot.dart');
#import('package:dart-xml/xml.dart');
#import('package:dart_utils/web.dart');
#import('package:dart_utils/shared.dart');
#import('package:DartNet-Event-Model/events.dart');
#import('package:buckshot/extensions/controls/dock_panel.dart');

#import('package:unittest/unittest.dart');
#import('package:unittest/html_enhanced_config.dart');

#import('layout_tests.dart', prefix:'layout');
#import('bug_tests.dart', prefix:'bugs');
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

#source('text_block_tests.dart');
#source('radio_button_group_tests.dart');
#source('style_template_tests.dart');
#source('string_to_grid_length_converter_tests.dart');
#source('resource_tests.dart');
#source('var_resource_tests.dart');

void main() {

  if (!reflectionEnabled){
// *** These warnings are incorrect: See http://www.dartbug.com/5183
    buckshot.registerElement(new DockPanel.register());
  }

////  setView(new View.fromResource('#dockPanelTest'))
////  setView(new View.fromResource('#borderTest'))
//  setView(new View.fromResource('#stackPanelTest'))
////  setView(new View.fromResource('#gridTest'))
////  setView(new View.fromResource('#horizontalTest'))
//    .then((_){
//      Polly.dump();
//    });
//
//  return;

  final _tList = new List<TestGroupBase>();

  useHtmlEnhancedConfiguration();

  layout.run();
  bugs.run();
  binding.run();
  border.run();
  polly.run();
  animation.run();
  frameworkelement.run();
  template.run();
  frameworkobject.run();
  frameworkproperty.run();
  textbox.run();
  grid.run();
  panel.run();
  
  _tList.add(new TextBlockTests());
  _tList.add(new RadioButtonGroupTests());
  _tList.add(new StyleTemplateTests());
  _tList.add(new StringToGridLengthConverterTests());
  _tList.add(new ResourceTests());
  _tList.add(new VarResourceTests());

  _tList.forEach((TestGroupBase t){
    group(t.testGroupName, (){
      t.testList.forEach((String name, Function testFunc){
        test(name, testFunc);
      });
    });
  });
}


//TODO:  This is an artifact from the old unit testing system and should be removed
// at some point.
/**
* A base class for defining groups of tests to be performed. */
class TestGroupBase {

  final LinkedHashMap<String, Function> testList;
  String testGroupName;

  TestGroupBase() : testList = new LinkedHashMap<String, Function>()
  {
    registerTests();
  }

  abstract void registerTests();

}
