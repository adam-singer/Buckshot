// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Represents the globally available instance of Buckshot.
*
* It is normally not be necessary to create your own instance
* of the [Buckshot] class.
*/
Buckshot get buckshot() => new Buckshot._cached();


/**
 * Returns a concrete object from a given [elementName] (case in-sensitive).
 * Returns null if the [elementName] cannot be found in any
 * in-scope libraries.
*
 * Optional [fromLibrary] will constrain to the search to a specific library.
*
 */
Future<FrameworkObject> createByName(String elementName, [String fromLibrary]){
  final c = new Completer();
  print('called on $elementName');

  final im = new Miriam().getObjectByName(elementName);

  if (im == null){
    c.complete(null);
    print('...complete null');
  }else{
    print('...getting new instance of $im');
    im
    .newInstance('',[])
    .then((o){
      print('...complete $o');
      c.complete(o.reflectee);
    });
  }

  print('returning future on $elementName');
  return c.future;
}

/**
* Buckshot provides a central initialization and registration facility
* for the framework.
*
* Use the globally available 'buckshot' object to access the
* framework system.  It is normally not necessary to create your own instance
* of the [Buckshot] class.
*/
class Buckshot extends FrameworkObject {
  static final String _defaultRootID = "#BuckshotHost";
  static final String _version = '0.50 Alpha';

  View _currentView;
  Element _domRootElement;
  StyleElement _buckshotCSS;
  BrowserInfo _browserInfo;

  final HashMap<AttachedFrameworkProperty, HashMap<FrameworkObject,
  Dynamic>> _attachedProperties;

  final HashMap<String, FrameworkResource> _resourceRegistry;

  //poor man's reflection...
  final HashMap<String, Dynamic> _objectRegistry;

  /// The root container that all elements are children of.
  final Border domRoot;

  /// Central registry of named [FrameworkObject] elements.
  final HashMap<String, FrameworkObject> namedElements;

  /// Bindable window width/height properties.  Readonly, so can only
  /// bind from, not to.
  FrameworkProperty windowWidthProperty;
  /// Bindable window width/height properties.  Readonly, so can only
  /// bind from, not to.
  FrameworkProperty windowHeightProperty;

  /// Bindable property representing the current version of Buckshot
  FrameworkProperty versionProperty;

  static Buckshot _ref;


  BrowserInfo get browserInfo() => _browserInfo;


  /// Pass the ID of the element in the DOM where buckshot will render content.
  Buckshot(String buckshotRootID)
  :
    namedElements = new HashMap<String, FrameworkObject>(),
    _resourceRegistry = new HashMap<String, FrameworkResource>(),
    _objectRegistry = new HashMap<String, Dynamic>(),
    _attachedProperties = new HashMap<AttachedFrameworkProperty,
            HashMap<FrameworkObject, Dynamic>>(),
    domRoot = new Border()
  {
    _initBuckshotSystem(buckshotRootID);
  }

  factory Buckshot._cached()
  {
//    if (_ref == null){
//      print('first time in Buckshot ctor');
//    }
    if (_ref != null) return _ref;

    //initialize Polly's statics
    Polly.init();

    new Buckshot._init();
    return _ref;
  }

  Buckshot._init([String rootID = Buckshot._defaultRootID])
  :
    namedElements = new HashMap<String, FrameworkObject>(),
    _resourceRegistry = new HashMap<String, FrameworkResource>(),
    _objectRegistry = new HashMap<String, Dynamic>(),
    _attachedProperties = new HashMap<AttachedFrameworkProperty,
            HashMap<FrameworkObject, Dynamic>>(),
    domRoot = new Border()
  {
    _ref = this;
    _initBuckshotSystem(rootID);
  }

  void _initBuckshotSystem(String rootID)
  {

    _domRootElement = document.query(rootID);

    if (_domRootElement == null)
      throw new BuckshotException("Unable to locate required root"
        " element (must be <div id='$rootID' />)");

    if (_domRootElement.tagName != "DIV")
      throw new BuckshotException("Root element for Buckshot"
        " must be a <div>. Element given was"
        " a <${_domRootElement.tagName.toLowerCase()}>");

    if (!Polly.browserOK){
      print('Buckshot Warning: Browser may not be compatible with Buckshot'
          ' framework.');
    }

    _initCSS();

    _initializeBuckshotProperties();

    //set the domRoot
    _domRootElement.elements.clear();
    _domRootElement.elements.add(domRoot.rawElement);

    // register core elements that do not derive from Control
    _registerCoreElements();

    // now register controls that may depend on control templates for visuals
    //_registerCoreControls();
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



  void _registerCoreElements(){
    // registers stuff not yet handled by the reflection queries
    registerAttachedProperty('layoutcanvas.top', LayoutCanvas.setTop);
    registerAttachedProperty('layoutcanvas.left', LayoutCanvas.setLeft);

    registerAttachedProperty('grid.column', Grid.setColumn);
    registerAttachedProperty('grid.row', Grid.setRow);
    registerAttachedProperty('grid.columnspan', Grid.setColumnSpan);
    registerAttachedProperty('grid.rowspan', Grid.setRowSpan);

    return;


//    final miriam = new Miriam();
//
//    final flist = [];
//
//    //add the resources first
//    flist.addAll(miriam.getInstancesOf(['TemplateObject', 'FrameworkResource', 'FrameworkElement']));
//
//
//
//    Futures
//      .wait(flist)
//      .then((List results){
//
//        results
//          .sort((a, b){
//            return a._templatePriority() - b._templatePriority();
//          });
//
//        print('${results}');
//
//        results.forEach((o){
//          if (o.hasReflectee){
//            print('....registering ${o.reflectee.type}');
//            registerElement(o.reflectee);
//            //TODO: find and register attached properties
//          }
//        });
//
//          registerSync();
//          _coreElementsRegistered = true;
//          c.complete(true);
//      });
//
//
//
//
//    return c.future;

  }

  /// Returns a resource that is registered with the given [resourceKey].
  retrieveResource(String resourceKey){
    String lowered = resourceKey.trim().toLowerCase();

    if (!_resourceRegistry.containsKey(lowered)) return null;

    var res = _resourceRegistry[lowered];

    if (res._stateBag.containsKey(FrameworkResource.RESOURCE_PROPERTY)){
      // resource property defined so return it's value
      return getValue(res._stateBag[FrameworkResource.RESOURCE_PROPERTY]);
    }else{
      // no resource property defined so just return the resource
      return res;
    }
  }

  void registerAttachedProperty(String propertyName, Function setterFunc){
    _objectRegistry[propertyName] = setterFunc;
  }

  /// Registers a resource to the framework.
  void registerResource(FrameworkResource resource){
    _resourceRegistry[resource.key.trim().toLowerCase()] = resource;
  }

  /// Registers a BuckshotObject to the framework.  Useful for registering
  /// extension elements.
  void registerElement(BuckshotObject o){
    _objectRegistry[o.type.trim().toLowerCase()] = o;
  }

  /// Gets the innerWidth of the window
  int get windowWidth() => getValue(windowWidthProperty);

  /// Gets the innerHeight of the window
  int get windowHeight() => getValue(windowHeightProperty);

  /// Gets the Buckshot version.
  String get version() => getValue(versionProperty);

  /// Sets the given [IView] as the root visual element.
  set rootView(View view){
    _currentView = view;

    domRoot._isLoaded = true;

    domRoot.content = view.rootVisual;

  }

  /// Gets the currently assigned [IView].
  View get rootView() => _currentView;

  /// Wraps a FrameworkElement into an [IView] and sets it as the root view.
  void renderRaw(FrameworkElement element){
    rootView = new View.from(element);
  }

  /// Changes the active context for the framework and returns the
  /// previous context.
  ///
  /// **Caution!** Only use this if you know exactly what you are doing.
  /// Switching context may have undesirable consequences.
  Buckshot switchContextTo(Buckshot context){
    var temp = Buckshot._ref;
    Buckshot._ref = context;
    return temp;
  }

  void dumpRegisteredObjects(){
    this._objectRegistry.forEach((k, v) => print('${v is FrameworkElement || v is FrameworkResource ? v.type : "()"}'));
  }

  String get type() => "BuckshotSystem";
  }