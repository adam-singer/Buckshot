// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


/**
* Represents a property of an element that can be attached loosely to other elements.
* Note that attached properties do not participate in the data binding model (they cannot
* bind or be bound to). */
class AttachedFrameworkProperty extends FrameworkPropertyBase
{

    AttachedFrameworkProperty(String propertyName, Function propertyChangedCallback)
      : super(null, propertyName, propertyChangedCallback)
      {
        buckshot._attachedProperties[this] = new HashMap<FrameworkElement, Dynamic>();
      }
}