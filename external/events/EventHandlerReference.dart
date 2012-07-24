// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* A wrapper class for EventHandler functions so that they can be located in
* collections (necessary because anonymous functions aren't Hashable). 
*/
class EventHandlerReference extends HashableObject
{
  /// Represents the handler that is being wrapped.
  final EventHandler handler;
  
  EventHandlerReference(EventHandler this.handler);
}
