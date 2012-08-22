// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#library('modaldialog.controls.buckshotui.org');

#import('../../lib/Buckshot.dart');

/**
* A Buckshot control that displays a general purpose
* modal dialog and returns results.
*
*/
class ModalDialog extends Control
{
  FrameworkProperty backgroundProperty;
  FrameworkProperty borderColorProperty;
  FrameworkProperty borderThicknessProperty;
  FrameworkProperty titleProperty;
  FrameworkProperty titleSizeProperty;
  FrameworkProperty textProperty;
  FrameworkProperty textSizeProperty;
  Binding b1, b2;
  Border bDialog;
  Border bMask;
  Grid cvRoot;

  Completer c;

  final List<ModalDialogButtons> buttons;

  ModalDialog()
  :
    buttons = new List<ModalDialogButtons>()
  {
    _initModalDialogProperties();
  }

  ModalDialog.with(String dialogTitle, String dialogMessage)
  :
    buttons = new List<ModalDialogButtons>()
  {
    _initModalDialogProperties();
    title = dialogTitle;
    text = dialogMessage;
  }

  void _updateButtons(List<ModalDialogButtons> list){
    buttons.clear();
    buttons.addAll(list);
  }

  void _initModalDialogProperties(){
    titleProperty = new FrameworkProperty(this, 'title', (_){}, 'undefined');
    textProperty = new FrameworkProperty(this, 'text', (_){}, 'undefined');

    cvRoot = Template.findByName('cvRoot', template);
    bDialog = Template.findByName('bDialog', template);
    bMask = Template.findByName('bMask', template);

    assert(cvRoot != null);

    // Override the underlying DOM element on this canvas so that it
    // is absolutely positioned int the window at 0,0
    cvRoot.rawElement.style.position = 'absolute';
    cvRoot.rawElement.style.top = '0px';
    cvRoot.rawElement.style.left = '0px';


    //TODO: this is just for testing, click events should hook
    //into the dialog buttons.
    bDialog.click + (_, __){
      b1.unregister();
      b2.unregister();
      this.rawElement.remove();
      onUnloaded();
      c.complete(ModalDialogButtons.OK);
    };
  }

  Future<ModalDialogButtons> show(){
    c = new Completer<ModalDialogButtons>();
    //inject into DOM

    b1 = new Binding(buckshot.windowWidthProperty, cvRoot.widthProperty);
    b2 = new Binding(buckshot.windowHeightProperty, cvRoot.heightProperty);

    buckshot.domRoot.rawElement.elements.add(cvRoot.rawElement);

    // manually trigger loaded state since we aren't adding this
    // to the visual tree using the API...
    cvRoot.isLoaded = true;
    onLoaded();
    cvRoot.updateLayout();

    return c.future;
  }

  String get text() => getValue(textProperty);
  set text(String v) => setValue(textProperty, v);

  String get title() => getValue(titleProperty);
  set title(String v) => setValue(titleProperty, v);

  String get defaultControlTemplate() {
    return
        '''
<controltemplate controlType='${this.templateName}'>
  <grid name='cvRoot'>
    <border halign='stretch' valign='stretch' name='bMask' background='Gray' opacity='0.5'></border>
    <border halign='center' valign='center' padding='5' borderthickness='1' bordercolor='Black' name='bDialog' background='White'>
      <stackpanel maxwidth='500'>
        <textblock name='tbTitle' text='{template title}' halign='center'></textblock>
        <textblock name='tbText' text='{template text}'></textblock>
        <stackpanel halign='center' orientation='horizontal'>
          <button name='btnModalDialogOK' content='OK'></button>
          <button name='btnModalDialogCancel' content='Cancel'></button>
          <button name='btnModalDialogYes' content='Yes'></button>
          <button name='btnModalDialogNo' content='No'></button>
        </stackpanel>
      </stackpanel>
    </border>
  </grid>
</controltemplate>
        ''';
  }
}


class ModalDialogButtons
{
  final String _str;

  const ModalDialogButtons(this._str);

  static final OK = const ModalDialogButtons('OK');
  static final CANCEL = const ModalDialogButtons('CANCEL');
  static final YES = const ModalDialogButtons('YES');
  static final NO = const ModalDialogButtons('NO');

  String toString() => _str;
}
