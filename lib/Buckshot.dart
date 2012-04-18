/// ## Copyright (c) 2012, John Evans & LUCA Studios LLC ##

///   <http://www.lucastudios.com/contact>

///   John: <https://plus.google.com/u/0/115427174005651655317/about>

///   Licensed under the Apache License, Version 2.0 (the "License");
///   you may not use this file except in compliance with the License.
///   You may obtain a copy of the License at

///   <http://www.apache.org/licenses/LICENSE-2.0>

///   Unless required by applicable law or agreed to in writing, software
///   distributed under the License is distributed on an "AS IS" BASIS,
///   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
///   See the License for the specific language governing permissions and
///   limitations under the License.

/// ## Try Buckshot Online ##
/// <http://www.lucastudios.com/trybuckshot>

/// ## Project Source Code Repository ##
/// <https://github.com/prujohn/Buckshot>

//TODO convert statebag properties to real properties

#library('Buckshot_Client');

#import('dart:html');
//#import('../../reactive/lib/reactive_lib.dart');

#source('MVVM/ViewModelBase.dart');
#source('MVVM/IView.dart');

#source('binding/Binding.dart');
#source('binding/BindingMode.dart');
#source('binding/BindingData.dart');

#source('events/FrameworkEvent.dart');
#source('events/EventHandler.dart');
#source('events/EventHandlerReference.dart');
#source('events/EventArgs.dart');
#source('events/AttachedPropertyChangedEventArgs.dart');
#source('events/MouseMoveEventArgs.dart');
#source('events/PropertyChangingEventArgs.dart');
#source('events/ListChangedEventArgs.dart');
#source('events/RoutedEventArgs.dart');
#source('events/SelectedItemChangedEventArgs.dart');

#source('primitives/Tuple.dart');
#source('primitives/Thickness.dart');

#source('enums/Visibility.dart');
#source('enums/Orientation.dart');
#source('enums/Colors.dart');
#source('enums/Cursors.dart');
#source('enums/LinearGradientDirection.dart');
#source('enums/RadialGradientDrawMode.dart');
#source('enums/GridUnitType.dart');
#source('enums/HorizontalAlignment.dart');
#source('enums/VerticalAlignment.dart');
#source('enums/Transforms.dart');
#source('enums/TransitionTiming.dart');

#source('elements/Panel.dart');
#source('elements/StackPanel.dart');
#source('elements/TextBlock.dart');
#source('elements/border/Border.dart');
#source('elements/border/BorderContainer.dart');
#source('elements/LayoutCanvas.dart');
#source('elements/Image.dart');
#source('elements/RawHtml.dart');
#source('elements/grid/Grid.dart');
#source('elements/grid/RowDefinition.dart');
#source('elements/grid/ColumnDefinition.dart');
#source('elements/grid/GridCell.dart');
#source('elements/grid/GridLayoutDefinition.dart');
#source('elements/grid/GridLength.dart');
#source('elements/CollectionPresenter.dart');
#source('elements/actions/ActionBase.dart');

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
#source('controls/ListBox.dart');

#source('exceptions/ExceptionBase.dart');
#source('exceptions/AnimationException.dart');
#source('exceptions/PresentationProviderException.dart');
#source('exceptions/FrameworkException.dart');

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

#source('resources/FrameworkResource.dart');
#source('resources/ResourceCollection.dart');
#source('resources/VarResource.dart');
#source('resources/Color.dart');
#source('resources/Brush.dart');
#source('resources/SolidColorBrush.dart');
#source('resources/LinearGradientBrush.dart');
#source('resources/RadialGradientBrush.dart');
#source('resources/StyleSetter.dart');
#source('resources/StyleTemplate.dart');
#source('resources/GradientStop.dart');

#source('core/globals.dart');
#source('core/BuckshotSystem.dart');
#source('core/FrameworkObject.dart');
#source('core/FrameworkProperty.dart');
#source('core/ObservableList.dart');
#source('core/FrameworkElement.dart');
#source('core/_VirtualContainer.dart');
#source('core/HashableObject.dart');
#source('core/_ContainerElement.dart');
#source('core/IValueConverter.dart');
#source('core/_RootElement.dart');
#source('core/DomHelpers.dart');
#source('core/BuckshotObject.dart');
#source('core/IPresentationFormatProvider.dart');
#source('core/BuckshotTemplateProvider.dart');
#source('core/FrameworkPropertyBase.dart');
#source('core/AttachedFrameworkProperty.dart');
#source('core/FrameworkPropertyResolutionException.dart');
#source('core/DataTemplate.dart');
#source('core/IFrameworkContainer.dart');

#source('animation/FrameworkAnimation.dart');
#source('animation/AnimationResource.dart');
#source('animation/AnimationKeyFrame.dart');
#source('animation/AnimationState.dart');
#source('animation/_CssCompiler.dart');

#source('elements/shape/Shape.dart');
#source('elements/shape/Ellipse.dart');
#source('elements/shape/Rectangle.dart');
#source('elements/shape/Line.dart');
#source('elements/shape/PolyLine.dart');
#source('elements/shape/Polygon.dart');
