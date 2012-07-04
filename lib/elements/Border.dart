//   Copyright (c) 2012, John Evans
//
//   https://plus.google.com/u/0/115427174005651655317/about
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


/**
* A container element that holds a single child and provides visual border properties. */
class Border extends FrameworkElement implements IFrameworkContainer
{
  /// Represents the [Color] of the border background.
  AnimatingFrameworkProperty backgroundProperty;

  /// Represents the [Thickness] of space between the border frame and the content.
  FrameworkProperty paddingProperty;

  /// Represents the rounding value of the border frame corners.
  AnimatingFrameworkProperty cornerRadiusProperty;

  /// Represents the [Color] of the border frame.
  AnimatingFrameworkProperty borderColorProperty;

  /// Represents the [Thickness] of the border frame.
  FrameworkProperty borderThicknessProperty;

  /// Represents the content inside the border.
  FrameworkProperty contentProperty;

  AnimatingFrameworkProperty horizontalScrollEnabledProperty;
  AnimatingFrameworkProperty verticalScrollEnabledProperty;

  FrameworkObject makeMe() => new Border();

  Border()
  {
    Dom.appendBuckshotClass(rawElement, "border");

    _initBorderProperties();

    stateBag[FrameworkObject.CONTAINER_CONTEXT] = contentProperty;
  }

  void _initBorderProperties(){
    //register the dependency properties
    contentProperty = new FrameworkProperty(
      this,
      "content",(c)
      {
        if (contentProperty.previousValue != null){
          contentProperty.previousValue.removeFromLayoutTree();
        }
        if (c != null) c.addToLayoutTree(this);

      });

    backgroundProperty = new AnimatingFrameworkProperty(
      this,
      "background",
      (Brush value){
        if (value == null){
          rawElement.style.background = "None";
          return;
        }
        value.renderBrush(rawElement);
      },
      'background',
      converter:const StringToSolidColorBrushConverter());

    paddingProperty = new FrameworkProperty(
      this,
      "padding",
      (Thickness value){
        rawElement.style.padding = '${value.top}px ${value.right}px ${value.bottom}px ${value.left}px';
        updateLayout();
      }, new Thickness(0), converter:const StringToThicknessConverter());

    cornerRadiusProperty = new AnimatingFrameworkProperty(
      this,
      "cornerRadius",
      (value){
        if (value == null || value < 0) value = 0;
        rawElement.style.borderRadius = '${value}px';
      }, 'border-radius', converter:const StringToNumericConverter());

    borderColorProperty = new AnimatingFrameworkProperty(
      this,
      "borderColor",
      (value){
        rawElement.style.borderColor = value.color.toString();
      }, 'border', converter:const StringToSolidColorBrushConverter());

    borderThicknessProperty = new FrameworkProperty(
      this,
      "borderThickness",
      (value){

        String color = borderColor != null ? rawElement.style.borderColor : Colors.White.toString();

        //TODO support border hatch styles

        rawElement.style.borderTop = 'solid ${value.top}px $color';
        rawElement.style.borderRight = 'solid ${value.right}px $color';
        rawElement.style.borderLeft = 'solid ${value.left}px $color';
        rawElement.style.borderBottom = 'solid ${value.bottom}px $color';

      }, new Thickness(0), converter:const StringToThicknessConverter());

    horizontalScrollEnabledProperty = new AnimatingFrameworkProperty(this, "horizontalScrollEnabled", (bool value){
      _assignOverflowX(value);
    }, 'overflow', false, converter:const StringToBooleanConverter());

    verticalScrollEnabledProperty = new AnimatingFrameworkProperty(this, "verticalScrollEnabled", (bool value){
      _assignOverflowY(value);
    }, 'overflow', false, converter:const StringToBooleanConverter());
  }

  void _assignOverflowX(value){
    if (value == true){
      rawElement.style.overflowX = "auto";
    }else{
      rawElement.style.overflowX = "hidden";
    }
  }

  void _assignOverflowY(value){
    if (value == true){
      rawElement.style.overflowY = "auto";
    }else{
      rawElement.style.overflowY = "hidden";
    }
  }

  /// Sets the [backgroundProperty] value.
  set background(Brush value) => setValue(backgroundProperty, value);
  /// Gets the [backgroundProperty] value.
  Brush get background() => getValue(backgroundProperty);

  /// Sets the [paddingProperty] value.
  set padding(Thickness value) => setValue(paddingProperty, value);
  /// Gets the [paddingProperty] value.
  Thickness get padding() => getValue(paddingProperty);

  /// Sets the [cornerRadiusProperty] value.
  set cornerRadius(int value) => setValue(cornerRadiusProperty, value);
  /// Gets the [cornerRadiusProperty] value.
  int get cornerRadius() => getValue(cornerRadiusProperty);

  /// Sets the [borderColorProperty] value.
  set borderColor(SolidColorBrush value) => setValue(borderColorProperty, value);
  /// Gets the [borderColorProperty] value.
  SolidColorBrush get borderColor() => getValue(borderColorProperty);

  /// Sets the [borderThicknessProperty] value.
  set borderThickness(Thickness value) => setValue(borderThicknessProperty, value);
  /// Gets the [borderThicknessProperty] value.
  Thickness get borderThickness() => getValue(borderThicknessProperty);

  /// Gets the [contentProperty] value.
  FrameworkElement get content() => getValue(contentProperty);
  /// Sets the [contentProperty] value.
  set content(FrameworkElement value) => setValue(contentProperty, value);

  /// Overridden [FrameworkObject] method for generating the html representation of the border.
  void createElement(){
    rawElement = new DivElement();
    rawElement.style.overflow = "hidden";
    Dom.makeFlexBox(this);
  }

  /// Overridden [FrameworkObject] method is called when the framework
  /// requires elements to recalculate layout.
  void updateLayout(){
    if (!_isLoaded) return;

    if (content == null) return;
    
    Dom.setXPCSS(content.rawElement, 'flex', 'none');
    
    if (content.hAlign != null){
        if(content.hAlign == HorizontalAlignment.stretch){
          Dom.setXPCSS(content.rawElement, 'flex', '1 1 auto');
        }
        
        Dom.setHorizontalFlexBoxAlignment(this, content.hAlign);
    }

    if (content.vAlign != null){
      Dom.setVerticalFlexBoxAlignment(this, content.vAlign);
    }
  }


  String get type() => "Border";
}
