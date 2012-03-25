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

/**
* A container element that holds a single child and provides visual border properties. */
class Border extends _ContainerElement implements IFrameworkContainer
{
  var _previousWidth = -1;
  var _previousHeight = -1;
  
  /// Represents the [Color] of the border background.
  FrameworkProperty backgroundProperty;
  
  /// Represents the [Thickness] of space between the border frame and the content.
  FrameworkProperty paddingProperty;
  
  /// Represents the rounding value of the border frame corners.
  FrameworkProperty cornerRadiusProperty; 
  
  /// Represents the [Color] of the border frame.
  FrameworkProperty borderColorProperty;
  
  /// Represents the [Thickness] of the border frame.
  FrameworkProperty borderThicknessProperty;
  
  /// Represents the content inside the border.
  FrameworkProperty contentProperty;
  
  FrameworkProperty horizontalScrollEnabledProperty;
  FrameworkProperty verticalScrollEnabledProperty;
  
  _BorderContainer _vc;
  
  
  /// Overridden [LucaObject] method for creating new borders.
  FrameworkObject makeMe() => new Border();
  
  Border()
  {
    _Dom.appendClass(_component, "luca_ui_border");
       
    _initBorderProperties();
    
    this._stateBag[FrameworkObject.CONTAINER_CONTEXT] = contentProperty;
  }
  
  void _initBorderProperties(){
    //register the dependency properties
    contentProperty = new FrameworkProperty(
      this,
      "content",
      (FrameworkElement value){
        if (_vc != null){      
          _vc.content = null;

          if (contentProperty.previousValue != null)
            contentProperty.previousValue.parent = null; //content.parent = null;
        }
            
        if (value != null)
        {
            if (value.parent != null)
              throw const FrameworkException("Element is already child of another element.");
           
            value.parent = this;
            
            //initialize the virtual container on first content add
            if (_vc == null){
              _vc = new _BorderContainer();
              _vc._containerParent = this;
              
              _assignOverflowX(getValue(horizontalAlignmentProperty));
              _assignOverflowY(getValue(verticalAlignmentProperty));
              
              _vc.addToLayoutTree(this);
                            
              _registerChild(_vc);
            }
            
            _vc.content = value;
            _vc.parent = this;
            
            updateLayout();
        }else{
          if (_vc != null){
            _vc.removeFromLayoutTree();
            _unRegisterChild(_vc);
            _vc = null;
          }
        }
      }, null);
        
    backgroundProperty = new FrameworkProperty(
      this,
      "background",
      (Brush value){
        if (value == null){
          _component.style.background = "None";
          return;
        }
        value.renderBrush(_component);
      });
    backgroundProperty.stringToValueConverter = const StringToSolidColorBrushConverter();
    
    paddingProperty = new FrameworkProperty(
      this,
      "padding",
      (Thickness value){
        _component.style.padding = '${value.top}px ${value.right}px ${value.bottom}px ${value.left}px';
      }, new Thickness(0));
    paddingProperty.stringToValueConverter = const StringToThicknessConverter();
    
    cornerRadiusProperty = new FrameworkProperty(
      this,
      "cornerRadius",
      (value){
        if (value == null || value < 0) value = 0;
        _component.style.borderRadius = '${value}px';
      });
    cornerRadiusProperty.stringToValueConverter = const StringToNumericConverter();
    
    borderColorProperty = new FrameworkProperty(
      this,
      "borderColor",
      (value){
        _component.style.borderColor = value.color.toString();
      }, new SolidColorBrush(new Color.hex(Colors.White.toString())));
    borderColorProperty.stringToValueConverter = const StringToSolidColorBrushConverter();
    
    borderThicknessProperty = new FrameworkProperty(
      this,
      "borderThickness",
      (value){
        
        String color = borderColor != null ? borderColor.color.toString() : Colors.White.toString();
        
        //TODO support border hatch styles
        _component.style.borderTop = 'solid ${value.top}px $color';
        _component.style.borderRight = 'solid ${value.right}px $color';
        _component.style.borderLeft = 'solid ${value.left}px $color';
        _component.style.borderBottom = 'solid ${value.bottom}px $color';
      }, new Thickness(0));
    borderThicknessProperty.stringToValueConverter = const StringToThicknessConverter();
    
    horizontalScrollEnabledProperty = new FrameworkProperty(this, "horizontalScrollEnabled", (bool value){      
      if (_vc != null) _assignOverflowX(value);
    }, false);
    horizontalScrollEnabledProperty.stringToValueConverter = const StringToBooleanConverter();
    
    verticalScrollEnabledProperty = new FrameworkProperty(this, "verticalScrollEnabled", (bool value){
      if (_vc != null) _assignOverflowY(value);
    }, false);
    verticalScrollEnabledProperty.stringToValueConverter = const StringToBooleanConverter();
  }
  
  void _assignOverflowX(bool value){
    if (value == true){
      this._vc._component.style.overflowX = "auto";
    }else{
      this._vc._component.style.overflowX = "hidden";
    }
  }
  
  void _assignOverflowY(bool value){
    if (value == true){
      this._vc._component.style.overflowY = "auto";
    }else{
      this._vc._component.style.overflowY = "hidden";
    }
  }
  
  /// Calculates the [actualWidth] of the border with margin, border, and padding taken into account. ** For internal use by the framework only. **
  void calculateWidth(int value){
    super.calculateWidth(value);
    if (value == "auto") return;
    setValue(actualWidthProperty, value - (margin.left + margin.right + borderThickness.left + borderThickness.right + padding.left + padding.right));
  }
  
  /// Calculates the [actualHeight] of the border with margin, border, and padding taken into account.  ** For internal use by the framework only. **
  void calculateHeight(int value){
    super.calculateHeight(value);
    if (value == "auto") return;
    
    setValue(actualHeightProperty, value - (margin.top + margin.bottom + borderThickness.top + borderThickness.bottom + padding.top + padding.bottom));
  }
  
//  /// Returns the adjusted inner width of the border.
//  int get innerWidth() => (margin != null && padding != null && borderThickness != null) ? _rawElement.clientWidth - (margin.left + padding.left + borderThickness.left + margin.right + padding.right + borderThickness.right) : 0;
//  
//  /// Returns the adjusted inner height of the border.
//  int get innerHeight() => (margin != null && padding != null && borderThickness != null) ? _rawElement.clientHeight - (margin.top + padding.top + borderThickness.top + margin.bottom + padding.bottom + borderThickness.bottom) : 0;
//  
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
  void CreateElement(){
    _component = _Dom.createByTag("div");
    _component.style.overflow = "hidden";
    _component.style.display = "inline-block";
    _component.style.boxSizing = "border-box";
  }
  
  /// Overridden [FrameworkObject] method is called when the framework requires elements to recalculate layout.
  void updateLayout(){
    if (_vc == null) return;
    
    //we want to make sure the virtual container is 
    //set to auto if the respective border width/height is auto
    //otherwise set virtual width/height to stretch
    
    //doing this makes sure that layouts work as expected
    
    if (_previousWidth == width && _previousHeight == height) return;
    
    _unRegisterChild(_vc); //prevent extra events from firing
    
    if (width == "auto"){
      _vc.horizontalAlignment = HorizontalAlignment.left;
      _vc.width = "auto";
    }else{
      _vc.horizontalAlignment = HorizontalAlignment.stretch;
    }
    
    if (height == "auto"){
      _vc.verticalAlignment = VerticalAlignment.top;
      _vc.height = "auto";
    }else{
      _vc.verticalAlignment = VerticalAlignment.stretch;
    }
    
    _registerChild(_vc);
    
    //hold changes to optimize next updateLayout();
    _previousWidth = width;
    _previousHeight = height;
  }
  
  String get type() => "Border";
}
