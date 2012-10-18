// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* A container element that holds a single child and provides visual border properties. */
class Border extends FrameworkElement implements FrameworkContainer
{
  /// Represents the [Brush] of the border background.
  AnimatingFrameworkProperty<Brush> background;

  /// Represents the [Thickness] of space between the border frame and the content.
  FrameworkProperty<Thickness> padding;

  /// Represents the rounding value of the border frame corners.
  AnimatingFrameworkProperty<Thickness> cornerRadius;

  /// Represents the [Color] of the border frame.
  AnimatingFrameworkProperty<Color> borderColor;

  /// Represents the [Thickness] of the border frame.
  FrameworkProperty<Thickness> borderThickness;

  /// Represents the style of the border frame.
  FrameworkProperty<BorderStyle> borderStyle;

  /// Represents the content inside the border.
  FrameworkProperty<FrameworkElement> content;

  AnimatingFrameworkProperty<bool> horizontalScrollEnabled;
  AnimatingFrameworkProperty<bool> verticalScrollEnabled;

  AligningPanel _polyfill;
  Function _redraw;

  Border()
  {
    Browser.appendClass(rawElement, "border");

    _initBorderProperties();

    stateBag[FrameworkObject.CONTAINER_CONTEXT] = content;

    if (Polly.supportsFlexModel){
      _redraw = (FrameworkElement child){
        Polly.setFlexboxAlignment(child);
      };
    }else{
      _polyfill = new AligningPanel(this);
      _polyfills['layout'] = _polyfill;

      _redraw = (FrameworkElement child){
        _polyfill.invalidate();
      };
    }
  }

  Border.register() : super.register();
  makeMe() => new Border();

  void _initBorderProperties(){
    //register the dependency properties
    content = new FrameworkProperty(
      this,
      "content", (FrameworkElement c)
      {
        if (content.previousValue != null){
          content.previousValue.removeFromLayoutTree();
        }
        if (c != null) c.addToLayoutTree(this);

      });

    background = new AnimatingFrameworkProperty(
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

    borderStyle= new FrameworkProperty(this, 'borderStyle',
        propertyChangedCallback: (BorderStyle value){
          rawElement.style.borderStyle = '$value';
        },
        defaultValue: BorderStyle.solid,
        converter: const StringToBorderStyleConverter());

    padding = new FrameworkProperty(
      this,
      "padding",
      (Thickness value){
        rawElement.style.padding = '${value.top}px ${value.right}px ${value.bottom}px ${value.left}px';
        updateLayout();
      }, new Thickness(0), converter:const StringToThicknessConverter());

    cornerRadius = new AnimatingFrameworkProperty(
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

    borderColor = new AnimatingFrameworkProperty(
      this,
      "borderColor",
      'border',
      propertyChangedCallback: (Color c){
        rawElement.style.borderColor = c.toColorString();
      },
      defaultValue: new Color.predefined(Colors.Red),
      converter:const StringToColorConverter());


    borderThickness = new FrameworkProperty(
      this,
      "borderThickness",
      (value){

        String color = borderColor.value != null ? rawElement.style.borderColor : Colors.White.toString();

        rawElement.style.borderTop = '${borderStyle.value} ${value.top}px $color';
        rawElement.style.borderRight = '${borderStyle.value} ${value.right}px $color';
        rawElement.style.borderLeft = '${borderStyle.value} ${value.left}px $color';
        rawElement.style.borderBottom = '${borderStyle.value} ${value.bottom}px $color';

      }, new Thickness(0), converter:const StringToThicknessConverter());

    horizontalScrollEnabled = new AnimatingFrameworkProperty(this,
        "horizontalScrollEnabled",
        'overflow',
        defaultValue: false,
        propertyChangedCallback:(bool value){
          _assignOverflowX(value);
        },
        converter:const StringToBooleanConverter());

    verticalScrollEnabled = new AnimatingFrameworkProperty(this,
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

  get containerContent => content.value;

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

    if (content.value == null) return;

    assert(_redraw != null);

    _redraw(content.value);
  }
}
