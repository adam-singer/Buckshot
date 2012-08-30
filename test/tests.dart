
#import('dart:html');
#import('../buckshot.dart');
#import('package:dart-xml/lib/xml.dart');
#import('../external/shared/shared.dart');
#import('../external/web/web.dart');
#import('package:DartNet-Event-Model/events.dart');
#import('../extensions/controls/DockPanel.dart');

// point this to wherever your copy of the dart source code is
#import('package:unittest/unittest.dart');
#import('package:unittest/html_enhanced_config.dart');

#source('initialization_tests.dart');
#source('framework_fundamentals_tests.dart');
#source('framework_property_tests.dart');
#source('framework_element_tests.dart');
#source('binding_tests.dart');
#source('border_tests.dart');
#source('button_tests.dart');
#source('control_tests.dart');
#source('framework_event_tests.dart');
#source('framework_exception_tests.dart');
#source('framework_object_tests.dart');
#source('layout_canvas_tests.dart');
#source('observable_list_tests.dart');
#source('panel_tests.dart');
#source('stack_panel_tests.dart');
#source('text_block_tests.dart');
#source('grid_tests.dart');
#source('grid_cell_tests.dart');
#source('text_box_tests.dart');
#source('radio_button_group_tests.dart');
#source('dom_helper_tests.dart');
#source('style_template_tests.dart');
#source('template_tests.dart');
#source('string_to_grid_length_converter_tests.dart');
#source('resource_tests.dart');
#source('var_resource_tests.dart');
#source('framework_animation_tests.dart');
#source('layout_tests.dart');

void main() {

  buckshot.registerAttachedProperty('dockpanel.dock', DockPanel.setDock);

  Template
    .deserialize(Template.getTemplate('#dockPanelTest'))
//    .deserialize(Template.getTemplate('#borderTest'))
//    .deserialize(Template.getTemplate('#stackPanelTest'))
//    .deserialize(Template.getTemplate('#gridTest'))
//    .deserialize(Template.getTemplate('#horizontalTest'))
    .then((e){
      buckshot.rootView = new View.from(e);
      Polly.dump();
    });


  return;

  final _tList = new List<TestGroupBase>();

  useHtmlEnhancedConfiguration();

  group('Dart Bugs', (){

    //fails in JS, OK in Dartium
    test('borderRadiusReturnsNull', (){
      var e = new Element.tag('div');
      e.style.borderRadius = '10px';

      var result = e.style.borderRadius;
      Expect.isNotNull(result);
      Expect.equals('10px', e.style.borderRadius);
    });

    test('SVG elements returning css', (){
      var se = new SVGSVGElement();
      var r = new SVGElement.tag('rect');
      se.elements.add(r);

      r.style.setProperty('fill','Red');

      var result = r.style.getPropertyValue('fill');
      Expect.isNotNull(result);
    });
  });

  group('Initialization', (){
    tearDown(() =>   Polly.dump());
    test('Buckshot Initialized', () => Expect.isNotNull(buckshot.domRoot));
  });

  group('Layout Tests', (){
    layoutTests();
  });

  _tList.add(new FrameworkFundamentalsTests());
  _tList.add(new FrameworkElementTests());
  _tList.add(new FrameworkPropertyTests());
  _tList.add(new FrameworkEventTests());
  _tList.add(new FrameworkExceptionTests());
  _tList.add(new BindingTests());
  _tList.add(new TemplateTests());
  _tList.add(new TextBoxTests());
  _tList.add(new BorderTests());
  _tList.add(new ButtonTests());
  _tList.add(new ControlTests());
  _tList.add(new FrameworkObjectTests());
  _tList.add(new ObservableListTests());
  _tList.add(new PanelTests());
  _tList.add(new StackPanelTests());
  _tList.add(new TextBlockTests());
  _tList.add(new LayoutCanvasTests());
  _tList.add(new RadioButtonGroupTests());
  _tList.add(new GridTests());
  _tList.add(new GridCellTests());
  _tList.add(new DomHelpersTests());
  _tList.add(new StyleTemplateTests());
  _tList.add(new StringToGridLengthConverterTests());
  _tList.add(new ResourceTests());
  _tList.add(new VarResourceTests());
  _tList.add(new FrameworkAnimationTests());

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
