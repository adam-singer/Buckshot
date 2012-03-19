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
* LucaSystem provides a central initialization and registration facility for the framework.
*
* LucaSystem must be initialized prior to using the framework:
*
*     new LucaSystem();
*/ 
class LucaSystem extends FrameworkObject {
  static final String _defaultRootID = "#LucaUIHost";
  static IView _currentRootView;
  static bool initialized = false;
  static Element _domRootElement;
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
  static LucaSystem _ref;
  
  factory LucaSystem()
  { 
    if (_ref != null) return _ref;
    return new LucaSystem._init();
  }
  
  factory LucaSystem.fromRoot(String domRootElementOrID)
  {
    if (_ref != null) return _ref;
    return new LucaSystem._init(domRootElementOrID);
  }
  
  LucaSystem._init([String rootID = LucaSystem._defaultRootID])
  {
    _ref = this;
    _initLucaSystem(rootID);
  } 
  
  void _initLucaSystem(String rootID)
  {
    LucaSystem._domRootElement = window.document.query(rootID);
    
    namedElements = new HashMap<String, FrameworkObject>();
    
    visualRoot = new _RootElement();
    
    _resourceRegistry = new HashMap<String, FrameworkResource>();
    
    _objectRegistry = new HashMap<String, Dynamic>();
        
    presentationProviders = new Set<IPresentationFormatProvider>();
    
    defaultPresentationProvider = new LucaxmlPresentationProvider();
    
    if (LucaSystem._domRootElement == null)
      throw new FrameworkException("Unable to locate required root element (must be <div id='$rootID' />)");
    
    if (LucaSystem._domRootElement.tagName != "DIV")
      throw new FrameworkException("Root element for LUCA UI must be a <div>. Element given was a <${LucaSystem._domRootElement.tagName.toLowerCase()}>");
    
    LucaSystem._attachedProperties = new HashMap<AttachedFrameworkProperty, HashMap<FrameworkObject, Dynamic>>();
    
    LucaSystem.windowWidthProperty = new FrameworkProperty(
      LucaSystem._ref,
      "windowWidth",
      (value){}, window.innerWidth); //subtracting 1 removes scrollbars in chrome.  haven't tested cross-browser yet.
    
    LucaSystem.windowHeightProperty = new FrameworkProperty(
      LucaSystem._ref,
      "windowHeight",
      (value){}, window.innerHeight);
    
    window.on.resize.add((e){
      if (_ref == null) return;
                 
      //any elements bound to these properties will also get updated...
      if (window.innerWidth != windowWidth){
        setValue(LucaSystem.windowWidthProperty, window.innerWidth);
      }
      if (window.innerHeight != windowHeight){
        setValue(LucaSystem.windowHeightProperty, window.innerHeight);
      }
    });

    // register core elements that do not derive from Control
    _registerCoreElements();
    
    // load in control template resources for core controls
    defaultPresentationProvider.deserialize(Globals._controlTemplates);
    
    // now register controls that may depend on control templates for visuals
    _registerCoreControls();
    
    LucaSystem.initialized = true;
  }

  /// Performs a search of the element tree starting from the given [FrameworkElement]
  /// and returns the first named Element matching the given name.
  ///
  /// ** Deprecated **
  ///
  /// ## Instead use:
  ///     LucaSystem.namedElements[elementName];
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
    LucaSystem.registerElement(new StackPanel());
    LucaSystem.registerElement(new Grid());
    LucaSystem.registerElement(new Border());
    LucaSystem.registerElement(new TextArea());
    LucaSystem.registerElement(new LayoutCanvas());
    LucaSystem.registerElement(new TextBlock());
    LucaSystem.registerElement(new CheckBox());
    LucaSystem.registerElement(new RadioButton());
    LucaSystem.registerElement(new Hyperlink());
    LucaSystem.registerElement(new Image());
    LucaSystem.registerElement(new RawHtml());
    LucaSystem.registerElement(new ColumnDefinition());
    LucaSystem.registerElement(new RowDefinition());
    LucaSystem.registerElement(new DropDownListItem());
    LucaSystem.registerElement(new CollectionPresenter());
    
    //resources
    LucaSystem.registerElement(new ResourceCollection());
    LucaSystem.registerElement(new Color());
    LucaSystem.registerElement(new LinearGradientBrush());
    LucaSystem.registerElement(new GradientStop());
    LucaSystem.registerElement(new SolidColorBrush());
    LucaSystem.registerElement(new RadialGradientBrush());
    LucaSystem.registerElement(new StyleSetter());
    LucaSystem.registerElement(new _StyleTemplateImplementation());
    LucaSystem.registerElement(new VarResource());
    LucaSystem.registerElement(new ControlTemplate());
    
    //attached properties
    LucaSystem._objectRegistry["grid.column"] = Grid.setColumn;
    LucaSystem._objectRegistry["grid.row"] = Grid.setRow;
    LucaSystem._objectRegistry["grid.columnspan"] = Grid.setColumnSpan;
    LucaSystem._objectRegistry["grid.rowspan"] = Grid.setRowSpan;
    
    LucaSystem._objectRegistry["layoutcanvas.top"] = LayoutCanvas.setTop;
    LucaSystem._objectRegistry["layoutcanvas.left"] = LayoutCanvas.setLeft;
    
  } 
  
  //NOTE: This accomodation is necessary until reflection is in place
  //doing this makes the framework more brittle because controls that
  //use control template may try to implement a control that isn't yet
  //registered here...
  static void _registerCoreControls(){
    LucaSystem.registerElement(new TextBox());
    LucaSystem.registerElement(new Slider());
    LucaSystem.registerElement(new Button());
    LucaSystem.registerElement(new DropDownList());
    LucaSystem.registerElement(new ListBox());
  }
  
  /// Returns a resource that is registered with the given [resourceKey].
  static retrieveResource(String resourceKey){
    String lowered = resourceKey.trim().toLowerCase();

    if (!LucaSystem._resourceRegistry.containsKey(lowered)) return null;

    var res = LucaSystem._resourceRegistry[lowered];
    
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
  static void registerResource(FrameworkResource object){
    LucaSystem._resourceRegistry[object.key.trim().toLowerCase()] = object;
  }
  
  /// Registers a LucaObject to the framework.  Useful for registering
  /// extension elements.
  static void registerElement(LucaObject object){
    LucaSystem._objectRegistry[object._type.trim().toLowerCase()] = object;
  }  
  
  /// Gets the innerWidth of the window
  static int get windowWidth() => (_ref != null) ? getValue(LucaSystem.windowWidthProperty) : -1;
  
  /// Gets the innerHeight of the window
  static int get windowHeight() => (_ref != null) ? getValue(LucaSystem.windowHeightProperty) : -1;
  
  /// Sets the given view as the root visual element.
  static set rootView(IView view){
    LucaSystem._currentRootView = view;
    visualRoot.content = view.rootVisual;
    
    //remove child nodes from the root dom element
    LucaSystem._domRootElement.nodes.clear();  
       
    LucaSystem._domRootElement.nodes.add(visualRoot._component);
    
  }
  
  /// Gets the currently assigned view.
  static IView get rootView() => LucaSystem._currentRootView;
  

  /// Wraps a FrameworkElement into an [IView] and sets it as the root view.
  static void renderRaw(FrameworkElement element){
    rootView = new IView(element);
  }
    
    
  String get _type() => "LucaSystem";
  }
