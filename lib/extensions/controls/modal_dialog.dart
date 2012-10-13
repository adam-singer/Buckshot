// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#library('modaldialog.controls.buckshotui.org');

#import('dart:html');
#import('package:buckshot/buckshot.dart');
#import('package:dartnet_event_model/events.dart');

/**
* Displays a general purpose modal dialog and returns results.
*
* ## Not Used In Templates ##
* ModalDialog is a activated and handled in code.  It's title and body content
* areas can be templates or simple strings.
*
* ## Examples ##
* ### A very basic dialog with textual title and body. ###
*     new ModalDialog
*        .with('Title', 'body', ModalDialog.Ok)
*        .show();
*
* ### Determining Button Clicked ###
*     new ModalDialog
*        .with('Title', 'body', ModalDialog.OkCancel)
*        .show() // .show() returns a Future with the button clicked.
*        .then((DialogButtonType b){
*           print('You clicked the "$b" button.');
*        });
*
* ### Using Templates For Title and Body ###
*     // ModalDialog supports arbitrary content in the title and body.
*
*     final title = new View.fromTemplate('<textblock text="title" />');
*     final body = new View.fromTemplate('<border width="30" height="30"'
*        ' background="Orange" />');
*
*     Futures
*        .wait([title.ready, body.ready]) //make sure the views are ready
*        .then((views){
*           new ModalDialog
*              .with(title.rootVisual, body.rootVisual, ModalDialog.OKCancel)
*              .show();
*        });
*
*  ### Setting Other Properties ###
*      new ModalDialog
*         .with('Title', 'Body', ModalDialog.YesNo)
*         ..cornerRadius = 7
*         ..borderThickness = new Thickness(3)
*         ..maskOpacity = 0.5
*         ..maskColor = new SolidColorBrush(new Color.predefined(Colors.Blue))
*         ..background = new SolidColorBrush(new Color.predefined(Colors.Yellow))
*         ..show();
*/
class ModalDialog extends Control
{
  FrameworkProperty backgroundProperty;
  FrameworkProperty borderColorProperty;
  FrameworkProperty borderThicknessProperty;
  FrameworkProperty cornerRadiusProperty;
  FrameworkProperty maskColorProperty;
  FrameworkProperty maskOpacityProperty;
  FrameworkProperty titleProperty;
  FrameworkProperty bodyProperty;
  Binding b1, b2;
  Border bDialog;
  Border bMask;
  Grid cvRoot;

  static const List<DialogButtonType> Ok =
      const [DialogButtonType.OK];

  static const List<DialogButtonType> OkCancel =
      const [DialogButtonType.OK,
             DialogButtonType.CANCEL];

  static const List<DialogButtonType> YesNo =
      const [DialogButtonType.YES,
             DialogButtonType.NO];

  static const List<DialogButtonType> BackNext =
      const [DialogButtonType.BACK,
             DialogButtonType.NEXT];

  static const List<DialogButtonType> BackNextCancel =
      const [DialogButtonType.BACK,
             DialogButtonType.NEXT,
             DialogButtonType.CANCEL];

  static const List<DialogButtonType> BackNextFinished =
      const [DialogButtonType.BACK,
             DialogButtonType.NEXT,
             DialogButtonType.FINISHED];

  static const List<DialogButtonType> NextFinished =
      const [DialogButtonType.NEXT,
             DialogButtonType.FINISHED];

  static const List<DialogButtonType> Next =
      const [DialogButtonType.NEXT];

  static const List<DialogButtonType> Back =
      const [DialogButtonType.BACK];

  static const List<DialogButtonType> Cancel =
      const [DialogButtonType.CANCEL];

  Completer _dialogCompleter;

  ModalDialog()
  {
    _initModalDialogProperties();
  }

  ModalDialog.register() : super.register();
  makeMe() => new ModalDialog();

  ModalDialog.with(titleContent, bodyContent, List<DialogButtonType> buttons)
  {
    _initModalDialogProperties();
    _initButtons(buttons);
    title = titleContent;
    body = bodyContent;

  }


  void setButtons(List<DialogButtonType> buttons){
    _initButtons(buttons);
  }

  void buttonClick_handler(sender, args){
    final b = sender as Button;
    b1.unregister();
    b2.unregister();
    this.rawElement.remove();
    onUnloaded();

    _dialogCompleter.complete(DialogButtonType.fromString(b.content));
  }

  // modalDialog needs to override this in order to work property.
  void finishOnLoaded(){
    template.isLoaded = true;

    // we have to fire this manually because of the complicate
    // layout nature of this control.
    (template as Panel).children[1].onAddedToDOM();
  }

  void _initButtons(List buttons){
    final buttonsContainer =
        Template.findByName('spButtonContainer', template) as Panel;

    for (final Button b in buttonsContainer.children){
      if (buttons.some((tb) => tb.toString() == b.content.toLowerCase())){
        b.visibility = Visibility.visible;
        b.tag = b.click + buttonClick_handler;
      }else{
        b.visibility = Visibility.collapsed;
        if (b.tag != null){
          b.click - (b.tag as EventHandlerReference);
          b.tag = null;
        }
      }
    }
  }



  void _initModalDialogProperties(){
    titleProperty = new FrameworkProperty(this, 'title',
        defaultValue:'undefined');

    bodyProperty = new FrameworkProperty(this, 'body',
        defaultValue:'undefined');

    backgroundProperty = new FrameworkProperty(this, 'background',
        defaultValue: getResource('theme_dark_brush'),
        converter: const StringToSolidColorBrushConverter());

    maskColorProperty = new FrameworkProperty(this, 'maskColor',
        defaultValue: new SolidColorBrush(
                        new Color.predefined(Colors.Gray)),
        converter: const StringToSolidColorBrushConverter());

    maskOpacityProperty = new FrameworkProperty(this, 'maskOpacity',
        defaultValue: 0.5,
        converter: const StringToNumericConverter());

    borderColorProperty = new FrameworkProperty(this, 'borderColor',
        defaultValue: getResource('theme_border_color_dark'),
        converter: const StringToColorConverter());

    borderThicknessProperty = new FrameworkProperty(this, 'borderThickness',
        defaultValue: getResource('theme_border_thickness',
                                  const StringToThicknessConverter()),
        converter: const StringToThicknessConverter());

    cornerRadiusProperty = new FrameworkProperty(this, 'cornerRadius',
        defaultValue: getResource('theme_border_corner_radius',
            const StringToThicknessConverter()),
        converter: const StringToThicknessConverter());

    cvRoot = Template.findByName('cvRoot', template);

    // Override the underlying DOM element on this canvas so that it
    // is absolutely positioned int the window at 0,0
    cvRoot.rawElement.style.position = 'absolute';
    cvRoot.rawElement.style.top = '0px';
    cvRoot.rawElement.style.left = '0px';
  }

  Future<DialogButtonType> show(){
    log('showing', this);
    _dialogCompleter = new Completer<DialogButtonType>();

    b1 = new Binding(windowWidthProperty, cvRoot.widthProperty);
    b2 = new Binding(windowHeightProperty, cvRoot.heightProperty);

    document.body.elements.add(cvRoot.rawElement);

    // manually trigger loaded state since we aren't adding this
    // to the visual tree using the API...
    cvRoot.isLoaded = true;
    onLoaded();
    cvRoot.updateLayout();

    return _dialogCompleter.future;
  }

  get body => getValue(bodyProperty);
  set body(v) => setValue(bodyProperty, v);

  get title => getValue(titleProperty);
  set title(v) => setValue(titleProperty, v);

  Brush get maskColor => getValue(maskColorProperty);
  set maskColor(Brush value) => setValue(maskColorProperty, value);

  num get maskOpacity => getValue(maskOpacityProperty);
  set maskOpacity(num value) => setValue(maskOpacityProperty, value);

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


  String get defaultControlTemplate {
    return
        '''
<controltemplate controlType='${this.templateName}'>
  <grid name='cvRoot' zorder='32766'>
    <border halign='stretch' 
            valign='stretch' 
            name='bMask' 
            background='{template maskColor}' 
            opacity='{template maskOpacity}' />
    <border shadowx='3' 
            shadowy='3' 
            shadowblur='6' 
            minwidth='200' 
            halign='center' valign='center' padding='5' 
            cornerRadius='{template cornerRadius}' 
            borderthickness='{template borderThickness}' 
            bordercolor='{template borderColor}' 
            background='{template background}'>
      <stack minwidth='200' maxwidth='500'>
        <contentpresenter content='{template title}' halign='center' />
        <contentpresenter halign='center' content='{template body}' />
        <stack name='spButtonContainer' halign='right' orientation='horizontal'>
          <button content='Ok' />
          <button content='Cancel' />
          <button content='Yes' />
          <button content='No'/>
          <button content='Back' />
          <button content='Next' />
          <button content='Finished' />
        </stack>
      </stack>
    </border>
  </grid>
</controltemplate>
        ''';
  }
}


class DialogButtonType
{
  final String _str;

  const DialogButtonType(this._str);

  static const OK = const DialogButtonType('ok');
  static const CANCEL = const DialogButtonType('cancel');
  static const YES = const DialogButtonType('yes');
  static const NO = const DialogButtonType('no');
  static const NEXT = const DialogButtonType('next');
  static const BACK = const DialogButtonType('back');
  static const FINISHED = const DialogButtonType('finished');

  String toString() => _str;

  static DialogButtonType fromString(String name){
    switch(name.toLowerCase()){
      case 'ok':
        return DialogButtonType.OK;
      case 'cancel':
        return DialogButtonType.CANCEL;
      case 'yes':
        return DialogButtonType.YES;
      case 'no':
        return DialogButtonType.NO;
      case 'next':
        return DialogButtonType.NEXT;
      case 'back':
        return DialogButtonType.BACK;
      case 'finished':
        return DialogButtonType.FINISHED;
      default:
        throw new Exception('Unable to match $name to a DialogButtonType');
    }
  }

}