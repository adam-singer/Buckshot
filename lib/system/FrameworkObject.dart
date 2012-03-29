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
  
  bool _isLoaded = false;
  
  /// A meta-data tag that represents the container context of an element,
  /// if it has one.
  ///
  /// ### To set the container context of an element:
  ///     stateBag[CONTAINER_CONTEXT] = {propertyNameOfElementContainerContext};
  static final String CONTAINER_CONTEXT = "CONTAINER_CONTEXT";
  
  //allows container elements to subscribe/unsubscribe to attached property changes of children
  final FrameworkEvent<AttachedPropertyChangedEventArgs> attachedPropertyChanged;
  
  /// Represents a name identifier for the element.  Assigning a name to an element
  /// allows it to be found and bound to by other elements.
  FrameworkProperty nameProperty;
  
  /// Overridden [LucaObject] method.
  BuckshotObject makeMe() => new FrameworkObject();
  
  /// Gets a boolean value indicating whether this element has a contain context set.
  bool get isContainer() => _stateBag.containsKey(CONTAINER_CONTEXT);
  
  FrameworkObject() : 
    attachedPropertyChanged = new FrameworkEvent<AttachedPropertyChangedEventArgs>()
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
            throw new FrameworkException('Attempted to assign name "${value}" to element that already has a name "${nameProperty.previousValue}" assigned.');
          }
          
          if (value != null){
            Buckshot.namedElements[value] = this;
            if (_component != null) _component.attributes["ID"] = value;
          }
          
        });
    }  
  
  /// Sets the [nameProperty] value.
  set name(String value) => setValue(nameProperty, value);
  /// Gets the [nameProperty] value.
  String get name() => getValue(nameProperty);
      
  void applyVisualTemplate() {
    //the base method just calls CreateElement
    //sub-classes (like Control) will use this to apply 
    //a visual template
    CreateElement(); 
  }
  
  //TODO set/getAttachedValue belong somewhere else...
  
  /**
  * Sets the value of a given AttachedFrameworkProperty for a given Element. */
  static void setAttachedValue(FrameworkElement element, AttachedFrameworkProperty property, Dynamic value)
  {
    HashMap<FrameworkElement, Dynamic> aDepInfo = Buckshot._attachedProperties[property];

    //no need to invoke if nothing has changed
    if (aDepInfo[element] == value) return;
    
    Dynamic oldValue = aDepInfo[element];
    aDepInfo[element] = value;

    
    //invoke the event so that any subscribers will get the message
    //subscribers will typically be parents interested to know if attached properties change on children
    element.attachedPropertyChanged.invoke(element, new AttachedPropertyChangedEventArgs(element, property, value));
    property.propertyChanging.invoke(property, new PropertyChangingEventArgs(oldValue, value));
  }
  
  /**
  * Gets the value of a given AttachedFrameworkProperty for a given Element. */
  static Dynamic getAttachedValue(FrameworkElement element, AttachedFrameworkProperty property){
      if (property == null) return null;

      HashMap<FrameworkElement, Dynamic> aDepInfo = Buckshot._attachedProperties[property];
      
      return (aDepInfo.containsKey(element)) ? aDepInfo[element] : null;
  }
  
  /// Called by the framework to allow an element to construct it's HTML representation
  /// and assign to [component].
  void CreateElement(){
    _component = _Dom.createByTag("div");
  }
  
  /// Called by the framework to request that an element update it's visual layout.
  void updateLayout(){}
  
  String get type() => "FrameworkObject";
  
}