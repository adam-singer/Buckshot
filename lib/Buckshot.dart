// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/// ## Try Buckshot Online ##
/// <http://www.buckshotui.org/sandbox>

#library('core.buckshotui.org');

#import('dart:html');
#import('dart:json');
#import('dart:isolate');
#import('dart:math');

#import('package:dart-xml/lib/xml.dart');
#import('package:DartNet-Event-Model/events.dart');
#import('../external/web/web.dart');
#import('../external/yaml/yaml.dart');
#import('../external/shared/shared.dart');

//TODO: move to dedicated library at some point
#import('core/Miriam.dart');

#source('core/globals.dart');
#source('core/BuckshotSystem.dart');
#source('core/FrameworkObject.dart');
#source('core/FrameworkProperty.dart');
#source('core/ObservableList.dart');
#source('core/FrameworkElement.dart');
#source('core/BuckshotObject.dart');
#source('core/FrameworkPropertyBase.dart');
#source('core/AttachedFrameworkProperty.dart');
#source('core/DataTemplate.dart');
#source('core/IFrameworkContainer.dart');

#source('core/polly/Polly.dart');
#source('core/polly/FlexModel.dart');
#source('core/polly/_Brutus.dart');

#source('events/BuckshotEvent.dart');
#source('events/MeasurementChangedEventArgs.dart');
#source('events/DragEventArgs.dart');

#source('MVVM/ViewModelBase.dart');
#source('MVVM/View.dart');

#source('binding/Binding.dart');
#source('binding/BindingMode.dart');
#source('binding/BindingData.dart');

#source('elements/Panel.dart');
#source('elements/StackPanel.dart');
#source('elements/TextBlock.dart');
#source('elements/Border.dart');
#source('elements/LayoutCanvas.dart');
#source('elements/Image.dart');
#source('elements/RawHtml.dart');
#source('elements/grid/Grid.dart');
#source('elements/grid/RowDefinition.dart');
#source('elements/grid/ColumnDefinition.dart');
#source('elements/grid/_GridCell.dart');
#source('elements/grid/GridLayoutDefinition.dart');
#source('elements/grid/GridLength.dart');
#source('elements/CollectionPresenter.dart');
#source('elements/ContentPresenter.dart');
//#source('elements/DockPanel.dart');

#source('elements/actions/ActionBase.dart');
#source('elements/actions/PlayAnimation.dart');
#source('elements/actions/SetProperty.dart');
#source('elements/actions/ToggleProperty.dart');

#source('controls/TextBox.dart');
#source('controls/control/Control.dart');
#source('controls/control/ControlTemplate.dart');
#source('controls/RadioButton.dart');
#source('controls/RadioButtonGroup.dart');
#source('controls/Button.dart');
#source('controls/CheckBox.dart');
#source('controls/TextArea.dart');
#source('controls/Slider.dart');
#source('controls/Hyperlink.dart');
#source('controls/DropDownList.dart');
//#source('controls/ListBox.dart');
//#source('controls/TreeView/TreeView.dart');
//#source('controls/TreeView/TreeNode.dart');

#source('converters/StringToNumericConverter.dart');
#source('converters/StringToThicknessConverter.dart');
#source('converters/StringToBooleanConverter.dart');
#source('converters/StringToGridLengthConverter.dart');
#source('converters/StringToGridUnitTypeConverter.dart');
#source('converters/StringToHorizontalAlignmentConverter.dart');
#source('converters/StringToOrientationConverter.dart');
#source('converters/StringToVerticalAlignmentConverter.dart');
#source('converters/StringToColorConverter.dart');
#source('converters/StringToSolidColorBrushConverter.dart');
#source('converters/StringToRadialGradientDrawModeConverter.dart');
#source('converters/StringToFrameworkElementConverter.dart');
#source('converters/StringToVisibilityConverter.dart');
#source('converters/StringToInputTypesConverter.dart');
#source('converters/StringToLocationConverter.dart');

#source('resources/FrameworkResource.dart');
#source('resources/ResourceCollection.dart');
#source('resources/Var.dart');
#source('resources/Color.dart');
#source('resources/Brush.dart');
#source('resources/SolidColorBrush.dart');
#source('resources/LinearGradientBrush.dart');
#source('resources/RadialGradientBrush.dart');
#source('resources/Setter.dart');
#source('resources/StyleTemplate.dart');
#source('resources/GradientStop.dart');

#source('animation/FrameworkAnimation.dart');
#source('animation/AnimationResource.dart');
#source('animation/AnimationKeyFrame.dart');
#source('animation/AnimationState.dart');
#source('animation/_CssCompiler.dart');

#source('elements/shape/Shape.dart');
#source('elements/shape/Ellipse.dart');
#source('elements/shape/Rectangle.dart');
//#source('elements/shape/Line.dart');
//#source('elements/shape/PolyLine.dart');
//#source('elements/shape/Polygon.dart');

#source('templates/IPresentationFormatProvider.dart');
#source('templates/XmlTemplateProvider.dart');
#source('templates/JSONTemplateProvider.dart');
#source('templates/YAMLTemplateProvider.dart');
#source('templates/Template.dart');
#source('templates/TemplateObject.dart');

//Use this to generate clean dart docs of just the buckshot library
//main(){}
