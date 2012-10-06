// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Represents and element that can participate in the framework's
* [Binding] and [FrameworkProperty] model. */
class FrameworkObject extends BuckshotObject
{
  bool _watchingMeasurement = false;
  bool _watchingPosition = false;
  bool _firstLoad = true;
  ElementRect _previousMeasurement;
  ElementRect _previousPosition;
  FrameworkObject _parent;
  bool isLoaded = false;

  /// Represents the data context assigned to the FrameworkElement.
  /// Declarative xml binding can be used to bind to data context.
  FrameworkProperty dataContextProperty;

  /// Represents a map of [Binding]s that will be bound just before
  /// the element renders to the DOM.
  final HashMap<FrameworkProperty, BindingData> lateBindings =
      new HashMap<FrameworkProperty, BindingData>();

  final Map<String, FrameworkEvent> _eventBindings =
      new Map<String, FrameworkEvent>();

  /// Fires when the FrameworkElement is inserted into the DOM.
  final FrameworkEvent<EventArgs> loaded = new FrameworkEvent<EventArgs>();
  /// Fires when the FrameworkElement is removed from the DOM.
  final FrameworkEvent<EventArgs> unloaded = new FrameworkEvent<EventArgs>();
  /// Fires when the measurement of the the element changes.
  FrameworkEvent<MeasurementChangedEventArgs> measurementChanged;
  /// Fires when the position of the element changes.
  FrameworkEvent<MeasurementChangedEventArgs> positionChanged;

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
  static const String CONTAINER_CONTEXT = "CONTAINER_CONTEXT";

  //allows container elements to subscribe/unsubscribe to attached property
  //changes of children.
  final FrameworkEvent<AttachedPropertyChangedEventArgs>
          attachedPropertyChanged =
          new FrameworkEvent<AttachedPropertyChangedEventArgs>();

  /// Represents a name identifier for the element.
  /// Assigning a name to an element
  /// allows it to be found and bound to by other elements.
  FrameworkProperty nameProperty;

  FrameworkObject() {
      applyVisualTemplate();

      if (rawElement == null) createElement();

      //grab the unwrapped version
      //_rawElement = _unwrap(rawElement);

      _initFrameworkObjectProperties();

      _initFrameworkObjectEvents();

      if (reflectionEnabled){
        return;
      }

      registerEvent('attachedpropertychanged', attachedPropertyChanged);
      registerEvent('loaded', loaded);
      registerEvent('unloaded', unloaded);
      registerEvent('measurementchanged', measurementChanged);
      registerEvent('positionchanged', positionChanged);
  }

  FrameworkObject.register() : super.register();
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

    dataContextProperty = new FrameworkProperty(this, "dataContext");
  }

  void _startWatchMeasurement(){
    _watchingMeasurement = true;

    watchIt(int time){
      if (!_watchingMeasurement) return;

      rawElement.rect.then((ElementRect m){
        if (!_watchingMeasurement) return;

        mostRecentMeasurement = m;

        if (_previousMeasurement == null){
          measurementChanged.invoke(this,
            new MeasurementChangedEventArgs(m, m));
        }else{
          if (
              _previousMeasurement.bounding.width != m.bounding.width
              || _previousMeasurement.bounding.height != m.bounding.height
              || _previousMeasurement.client.width != m.client.width
              || _previousMeasurement.client.height != m.client.height
              || _previousMeasurement.offset.width != m.offset.width
              || _previousMeasurement.offset.height != m.offset.height
              || _previousMeasurement.scroll.width != m.scroll.width
              || _previousMeasurement.scroll.height != m.scroll.height
              ){

            measurementChanged.invoke(this,
              new MeasurementChangedEventArgs(_previousMeasurement, m));
          }
        }
        _previousMeasurement = m;
      });
    }

    FrameworkAnimation.workers['${safeName}_watch_measurement'] = watchIt;

  }

  void _stopWatchMeasurement(){
    if (FrameworkAnimation.workers.containsKey('${safeName}_watch_measurement')){
      FrameworkAnimation.workers.remove('${safeName}_watch_measurement');
    }

    _previousMeasurement = null;
    _watchingMeasurement = false;
  }

  void _startWatchPosition(){
    _watchingPosition= true;

    watchIt(int time){
      if (!_watchingPosition) return;

      rawElement.rect.then((ElementRect m){
        if (!_watchingPosition) return;

        mostRecentMeasurement = m;

        if (_previousPosition == null){
          positionChanged.invoke(this,
            new MeasurementChangedEventArgs(m, m));
        }else{
          if (
              _previousPosition.bounding.left != m.bounding.left
              || _previousPosition.bounding.top != m.bounding.top
              || _previousPosition.client.left != m.client.left
              || _previousPosition.client.top != m.client.top
              || _previousPosition.offset.left != m.offset.left
              || _previousPosition.offset.top != m.offset.top
              || _previousPosition.scroll.left != m.scroll.left
              || _previousPosition.scroll.top != m.scroll.top
              ){

            positionChanged.invoke(this,
              new MeasurementChangedEventArgs(_previousPosition, m));
          }
        }
        _previousPosition = m;
      });
    }

    FrameworkAnimation.workers['${safeName}_watch_position'] = watchIt;

  }

  void _stopWatchPosition(){
    if (FrameworkAnimation.workers.containsKey('${safeName}_watch_position')){
      FrameworkAnimation.workers.remove('${safeName}_watch_position');
    }

    _previousPosition = null;
    _watchingPosition = false;
  }

  void _initFrameworkObjectEvents(){
    // only begins animation loop on first request of the event
    // to preserve resources when not in use.
    measurementChanged = new BuckshotEvent<MeasurementChangedEventArgs>
    ._watchFirstAndLast(
      () => _startWatchMeasurement(),
      () =>  _stopWatchMeasurement()
    );

    positionChanged = new BuckshotEvent<MeasurementChangedEventArgs>
    ._watchFirstAndLast(
      () => _startWatchPosition(),
      () =>  _stopWatchPosition()
    );
  }

  void addToLayoutTree(FrameworkObject parentElement){

    parentElement.rawElement.elements.add(rawElement);

    parent = parentElement;

    if (!parentElement.isLoaded) return;

    onAddedToDOM();
  }

  void onAddedToDOM(){
    //parent is in the DOM so we should call loaded event and check for children

    updateDataContext();

    isLoaded = true;

    if (parent != null){
      parent.updateLayout();
    }

    onLoaded();

    loaded.invoke(this, new EventArgs());

    if (_firstLoad){
      onFirstLoad();
      _firstLoad = false;
    }

    if (this is! IFrameworkContainer) return;

    final containerContent = (this as IFrameworkContainer).content;

    if (containerContent is Collection){
      containerContent
        .forEach((FrameworkElement child)
          {
            child.parent = this;
            child.onAddedToDOM();
          });
    }else if (containerContent is FrameworkElement){
      containerContent.onAddedToDOM();
    }
  }

  void onLoaded(){}
  void onUnloaded(){}
  void onFirstLoad(){}

  bool _dataContextUpdated = false;
  void updateDataContext(){
    if (_dataContextUpdated) return;
    _dataContextUpdated = true;

    //TODO: Support multiple datacontext updates

    final dcs = resolveAllDataContexts();

    if (dcs.isEmpty()) return;

    _wireEventBindings(dcs);

    final dc = dcs[0];

    //dataContext = dc.value;

    //binding each property in the lateBindings collection
    //to the data context
    lateBindings
      .forEach((FrameworkProperty p, BindingData bd){
        if (bd.dataContextPath == ""){
          new Binding(dc, p);
        }else{
          if (dc.value is! BuckshotObject)
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

  void _wireEventBindings(List dataContexts){
    if (_eventBindings.isEmpty()) return;

    if (!reflectionEnabled){
      _eventBindings
        .forEach((String handler, FrameworkEvent event){
          handler = handler.toLowerCase();

          if (_globalEventHandlers.containsKey(handler)){
            // handler found in global registry
            event.register(_globalEventHandlers[handler]);
          }else{
            // work through each dataContext and try to find a matching
            // handler

            for(final dc in dataContexts){
              final dcv = dc.value;
              if (dcv != null && dcv is BuckshotObject &&
                  dcv._eventHandlers.containsKey(handler)){
                event.register(dcv._eventHandlers[handler]);
                break;
              }
            }
          }
        });

      return;
    }

    if (dataContexts.isEmpty()){
      // global event handler
      final lm = buckshot.mirrorSystem().isolate.rootLibrary;
      _eventBindings
        .forEach((String handler, FrameworkEvent event){
          if (lm.functions.containsKey(handler)){

            //invoke the handler when the event fires
            event + (sender, args){
              lm.invoke(handler, [buckshot.reflectMe(sender),
                                  buckshot.reflectMe(args)]);
            };
          }
      });
    }else{
      _eventBindings
        .forEach((String handler, FrameworkEvent event){
          for(final dc in dataContexts){
            if (dc.value == null) continue;

            final im = buckshot.reflectMe(dc.value);

            if (im.type.methods.containsKey(handler)){

              //invoke the handler when the event fires
              event + (sender, args){
                im.invoke(handler, [buckshot.reflectMe(sender),
                                    buckshot.reflectMe(args)]);
              };

              break;
            }
          }
      });
    }
  }

  void removeFromLayoutTree(){
    this.rawElement.remove();

    //db('Removed from Layout Tree', this);
    var p = parent;

    parent = null;

    if (!p.isLoaded) return;

    _onRemoveFromDOM();
  }

  _onRemoveFromDOM(){
    isLoaded = false;

    onUnloaded();
    unloaded.invoke(this, new EventArgs());

    //db('Removed from DOM', this);

    if (this is! IFrameworkContainer) return;

    final cc = this as IFrameworkContainer;

    if (cc.content is List){
      cc.content.forEach((FrameworkElement child) => child._onRemoveFromDOM());
    }else if (cc.content is FrameworkElement){
      cc.content._onRemoveFromDOM();
    }
  }


  ElementRect mostRecentMeasurement;

  Future<ElementRect> updateMeasurement(){
    if (!isLoaded) return null;

    final rf = rawElement.rect;

    rf.then((ElementRect r) { mostRecentMeasurement = r;});

    return rf;
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

  List<FrameworkProperty> resolveAllDataContexts(){
    var list = new List<FrameworkProperty>();

    if (dataContext != null) list.add(dataContextProperty);

    if (parent == null) return list;

    list.addAll(parent.resolveAllDataContexts());

    return list;
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