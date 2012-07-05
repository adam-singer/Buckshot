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
* Represents an event within the framework.
*/
class FrameworkEvent<T extends EventArgs> extends BuckshotObject
{
  Function _gotFirstSubscriberCallback;
  Function _lostLastSubscriberCallback;
  
  BuckshotObject makeMe() => null;

  final List<EventHandlerReference> _handlers;

  FrameworkEvent() 
  : 
    _handlers = new List<EventHandlerReference>(),
    _gotFirstSubscriberCallback = null,
    _lostLastSubscriberCallback = null;

  FrameworkEvent._watchFirstAndLast(this._gotFirstSubscriberCallback, this._lostLastSubscriberCallback)
  :
    _handlers = new List<EventHandlerReference>();

  /**
  * Returns true if the FrameworkEvent has handlers registered. */
  bool get hasHandlers() => !_handlers.isEmpty();

  /**
  * Registers an EventHandler to the FrameworkEvent, and returns an
  * EventHandlerReference, which can be used to unregister the
  * handler at some later time. */
  EventHandlerReference register(Function handler){
    var hr = new EventHandlerReference(handler);
    _handlers.add(hr);

    if (_gotFirstSubscriberCallback != null && _handlers.length == 1){
      _gotFirstSubscriberCallback();
    }

    return hr;
  }

  /**
  * Unregisters an EventHandler (via it's EventHandlerReference from the
  * FrameworkEvent. */
  void unregister(EventHandlerReference handlerReference){
    int i = _handlers.indexOf(handlerReference, 0);
    if (i < 0) return;
    _handlers.removeRange(i, 1);

    if (_lostLastSubscriberCallback != null && _handlers.isEmpty()){
      _lostLastSubscriberCallback();
    }
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
    _handlers.forEach((handlerReference) => handlerReference.handler(sender, args));
  }
  
  void invokeAsync(sender, T args){    
    new Timer(0, (_){
      _handlers.forEach((handlerReference) => handlerReference.handler(sender, args));
    });
  }

  String get type() => "FrameworkEvent";
}


