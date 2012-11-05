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
part of sandbox;
class MasterViewModel extends ViewModelBase
{
  const months = const ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul',
                        'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  final DemoModel model = new DemoModel();
  final View _calc = new Calculator();
  final View _todo = new todo.Main();

  // used to track the tree views and clear them as needed.
  final List<TreeView> _treeViews = new List<TreeView>();
  TreeView _currentTreeView;

  FrameworkProperty<String> timeStamp;
  FrameworkProperty<List<DataTemplate>> videos;
  FrameworkProperty<SomeColors> color;
  FrameworkProperty<List<DataTemplate>> fruit;
  FrameworkProperty<List<DataTemplate>> icons;
  FrameworkProperty<FrameworkElement> renderedOutput;
  FrameworkProperty<String> templateText;
  FrameworkProperty<String> errorMessage;
  FrameworkProperty<TreeNode> demoTreeNodeSelected;
  FrameworkProperty<String> dockText;
  FrameworkProperty<num> secondInDegrees;
  FrameworkProperty<num> minuteInDegrees;
  FrameworkProperty<num> hourInDegrees;
  FrameworkProperty<String> dayAndMonth;

  View _mainView;

  MasterViewModel()
  {
    _initDemoViewModelProperties();

    _regEventHandlers();

    _startTimer();

    window.on.popState.add((e){
      final demo = queryString['demo'];

      if (demo != null){
        _mainView.rootVisual.dataContext.value.setTemplate('#${demo}');
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
        setTemplate('#${demo}');
      }
    });
  }

  void _startTimer(){
    window.setInterval((){
      Date d = new Date.now();

      _updateDate(d);

      timeStamp.value = d.toString();

      secondInDegrees.value = d.second * 6;

      minuteInDegrees.value = (d.minute * 6) + (d.second / 10);

      final hour = d.hour % 24 > 0 ? d.hour - 12 : d.hour;

      hourInDegrees.value = (hour * 30) + (d.minute / 2);
    }, 1000);

  }

  void _updateDate(Date d){
    dayAndMonth.value = "${d.day} ${months[d.month]}";
  }


  // Initialize the properties that we want to expose for template binding.
  void _initDemoViewModelProperties(){
    timeStamp = new FrameworkProperty(this, "timeStamp",
        defaultValue:new Date.now().toString());

    icons = new FrameworkProperty(this, "icons",
        defaultValue:model.iconList);

    videos = new FrameworkProperty(this, "videos",
        defaultValue:model.videoList);

    fruit = new FrameworkProperty(this, "fruit",
        defaultValue:model.fruitList);

    // Since colorProperty is itself a BuckshotObject, the framework will
    // allow dot-notation resolution to any properties within that object as
    // well. ex. "color.red" or "color.orange"
    color = new FrameworkProperty(this, "color",
        defaultValue:model.colorClass);

    renderedOutput = new FrameworkProperty(this, 'renderedOutput');

    templateText = new FrameworkProperty(this, 'templateText');

    errorMessage = new FrameworkProperty(this, 'errorMessage');

    demoTreeNodeSelected = new FrameworkProperty(this,
        'demoTreeNodeSelected', defaultValue: '');

    dockText = new FrameworkProperty(this, 'dockText',
        defaultValue: 'Docked left.');

    secondInDegrees = new FrameworkProperty(this, 'secondInDegs',
        defaultValue: 0);

    hourInDegrees = new FrameworkProperty(this, 'hourInDegs',
        defaultValue: 0);

    minuteInDegrees = new FrameworkProperty(this, 'minuteInDegs',
        defaultValue: 0);

    dayAndMonth = new FrameworkProperty(this, 'dayAndMonth',
        defaultValue: '');
  }

  void setQueryStringTo(String value){
    window.history.pushState({}, document.title, '?demo=$value');
  }

  /**
   * Sets the given [templateText] to the [templateTextProperty] and renders
   * it into the [renderedOutputProperty].
   */
  void setTemplate(String text){
    text = text.trim();

    if (text == ''){
      resetUI();
      return;
    }

    if (text.startsWith('app.')){
      final appName = text.split('.')[1];
      resetUI();
      switch(appName){
        case 'todo':
          _todo.ready.then((_){
            renderedOutput.value = _todo.rootVisual;
          });
          break;
        case 'calc':
          _calc.ready.then((_){
            renderedOutput.value = _calc.rootVisual;
          });
          break;
        default:
          resetUI();
          return;
      }
    }else{
      if (text.startsWith('<')){
        templateText.value = text;

        Template
          .deserialize(text)
          .then((c){
            renderedOutput.value = c;
          });
      }else{
        Template
          .deserialize('web/views/templates/${text}.xml')
          .then((t){
            renderedOutput.value = t;
            templateText.value = t.stateBag['__buckshot_template__'];
          });
      }
    }
  }

  /**
   * Resets the UI properties to default states. */
  void resetUI(){
    //TODO: reset dropdown lists
    templateText.value = '';
    renderedOutput.value = null;
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
        log('$results');
        final md = new ModalDialog
          .with(results[0], results[1], ModalDialog.OkCancel);

        return md.show();
        })
      .chain((DialogButtonType dbt){
        final md = new ModalDialog
          .with('Dialog Results',
            'You clicked the "$dbt" button on the previous dialog.',
              ModalDialog.Ok)
          ..maskBrush.value = new SolidColorBrush.fromPredefined(Colors.Green);

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
          ..offsetX.value = 100
          ..offsetY.value = -150
          ..cornerRadius.value = new Thickness(7)
          ..borderThickness.value = new Thickness(3)
          ..borderColor.value = new Color.predefined(Colors.SteelBlue)
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
    log('fired click event', element:sender);
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
        renderedOutput.value = errorView.rootVisual;
        errorMessage.value = error;
      });
    }

    String error = '';

    try{
      setTemplate(templateText.value.trim());
    }on AnimationException catch(ae){
      error = "An error occurred while attempting to process an"
        " animation resource: ${ae}";
    }on TemplateException catch(pe){
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
    }catch(e){
      error = "A general exception occured while attempting to"
          " render the content.  Please bear with us as we (and Dart) are"
          " still in the early stages of development.  Thanks! ${e}";
    }
    finally{
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

    final value = args.node.tag.value;

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
    demoTreeNodeSelected.value = args.node.header.value;
  }

  void dockpanel_click(sender, args){
      String text = "Docked ";
      final dp = namedElements['dockpanelDemo'];
      final b = namedElements['btnDock'];
      assert(dp != null);
      assert(b != null);

      switch(sender.content.value){
        case 'Left':
          DockPanel.setDock(b, DockLocation.left);
          dockText.value = '$text left.';
          break;
        case 'Top':
          DockPanel.setDock(b, DockLocation.top);
          dockText.value = '$text top.';
          break;
        case 'Right':
          DockPanel.setDock(b, DockLocation.right);
          dockText.value = '$text right.';
          break;
        case 'Bottom':
          DockPanel.setDock(b, DockLocation.bottom);
          dockText.value = '$text bottom.';
          break;
        default:
          log('Unable to parse dock panel direction', element: sender);
          break;
      }

      (dp as DockPanel).invalidate();
  }

}