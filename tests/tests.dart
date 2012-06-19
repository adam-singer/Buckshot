//   Copyright (c) 2012, John Evans & LUCA Studios LLC
//
//   http://www.lucastudios.com/contact
//   John: https://plus.google.com/u/0/115427174005651655317/about
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

#import('dart:html');

// point this to wherever your copy of the dart source code is
#import('/d:/development/dart/editor_latest/dart/dart-sdk/lib/unittest/unittest.dart');
#import('/d:/development/dart/editor_latest/dart/dart-sdk/lib/unittest/html_enhanced_config.dart');

#import('../external/dartxml/lib/xml.dart');

#source('../lib/MVVM/ViewModelBase.dart');
#source('../lib/MVVM/IView.dart');

#source('../lib/binding/Binding.dart');
#source('../lib/binding/BindingMode.dart');
#source('../lib/binding/BindingData.dart');

#source('../lib/events/FrameworkEvent.dart');
#source('../lib/events/EventHandler.dart');
#source('../lib/events/EventHandlerReference.dart');
#source('../lib/events/EventArgs.dart');
#source('../lib/events/AttachedPropertyChangedEventArgs.dart');
#source('../lib/events/MouseMoveEventArgs.dart');
#source('../lib/events/PropertyChangingEventArgs.dart');
#source('../lib/events/ListChangedEventArgs.dart');
#source('../lib/events/RoutedEventArgs.dart');
#source('../lib/events/SelectedItemChangedEventArgs.dart');
#source('../lib/events/MeasurementChangedEventArgs.dart');

#source('../lib/primitives/Tuple.dart');
#source('../lib/primitives/Thickness.dart');

#source('../lib/enums/Visibility.dart');
#source('../lib/enums/Orientation.dart');
#source('../lib/enums/Colors.dart');
#source('../lib/enums/Cursors.dart');
#source('../lib/enums/LinearGradientDirection.dart');
#source('../lib/enums/RadialGradientDrawMode.dart');
#source('../lib/enums/GridUnitType.dart');
#source('../lib/enums/HorizontalAlignment.dart');
#source('../lib/enums/VerticalAlignment.dart');
#source('../lib/enums/Transforms.dart');
#source('../lib/enums/TransitionTiming.dart');

#source('../lib/elements/Panel.dart');
#source('../lib/elements/StackPanel.dart');
#source('../lib/elements/TextBlock.dart');
#source('../lib/elements/Border.dart');
#source('../lib/elements/LayoutCanvas.dart');
#source('../lib/elements/Image.dart');
#source('../lib/elements/RawHtml.dart');
#source('../lib/elements/grid/Grid.dart');
#source('../lib/elements/grid/RowDefinition.dart');
#source('../lib/elements/grid/ColumnDefinition.dart');
#source('../lib/elements/grid/GridCell.dart');
#source('../lib/elements/grid/GridLayoutDefinition.dart');
#source('../lib/elements/grid/GridLength.dart');
#source('../lib/elements/CollectionPresenter.dart');
#source('../lib/elements/actions/ActionBase.dart');

#source('../lib/controls/TextBox.dart');
#source('../lib/controls/control/Control.dart');
#source('../lib/controls/control/ControlTemplate.dart');
#source('../lib/controls/RadioButton.dart');
#source('../lib/controls/RadioButtonGroup.dart');
#source('../lib/controls/Button.dart');
#source('../lib/controls/CheckBox.dart');
#source('../lib/controls/TextArea.dart');
#source('../lib/controls/Slider.dart');
#source('../lib/controls/Hyperlink.dart');
#source('../lib/controls/DropDownList.dart');
#source('../lib/controls/ListBox.dart');

#source('../lib/exceptions/ExceptionBase.dart');
#source('../lib/exceptions/AnimationException.dart');
#source('../lib/exceptions/PresentationProviderException.dart');
#source('../lib/exceptions/FrameworkException.dart');

#source('../lib/converters/StringToNumericConverter.dart');
#source('../lib/converters/StringToThicknessConverter.dart');
#source('../lib/converters/StringToBooleanConverter.dart');
#source('../lib/converters/StringToGridLengthConverter.dart');
#source('../lib/converters/StringToGridUnitTypeConverter.dart');
#source('../lib/converters/StringToHorizontalAlignmentConverter.dart');
#source('../lib/converters/StringToOrientationConverter.dart');
#source('../lib/converters/StringToVerticalAlignmentConverter.dart');
#source('../lib/converters/StringToColorConverter.dart');
#source('../lib/converters/StringToSolidColorBrushConverter.dart');
#source('../lib/converters/StringToRadialGradientDrawModeConverter.dart');
#source('../lib/converters/StringToFrameworkElementConverter.dart');
#source('../lib/converters/StringToVisibilityConverter.dart');
#source('../lib/converters/StringToInputTypesConverter.dart');

#source('../lib/resources/FrameworkResource.dart');
#source('../lib/resources/ResourceCollection.dart');
#source('../lib/resources/VarResource.dart');
#source('../lib/resources/Color.dart');
#source('../lib/resources/Brush.dart');
#source('../lib/resources/SolidColorBrush.dart');
#source('../lib/resources/LinearGradientBrush.dart');
#source('../lib/resources/RadialGradientBrush.dart');
#source('../lib/resources/StyleSetter.dart');
#source('../lib/resources/StyleTemplate.dart');
#source('../lib/resources/GradientStop.dart');

#source('../lib/core/globals.dart');
#source('../lib/core/BuckshotSystem.dart');
#source('../lib/core/FrameworkObject.dart');
#source('../lib/core/FrameworkProperty.dart');
#source('../lib/core/ObservableList.dart');
#source('../lib/core/FrameworkElement.dart');
#source('../lib/core/HashableObject.dart');
#source('../lib/core/IValueConverter.dart');
#source('../lib/core/DOM.dart');
#source('../lib/core/BuckshotObject.dart');
#source('../lib/core/IPresentationFormatProvider.dart');
#source('../lib/core/BuckshotTemplateProvider.dart');
#source('../lib/core/FrameworkPropertyBase.dart');
#source('../lib/core/AttachedFrameworkProperty.dart');
#source('../lib/core/FrameworkPropertyResolutionException.dart');
#source('../lib/core/DataTemplate.dart');
#source('../lib/core/IFrameworkContainer.dart');

#source('../lib/animation/FrameworkAnimation.dart');
#source('../lib/animation/AnimationResource.dart');
#source('../lib/animation/AnimationKeyFrame.dart');
#source('../lib/animation/AnimationState.dart');
#source('../lib/animation/_CssCompiler.dart');

#source('../lib/elements/shape/Shape.dart');
#source('../lib/elements/shape/Ellipse.dart');
#source('../lib/elements/shape/Rectangle.dart');
#source('../lib/elements/shape/Line.dart');
#source('../lib/elements/shape/PolyLine.dart');
#source('../lib/elements/shape/Polygon.dart');

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
#source('BuckshotTemplateProviderTests.dart');
#source('StringToGridLengthConverterTests.dart');
#source('ResourceTests.dart');
#source('VarResourceTests.dart');
#source('FrameworkAnimationTests.dart');
#source('LayoutTests.dart');

void main() {
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
  _tList.add(new BuckshotTemplateProviderTests());
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
