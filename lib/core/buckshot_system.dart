// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Represents the globally available instance of Buckshot.
*
* It is normally not be necessary to create your own instance
* of the [Buckshot] class.
*/
Buckshot get buckshot => new Buckshot._cached();

/**
* A general utility service for the Buckshot framework.
*
* Use the globally available 'buckshot' object to access the
* framework system.  It is normally not necessary to create your own instance
* of the [Buckshot] class.
*/
class Buckshot extends FrameworkObject
{
  static final String _defaultRootID = "#BuckshotHost";
  static final String _version = '0.55 Alpha';

  StyleElement _buckshotCSS;

  /// Central registry of named [FrameworkObject] elements.
  final HashMap<String, FrameworkObject> namedElements;

  final HashMap<String, Function> _objectRegistry;
  
  /// Bindable window width/height properties.  Readonly, so can only
  /// bind from, not to.
  FrameworkProperty windowWidthProperty;
  /// Bindable window width/height properties.  Readonly, so can only
  /// bind from, not to.
  FrameworkProperty windowHeightProperty;

  /// Bindable property representing the current version of Buckshot
  FrameworkProperty versionProperty;

  static Buckshot _ref;

  /// Pass the ID of the element in the DOM where buckshot will render content.
  Buckshot(String buckshotRootID)
  :
    _objectRegistry = new HashMap<String, Dynamic>(),
    namedElements = new HashMap<String, FrameworkObject>()
  {
    _initBuckshotSystem(buckshotRootID);
  }

  factory Buckshot._cached()
  {
    if (_ref != null) return _ref;

    //initialize Polly's statics
    Polly.init();

    new Buckshot._init();
    return _ref;
  }

  Buckshot._init([String rootID = Buckshot._defaultRootID])
  :
    _objectRegistry = new HashMap<String, Dynamic>(),
    namedElements = new HashMap<String, FrameworkObject>()
  {
    _ref = this;
    _initBuckshotSystem(rootID);
  }

  void _initBuckshotSystem(String rootID)
  {
    if (!Polly.browserOK){
      print('Buckshot Warning: Browser may not be compatible with Buckshot'
          ' framework.');
    }

    _initCSS();

    _initializeBuckshotProperties();
    
    _registerCoreElements();
  }

  void _registerCoreElements(){
    registerElement(BuckshotObject o){
      _objectRegistry['${o.toString().toLowerCase()}'] = o.makeMe;
    }
    
    registerElement(new Ellipse.register());
    registerElement(new Rectangle.register());
    registerElement(new StackPanel.register());
    registerElement(new LayoutCanvas.register());
    registerElement(new Grid.register());
    registerElement(new Border.register());
    registerElement(new ContentPresenter.register());
    registerElement(new TextArea.register());
    registerElement(new TextBlock.register());
    registerElement(new CheckBox.register());
    registerElement(new RadioButton.register());
    registerElement(new Hyperlink.register());
    registerElement(new Image.register());
    registerElement(new RawHtml.register());
    registerElement(new ColumnDefinition.register());
    registerElement(new RowDefinition.register());
    registerElement(new DropDownItem.register());
    registerElement(new CollectionPresenter.register());

    //resources
    registerElement(new ResourceCollection.register());
    registerElement(new Color.register());
    registerElement(new LinearGradientBrush.register());
    registerElement(new GradientStop.register());
    registerElement(new SolidColorBrush.register());
    registerElement(new RadialGradientBrush.register());
    registerElement(new Setter.register());
    registerElement(new StyleTemplate.register());
    registerElement(new Var.register());
    registerElement(new ControlTemplate.register());
    registerElement(new AnimationResource.register());
    registerElement(new AnimationKeyFrame.register());
    registerElement(new AnimationState.register());

    //actions
    registerElement(new SetProperty.register());
    
    registerElement(new TextBox());
    registerElement(new Slider());
    registerElement(new Button());
    registerElement(new DropDownList());
    
//    registerAttachedProperty('layoutcanvas.top', LayoutCanvas.setTop);
//    registerAttachedProperty('layoutcanvas.left', LayoutCanvas.setLeft);
//    registerAttachedProperty('grid.column', Grid.setColumn);
//    registerAttachedProperty('grid.row', Grid.setRow);
//    registerAttachedProperty('grid.columnspan', Grid.setColumnSpan);
//    registerAttachedProperty('grid.rowspan', Grid.setRowSpan);
  
  }
  
  void _initCSS(){
    document.head.elements.add(
      new Element.html('<style id="__BuckshotCSS__"></style>'));

    _buckshotCSS = document.head.query('#__BuckshotCSS__');

    if (_buckshotCSS == null)
      throw const BuckshotException('Unable to initialize'
        ' Buckshot StyleSheet.');
  }

  void _initializeBuckshotProperties(){
    versionProperty = new FrameworkProperty(Buckshot._ref,
      "version", (_){}, _version);

    //TODO unit test
    versionProperty.readOnly = true;

    windowWidthProperty = new FrameworkProperty(
      Buckshot._ref, "windowWidth", (_){}, window.innerWidth);

    windowHeightProperty = new FrameworkProperty(
      Buckshot._ref, "windowHeight", (_){}, window.innerHeight);

    window.on.resize.add((e){
      if (_ref == null) return;

      //any elements bound to these properties will also get updated...
      if (window.innerWidth != windowWidth){
        setValue(windowWidthProperty, window.innerWidth);
      }

      if (window.innerHeight != windowHeight){
        setValue(windowHeightProperty, window.innerHeight);
      }
    });
  }

  /// Gets the innerWidth of the window
  int get windowWidth => getValue(windowWidthProperty);

  /// Gets the innerHeight of the window
  int get windowHeight => getValue(windowHeightProperty);

  /// Gets the Buckshot version.
  String get version => getValue(versionProperty);
}