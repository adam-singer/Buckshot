#library('popup.controls.buckshotui.org');

#import('dart:html');
#import('../../../buckshot.dart');
#import('package:DartNet-Event-Model/events.dart');
#import('package:dart_utils/shared.dart');

/**
 * A popup control that hovers over a given element.
 */
class Popup extends Control
{
  FrameworkProperty offsetXProperty;
  FrameworkProperty offsetYProperty;
  FrameworkProperty backgroundProperty;
  FrameworkProperty borderColorProperty;
  FrameworkProperty borderThicknessProperty;
  FrameworkProperty cornerRadiusProperty;
  FrameworkProperty contentProperty;
  
  Border _root;
  FrameworkElement _target;
  EventHandlerReference _ref;
  SafePoint _currentPos;
  
  Popup(){
    _initPopupProperties();
  }
  
  Popup.with(FrameworkElement popupContent){
    _initPopupProperties();
    content = popupContent;
  }
    
  Popup.register() : super.register();
  makeMe() => new Popup();
  
  
  
  void show(FrameworkElement target){
    document.body.elements.add(_root.rawElement);
    
    // manually trigger loaded state since we aren't adding this
    // to the visual tree using the API...
    _root.isLoaded = true;
    onLoaded();
    _root.updateLayout();
  }
  
  void hide(){
    _target = null;
  }
  
  /// Gets the [contentProperty] value.
  get content => getValue(contentProperty);
  /// Sets the [contentProperty] value;
  set content(v) => setValue(contentProperty, v);
   
  /// Sets the [backgroundProperty] value.
  set background(Brush value) => setValue(backgroundProperty, value);
  /// Gets the [backgroundProperty] value.
  Brush get background => getValue(backgroundProperty);

  /// Sets the [cornerRadiusProperty] value.
  set cornerRadius(int value) => setValue(cornerRadiusProperty, value);
  /// Gets the [cornerRadiusProperty] value.
  int get cornerRadius => getValue(cornerRadiusProperty);

  /// Sets the [borderColorProperty] value.
  set borderColor(SolidColorBrush value) => setValue(borderColorProperty, value);
  /// Gets the [borderColorProperty] value.
  SolidColorBrush get borderColor => getValue(borderColorProperty);

  /// Sets the [borderThicknessProperty] value.
  set borderThickness(Thickness value) => setValue(borderThicknessProperty, value);
  /// Gets the [borderThicknessProperty] value.
  Thickness get borderThickness => getValue(borderThicknessProperty);
  
  set offsetX(num value) => setValue(offsetXProperty, value);
  num get offsetX => getValue(offsetXProperty);
  
  set offsetY(num value) => setValue(offsetYProperty, value);
  num get offsetY => getValue(offsetYProperty);
  
  void _initPopupProperties(){
    backgroundProperty = new FrameworkProperty(this, 'background',
        defaultValue: new SolidColorBrush(
                        new Color.predefined(Colors.WhiteSmoke)),
        converter: const StringToSolidColorBrushConverter());
        
    borderColorProperty = new FrameworkProperty(this, 'borderColor',
        defaultValue: new SolidColorBrush(
                        new Color.predefined(Colors.Black)),
        converter: const StringToSolidColorBrushConverter());
    
    borderThicknessProperty = new FrameworkProperty(this, 'borderThickness',
        defaultValue: new Thickness(1),
        converter: const StringToThicknessConverter());
    
    cornerRadiusProperty = new FrameworkProperty(this, 'cornerRadius',
        defaultValue: 0,
        converter: const StringToNumericConverter());
    
    contentProperty = new FrameworkProperty(this, 'content');
    
    offsetXProperty = new FrameworkProperty(this, 'offsetX', 
        converter: const StringToNumericConverter());
    
    offsetYProperty = new FrameworkProperty(this, 'offsetY', 
        converter: const StringToNumericConverter());
    
    _root = Template.findByName('__borderRoot__', template) as Border;
//    bDialog = Template.findByName('bDialog', template);
    //bMask = Template.findByName('bMask', template);

    // Override the underlying DOM element on this canvas so that it
    // is absolutely positioned int the window at 0,0
    _root.rawElement.style.position = 'absolute';
    _root.rawElement.style.top = '0px';
    _root.rawElement.style.left = '0px';
    
  }
  
  String get defaultControlTemplate {
    return
'''
<controltemplate controlType='${this.templateName}'>
    <border name='__borderRoot__'
            minwidth='20'
            minheight='20'
            padding='5' 
            cornerRadius='{template cornerRadius}' 
            borderthickness='{template borderThickness}' 
            bordercolor='{template borderColor}' 
            background='{template background}'
            content='{template content}' />
</controltemplate>
''';
  }

}
