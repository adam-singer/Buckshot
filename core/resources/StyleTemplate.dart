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
* Defines a template that can be assigned to a [FrameworkElement]. */
interface StyleTemplate default _StyleTemplateImplementation
{
  StyleTemplate();
  
  
  LucaObject makeMe();
  
  /**
  * Sets a style [property] with a given [value], which will apply to all current and future Elements using this StyleTemplate.
  * Unknown properties are ignored. */
  void setProperty(String property, Dynamic value);
  
  ObservableList<StyleSetter> get setters();
  set setters(ObservableList<StyleSetter> value);
  
  /**
  * Copies setters from one or more [templates] into the current StyleTemplate.
  * Does not move associated elements or bindings, but the copied setters are
  * applied to any elements using the current StyleTemplate. */
  void mergeWith(List<StyleTemplate> templates);
  
  //these are needed internally, not for use outside the library...
  void _registerElement(FrameworkElement element);
  void _unregisterElement(FrameworkElement element);
}

// Default implementation for StyleTemplate interface.
class _StyleTemplateImplementation extends FrameworkResource implements StyleTemplate
{
  final Set<FrameworkElement> _registeredElements;
  final HashMap<String, StyleSetter> _setters;
  final String stateBagPrefix = "__StyleBinding__";
  FrameworkProperty settersProperty;
  
  LucaObject makeMe() => new _StyleTemplateImplementation();
  
  _StyleTemplateImplementation()
  : _registeredElements = new HashSet<FrameworkElement>(),
    _setters = new HashMap<String, StyleSetter>()
    {
      _initStyleTemplateProperties();
      
      setters.listChanged + _onSettersCollectionChanging;
      
    }  
    
  ObservableList<StyleSetter> get setters() => getValue(settersProperty);
  set setters(ObservableList<StyleSetter> value) => setValue(settersProperty, value);
    
    
  void mergeWith(List<StyleTemplate> templates){
    if (templates == null || templates.isEmpty()) return;
    
    for (final _StyleTemplateImplementation style in templates){
      if (style == null || style == this) continue; //ignore if null or same template
    
      //copy the style setters
      style._setters.forEach((_, StyleSetter s){
        setProperty(s.property, s.value);
      });
    }
  }
    
  void setProperty(String property, Dynamic newValue){
    if (_setters.containsKey(property)){
      _setters[property].value = newValue;  
    }else{
      _setters[property] = new StyleSetter.with(property, newValue);
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
    element._stateBag.forEach((String k, Dynamic v){
      if (k.startsWith(stateBagPrefix)){
        v.unregister();
        element._stateBag.remove(k);
      }
    });
  }
  
  void _bindSetterToElement(StyleSetter setter, FrameworkElement element){
    element._frameworkProperties
    .filter((FrameworkProperty p) => p.propertyName == setter.property)
    .forEach((FrameworkProperty p) {
      Binding b = new Binding(setter.valueProperty, p);
      p.sourceObject._stateBag["$stateBagPrefix${setter.property}__"] = b;
    });
  }
  
  String get _type() => "StyleTemplate";
}
