#library('popup.controls.buckshotui.org');

#import('dart:html');
#import('package:buckshot/buckshot.dart');
#import('package:dartnet_event_model/events.dart');
#import('package:dart_utils/shared.dart');

/**
 * A popup control that hovers over a given element.
 *
 * Popup ensures that only a single instance of it is visible at any given
 * time.  If another Popup is visible, it will be removed before displaying
 * the current Popup.
 *
 * Popup, much like [ModalDialog] is not meant to be declared directly in
 * templates, but instead initialized and handled in code.
 *
 * Aside from the above, it is up to the developer to manage the logic under
 * which the Popup will open and close.  The examples below demonstrate a basic
 * mechanism whereby clicking on the Popup will close it.
 *
 * See the Sandbox demo for an example of a more complex Popup implementation.
 *
 * ## Examples ##
 * ### A basic Popup ###
 *     // A Popup with no content.
 *     final p = new Popup().show();
 *     p.click(_,__) => p.hide();
 *
 * ### Offset from the window ###
 *     final p = new Popup()
 *        ..offsetX = 50
 *        ..offsetY = 50
 *        ..show();
 *     p.click(_,__) => p.hide();
 *
 * ### Offset relative to another element ###
 *     final p = new Popup()
 *        ..offsetX = 50
 *        ..offsetY = 50
 *        ..show(someOtherElement);
 *     p.click(_,__) => p.hide();
 *
 * ### Providing content to the popup ###
 *     final content = new
 *        View.fromTemplate("<textblock margin='10' text='hello world!' />");
 *
 *     content.ready((_){
 *        final p = new Popup.with(content)
 *           ..offsetX = 50
 *           ..offsetY = 50
 *           ..show(someOtherElement);
 *        p.click(_,__) => p.hide();
 *     });
 *
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

  FrameworkElement _target;
  EventHandlerReference _ref;
  SafePoint _currentPos;
  static Popup _currentPopup;

  Popup(){
    _initPopupProperties();
  }

  Popup.with(FrameworkElement popupContent){
    _initPopupProperties();
    content = popupContent;
  }

  Popup.register() : super.register();
  makeMe() => new Popup();

  void show([FrameworkElement target = null]){
    if (_currentPopup != null) _currentPopup.hide();

    if (target == null || !target.isLoaded){
      rawElement.style.left = '${offsetX}px';
      rawElement.style.top = '${offsetY}px';
      document.body.elements.add(rawElement);

      // manually trigger loaded state since we aren't adding this
      // to the visual tree using the API...
      isLoaded = true;
      onLoaded();
      updateLayout();
      _currentPopup = this;
    }else{
      target
        .updateMeasurementAsync
        .then((ElementRect r){
          rawElement.style.left = '${offsetX + r.bounding.left}px';
          rawElement.style.top = '${offsetY + r.bounding.top}px';
          document.body.elements.add(rawElement);

          // manually trigger loaded state since we aren't adding this
          // to the visual tree using the API...
          isLoaded = true;
          onLoaded();
          updateLayout();
          _currentPopup = this;
        });
    }
  }

  void hide(){
    rawElement.remove();
    _currentPopup = null;
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
  set cornerRadius(Thickness value) => setValue(cornerRadiusProperty, value);
  /// Gets the [cornerRadiusProperty] value.
  Thickness get cornerRadius => getValue(cornerRadiusProperty);

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
        defaultValue: new Thickness(0),
        converter: const StringToThicknessConverter());

    contentProperty = new FrameworkProperty(this, 'content');

    offsetXProperty = new FrameworkProperty(this, 'offsetX',
        defaultValue: 0,
        converter: const StringToNumericConverter());

    offsetYProperty = new FrameworkProperty(this, 'offsetY',
        defaultValue: 0,
        converter: const StringToNumericConverter());

    // Override the underlying DOM element so that it
    // is absolutely positioned int the window at 0,0
    cursor = Cursors.Arrow;
    rawElement.style.position = 'absolute';
    rawElement.style.top = '0px';
    rawElement.style.left = '0px';

  }

  String get defaultControlTemplate {
    return
'''
<controltemplate controlType='${this.templateName}'>
    <border name='__borderRoot__'
            shadowx='3'
            shadowy='3'
            shadowblur='6'
            zorder='32766'
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
