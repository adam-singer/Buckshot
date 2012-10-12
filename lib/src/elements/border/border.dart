// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

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

  /// Represents the style of the border frame.
  FrameworkProperty borderStyleProperty;

  /// Represents the content inside the border.
  FrameworkProperty contentProperty;

  AnimatingFrameworkProperty horizontalScrollEnabledProperty;
  AnimatingFrameworkProperty verticalScrollEnabledProperty;

  AligningPanel _polyfill;
  Function _redraw;

  Border()
  {
    Browser.appendClass(rawElement, "border");

    _initBorderProperties();

    stateBag[FrameworkObject.CONTAINER_CONTEXT] = contentProperty;

    if (Polly.flexModel != FlexModel.Flex){
      _polyfill = new AligningPanel(this);
      _polyfills['layout'] = _polyfill;

      _redraw = (FrameworkElement child){
        _polyfill.invalidate();
      };
    }else{
      _redraw = (FrameworkElement child){
        Polly.setFlexboxAlignment(child);
      };
    }

  }

  Border.register() : super.register();
  makeMe() => new Border();

  void _initBorderProperties(){
    //register the dependency properties
    contentProperty = new FrameworkProperty(
      this,
      "content",(FrameworkElement c)
      {
        if (contentProperty.previousValue != null){
          contentProperty.previousValue.removeFromLayoutTree();
        }
        if (c != null) c.addToLayoutTree(this);

      });

    backgroundProperty = new AnimatingFrameworkProperty(
      this,
      "background",
      'background',
      propertyChangedCallback:(Brush value){
        if (value == null){
          rawElement.style.background = "None";
          return;
        }
        value.renderBrush(rawElement);
      },
      converter:const StringToSolidColorBrushConverter());

    borderStyleProperty = new FrameworkProperty(this, 'borderStyle',
        propertyChangedCallback: (BorderStyle value){
          rawElement.style.borderStyle = '$value';
        },
        defaultValue: BorderStyle.solid,
        converter: const StringToBorderStyleConverter());

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
      'border-radius',
      propertyChangedCallback:(Thickness value){
        // TODO (John) this is a temprorary fix until value converters are working in
        // templates...
        if (value is num){
          value = new Thickness(value);
        }

        rawElement.style.borderRadius = '${value.top}px ${value.right}px'
          ' ${value.bottom}px ${value.left}px';
      },
      defaultValue: getResource('theme_border_corner_radius',
                                converter: const StringToThicknessConverter()),
      converter:const StringToThicknessConverter());

    borderColorProperty = new AnimatingFrameworkProperty(
      this,
      "borderColor",
      'border',
      propertyChangedCallback: (Color c){
        rawElement.style.borderColor = c.toColorString();
      },
      defaultValue: new Color.predefined(Colors.White),
      converter:const StringToColorConverter());


    borderThicknessProperty = new FrameworkProperty(
      this,
      "borderThickness",
      (value){

        String color = borderColor != null ? rawElement.style.borderColor : Colors.White.toString();

        rawElement.style.borderTop = '${borderStyle} ${value.top}px $color';
        rawElement.style.borderRight = '${borderStyle} ${value.right}px $color';
        rawElement.style.borderLeft = '${borderStyle} ${value.left}px $color';
        rawElement.style.borderBottom = '${borderStyle} ${value.bottom}px $color';

      }, new Thickness(0), converter:const StringToThicknessConverter());

    horizontalScrollEnabledProperty = new AnimatingFrameworkProperty(this,
        "horizontalScrollEnabled",
        'overflow',
        defaultValue: false,
        propertyChangedCallback:(bool value){
          _assignOverflowX(value);
        },
        converter:const StringToBooleanConverter());

    verticalScrollEnabledProperty = new AnimatingFrameworkProperty(this,
        "verticalScrollEnabled",
        'overflow',
        propertyChangedCallback:(bool value){
          _assignOverflowY(value);
        },
        defaultValue: false,
        converter:const StringToBooleanConverter());
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

  set verticalScrollEnabled(bool value) => setValue(verticalScrollEnabledProperty, value);


  set borderStyle(BorderStyle value) => setValue(borderStyleProperty, value);
  BorderStyle get borderStyle => getValue(borderStyleProperty);

  /// Sets the [backgroundProperty] value.
  set background(Brush value) => setValue(backgroundProperty, value);
  /// Gets the [backgroundProperty] value.
  Brush get background => getValue(backgroundProperty);

  /// Sets the [paddingProperty] value.
  set padding(Thickness value) => setValue(paddingProperty, value);
  /// Gets the [paddingProperty] value.
  Thickness get padding => getValue(paddingProperty);

  /// Sets the [cornerRadiusProperty] value.
  set cornerRadius(int value) => setValue(cornerRadiusProperty, value);
  /// Gets the [cornerRadiusProperty] value.
  int get cornerRadius => getValue(cornerRadiusProperty);

  /// Sets the [borderColorProperty] value.
  set borderColor(Color value) => setValue(borderColorProperty, value);
  /// Gets the [borderColorProperty] value.
  Color get borderColor => getValue(borderColorProperty);

  /// Sets the [borderThicknessProperty] value.
  set borderThickness(Thickness value) => setValue(borderThicknessProperty, value);
  /// Gets the [borderThicknessProperty] value.
  Thickness get borderThickness => getValue(borderThicknessProperty);

  /// Gets the [contentProperty] value.
  FrameworkElement get content => getValue(contentProperty);
  /// Sets the [contentProperty] value.
  set content(FrameworkElement value) => setValue(contentProperty, value);

  /// Overridden [FrameworkObject] method for generating the html representation of the border.
  void createElement(){
    rawElement = new DivElement();
    rawElement.style.overflow = 'hidden';
    Polly.makeFlexBox(rawElement);
  }

  /// Overridden [FrameworkObject] method is called when the framework
  /// requires elements to recalculate layout.
  void updateLayout(){
    if (!isLoaded) return;

    if (content == null) return;

    assert(_redraw != null);

    _redraw(content);
  }
}
