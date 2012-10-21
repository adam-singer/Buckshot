#library('popup.controls.buckshotui.org');

#import('dart:html');
#import('package:buckshot/buckshot.dart');
#import('package:dartnet_event_model/events.dart');

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
  FrameworkProperty<num> offsetX;
  FrameworkProperty<num> offsetY;
  FrameworkProperty<Brush> background;
  FrameworkProperty<Color> borderColor;
  FrameworkProperty<Thickness> borderThickness;
  FrameworkProperty<Thickness> cornerRadius;
  FrameworkProperty<Dynamic> content;

  FrameworkElement _target;
  EventHandlerReference _ref;
  SafePoint _currentPos;
  static Popup _currentPopup;

  Popup(){
    _initPopupProperties();
  }

  Popup.with(FrameworkElement popupContent){
    _initPopupProperties();
    content.value = popupContent;
  }

  Popup.register() : super.register();
  makeMe() => new Popup();

  void show([FrameworkElement target = null]){
    if (_currentPopup != null) _currentPopup.hide();

    if (target == null || !target.isLoaded){
      rawElement.style.left = '${offsetX.value}px';
      rawElement.style.top = '${offsetY.value}px';
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
          rawElement.style.left = '${offsetX.value + r.bounding.left}px';
          rawElement.style.top = '${offsetY.value + r.bounding.top}px';
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

  void _initPopupProperties(){
    background = new FrameworkProperty(this, 'background',
        defaultValue: getResource('theme_dark_brush'),
        converter: const StringToSolidColorBrushConverter());

    borderColor = new FrameworkProperty(this, 'borderColor',
        defaultValue: getResource('theme_border_color'),
        converter: const StringToColorConverter());

    borderThickness = new FrameworkProperty(this, 'borderThickness',
        defaultValue: getResource('theme_border_thickness',
                                 converter: const StringToThicknessConverter()),
        converter: const StringToThicknessConverter());

    cornerRadius= new FrameworkProperty(this, 'cornerRadius',
        defaultValue: getResource('theme_border_corner_radius',
                                 converter: const StringToThicknessConverter()),
        converter: const StringToThicknessConverter());

    content = new FrameworkProperty(this, 'content');

    offsetX = new FrameworkProperty(this, 'offsetX',
        defaultValue: 0,
        converter: const StringToNumericConverter());

    offsetY = new FrameworkProperty(this, 'offsetY',
        defaultValue: 0,
        converter: const StringToNumericConverter());

    // Override the underlying DOM element so that it
    // is absolutely positioned int the window at 0,0
    cursor.value = Cursors.Arrow;
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
