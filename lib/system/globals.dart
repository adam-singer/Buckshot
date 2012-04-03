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
 * Global Definitions. */
class Globals
{
  static final bool addPropertyAttributes = false;
  
  /**
  * Sets an attribute on the element with the given FrameworkProperty value */
  static satt(FrameworkProperty property){
    if (property == null || !(property.sourceObject is FrameworkElement)) return;

    FrameworkElement fl = property.sourceObject;
    fl._component.attributes["data-lucaui-${property.propertyName}"] = getValue(property);
  }
  
  //remove
//  static final String _controlTemplates =
//'''
//<resourcecollection>
//  <controltemplate controlType="template_ListBox">
//    <template>
//          <collectionPresenter name="__buckshot_listbox_presenter__">
//          </collectionPresenter>
//    </template>
//  </controltemplate>
//</resourcecollection>
//''';

}


/**
 * Sets the value of a given [FrameworkProperty] to a given [value]. */
void setValue(FrameworkProperty property, Dynamic value)
{     
    //if (Globals.addPropertyAttributes)
           // Globals.satt(property);
   
   if (property.stringToValueConverter != null && value is String){
     value = property.stringToValueConverter.convert(value);
   }
   
  
   if (property.value == value) return;
    
    property._previousValue = property.value;
    property.value = value;   

    // 3 different activities take place when a FrameworkProperty value changes,
    // in this order of precedence:
    //    1) callback - lets the FrameworkProperty do any work it wants to do
    //    2) bindings - fires any bindings associated with the FrameworkProperty
    //    3) event - notifies any subscribers that the FrameworkProperty value changed
    
    // 1) callback
    Function f = property.propertyChangedCallback;
    f(value);
    
    // 2) bindings
    _BindingImplementation._executeBindingsFor(property);
    
    // 3) event
    if (property.propertyChanging.hasHandlers)
      property.propertyChanging.invoke(property.sourceObject, new PropertyChangingEventArgs(property.previousValue, value));
}

/**
 * Gets the current value of a given [FrameworkProperty] object.
 * Returns null if the [propertyInfo] object does not exist or if the underlying
 * property is not found. */
Dynamic getValue(FrameworkProperty propertyInfo)
{  
  return (propertyInfo == null) ? null : propertyInfo.value;
}


/// Global flag for forking debug related code.
bool DEBUG = true;


/**
* Executes a javascript alert "break point" with optional [breakInfo]. */
br([breakInfo]){
  if (!DEBUG) return;
  window.alert("Debug Break: ${breakInfo != null ? breakInfo.toString() : ''}");
}

/**
* Prints output to the javascript console with optional FrameworkElement [element] info. */
db(String message, [FrameworkObject element]){
  if (!DEBUG) return;
  if (element == null){
    print(message);
    return;
  }
  print("[${element.type}(${element.name})] $message");
}

