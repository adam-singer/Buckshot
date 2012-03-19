///   Copyright (c) 2012, John Evans & LUCA Studios LLC
///
///   <http://www.lucastudios.com/contact>
///
///   John: <https://plus.google.com/u/0/115427174005651655317/about>
///
///   Licensed under the Apache License, Version 2.0 (the "License");
///   you may not use this file except in compliance with the License.
///   You may obtain a copy of the License at
///
///   <http://www.apache.org/licenses/LICENSE-2.0>
///
///   Unless required by applicable law or agreed to in writing, software
///   distributed under the License is distributed on an "AS IS" BASIS,
///   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
///   See the License for the specific language governing permissions and
///   limitations under the License.
///
/// ## Try Buckshot Online
/// <http://www.lucastudios.com/trybuckshot>
///
/// ## Project Source Code Repository
/// <https://github.com/prujohn/Buckshot>


#library('Buckshot_Core');

#import('dart:html');

#source('MVVM/ViewModelBase.dart');
#source('MVVM/IView.dart');

#source('binding/Binding.dart');
#source('binding/BindingMode.dart');

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

#source('elements/Control.dart');
#source('elements/Panel.dart');
#source('elements/TextBox.dart');
#source('elements/StackPanel.dart');
#source('elements/TextBlock.dart');
#source('elements/RadioButton.dart');
#source('elements/RadioButtonGroup.dart');
#source('elements/CheckBox.dart');
#source('elements/TextArea.dart');
#source('elements/border/Border.dart');
#source('elements/border/BorderContainer.dart');
#source('elements/Button.dart');
#source('elements/LayoutCanvas.dart');
#source('elements/Slider.dart');
#source('elements/Hyperlink.dart');
#source('elements/Image.dart');
#source('elements/RawHtml.dart');
#source('elements/grid/Grid.dart');
#source('elements/grid/RowDefinition.dart');
#source('elements/grid/ColumnDefinition.dart');
#source('elements/grid/GridCell.dart');
#source('elements/grid/GridLayoutDefinition.dart');
#source('elements/grid/GridLength.dart');
#source('elements/DropDownList.dart');
#source('elements/ListBox.dart');
//#source('elements/grid/Grid2.dart');

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

#source('client/globals.dart');
#source('client/BuckshotSystem.dart');
#source('client/FrameworkObject.dart');
#source('client/FrameworkProperty.dart');
#source('client/ObservableList.dart');
#source('client/FrameworkElement.dart');
#source('client/VirtualContainer.dart');
#source('client/HashableObject.dart');
#source('client/ContainerElement.dart');
#source('client/FrameworkDebug.dart');
#source('client/IValueConverter.dart');
#source('client/RootElement.dart');
#source('client/DomHelpers.dart');
#source('client/BuckshotObject.dart');
#source('client/IPresentationFormatProvider.dart');
#source('client/BuckshotTemplateProvider.dart');
#source('client/FrameworkPropertyBase.dart');
#source('client/AttachedFrameworkProperty.dart');
#source('client/FrameworkPropertyResolutionException.dart');
#source('client/DataTemplate.dart');
#source('client/CollectionPresenter.dart');
#source('client/BindingData.dart');
#source('client/ControlTemplate.dart');
#source('client/IFrameworkContainer.dart');
#source('client/IMultiChildContainer.dart');
#source('client/ISingleChildContainer.dart');
