// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


/**
 * Extends the [FrameworkEvent] event model by adding first/last
 * watcher functionality to the event lifecycle. 
 */
class BuckshotEvent<T extends EventArgs> extends FrameworkEvent
{
  Function _gotFirstSubscriberCallback;
  Function _lostLastSubscriberCallback;
  
  BuckshotEvent();
  
  BuckshotEvent._watchFirstAndLast(this._gotFirstSubscriberCallback, this._lostLastSubscriberCallback)
  :
    super();
  
  
  /**
  * Registers an EventHandler to the FrameworkEvent, and returns an
  * EventHandlerReference, which can be used to unregister the
  * handler at some later time. */
  EventHandlerReference register(Function handler){
    var hr = new EventHandlerReference(handler);
    handlers.add(hr);

    if (_gotFirstSubscriberCallback != null && handlers.length == 1){
      _gotFirstSubscriberCallback();
    }

    return hr;
  }

  /**
  * Unregisters an EventHandler (via it's EventHandlerReference from the
  * FrameworkEvent. */
  void unregister(EventHandlerReference handlerReference){
    int i = handlers.indexOf(handlerReference, 0);
    if (i < 0) return;
    handlers.removeRange(i, 1);

    if (_lostLastSubscriberCallback != null && handlers.isEmpty()){
      _lostLastSubscriberCallback();
    }
  }
}
