// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#library('modaldialog.controls.buckshotui.org');

#import('dart:html');
#import('../../../buckshot.dart');
#import('package:DartNet-Event-Model/events.dart');
#import('package:dart_utils/shared.dart');

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
  FrameworkProperty bodyProperty;
  Binding b1, b2;
  Border bDialog;
  Border bMask;
  Grid cvRoot;

  static final List<DialogButtonType> Ok = 
      const [DialogButtonType.OK];
  
  static final List<DialogButtonType> OkCancel = 
      const [DialogButtonType.OK, 
             DialogButtonType.CANCEL];
  
  static final List<DialogButtonType> YesNo = 
      const [DialogButtonType.YES, 
             DialogButtonType.NO];
  
  static final List<DialogButtonType> BackNext = 
      const [DialogButtonType.BACK, 
             DialogButtonType.NEXT];
  
  static final List<DialogButtonType> BackNextCancel = 
      const [DialogButtonType.BACK, 
             DialogButtonType.NEXT, 
             DialogButtonType.CANCEL];
  
  static final List<DialogButtonType> BackNextFinished = 
      const [DialogButtonType.BACK, 
             DialogButtonType.NEXT, 
             DialogButtonType.FINISHED];

  static final List<DialogButtonType> NextFinished = 
      const [DialogButtonType.NEXT, 
             DialogButtonType.FINISHED];
  
  static final List<DialogButtonType> Next = 
      const [DialogButtonType.NEXT];
  
  static final List<DialogButtonType> Back = 
      const [DialogButtonType.BACK];
  
  static final List<DialogButtonType> Cancel = 
      const [DialogButtonType.CANCEL];
  
  Completer c;
  
  ModalDialog()
  {
    _initModalDialogProperties();
    
  }
  
  ModalDialog.register() : super.register();
  makeMe() => new ModalDialog();

  ModalDialog.with(titleContent, String bodyContent, List<DialogButtonType> buttons)
  {
    _initModalDialogProperties();
    _initButtons(buttons);
    title = titleContent;
    content = bodyContent;
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
        
    c.complete(DialogButtonType.fromString(b.content));
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
    titleProperty = new FrameworkProperty(this, 'title', defaultValue:'undefined');
    bodyProperty = new FrameworkProperty(this, 'content', defaultValue:'undefined');

    cvRoot = Template.findByName('cvRoot', template);
//    bDialog = Template.findByName('bDialog', template);
    bMask = Template.findByName('bMask', template);

    // Override the underlying DOM element on this canvas so that it
    // is absolutely positioned int the window at 0,0
    cvRoot.rawElement.style.position = 'absolute';
    cvRoot.rawElement.style.top = '0px';
    cvRoot.rawElement.style.left = '0px';


    //TODO: this is just for testing, click events should hook
    //into the dialog buttons.
//    bDialog.click + (_, __){
//      b1.unregister();
//      b2.unregister();
//      this.rawElement.remove();
//      onUnloaded();
//      c.complete(DialogButtonType.OK);
//    };
  }

  Future<DialogButtonType> show(){
    c = new Completer<DialogButtonType>();
    //inject into DOM

    b1 = new Binding(buckshot.windowWidthProperty, cvRoot.widthProperty);
    b2 = new Binding(buckshot.windowHeightProperty, cvRoot.heightProperty);

    document.body.elements.add(cvRoot.rawElement);

    // manually trigger loaded state since we aren't adding this
    // to the visual tree using the API...
    cvRoot.isLoaded = true;
    onLoaded();
    cvRoot.updateLayout();

    return c.future;
  }

  get content => getValue(bodyProperty);
  set content(v) => setValue(bodyProperty, v);

  get title => getValue(titleProperty);
  set title(v) => setValue(titleProperty, v);

  String get defaultControlTemplate {
    return
        '''
<controltemplate controlType='${this.templateName}'>
  <grid name='cvRoot'>
    <border halign='stretch' valign='stretch' name='bMask' background='Gray' opacity='0.5'></border>
    <border minwidth='200' halign='center' valign='center' padding='5' borderthickness='1' bordercolor='Black' background='White'>
      <stackpanel minwidth='200' maxwidth='500'>
        <contentpresenter content='{template title}' halign='center' />
        <contentpresenter halign='center' content='{template content}' />
        <stackpanel name='spButtonContainer' halign='right' orientation='horizontal'>
          <button content='Ok' />
          <button content='Cancel' />
          <button content='Yes' />
          <button content='No'/>
          <button content='Back' />
          <button content='Next' />
          <button content='Finished' />
        </stackpanel>
      </stackpanel>
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

  static final OK = const DialogButtonType('ok');
  static final CANCEL = const DialogButtonType('cancel');
  static final YES = const DialogButtonType('yes');
  static final NO = const DialogButtonType('no');
  static final NEXT = const DialogButtonType('next');
  static final BACK = const DialogButtonType('back');
  static final FINISHED = const DialogButtonType('finished');

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
