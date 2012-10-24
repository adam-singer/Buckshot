part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


/**
* A general utility service for the Buckshot framework.
*
* ## Deprecated ##
* This class will be removed once mirrors are supported by dart2js.
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
  get mirrorSystem => currentMirrorSystem();

}