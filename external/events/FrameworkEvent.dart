// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Represents an event within the framework.
*/
class FrameworkEvent<T extends EventArgs>
{
  final List<EventHandlerReference> handlers;

  FrameworkEvent() 
  : 
    handlers = new List<EventHandlerReference>();

  /**
  * Returns true if the FrameworkEvent has handlers registered. */
  bool get hasHandlers() => !handlers.isEmpty();

  /**
  * Registers an EventHandler to the FrameworkEvent, and returns an
  * EventHandlerReference, which can be used to unregister the
  * handler at some later time. */
  EventHandlerReference register(Function handler){
    var hr = new EventHandlerReference(handler);
    handlers.add(hr);

    return hr;
  }

  /**
  * Unregisters an EventHandler (via it's EventHandlerReference from the
  * FrameworkEvent. */
  void unregister(EventHandlerReference handlerReference){
    int i = handlers.indexOf(handlerReference, 0);
    if (i < 0) return;
    handlers.removeRange(i, 1);
  }

  /**
  * This operator overload is syntactic sugar for the register() method. */
  EventHandlerReference operator +(Function handler) => register(handler);

  /**
  * This operator overload is syntactic sugar for the unregister() method. */
  void operator -(EventHandlerReference handlerReference) => unregister(handlerReference);

  /**
  * Call each EventHandler function that is registered to the FrameworkEvent */
  void invoke(sender, T args){
    handlers.forEach((handlerReference) => handlerReference.handler(sender, args));
  }
  
  void invokeAsync(sender, T args){    
    new Timer(0, (_){
      handlers.forEach((handlerReference) => handlerReference.handler(sender, args));
    });
  }
}


