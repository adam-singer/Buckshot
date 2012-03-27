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
* BuckshotSystem provides a central initialization and registration facility for the framework.
*
* BuckshotSystem must be initialized prior to using the framework:
*
*     new BuckshotSystem();
*/ 
class BuckshotSystem extends FrameworkObject {
  static final String _defaultRootID = "#BuckshotHost";
  static IView _currentRootView;
  static bool initialized = false;
  static Element _domRootElement;
  static StyleElement _buckshotCSS;
  static HashMap<AttachedFrameworkProperty, HashMap<FrameworkObject, Dynamic>> _attachedProperties;
  
  //TODO: Eventually support multiple presentation providers
  static Set<IPresentationFormatProvider> presentationProviders;
  
  static IPresentationFormatProvider defaultPresentationProvider;
  
  static HashMap<String, FrameworkResource> _resourceRegistry;
  
  //poor man's reflection...
  static HashMap<String, Dynamic> _objectRegistry;
  
  /// The root container that all elements are children of.
  static _RootElement visualRoot;
  
  /// **deprecated**
  static bool unitTestEnabled = false; //flag used to accomodate unit testing scenarios
  
  /// Central registry of named [FrameworkObject] elements.
  static HashMap<String, FrameworkObject> namedElements;
  
  /// Bindable window width/height properties.  Readonly so can only bind from, not to.
  static FrameworkProperty windowWidthProperty;
  /// Bindable window width/height properties.  Readonly so can only bind from, not to.
  static FrameworkProperty windowHeightProperty;
  
  //"Singleton?"
  static BuckshotSystem _ref;
  
  factory BuckshotSystem()
  { 
    if (_ref != null) return _ref;
    return new BuckshotSystem._init();
  }
  
  factory BuckshotSystem.fromRoot(String domRootElementOrID)
  {
    if (_ref != null) return _ref;
    return new BuckshotSystem._init(domRootElementOrID);
  }
  
  BuckshotSystem._init([String rootID = BuckshotSystem._defaultRootID])
  {
    _ref = this;
    _initBuckshotSystem(rootID);
  } 
  
  void _initBuckshotSystem(String rootID)
  {
    BuckshotSystem._domRootElement = window.document.query(rootID);
    
    if (BuckshotSystem._domRootElement == null)
      throw new FrameworkException("Unable to locate required root element (must be <div id='$rootID' />)");
    
    if (BuckshotSystem._domRootElement.tagName != "DIV")
      throw new FrameworkException("Root element for LUCA UI must be a <div>. Element given was a <${BuckshotSystem._domRootElement.tagName.toLowerCase()}>");
    
    document.head.elements.add(new Element.html('<style id="__BuckshotCSS__"></style>'));
    _buckshotCSS = document.head.query('#__BuckshotCSS__');
    
    if (_buckshotCSS == null)
      throw const FrameworkException('Unable to initialize Buckshot StyleSheet.');
    
    namedElements = new HashMap<String, FrameworkObject>();
    
    visualRoot = new _RootElement();
    
    _resourceRegistry = new HashMap<String, FrameworkResource>();
    
    _objectRegistry = new HashMap<String, Dynamic>();
        
    presentationProviders = new Set<IPresentationFormatProvider>();
    
    defaultPresentationProvider = new BuckshotTemplateProvider();
        
    BuckshotSystem._attachedProperties = new HashMap<AttachedFrameworkProperty, HashMap<FrameworkObject, Dynamic>>();
    
    BuckshotSystem.windowWidthProperty = new FrameworkProperty(
      BuckshotSystem._ref,
      "windowWidth",
      (value){}, window.innerWidth); //subtracting 1 removes scrollbars in chrome.  haven't tested cross-browser yet.
    
    BuckshotSystem.windowHeightProperty = new FrameworkProperty(
      BuckshotSystem._ref,
      "windowHeight",
      (value){}, window.innerHeight);
    
    window.on.resize.add((e){
      if (_ref == null) return;
                 
      //any elements bound to these properties will also get updated...
      if (window.innerWidth != windowWidth){
        setValue(BuckshotSystem.windowWidthProperty, window.innerWidth);
      }
      if (window.innerHeight != windowHeight){
        setValue(BuckshotSystem.windowHeightProperty, window.innerHeight);
      }
    });

    // register core elements that do not derive from Control
    _registerCoreElements();
    
    // load in control template resources for core controls
    defaultPresentationProvider.deserialize(Globals._controlTemplates);
    
    // now register controls that may depend on control templates for visuals
    _registerCoreControls();
    
    BuckshotSystem.initialized = true;
  }

  /// Performs a search of the element tree starting from the given [FrameworkElement]
  /// and returns the first named Element matching the given name.
  ///
  /// ** Deprecated **
  ///
  /// ## Instead use:
  ///     BuckshotSystem.namedElements[elementName];
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
    
  static void _registerCoreElements(){
    //registering elements we need ahead of time (poor man's reflection...)
    
    //elements
    BuckshotSystem.registerElement(new StackPanel());
    BuckshotSystem.registerElement(new Grid());
    BuckshotSystem.registerElement(new Border());
    BuckshotSystem.registerElement(new TextArea());
    BuckshotSystem.registerElement(new LayoutCanvas());
    BuckshotSystem.registerElement(new TextBlock());
    BuckshotSystem.registerElement(new CheckBox());
    BuckshotSystem.registerElement(new RadioButton());
    BuckshotSystem.registerElement(new Hyperlink());
    BuckshotSystem.registerElement(new Image());
    BuckshotSystem.registerElement(new RawHtml());
    BuckshotSystem.registerElement(new ColumnDefinition());
    BuckshotSystem.registerElement(new RowDefinition());
    BuckshotSystem.registerElement(new DropDownListItem());
    BuckshotSystem.registerElement(new CollectionPresenter());
    
    //resources
    BuckshotSystem.registerElement(new ResourceCollection());
    BuckshotSystem.registerElement(new Color());
    BuckshotSystem.registerElement(new LinearGradientBrush());
    BuckshotSystem.registerElement(new GradientStop());
    BuckshotSystem.registerElement(new SolidColorBrush());
    BuckshotSystem.registerElement(new RadialGradientBrush());
    BuckshotSystem.registerElement(new StyleSetter());
    BuckshotSystem.registerElement(new _StyleTemplateImplementation());
    BuckshotSystem.registerElement(new VarResource());
    BuckshotSystem.registerElement(new ControlTemplate());
    BuckshotSystem.registerElement(new AnimationResource());
    BuckshotSystem.registerElement(new AnimationKeyFrame());
    BuckshotSystem.registerElement(new AnimationState());
    
    //attached properties
    BuckshotSystem._objectRegistry["grid.column"] = Grid.setColumn;
    BuckshotSystem._objectRegistry["grid.row"] = Grid.setRow;
    BuckshotSystem._objectRegistry["grid.columnspan"] = Grid.setColumnSpan;
    BuckshotSystem._objectRegistry["grid.rowspan"] = Grid.setRowSpan;
    
    BuckshotSystem._objectRegistry["layoutcanvas.top"] = LayoutCanvas.setTop;
    BuckshotSystem._objectRegistry["layoutcanvas.left"] = LayoutCanvas.setLeft;
    
  } 
  
  //NOTE: This accomodation is necessary until reflection is in place
  //doing this makes the framework more brittle because controls that
  //use control template may try to implement a control that isn't yet
  //registered here...
  static void _registerCoreControls(){
    BuckshotSystem.registerElement(new TextBox());
    BuckshotSystem.registerElement(new Slider());
    BuckshotSystem.registerElement(new Button());
    BuckshotSystem.registerElement(new DropDownList());
    BuckshotSystem.registerElement(new ListBox());
  }
  
  /// Returns a resource that is registered with the given [resourceKey].
  static retrieveResource(String resourceKey){
    String lowered = resourceKey.trim().toLowerCase();

    if (!BuckshotSystem._resourceRegistry.containsKey(lowered)) return null;

    var res = BuckshotSystem._resourceRegistry[lowered];
    
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
  static void registerResource(FrameworkResource resource){
    BuckshotSystem._resourceRegistry[resource.key.trim().toLowerCase()] = resource;
    
    //pre-cache the compiled animation
    if (resource is AnimationResource){
      _CssCompiler.compileAnimation(resource);
    }
  }
  
  /// Registers a BuckshotObject to the framework.  Useful for registering
  /// extension elements.
  static void registerElement(BuckshotObject o){
    BuckshotSystem._objectRegistry[o.type.trim().toLowerCase()] = o;
  }  
  
  /// Gets the innerWidth of the window
  static int get windowWidth() => (_ref != null) ? getValue(BuckshotSystem.windowWidthProperty) : -1;
  
  /// Gets the innerHeight of the window
  static int get windowHeight() => (_ref != null) ? getValue(BuckshotSystem.windowHeightProperty) : -1;
  
  /// Sets the given view as the root visual element.
  static set rootView(IView view){
    BuckshotSystem._currentRootView = view;
    
    //remove child nodes from the root dom element
    BuckshotSystem._domRootElement.elements.clear();  
       
    BuckshotSystem._domRootElement.elements.add(visualRoot._component);

    visualRoot._isLoaded = true;
    //db('(BuckshotSystem)Updating visualRoot content', visualRoot);
    visualRoot.content = view.rootVisual;
    //    visualRoot._isLoaded = true;
//    visualRoot._onAddedToDOM();
  }
  
  /// Gets the currently assigned view.
  static IView get rootView() => BuckshotSystem._currentRootView;
  

  /// Wraps a FrameworkElement into an [IView] and sets it as the root view.
  static void renderRaw(FrameworkElement element){
    rootView = new IView(element);
  }
    
    
  String get type() => "BuckshotSystem";
  }
