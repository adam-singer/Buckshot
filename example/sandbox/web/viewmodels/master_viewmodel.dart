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
class MasterViewModel extends ViewModelBase
{
  final DemoModel model = new DemoModel();
  final View _calc = new Calculator();
  final View _todo = new todo.Main();

  // used to track the tree views and clear them as needed.
  final List<TreeView> _treeViews = new List<TreeView>();
  TreeView _currentTreeView;

  FrameworkProperty timeStampProperty;
  FrameworkProperty videosProperty;
  FrameworkProperty colorProperty;
  FrameworkProperty fruitProperty;
  FrameworkProperty iconsProperty;
  FrameworkProperty renderedOutputProperty;
  FrameworkProperty templateTextProperty;
  FrameworkProperty errorMessageProperty;
  FrameworkProperty demoTreeNodeSelectedProperty;
  FrameworkProperty dockTextProperty;
  FrameworkProperty secondInDegsProperty;
  FrameworkProperty minuteInDegsProperty;
  FrameworkProperty hourInDegsProperty;
  FrameworkProperty dayAndMonthProperty;

  View _mainView;

  MasterViewModel()
  {
    _initDemoViewModelProperties();

    _regEventHandlers();

    _startTimer();

    window.on.popState.add((e){
      final demo = queryString['demo'];

      if (demo != null){
        _mainView.rootVisual.dataContext.setTemplate('#${demo}');
      }
    });
  }

  MasterViewModel.withView(this._mainView)
  {
    _initDemoViewModelProperties();

    _regEventHandlers();

    _startTimer();

    window.on.popState.add((e){
      final demo = queryString['demo'];

      if (demo != null){
        _mainView.rootVisual.dataContext.setTemplate('#${demo}');
      }
    });
  }

  void _startTimer(){
    window.setInterval((){
      Date d = new Date.now();

      _updateDate(d);

      setValue(timeStampProperty, d.toString());

      setValue(secondInDegsProperty, d.second * 6);

      setValue(minuteInDegsProperty, (d.minute * 6) + (d.second / 10));

      final hour = d.hour % 24 > 0 ? d.hour - 12 : d.hour;

      setValue(hourInDegsProperty, (hour * 30) + (d.minute / 2));
    }, 1000);

  }

  void _updateDate(Date d){
    final months = const ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul',
                          'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    setValue(dayAndMonthProperty, "${d.day} ${months[d.month]}");
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

    renderedOutputProperty = new FrameworkProperty(this, 'renderedOutput');

    templateTextProperty = new FrameworkProperty(this, 'templateText');

    errorMessageProperty = new FrameworkProperty(this, 'errorMessage');

    demoTreeNodeSelectedProperty = new FrameworkProperty(this,
        'demoTreeNodeSelected', defaultValue: '');

    dockTextProperty = new FrameworkProperty(this, 'dockText',
        defaultValue: 'Docked left.');

    secondInDegsProperty = new FrameworkProperty(this, 'secondInDegs',
        defaultValue: 0);

    hourInDegsProperty = new FrameworkProperty(this, 'hourInDegs',
        defaultValue: 0);

    minuteInDegsProperty = new FrameworkProperty(this, 'minuteInDegs',
        defaultValue: 0);

    dayAndMonthProperty = new FrameworkProperty(this, 'dayAndMonth',
        defaultValue: '');
  }

  void setQueryStringTo(String value){
    window.history.pushState({}, document.title, '?demo=$value');
  }

  /**
   * Sets the given [templateText] to the [templateTextProperty] and renders
   * it into the [renderedOutputProperty].
   */
  void setTemplate(String templateText){
    templateText = templateText.trim();

    if (templateText == ''){
      resetUI();
      return;
    }

    if (templateText.startsWith('app.')){
      final appName = templateText.split('.')[1];
      resetUI();
      switch(appName){
        case 'todo':
          _todo.ready.then((_){
            setValue(renderedOutputProperty, _todo.rootVisual);
          });
          break;
        case 'calc':
          _calc.ready.then((_){
            setValue(renderedOutputProperty, _calc.rootVisual);
          });
          break;
        default:
          resetUI();
          return;
      }
    }else{
      if (templateText.startsWith('<')){
        setValue(templateTextProperty, templateText);

        Template
          .deserialize(templateText)
          .then((c){
            setValue(renderedOutputProperty, c);
          });
      }else{
        Template
          .deserialize('web/views/templates/${templateText}.xml')
          .then((t){
            setValue(renderedOutputProperty, t);
            setValue(templateTextProperty, t.stateBag['__buckshot_template__']);
          });
      }
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
<textblock fontsize='20' text='Modal Dialog Box Title' />
'''
    );

    final bodyView =
        new View.fromResource('web/views/templates/modaldialog.xml');

    Futures
      .wait([titleView.ready, bodyView.ready])
      .chain((results){
        final md = new ModalDialog
          .with(results[0], results[1], ModalDialog.OkCancel);

        return md.show();
        })
      .chain((DialogButtonType dbt){
        final md = new ModalDialog
          .with('Dialog Results',
            'You clicked the "$dbt" button on the previous dialog.',
              ModalDialog.Ok)
          ..maskColor = new SolidColorBrush(
              new Color.predefined(Colors.Green));

        return md.show();
      });
  }


  void _showPopupDemo(TreeNode popUpNode){
    if (_mainView == null) return;

    new View
        .fromResource('web/views/templates/popup.xml')
        .ready
        .then((t){

          final p = new Popup
              .with(t)
          ..offsetX = 100
          ..offsetY = -150
          ..cornerRadius = new Thickness(7)
          ..borderThickness = new Thickness(3)
          ..borderColor = new Color.predefined(Colors.SteelBlue)
          ..show(popUpNode);
          p.click + (_,__) => p.hide();
        });
  }

  /*
   * Event Handlers
   */

  void _regEventHandlers(){
    registerEventHandler('refresh_handler', refresh_handler);
    registerEventHandler('clearall_handler', clearAll_handler);
    registerEventHandler('demotreeview_selection', demotreeview_selection);
    registerEventHandler('dockpanel_click', dockpanel_click);
    registerEventHandler('selection_handler', selection_handler);
    registerEventHandler('debug_click', debug_click);
  }


  void debug_click(sender, args){
    db('fired click event', sender);
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

    // since the view is using multiple TreeViews (for now) we have to
    // track them and clear the active node a of the previous TreeView
    // when a node is selected in another.

    if (_treeViews.indexOf(sender) == -1){
        _treeViews.add(sender);
    }

    if (_currentTreeView != null && sender != _currentTreeView){
      _currentTreeView.clearSelectedNode();
    }

    _currentTreeView = sender;

    final value = args.node.tag;

    if (value == ''){
      resetUI();
    }else if (value == 'modaldialog'){
      _showModalDialogDemo();
    }else if (value == 'popup'){
      _showPopupDemo(args.node);
    }else if (value.startsWith('app.')){
      setTemplate(value);
    }else{
      setQueryStringTo(value);
      setTemplate(value);
    }
  }

  void demotreeview_selection(sender, args)
  {
    setValue(demoTreeNodeSelectedProperty, args.node.header);
  }

  void dockpanel_click(sender, args){
      String text = "Docked ";
      final dp = buckshot.namedElements['dockpanelDemo'];
      final b = buckshot.namedElements['btnDock'];
      if (dp == null || b == null) return;

      switch(sender.content){
        case 'Left':
          DockPanel.setDock(b, DockLocation.left);
          setValue(dockTextProperty, '$text left.');
          break;
        case 'Top':
          DockPanel.setDock(b, DockLocation.top);
          setValue(dockTextProperty, '$text top.');
          break;
        case 'Right':
          DockPanel.setDock(b, DockLocation.right);
          setValue(dockTextProperty, '$text right.');
          break;
        case 'Bottom':
          DockPanel.setDock(b, DockLocation.bottom);
          setValue(dockTextProperty, '$text bottom.');
          break;
        default:
          print('boo!');
          break;
      }

      (dp as DockPanel).invalidate();
  }

}