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
* The "extends" keyword in the generic T acts as a lightweight type constraint
* in static checks.
*/
interface FrameworkEvent<T extends EventArgs>  default _FrameworkEventImplementation<T extends EventArgs>{
  
  const FrameworkEvent();
  
  /**
  * Returns true if the FrameworkEvent has handlers registered. */
  bool get hasHandlers();
  
  /**
  * Registers an EventHandler to the LucaEvent, and returns an
  * EventHandlerReference, which can be used to unregister the 
  * handler at some later time. */
  EventHandlerReference register(Function handler);
  
  /**
  * Unregisters an EventHandler (via it's EventHandlerReference from the LucaEvent */
  void unregister(EventHandlerReference handlerReference);
  
  /**
  * This operator overload is syntactic sugar for the register() method. */
  EventHandlerReference operator +(Function handler);
  
  /**
  * This operator overload is syntactic sugar for the unregister() method. */
  void operator -(EventHandlerReference handlerReference);
  
  /**
  * Call each EventHandler function that is registered to the FrameworkEvent */
  void invoke(sender, T args);
  
  String get type();
}

class _FrameworkEventImplementation<T extends EventArgs> extends BuckshotObject implements FrameworkEvent
{
  
  BuckshotObject makeMe() => null;
  
  final List<EventHandlerReference> _handlers;
  
  _FrameworkEventImplementation() : _handlers = new List<EventHandlerReference>();

  bool get hasHandlers() => !_handlers.isEmpty();
  
  EventHandlerReference register(Function handler){
    var hr = new EventHandlerReference(handler);
    _handlers.add(hr);
    return hr;
  }
  
  void unregister(EventHandlerReference handlerReference){
    int i = _handlers.indexOf(handlerReference, 0);   
    if (i < 0) return;
    _handlers.removeRange(i, 1);
  }
  
  EventHandlerReference operator +(Function handler) => register(handler);
  
  void operator -(EventHandlerReference handlerReference) => unregister(handlerReference);
    
  void invoke(sender, T args) => _handlers.forEach((handlerReference) => handlerReference.handler(sender, args));
  
  String get type() => "FrameworkEvent";
}


