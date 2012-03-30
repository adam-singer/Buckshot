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
* Buckshot provides a central initialization and registration facility for the framework.
*
* Buckshot must be initialized prior to using the framework:
*
*     new Buckshot();
*/ 
class Buckshot extends FrameworkObject {
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
  static Buckshot _ref;
  
  factory Buckshot()
  { 
    if (_ref != null) return _ref;
    return new Buckshot._init();
  }
  
  factory Buckshot.fromRoot(String domRootElementOrID)
  {
    if (_ref != null) return _ref;
    return new Buckshot._init(domRootElementOrID);
  }
  
  Buckshot._init([String rootID = Buckshot._defaultRootID])
  {
    _ref = this;
    _initBuckshotSystem(rootID);
  } 
  
  void _initBuckshotSystem(String rootID)
  {
    Buckshot._domRootElement = window.document.query(rootID);
    
    if (Buckshot._domRootElement == null)
      throw new FrameworkException("Unable to locate required root element (must be <div id='$rootID' />)");
    
    if (Buckshot._domRootElement.tagName != "DIV")
      throw new FrameworkException("Root element for LUCA UI must be a <div>. Element given was a <${Buckshot._domRootElement.tagName.toLowerCase()}>");
    
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
        
    Buckshot._attachedProperties = new HashMap<AttachedFrameworkProperty, HashMap<FrameworkObject, Dynamic>>();
    
    Buckshot.windowWidthProperty = new FrameworkProperty(
      Buckshot._ref,
      "windowWidth",
      (value){}, window.innerWidth); //subtracting 1 removes scrollbars in chrome.  haven't tested cross-browser yet.
    
    Buckshot.windowHeightProperty = new FrameworkProperty(
      Buckshot._ref,
      "windowHeight",
      (value){}, window.innerHeight);
    
    window.on.resize.add((e){
      if (_ref == null) return;
                 
      //any elements bound to these properties will also get updated...
      if (window.innerWidth != windowWidth){
        setValue(Buckshot.windowWidthProperty, window.innerWidth);
      }
      if (window.innerHeight != windowHeight){
        setValue(Buckshot.windowHeightProperty, window.innerHeight);
      }
    });

    // register core elements that do not derive from Control
    _registerCoreElements();
    
    // load in control template resources for core controls
    defaultPresentationProvider.deserialize(Globals._controlTemplates);
    
    // now register controls that may depend on control templates for visuals
    _registerCoreControls();
    
    Buckshot.initialized = true;
  }

  /// Performs a search of the element tree starting from the given [FrameworkElement]
  /// and returns the first named Element matching the given name.
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
    
  static void _registerCoreElements(){
    //registering elements we need ahead of time (poor man's reflection...)
    
    //shapes
    Buckshot.registerElement(new Ellipse());
    Buckshot.registerElement(new Rectangle());
    Buckshot.registerElement(new Line());
    Buckshot.registerElement(new PolyLine());
    Buckshot.registerElement(new Polygon());
    
    //elements
    Buckshot.registerElement(new StackPanel());
    Buckshot.registerElement(new Grid());
    Buckshot.registerElement(new Border());
    Buckshot.registerElement(new TextArea());
    Buckshot.registerElement(new LayoutCanvas());
    Buckshot.registerElement(new TextBlock());
    Buckshot.registerElement(new CheckBox());
    Buckshot.registerElement(new RadioButton());
    Buckshot.registerElement(new Hyperlink());
    Buckshot.registerElement(new Image());
    Buckshot.registerElement(new RawHtml());
    Buckshot.registerElement(new ColumnDefinition());
    Buckshot.registerElement(new RowDefinition());
    Buckshot.registerElement(new DropDownListItem());
    Buckshot.registerElement(new CollectionPresenter());
    Buckshot.registerElement(new AnimationAction());
    Buckshot.registerElement(new SetPropertyAction());
    Buckshot.registerElement(new TogglePropertyAction());
    
    //resources
    Buckshot.registerElement(new ResourceCollection());
    Buckshot.registerElement(new Color());
    Buckshot.registerElement(new LinearGradientBrush());
    Buckshot.registerElement(new GradientStop());
    Buckshot.registerElement(new SolidColorBrush());
    Buckshot.registerElement(new RadialGradientBrush());
    Buckshot.registerElement(new StyleSetter());
    Buckshot.registerElement(new _StyleTemplateImplementation());
    Buckshot.registerElement(new VarResource());
    Buckshot.registerElement(new ControlTemplate());
    Buckshot.registerElement(new AnimationResource());
    Buckshot.registerElement(new AnimationKeyFrame());
    Buckshot.registerElement(new AnimationState());
    
    //attached properties
    Buckshot._objectRegistry["grid.column"] = Grid.setColumn;
    Buckshot._objectRegistry["grid.row"] = Grid.setRow;
    Buckshot._objectRegistry["grid.columnspan"] = Grid.setColumnSpan;
    Buckshot._objectRegistry["grid.rowspan"] = Grid.setRowSpan;
    
    Buckshot._objectRegistry["layoutcanvas.top"] = LayoutCanvas.setTop;
    Buckshot._objectRegistry["layoutcanvas.left"] = LayoutCanvas.setLeft;
    
  } 
  
  //NOTE: This accomodation is necessary until reflection is in place
  //doing this makes the framework more brittle because controls that
  //use control template may try to implement a control that isn't yet
  //registered here...
  static void _registerCoreControls(){
    Buckshot.registerElement(new TextBox());
    Buckshot.registerElement(new Slider());
    Buckshot.registerElement(new Button());
    Buckshot.registerElement(new DropDownList());
    Buckshot.registerElement(new ListBox());
  }
  
  /// Returns a resource that is registered with the given [resourceKey].
  static retrieveResource(String resourceKey){
    String lowered = resourceKey.trim().toLowerCase();

    if (!Buckshot._resourceRegistry.containsKey(lowered)) return null;

    var res = Buckshot._resourceRegistry[lowered];
    
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
    Buckshot._resourceRegistry[resource.key.trim().toLowerCase()] = resource;
  }
  
  /// Registers a BuckshotObject to the framework.  Useful for registering
  /// extension elements.
  static void registerElement(BuckshotObject o){
    Buckshot._objectRegistry[o.type.trim().toLowerCase()] = o;
  }  
  
  /// Gets the innerWidth of the window
  static int get windowWidth() => (_ref != null) ? getValue(Buckshot.windowWidthProperty) : -1;
  
  /// Gets the innerHeight of the window
  static int get windowHeight() => (_ref != null) ? getValue(Buckshot.windowHeightProperty) : -1;
  
  /// Sets the given view as the root visual element.
  static set rootView(IView view){
    Buckshot._currentRootView = view;
    
    //remove child nodes from the root dom element
    Buckshot._domRootElement.elements.clear();  
       
    Buckshot._domRootElement.elements.add(visualRoot._component);

    visualRoot._isLoaded = true;
    //db('(BuckshotSystem)Updating visualRoot content', visualRoot);
    visualRoot.content = view.rootVisual;
    //    visualRoot._isLoaded = true;
//    visualRoot._onAddedToDOM();
  }
  
  /// Gets the currently assigned view.
  static IView get rootView() => Buckshot._currentRootView;
  

  /// Wraps a FrameworkElement into an [IView] and sets it as the root view.
  static void renderRaw(FrameworkElement element){
    rootView = new IView(element);
  }
    
    
  String get type() => "BuckshotSystem";
  }
