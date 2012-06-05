//   Copyright (c) 2012, John Evans & LUCA Studios LLC
//
//   http://www.lucastudios.com/contact
//   John: https://plus.google.com/u/0/115427174005651655317/about
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.


/**
* Represents the globally available instance of Buckshot.
*
* It is normally not be necessary to create your own instance
* of the [Buckshot] class.
*/
Buckshot get buckshot() => new Buckshot._cached();


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
  static final String _version = '0.41 Alpha';
  IView _currentView;
  Element _domRootElement;
  StyleElement _buckshotCSS;

  /// Represents the default [IPresentationProvider], which is the template
  /// serializer/de-serializer used by the framework.
  IPresentationFormatProvider defaultPresentationProvider;

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
    if (_ref != null) return _ref;
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
   
    if (!browserOK){
      print('Buckshot Warning: Browser may not be compatible with Buckshot framework.');
    }
    
    _initCSS();

    defaultPresentationProvider = new BuckshotTemplateProvider();

    _initializeBuckshotProperties();

    //set the domRoot
    _domRootElement.elements.clear();
    _domRootElement.elements.add(domRoot._component);

    // register core elements that do not derive from Control
    _registerCoreElements();

    // now register controls that may depend on control templates for visuals
    _registerCoreControls();
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

  
  /** Returns true if the framework is known to be compatible with the browser type/version it is running in */
  static bool get browserOK() {
    final ua = window.navigator.userAgent;
    
    //Dartium should always work
    if (ua.contains('(Dart)')) return true;
    
    //Chrome(ium) v21+
    if (ua.contains('Chrome/')){
      final i = ua.indexOf('Chrome/') + 7;
      final v = Math.parseInt(ua.substring(i, i + 2));
      if (v >= 21) return true;
    }   
    
    return false;
  }
  
  // TODO move this to BuckshotObject as instance method?

  /// Performs a search of the element tree starting from the given
  /// [FrameworkElement] and returns the first named Element matching
  /// the given name.
  ///
  /// ** Deprecated **
  ///
  /// ## Instead use:
  ///     Buckshot.namedElements[elementName];
  static FrameworkElement findByName(String name, FrameworkElement startingWith){

    if (startingWith.name != null && startingWith.name == name) return startingWith;

    if (!startingWith.isContainer) return null;

    var cc = startingWith._stateBag[FrameworkObject.CONTAINER_CONTEXT];
    if (cc is List){
      for (final el in cc){
        var result = findByName(name, el);
        if (result != null) return result;
      }
    }else if (cc is FrameworkProperty){
      FrameworkElement obj = getValue(cc);
      if (obj == null || !(obj is FrameworkElement)) return null;
      return findByName(name, obj);
    }else{
      return null;
    }
  }

  void _registerCoreElements(){
    //registering elements we need ahead of time (poor man's reflection...)

    //shapes
    registerElement(new Ellipse());
    registerElement(new Rectangle());
    registerElement(new Line());
    registerElement(new PolyLine());
    registerElement(new Polygon());

    //elements
    registerElement(new StackPanel());
    registerElement(new Grid());
    registerElement(new Border());
    registerElement(new TextArea());
    registerElement(new LayoutCanvas());
    registerElement(new TextBlock());
    registerElement(new CheckBox());
    registerElement(new RadioButton());
    registerElement(new Hyperlink());
    registerElement(new Image());
    registerElement(new RawHtml());
    registerElement(new ColumnDefinition());
    registerElement(new RowDefinition());
    registerElement(new DropDownListItem());
    registerElement(new CollectionPresenter());

    //resources
    registerElement(new ResourceCollection());
    registerElement(new Color());
    registerElement(new LinearGradientBrush());
    registerElement(new GradientStop());
    registerElement(new SolidColorBrush());
    registerElement(new RadialGradientBrush());
    registerElement(new StyleSetter());
    registerElement(new _StyleTemplateImplementation());
    registerElement(new VarResource());
    registerElement(new ControlTemplate());
    registerElement(new AnimationResource());
    registerElement(new AnimationKeyFrame());
    registerElement(new AnimationState());

    //attached properties
    _objectRegistry["grid.column"] = Grid.setColumn;
    _objectRegistry["grid.row"] = Grid.setRow;
    _objectRegistry["grid.columnspan"] = Grid.setColumnSpan;
    _objectRegistry["grid.rowspan"] = Grid.setRowSpan;

    _objectRegistry["layoutcanvas.top"] = LayoutCanvas.setTop;
    _objectRegistry["layoutcanvas.left"] = LayoutCanvas.setLeft;

  }

  //NOTE: This accomodation is necessary until reflection is in place
  //doing this makes the framework more brittle because controls that
  //use control template may try to implement a control that isn't yet
  //registered here...
  void _registerCoreControls(){
    registerElement(new TextBox());
    registerElement(new Slider());
    registerElement(new Button());
    registerElement(new DropDownList());
    registerElement(new ListBox());
  }

  /// Returns a resource that is registered with the given [resourceKey].
  retrieveResource(String resourceKey){
    String lowered = resourceKey.trim().toLowerCase();

    if (!_resourceRegistry.containsKey(lowered)) return null;

    var res = _resourceRegistry[lowered];

    if (res._stateBag.containsKey(FrameworkResource.RESOURCE_PROPERTY)){
//      db('$lowered ${res._type} ${getValue(res._stateBag[FrameworkResource.RESOURCE_PROPERTY])}');
      // resource property defined so return it's value
      return getValue(res._stateBag[FrameworkResource.RESOURCE_PROPERTY]);
    }else{
      // no resource property defined so just return the resource
      return res;
    }
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
  set rootView(IView view){
    _currentView = view;

    domRoot._isLoaded = true;

    domRoot.content = view.rootVisual;

  }

  /// Gets the currently assigned [IView].
  IView get rootView() => _currentView;


  /// Wraps a FrameworkElement into an [IView] and sets it as the root view.
  void renderRaw(FrameworkElement element){
    rootView = new IView(element);
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
