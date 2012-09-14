// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Represents the globally available instance of Buckshot.
*
* It is normally not be necessary to create your own instance
* of the [Buckshot] class.
*/
Buckshot buckshot = new Buckshot();


/**
 * Sets a [View] into the DOM for rendering. Returns a future which completes
 * when the view is ready (fully deserialized and constructed).
 *
 * ## Placement in DOM ##
 * By default Views will look for a DOM element with the 'BuckshotHost' ID,
 * but you can supply an optional ID to render the content elsewhere.  This
 * will allow you to render Buckshot content to multiple places on the page,
 * although typically you will have only one rendering location.
 *
 * ## Implicit Container For Root Views ##
 * Buckshot places root views into an implicit [Border] root container.  You
 * can manipulate this container with:
 *
 *     myView.rootVisual.parent.{...}
 *
 * This is useful if you want to do things like set explicit width & height
 * values for the root container, but you can also set other typical [Border]
 * properties like borderWidth, borderThickness, etc.
 */
Future<FrameworkElement> setView(View view, [String elementID = 'BuckshotHost'])
{
  final c = new Completer();

  _initFramework();
  
  final el = query('#${elementID}');

  if (el == null){
    throw new BuckshotException('Could not find DOM element with ID of '
        ' "${elementID}"');
  }

  view.ready.then((_){
    final b = new Border();
    el.elements.clear();
    b.isLoaded = true;
    el.elements.add(b.rawElement);
    b.content = view.rootVisual;
    c.complete(view.rootVisual);
  });
  
  return c.future;
}

bool _frameworkInitialized = false;

_initFramework(){
  if (_frameworkInitialized) return;
  
  _frameworkInitialized = true;
  
  if (!FrameworkAnimation._started){
    FrameworkAnimation._startAnimatonLoop();
  }
}


/**
 * Sets the value of a given [FrameworkProperty] to a given [v]. */
Future setValueAsync(FrameworkProperty property, Dynamic value)
{
  Completer c = new Completer();

   doIt(foo){

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
      Binding._executeBindingsFor(property);

      // 3) event
      if (property.propertyChanging.hasHandlers)
        property.propertyChanging.invoke(property.sourceObject,
          new PropertyChangingEventArgs(property.previousValue, value));

      c.complete(null);
   }

   window.requestAnimationFrame(doIt);

   return c.future;
}

/**
 * Sets the value of a given [FrameworkProperty] [property] to a given [value].
 */
void setValue(FrameworkProperty property, Dynamic value)
{
   if (property.stringToValueConverter != null && value is String){
     value = property.stringToValueConverter.convert(value);
   }

   //TODO this isn't working well on some complex objects
   if (property.value === value) return;

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
    Binding._executeBindingsFor(property);

    // 3) event
    if (property.propertyChanging.hasHandlers)
      property.propertyChanging.invoke(property.sourceObject,
        new PropertyChangingEventArgs(property.previousValue, value));

}

/**
 * Gets the current value of a given [FrameworkProperty] object.
 */
getValue(FrameworkProperty property) =>
    (property == null) ? null : property.value;

/**
* Executes a javascript alert "break point" with optional [breakInfo]. */
br([breakInfo]){
  window.alert("Debug Break: ${breakInfo != null ? breakInfo.toString() : ''}");
}

/**
* Prints output to stout with optional FrameworkElement [element] info. */
db(String message, [FrameworkObject element]){
  if (element == null){
    print(message);
    return;
  }
  if (reflectionEnabled){
    print("[${buckshot.reflectMe(element).type.simpleName}(${element.name})] $message");
  }else{
    print("[${element}(${element.name})] $message");
  }
}

/**
 * Debug function that pretty prints an element tree. */
printTree(startWith, [int indent = 0]){
  if (startWith == null || startWith is! FrameworkElement) return;

  String space(int n){
    var s = new StringBuffer();
    for(int i = 0; i < n; i++){
      s.add(' ');
    }
    return s.toString();
  }

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


Future _functionToFuture(Function f){
  Completer c = new Completer();

  void doIt(foo) => c.complete(f());

  try{
    window.requestAnimationFrame(doIt);
  }on Exception catch (e){
    c.completeException(e);
  }

  return c.future;
}


