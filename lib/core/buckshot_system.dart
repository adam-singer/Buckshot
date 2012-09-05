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
  
  final Map<String, Dynamic> _mirrorCache;

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
    namedElements = new HashMap<String, FrameworkObject>(),
    _mirrorCache = new Map<String, Dynamic>()
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
    namedElements = new HashMap<String, FrameworkObject>(),
    _mirrorCache = new Map<String, Dynamic>()
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
    
    if (!reflectionEnabled){
      _registerCoreElements();
    }
  }

  void registerElement(BuckshotObject o){
    assert(!reflectionEnabled);
    
    _objectRegistry['${o.toString().toLowerCase()}'] = o.makeMe;
  }
  
  void registerAttachedProperty(String property, setterFunction){
    _objectRegistry[property] = setterFunction;
  }
  
  void _registerCoreElements(){    
    registerElement(new Ellipse.register());
    registerElement(new Rectangle.register());
    registerElement(new StackPanel.register());
    registerElement(new Stack.register());
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
  
  // Wrappers to prevent propagation of static warnings elsewhere.
  reflectMe(object) => reflect(object);
  mirrorSystem() => currentMirrorSystem();
  
  /**
   * Returns the InterfaceMirror of a given [name] by searching through all
   * available in-scope libraries.
   *
   * Case insensitive.
   *
   * Returns null if not found.
   */
  getObjectByName(String name){
    final lowerName = name.toLowerCase();
    
    if (!reflectionEnabled){
      if (!_objectRegistry.containsKey(lowerName)) return null;
      return _objectRegistry[lowerName]();
    }else{
      if (_mirrorCache.containsKey(lowerName)){
        //print('[Miriam] Returning cached mirror of "$lowerName"');
        return _mirrorCache[lowerName];
      }

      var result;

      currentMirrorSystem()
      .libraries
      .forEach((String lName, libMirror){
        libMirror
          .classes
          .forEach((String cName, classMirror){
            if (classMirror.simpleName.toLowerCase() == lowerName){
              result = classMirror;
            }
          });
      });

      if (result != null){
        //cache result;
        //print('[Miriam] caching mirror "$lowerName"');
        _mirrorCache[lowerName] = result;
      }
  
      return result;
    }
  }
}