
#import('dart:html');
#import('../lib/Buckshot.dart');
#import('../external/dartxml/lib/xml.dart');
#import('../external/shared/shared.dart');
#import('../external/web/web.dart');
#import('../external/events/events.dart');
#import('../extensions/controls/DockPanel.dart');

// point this to wherever your copy of the dart source code is
#import('/d:/development/dart/editor_latest/dart/dart-sdk/lib/unittest/unittest.dart');
#import('/d:/development/dart/editor_latest/dart/dart-sdk/lib/unittest/html_enhanced_config.dart');

#source('InitializationTests.dart');
#source('FrameworkFundamentalsTests.dart');
#source('FrameworkPropertyTests.dart');
#source('FrameworkElementTests.dart');
#source('BindingTests.dart');
#source('BorderTests.dart');
#source('ButtonTests.dart');
#source('ControlTests.dart');
#source('FrameworkEventTests.dart');
#source('FrameworkExceptionTests.dart');
#source('FrameworkObjectTests.dart');
#source('LayoutCanvasTests.dart');
#source('ObservableListTests.dart');
#source('PanelTests.dart');
#source('StackPanelTests.dart');
#source('TextBlockTests.dart');
#source('GridTests.dart');
#source('GridCellTests.dart');
#source('TextBoxTests.dart');
#source('RadioButtonGroupTests.dart');
#source('DomHelpersTests.dart');
#source('StyleTemplateTests.dart');
#source('TemplateTests.dart');
#source('StringToGridLengthConverterTests.dart');
#source('ResourceTests.dart');
#source('VarResourceTests.dart');
#source('FrameworkAnimationTests.dart');
#source('LayoutTests.dart');

void main() {

//  buckshot.rootView = new IView.from(Template.deserialize(Template.getTemplate('#borderTest')));
//  buckshot.rootView = new IView.from(Template.deserialize(Template.getTemplate('#stackPanelTest')));
//  buckshot.rootView = new IView.from(Template.deserialize(Template.getTemplate('#gridTest')));
//  buckshot.rootView = new IView.from(Template.deserialize(Template.getTemplate('#horizontalTest')));

  buckshot.registerElement(new DockPanel());
  buckshot.registerAttachedProperty('dockpanel.dock', DockPanel.setDock);
  buckshot.rootView = new IView.from(Template.deserialize(Template.getTemplate('#dockPanelTest')));
  
  Polly.dump();
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
