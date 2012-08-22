// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


// Default implementation for StyleTemplate interface.
class StyleTemplate extends FrameworkResource
{
  final Set<FrameworkElement> _registeredElements;
  final HashMap<String, StyleSetter> _setters;
  final String stateBagPrefix = "__StyleBinding__";
  FrameworkProperty settersProperty;

  StyleTemplate()
  : _registeredElements = new HashSet<FrameworkElement>(),
    _setters = new HashMap<String, StyleSetter>()
    {
      _initStyleTemplateProperties();

      setters.listChanged + _onSettersCollectionChanging;

    }

  /** Gets the [StyleSetter] [ObservableList] from [settersProperty]. */
  ObservableList<StyleSetter> get setters() => getValue(settersProperty);
  /** Setst he [StyleSetter] [ObsersableList] from [settersProperty]. */
  set setters(ObservableList<StyleSetter> value) => setValue(settersProperty, value);

  /** Returns a [Collection] of [FrameworkElement]'s registered to the StyleTemplate */
  Collection<FrameworkElement> get registeredElements() => _registeredElements;

  /**
  * Copies setters from one or more [templates] into the current StyleTemplate.
  * Does not move associated elements or bindings, but the copied setters are
  * applied to any elements using the current StyleTemplate. */
  void mergeWith(List<StyleTemplate> templates){
    if (templates == null || templates.isEmpty()) return;

    for (final StyleTemplate style in templates){
      if (style == null || style == this) continue; //ignore if null or same template

      //copy the style setters
      style._setters.forEach((_, StyleSetter s){
        setProperty(s.property, s.value);
      });
    }
  }


  /**
   * Returns a property value from a given [property] name. Null if property doesn't exist. */
  getProperty(String property){
    if (_setters.containsKey(property)){
      return _setters[property].value;
    }else{
      return null;
    }
  }

  /**
  * Sets a style [property] with a given [value], which will apply to all current and future Elements using this StyleTemplate.
  * Unknown properties are ignored. */
  void setProperty(String property, Dynamic newValue){
    if (_setters.containsKey(property)){
      _setters[property].value = newValue;
    }else{
      _setters[property] = new StyleSetter.with(property, newValue);
      setters.add(_setters[property]);
      _registerNewSetterBindings(_setters[property]);
    }
  }

  void _onSettersCollectionChanging(Object _, ListChangedEventArgs args){
    args.oldItems.forEach((StyleSetter item){
      if (_setters.containsKey(item.property))
        _setters.remove(item.property);
    });


    args.newItems.forEach((item){
      setProperty(item.property, item.value);
    });

  }

  void _registerNewSetterBindings(StyleSetter newSetter){
    _registeredElements.forEach((FrameworkElement e)
      {
          _bindSetterToElement(newSetter, e);
      });
  }

  void _initStyleTemplateProperties(){
    settersProperty = new FrameworkProperty(this, "setters", (v){}, new ObservableList<StyleSetter>());
  }

  void _registerElement(FrameworkElement element){
      _registeredElements.add(element);
      _setStyleBindings(element);
  }

  void _unregisterElement(FrameworkElement element){
    if (_registeredElements.contains(element)){
      _registeredElements.remove(element);
      _unsetStyleBindings(element);
    }
  }

  void _setStyleBindings(FrameworkElement element){
    _setters.forEach((_, StyleSetter s){
      _bindSetterToElement(s, element);
    });
  }

  void _unsetStyleBindings(FrameworkElement element){
    element.stateBag.forEach((String k, Dynamic v){
      if (k.startsWith(stateBagPrefix)){
        v.unregister();
        element.stateBag.remove(k);
      }
    });
  }

  void _bindSetterToElement(StyleSetter setter, FrameworkElement element){
    element._frameworkProperties
    .filter((FrameworkProperty p) => p.propertyName == setter.property)
    .forEach((FrameworkProperty p) {
      Binding b = new Binding(setter.valueProperty, p);
      p.sourceObject.stateBag["$stateBagPrefix${setter.property}__"] = b;
    });
  }
}
