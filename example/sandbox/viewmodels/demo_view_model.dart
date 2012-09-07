// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
 * A view model for displaying information in the Sandbox Demo.
 *
 * Objects that participate in data binding should derive from [ViewModelBase].
 *
 * Properties that need to be bound to must be of type [FrameworkProperty].
 */
class DemoViewModel extends ViewModelBase
{
  final DemoModel model;

  FrameworkProperty timeStampProperty;
  FrameworkProperty videosProperty;
  FrameworkProperty colorProperty;
  FrameworkProperty fruitProperty;
  FrameworkProperty iconsProperty;
  FrameworkProperty versionProperty;
  FrameworkProperty renderedOutputProperty;
  FrameworkProperty templateTextProperty;
  FrameworkProperty errorMessageProperty;
  FrameworkProperty demoTreeNodeSelectedProperty;

  DemoViewModel()
  :
    model = new DemoModel()
  {
    _initDemoViewModelProperties();
    
    _regEventHandlers();

    // Update the timeStampProperty every second with a new timestamp.
    // Anything binding to this will get updated.
    window.setInterval(() => setValue(timeStampProperty,
        new Date.now().toString()), 1000);
  }

  // Initialize the properties that we want to expose for template binding.
  void _initDemoViewModelProperties(){
    timeStampProperty = new FrameworkProperty(this, "timeStamp",
        defaultValue:new Date.now().toString());

    iconsProperty = new FrameworkProperty(this, "icons",
        defaultValue:model.iconList);

    videosProperty = new FrameworkProperty(this, "videos",
        defaultValue:model.videoList);

    fruitProperty = new FrameworkProperty(this, "fruit",
        defaultValue:model.fruitList);

    // Since colorProperty is itself a BuckshotObject, the framework will
    // allow dot-notation resolution to any properties within that object as
    // well. ex. "color.red" or "color.orange"
    colorProperty = new FrameworkProperty(this, "color",
        defaultValue:model.colorClass);

    versionProperty = new FrameworkProperty(this, 'version',
        defaultValue:buckshot.version);

    renderedOutputProperty = new FrameworkProperty(this, 'renderedOutput');

    templateTextProperty = new FrameworkProperty(this, 'templateText');

    errorMessageProperty = new FrameworkProperty(this, 'errorMessage');

    demoTreeNodeSelectedProperty = new FrameworkProperty(this,
        'demoTreeNodeSelected', defaultValue: '');
  }

  /**
   * Sets the given [templateText] to the [templateTextProperty] and renders
   * it into the [renderedOutputProperty].
   */
  void setTemplate(String templateText){
    if (templateText == ''){
      resetUI();
      return;
    }
    
    if (templateText.startsWith('app.')){
      final appName = templateText.split('.')[1];
      switch(appName){
        case 'todo':
          final todoView = new todo.Main();
          todoView.ready.then((_){
            setValue(renderedOutputProperty, todoView.rootVisual);
          });
          break;
        case 'calc':
          final calcView = new calc.Main();
          calcView.ready.then((_){
            setValue(renderedOutputProperty, calcView.rootVisual);
          });        
          break;
        default:
          resetUI();
          return;
      }
    }else{
      setValue(templateTextProperty, templateText);

      Template.deserialize(templateText).then((c){
        setValue(renderedOutputProperty, c);
      });      
    }
  }

  /**
   * Resets the UI properties to default states. */
  void resetUI(){
    //TODO: reset dropdown lists
    setValue(templateTextProperty, '');
    setValue(renderedOutputProperty, null);
  }

  void _showModalDialogDemo(){
    final titleView = new View.fromTemplate(
        '''
        <textblock fontfamily='Arial' fontsize='20' text='Modal Dialog Box Title' />
        '''    
    );
    
    final bodyView = new View.fromTemplate(
        '''
        <stack>
        <textblock fontfamily='Arial' margin='0,5' text='Dialogs can host any content in the title and body.' />
        <textbox width='400' placeholder='Including input from the user' />
        <textblock fontfamily='Arial' margin='0,5' text='ModalDialog also supports buttons for everything from simple dialogs to multi-step wizards.' />
        <textblock fontfamily='Arial' margin='0,5' text='Here are some examples:' />
        <stack background='Gray' orientation='horizontal'>
        <button content='Ok' />
        <button content='Cancel' />
        </stack>
        <stack background='Gray' orientation='horizontal'>
        <button content='Yes' />
        <button content='No' />
        </stack>
        <stack background='Gray' orientation='horizontal'>
        <button content='Next' />
        <button content='Back' />
        <button content='Finished' />
        </stack>
        </stack>
        '''
    );
    
    
    Futures
    .wait([
           titleView.ready,
           bodyView.ready])
    .then((views){
      final md = new ModalDialog
          .with(views[0], views[1], ModalDialog.OkCancel);
      
      md.show().then((DialogButtonType dbt){
        new ModalDialog.with('Dialog Results', 
            'You clicked the "$dbt" button on the previous dialog.', ModalDialog.Ok)
        ..show();
      });
    });    
  }
  
  
  /*
   * Event Handlers
   */

  void _regEventHandlers(){   
    registerEventHandler('refresh_handler', refresh_handler);
    registerEventHandler('clearall_handler', clearAll_handler);
    registerEventHandler('selection_handler', selection_handler);
    registerEventHandler('demotreeview_selection', demotreeview_selection);
    registerEventHandler('dockpanel_click', dockpanel_click);
  }
  
  /**
   * Handles click events coming from the 'refresh output' button
   */
  void refresh_handler(sender, args){

    // I had to put this here because the closure wasn't working
    // correctly in the final{} block.
    void doError(String error){
      var errorView = new ErrorView();

      errorView.ready.then((_){
        setValue(renderedOutputProperty, errorView.rootVisual);
        setValue(errorMessageProperty, error);
      });
    }

    String error = '';

    try{
      setTemplate(getValue(templateTextProperty).trim());
    }on AnimationException catch(ae){
      error = "An error occurred while attempting to process an"
        " animation resource: ${ae}";
    }on PresentationProviderException catch(pe){
      error = "We were unable to parse your input into content for"
        " display: ${pe}";
    }on FrameworkPropertyResolutionException catch(pre){
      error = "A framework error occured while attempting to resolve"
        " a property binding: ${pre}";
    }on BuckshotException catch(fe){
      error = "A framework error occured while attempting to render"
        " the content: ${fe}";
    }on Exception catch(e){
      error = "A general exception occured while attempting to"
        " render the content.  Please bear with us as we (and Dart) are"
        " still in the early stages of development.  Thanks! ${e}";
    }finally{
      if (error == '') return;
      doError(error);
    }
  }

  /**
   * Handles click events coming from the 'clear all' button.
   */
  void clearAll_handler(sender, args) => resetUI();

  /**
   * Handles selection changed events coming from the TreeView.
   */
  void selection_handler(sender, args){
    final value = args.node.tag;

    if (value == ''){
      resetUI();
    } else if (value == 'modaldialog'){
      _showModalDialogDemo();
    }else{
      setTemplate(value.startsWith('app.') ? value : Template.getTemplate('#${value}'));
    }
  }

  void demotreeview_selection(sender, args)
  {
    setValue(demoTreeNodeSelectedProperty, args.node.header);
  }

  void dockpanel_click(sender, args){
      final dp = buckshot.namedElements['dockpanelDemo'];
      final b = buckshot.namedElements['btnDock'];
      if (dp == null || b == null) return;

      switch(sender.content){
        case 'Left':
          DockPanel.setDock(b, DockLocation.left);
          break;
        case 'Top':
          DockPanel.setDock(b, DockLocation.top);
          break;
        case 'Right':
          DockPanel.setDock(b, DockLocation.right);
          break;
        case 'Bottom':
          DockPanel.setDock(b, DockLocation.bottom);
          break;
        default:
          print('boo!');
          break;
      }

      (dp as DockPanel).invalidate();
  }

}