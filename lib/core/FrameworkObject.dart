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
* Represents and element that can participate in the framework's
* [Binding] and [FrameworkProperty] model. */
class FrameworkObject extends BuckshotObject {
  Element _component;
  FrameworkObject _parent;
  bool _isLoaded = false;

  /// Represents the data context assigned to the FrameworkElement.
  /// Declarative xml binding can be used to bind to data context.
  FrameworkProperty dataContextProperty;

  /// Represents a map of [Binding]s that will be bound just before
  /// the element renders to the DOM.
  final HashMap<FrameworkProperty, BindingData> lateBindings;

  /// Fires when the FrameworkElement is inserted into the DOM.
  final FrameworkEvent<EventArgs> loaded;
  /// Fires when the FrameworkElement is removed from the DOM.
  final FrameworkEvent<EventArgs> unloaded;

  /**
  * Accesses the underlying raw HTML element.
  *
  * **CAUTION:** Advanced use only.  Changing element properties directly may
  * cause undesirable results in the Buckshot framework.
  */
  Element get rawElement() => _component;
  set rawElement(Element v) => _component = v;

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

  /// Overridden [LucaObject] method.
  BuckshotObject makeMe() => new FrameworkObject();

  /// Gets a boolean value indicating whether this element
  /// has a contain context set.
  bool get isContainer() => _stateBag.containsKey(CONTAINER_CONTEXT);

  FrameworkObject() :
    lateBindings = new HashMap<FrameworkProperty, BindingData>(),
    loaded = new FrameworkEvent<EventArgs>(),
    unloaded = new FrameworkEvent<EventArgs>(),
    attachedPropertyChanged =
    new FrameworkEvent<AttachedPropertyChangedEventArgs>()
    {
      applyVisualTemplate();

      if (_component == null) CreateElement();

      _Dom.appendBuckshotClass(_component, 'frameworkobject');

      //grab the unwrapped version
      //_rawElement = _unwrap(_component);

      _initFrameworkObjectProperties();

    }

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
          if (_component != null) _component.attributes["ID"] = value;
        }

      });

    dataContextProperty = new FrameworkProperty(
      this,
      "dataContext",
      (value){});
  }

  //TODO load/unload should be asynchronous?
  void addToLayoutTree(FrameworkObject parentElement){

    parentElement._component.elements.add(_component);

    parent = parentElement;

   // db('Added to Layout Tree', this);
    if (!parentElement._isLoaded) return;

    _onAddedToDOM();
  }

  void _onAddedToDOM(){
    //parent is in the DOM so we should call loaded event and check for children

    updateDataContext();

    _isLoaded = true;

    parent.updateLayout();

    onLoaded();
    loaded.invoke(this, new EventArgs());

    //db('Added to DOM', this);

    if (this is! IFrameworkContainer) return;

    if (this.dynamic.content is List){
      this.dynamic.content.forEach((FrameworkElement child)
        => child._onAddedToDOM());
    }else if (this.dynamic.content is FrameworkElement){
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

        if (bd.converter != null)
          new Binding(dc.value.resolveProperty(bd.dataContextPath),
            p, bindingMode:bd.bindingMode, converter:bd.converter);
        else
          new Binding(dc.value.resolveProperty(bd.dataContextPath),
            p, bindingMode:bd.bindingMode);
      }
    });
  }

  void removeFromLayoutTree(){
    this._component.remove();

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
    _component
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


  bool isChildOf(FrameworkElement candidate){
    if (parent != null && parent == candidate)
      return true;

    if (parent == null) return false;

    return parent.isChildOf(candidate);
  }

  /// Sets the [nameProperty] value.
  set name(String value) => setValue(nameProperty, value);
  /// Gets the [nameProperty] value.
  String get name() => getValue(nameProperty);

  /// Sets the parent FrameworkElement.
  set parent(FrameworkObject value) => _parent = value;
  /// Gets the parent FrameworkElement.
  FrameworkObject get parent() => _parent;

  /// Sets the [dataContextProperty] value.
  set dataContext(Dynamic value) => setValue(dataContextProperty, value);
  /// Gets the [dataContextProperty] value.
  Dynamic get dataContext() => getValue(dataContextProperty);

  void applyVisualTemplate() {
    //the base method just calls CreateElement
    //sub-classes (like Control) will use this to apply
    //a visual template
    CreateElement();
  }

  //TODO set/getAttachedValue belong somewhere else...

  /**
  * Sets the value of a given AttachedFrameworkProperty for a given Element. */
  static void setAttachedValue(FrameworkElement element,
                               AttachedFrameworkProperty property,
                               Dynamic value)
  {
    HashMap<FrameworkElement, Dynamic> aDepInfo =
        buckshot._attachedProperties[property];

    //no need to invoke if nothing has changed
    if (aDepInfo[element] == value) return;

    Dynamic oldValue = aDepInfo[element];
    aDepInfo[element] = value;

    //invoke the event so that any subscribers will get the message
    //subscribers will typically be parents interested to know if attached
    // properties change on children
    element.attachedPropertyChanged.invoke(element,
      new AttachedPropertyChangedEventArgs(element, property, value));

    property.propertyChanging.invoke(property,
      new PropertyChangingEventArgs(oldValue, value));
  }

  /**
  * Gets the value of a given AttachedFrameworkProperty for a given Element. */
  static Dynamic getAttachedValue(FrameworkElement element,
                                  AttachedFrameworkProperty property){
      if (property == null) return null;

      HashMap<FrameworkElement, Dynamic> aDepInfo =
          buckshot._attachedProperties[property];

      return (aDepInfo.containsKey(element)) ? aDepInfo[element] : null;
  }

  /// Called by the framework to allow an element to construct it's
  /// HTML representation and assign to [component].
  void CreateElement(){
    _component = _Dom.createByTag('div');
  }

  /// Called by the framework to request that an element update it's
  /// visual layout.
  void updateLayout(){}

  String get type() => "FrameworkObject";

}