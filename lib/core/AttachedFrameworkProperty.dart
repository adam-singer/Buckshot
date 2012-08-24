// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


/**
 * Represents a property of an element that can be attached loosely to other
 * elements.
 *
 * Note that attached properties do not participate in the data binding model
 * (they cannot bind or be bound to).
 */
class AttachedFrameworkProperty extends FrameworkPropertyBase
{
    AttachedFrameworkProperty(String propertyName, Function propertyChangedCallback)
      : super(null, propertyName, propertyChangedCallback)
      {
        buckshot._attachedProperties[this] = new HashMap<FrameworkElement, Dynamic>();
      }

    /**
     * Returns the setter function of a given [classPropertyPair] where the
     * string looks like:
     *
     *     'class.attachedPropertyName'
     *
     */
    static Function getSetPropertyFunction(String classPropertyPair){
      throw const NotImplementedException();
    }

    /**
     * Sets the value of a given [AttachedFrameworkProperty] for a given Element. */
    static void setValue(FrameworkElement element,
                                 AttachedFrameworkProperty property,
                                 value)
    {
      final aDepInfo = buckshot._attachedProperties[property];

      //no need to invoke if nothing has changed
      if (aDepInfo[element] == value) return;

      Dynamic oldValue = aDepInfo[element];
      aDepInfo[element] = value;

      //invoke the event so that any subscribers will get the message
      //subscribers will typically be parents interested to know if attached
      // properties change on children
      element.attachedPropertyChanged.invoke(element,
          new AttachedPropertyChangedEventArgs(element, property, value));

      property.propertyChanging.invoke(property,
          new PropertyChangingEventArgs(oldValue, value));
    }

    /**
     * Gets the value of a given [AttachedFrameworkProperty] for a given Element. */
    static getValue(FrameworkElement element,
                                    AttachedFrameworkProperty property){
      if (property == null) return null;

      final aDepInfo = buckshot._attachedProperties[property];

      return (aDepInfo.containsKey(element)) ? aDepInfo[element] : null;
  }
}