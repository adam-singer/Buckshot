// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Represents and element that can participate in the framework's
* [Binding] and [FrameworkProperty] model. */
class FrameworkObject extends BuckshotObject 
{
  bool _watchingMeasurement = false;
  int _animationFrameID;
  ElementRect _previousMeasurement;
  FrameworkObject _parent;
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;
  set isLoaded(bool v) => _isLoaded = v;

  /// Represents the data context assigned to the FrameworkElement.
  /// Declarative xml binding can be used to bind to data context.
  FrameworkProperty dataContextProperty;

  /// Represents a map of [Binding]s that will be bound just before
  /// the element renders to the DOM.
  final HashMap<FrameworkProperty, BindingData> lateBindings;

  final Map<String, FrameworkEvent> _eventBindings;

  /// Fires when the FrameworkElement is inserted into the DOM.
  final FrameworkEvent<EventArgs> loaded;
  /// Fires when the FrameworkElement is removed from the DOM.
  final FrameworkEvent<EventArgs> unloaded;
  /// Fires when the measurement of the the FrameworkElement changes.
  FrameworkEvent<MeasurementChangedEventArgs> measurementChanged;

  /**
  * Accesses the underlying raw HTML root element.
  *
  * **CAUTION:** Advanced use only.  Changing element properties directly may
  * cause undesirable results in the framework.
  */
  Element rawElement;

  /// A meta-data tag that represents the container context of an element,
  /// if it has one.
  ///
  /// ### To set the container context of an element:
  ///     stateBag[CONTAINER_CONTEXT] = {propertyNameOfElementContainerContext};
  static final String CONTAINER_CONTEXT = "CONTAINER_CONTEXT";

  //allows container elements to subscribe/unsubscribe to attached property
  //changes of children.
  final FrameworkEvent<AttachedPropertyChangedEventArgs>
          attachedPropertyChanged;

  /// Represents a name identifier for the element.
  /// Assigning a name to an element
  /// allows it to be found and bound to by other elements.
  FrameworkProperty nameProperty;

  FrameworkObject() :
    lateBindings = new HashMap<FrameworkProperty, BindingData>(),
    _eventBindings = new Map<String, FrameworkEvent>(),
    loaded = new FrameworkEvent<EventArgs>(),
    unloaded = new FrameworkEvent<EventArgs>(),
    attachedPropertyChanged =
      new FrameworkEvent<AttachedPropertyChangedEventArgs>()
    {
      applyVisualTemplate();

      if (rawElement == null) createElement();

      //grab the unwrapped version
      //_rawElement = _unwrap(rawElement);

      _initFrameworkObjectProperties();

      _initFrameworkObjectEvents();
      
      registerEvent('attachedpropertychanged', attachedPropertyChanged);
      registerEvent('loaded', loaded);
      registerEvent('unloaded', unloaded);
      registerEvent('measurementchanged', measurementChanged);
    }
  
  FrameworkObject.register() : super.register(),
    lateBindings = new HashMap<FrameworkProperty, BindingData>(),
    _eventBindings = new Map<String, FrameworkEvent>(),
    loaded = new FrameworkEvent<EventArgs>(),
    unloaded = new FrameworkEvent<EventArgs>(),
    attachedPropertyChanged = 
      new FrameworkEvent<AttachedPropertyChangedEventArgs>();
      
  makeMe() => null;
  
  void _initFrameworkObjectProperties(){
    nameProperty = new FrameworkProperty(
      this,
      "name",
      (String value){

        if (nameProperty.previousValue != null){
          throw new BuckshotException('Attempted to assign name "${value}"'
          ' to element that already has a name "${nameProperty.previousValue}"'
          ' assigned.');
        }

        if (value != null){
          buckshot.namedElements[value] = this;
          if (rawElement != null) rawElement.attributes["ID"] = value;
        }

      });

    dataContextProperty = new FrameworkProperty(
      this,
      "dataContext",
      (value){});
  }

  void _startWatchMeasurement(){
    _watchingMeasurement = true;

    watchIt(num time){
      if (!_watchingMeasurement) return;

      rawElement.rect.then((ElementRect m){

        mostRecentMeasurement = m;

        if (_previousMeasurement == null){
          measurementChanged.invoke(this,
            new MeasurementChangedEventArgs(m, m));
        }else{
          //TODO: (John) make a positionChanged event and a sizeChanged event
          // in addition to this measurementChanged event.
          if (
//              _previousMeasurement.bounding.left != m.bounding.left
//              || _previousMeasurement.bounding.top != m.bounding.top
              _previousMeasurement.bounding.width != m.bounding.width
              || _previousMeasurement.bounding.height != m.bounding.height
//              || _previousMeasurement.client.left != m.client.left
//              || _previousMeasurement.client.top != m.client.top
              || _previousMeasurement.client.width != m.client.width
              || _previousMeasurement.client.height != m.client.height
//              || _previousMeasurement.offset.left != m.offset.left
//              || _previousMeasurement.offset.top != m.offset.top
              || _previousMeasurement.offset.width != m.offset.width
              || _previousMeasurement.offset.height != m.offset.height
//              || _previousMeasurement.scroll.left != m.scroll.left
//              || _previousMeasurement.scroll.top != m.scroll.top
              || _previousMeasurement.scroll.width != m.scroll.width
              || _previousMeasurement.scroll.height != m.scroll.height
              ){

            measurementChanged.invoke(this,
              new MeasurementChangedEventArgs(_previousMeasurement, m));
          }
        }
        _previousMeasurement = m;
        _animationFrameID = window.requestAnimationFrame(watchIt);
      });
    }

    _animationFrameID = window.requestAnimationFrame(watchIt);

  }

  void _stopWatchMeasurement(){
    if (_animationFrameID != null)
      window.cancelAnimationFrame(_animationFrameID);
    _previousMeasurement = null;
    _watchingMeasurement = false;
  }

  void _initFrameworkObjectEvents(){
    // only begins animation loop on first request of the event
    // to preserve resources when not in use.
    measurementChanged = new BuckshotEvent<MeasurementChangedEventArgs>
    ._watchFirstAndLast(
      () => _startWatchMeasurement(),
      () =>  _stopWatchMeasurement()
    );
  }

  //TODO load/unload should be asynchronous?
  void addToLayoutTree(FrameworkObject parentElement){

    parentElement.rawElement.elements.add(rawElement);

    parent = parentElement;

   // db('Added to Layout Tree', this);
    if (!parentElement.isLoaded) return;

    _onAddedToDOM();
  }

  void _onAddedToDOM(){
    //parent is in the DOM so we should call loaded event and check for children

    updateDataContext();

    _isLoaded = true;

    if (parent != null){
      parent.updateLayout();
    }

    onLoaded();
    loaded.invoke(this, new EventArgs());

    //db('Added to DOM', this);

    if (this is! IFrameworkContainer) return;

    if ((this as IFrameworkContainer).content is List){
      (this as IFrameworkContainer)
        .content
        .forEach((FrameworkElement child)
          {
            child.parent = this;
            child._onAddedToDOM();
          });
    }else if ((this as IFrameworkContainer).content is FrameworkElement){
      this.dynamic.content._onAddedToDOM();
    }
  }

  void onLoaded(){}
  void onUnloaded(){}

  bool _dataContextUpdated = false;
  void updateDataContext(){
    if (_dataContextUpdated) return;
    _dataContextUpdated = true;

    //TODO: Support multiple datacontext updates

    var dc = resolveDataContext();

    _wireEventBindings(dc);

    if (dc == null) return;

    //binding each property in the lateBindings collection
    //to the data context
    lateBindings.forEach((FrameworkProperty p, BindingData bd){
      if (bd.dataContextPath == ""){
        new Binding(dc, p);
      }else{
        if (!(dc.value is BuckshotObject))
          throw new BuckshotException("Datacontext binding attempted to"
            " resolve properties '${bd.dataContextPath}'"
            " on non-BuckshotObject type.");

        //TODO keep a reference to these so they can be removed if the
        // datacontext changes

        if (bd.converter != null){
          dc.value.resolveProperty(bd.dataContextPath)
          .then((prop){
              new Binding(prop,
                  p, bindingMode:bd.bindingMode, converter:bd.converter);
          });
        }else{
          dc.value.resolveProperty(bd.dataContextPath)
          .then((prop){
              new Binding(prop, p, bindingMode:bd.bindingMode);
          });
        }
      }
    });
  }

  void _wireEventBindings(dataContextObject){
    if (_eventBindings.isEmpty()) return;

    if (!reflectionEnabled){
      _eventBindings.forEach((String handler, FrameworkEvent event){
        final dc = dataContextObject.value;
        
        if (dc != null && dc is BuckshotObject && 
            dc._eventHandlers.containsKey(handler.toLowerCase())){
          
          event.register(dc._eventHandlers[handler.toLowerCase()]);
        }
      });
      
      return;
    }
    
    if (dataContextObject == null || dataContextObject.value == null){
      final lm = buckshot.mirrorSystem().isolate.rootLibrary;
      _eventBindings.forEach((String handler, FrameworkEvent event){
        if (lm.functions.containsKey(handler)){

          //invoke the handler when the event fires
          event + (sender, args){
            lm.invoke(handler, [buckshot.reflectMe(sender), 
                                buckshot.reflectMe(args)]);
          };
        }
      });
    }else{
      final im = buckshot.reflectMe(dataContextObject.value);

      _eventBindings.forEach((String handler, FrameworkEvent event){
        if (im.type.methods.containsKey(handler)){

          //invoke the handler when the event fires
          event + (sender, args){
            im.invoke(handler, [buckshot.reflectMe(sender), 
                                buckshot.reflectMe(args)]);
          };
        }
      });
    }
  }

  void removeFromLayoutTree(){
    this.rawElement.remove();

    //db('Removed from Layout Tree', this);
    var p = parent;

    parent = null;

    if (!p._isLoaded) return;

    _onRemoveFromDOM();
  }

  _onRemoveFromDOM(){
    _isLoaded = false;

    onUnloaded();
    unloaded.invoke(this, new EventArgs());

    //db('Removed from DOM', this);

    if (this is! IFrameworkContainer) return;

    if (this.dynamic.content is List){
      this.dynamic.content.forEach((FrameworkElement child)
        => child._onRemoveFromDOM());
    }else if (this.dynamic.content is FrameworkElement){
      this.dynamic.content._onRemoveFromDOM();
    }
  }


  ElementRect mostRecentMeasurement;

  void updateMeasurement(){
    if (!isLoaded) return;

    rawElement
      .rect
      .then((ElementRect r) { mostRecentMeasurement = r;});
  }

  /// Returns the first non-null [dataContext] [FrameworkProperty]
  /// in the this [FrameworkElement]'s heirarchy.
  ///
  /// Returns null if no non-null [dataContext] can be found.
  FrameworkProperty resolveDataContext(){
    if (dataContext != null) return dataContextProperty;
    if (parent == null) return null;
    return parent.resolveDataContext();
  }

  /// Sets the [nameProperty] value.
  set name(String value) => setValue(nameProperty, value);
  /// Gets the [nameProperty] value.
  String get name => getValue(nameProperty);

  /// Sets the parent FrameworkElement.
  set parent(FrameworkObject value) => _parent = value;
  /// Gets the parent FrameworkElement.
  FrameworkObject get parent => _parent;

  /// Sets the [dataContextProperty] value.
  set dataContext(value) => setValue(dataContextProperty, value);
  /// Gets the [dataContextProperty] value.
  get dataContext => getValue(dataContextProperty);

  void applyVisualTemplate() {
    //the base method just calls CreateElement
    //sub-classes (like Control) will use this to apply
    //a visual template
    createElement();
  }

  /// Called by the framework to allow an element to construct it's
  /// HTML representation and assign to [component].
  void createElement(){
    rawElement = new DivElement();
  }

  /// Called by the framework to request that an element update it's
  /// visual layout.
  void updateLayout(){}

}