// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

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
    fl.rawElement.attributes["data-lucaui-${property.propertyName}"] = getValue(property);
  }

}

Future _functionToFuture(Function f){
  Completer c = new Completer();

  void doIt(foo) => c.complete(f());

  try{
    window.requestAnimationFrame(doIt);
  }catch (Exception e){
    c.completeException(e);
  }

  return c.future;
}

/**
 * Sets the value of a given [FrameworkProperty] to a given [v]. */
Future setValueAsync(FrameworkProperty property, Dynamic value)
{
  Completer c = new Completer();

   void doIt(foo){

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
      //    3) event - notifies any subscribers that the FrameworkProperty
      //       value changed

      // 1) callback
      Function f = property.propertyChangedCallback;
      f(value);

      // 2) bindings
      _BindingImplementation._executeBindingsFor(property);

      // 3) event
      if (property.propertyChanging.hasHandlers)
        property.propertyChanging.invoke(property.sourceObject,
          new PropertyChangingEventArgs(property.previousValue, value));

      c.complete(null);
   }

   window.requestAnimationFrame(doIt);

   return c.future;
}

void setValue(FrameworkProperty property, Dynamic value)
{
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
    //    3) event - notifies any subscribers that the FrameworkProperty
    //       value changed

    // 1) callback
    Function f = property.propertyChangedCallback;
    f(value);

    // 2) bindings
    _BindingImplementation._executeBindingsFor(property);

    // 3) event
    if (property.propertyChanging.hasHandlers)
      property.propertyChanging.invoke(property.sourceObject,
        new PropertyChangingEventArgs(property.previousValue, value));

}

/**
 * Gets the current value of a given [FrameworkProperty] object.
 * Returns null if the [propertyInfo] object does not exist or if the underlying
 * property is not found. */
Dynamic getValue(FrameworkProperty propertyInfo) =>
    (propertyInfo == null) ? null : propertyInfo.value;

/**
* Executes a javascript alert "break point" with optional [breakInfo]. */
br([breakInfo]){
  window.alert("Debug Break: ${breakInfo != null ? breakInfo.toString() : ''}");
}

/**
* Prints output to the javascript console with optional FrameworkElement [element] info. */
db(String message, [FrameworkObject element]){
  if (element == null){
    print(message);
    return;
  }
  print("[${element.type}(${element.name})] $message");
}


String space(int n){
  var s = new StringBuffer();
  for(int i = 0; i < n; i++){
    s.add(' ');
  }
  return s.toString();
}

/**
 * Debug function that pretty prints an element tree. */
printTree(startWith, [int indent = 0]){  
  if (startWith == null || startWith is! FrameworkElement) return;
  
  print('${space(indent)}${startWith}(Parent=${startWith.parent})');
  
  if (startWith is IFrameworkContainer){
    if ((startWith as IFrameworkContainer).content is List){
      (startWith as IFrameworkContainer)
        .content
        .forEach((e) => printTree(e, indent + 5));
    }else{
      printTree(startWith.content, indent + 5);
    }
  }
}


