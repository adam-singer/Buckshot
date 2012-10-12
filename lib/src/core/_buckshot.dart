
/**
* A general utility service for the Buckshot framework.
*
* Use the globally available 'buckshot' object to access the
* framework system.  It is normally not necessary to create your own instance
* of the [Buckshot] class.
*/
@deprecated class _buckshot extends FrameworkObject
{
  /** Deprecated.  Use top-level registerElement() instead. */
  @deprecated void registerElement(BuckshotObject o){
    if (reflectionEnabled) return;

    _objectRegistry['${o.toString().toLowerCase()}'] = o.makeMe;
    _log.info('Element (${o}) registered to framework.');
  }

  @deprecated void registerAttachedProperty(String property, setterFunction){
    if (reflectionEnabled) return;

    _objectRegistry[property] = setterFunction;
    _log.info('Attached property (${property}) registered to framework.');
  }


  // Wrappers to prevent propagation of static warnings elsewhere.
  reflectMe(object) => reflect(object);
  get mirrorSystem() => currentMirrorSystem();

}