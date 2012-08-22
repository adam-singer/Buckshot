// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Base class for all objects participating in the framework.
*/
class BuckshotObject extends HashableObject{
  final HashMap<String, Dynamic> stateBag;
  final List<Binding> _bindings;
  final Set<FrameworkProperty> _frameworkProperties;

  BuckshotObject():
    stateBag = new HashMap<String, Dynamic>(),
    _bindings = new List<Binding>(),
    _frameworkProperties = new Set<FrameworkProperty>();

  /// Gets a boolean value indicating whether the given object
  /// is a container or not.
  bool get isContainer() => this is IFrameworkContainer;

  /// Returns a boolean value indicting whether the object contains
  /// a [FrameworkProperty] by the given friendly [propertyName].
  bool hasProperty(String propertyName) =>
      _frameworkProperties.some((FrameworkProperty p) =>
          p.propertyName.toLowerCase() == propertyName.toLowerCase());


  /**
   *  A [Future] that returns a [FrameworkProperty] matching the given
   * [propertyName].
   *
   * Case Insensitive.
   */
  Future<FrameworkProperty> getPropertyByName(String propertyName){
    final c = new Completer();

    final m = buckshot.miriam.mirrorOf(this);

    var name = '';

    final found = m
                   .type
                   .variables
                   .getKeys()
                   .some((k){
                     if (!(k.endsWith('Property'))) return false;
                     final str = k.replaceAll('Property','').toLowerCase();
                     if (str == propertyName){
                       if (name != ''){
                         throw const BuckshotException('duplicate property names.');
                       }
                       name = k;
                       return true;
                     }else{
                       return false;
                     }
                     return str == propertyName;
                   });


    if (!found){
      c.complete(null);
    }else{
      m.getField(name).then((im){
        c.complete(im.reflectee);
      });
    }

    return c.future;
  }

  FrameworkProperty _getPropertyByName(String propertyName){
    Collection<FrameworkProperty> result =
        _frameworkProperties.filter((FrameworkProperty p) =>
            p.propertyName.toLowerCase() == propertyName.toLowerCase());

    if (result.length == 0) return null;
    return result.iterator().next();
  }

  /**
   * Returns a [FrameworkProperty] from a dot-notation [propertyNameChain].
   *
   * Throws a [FrameworkPropertyResolutionException] if any property cannot be resolved.
   *
   * Property name queries are case in-sensitive.
   *
   * ## Examples ##
   * * "background" - returns the 'background' FrameworkProperty of the root [BuckshotObject].
   * * "content.background" - returns the 'background' FrameworkProperty of the [BuckshotObject] assigned
   * to the 'content' property.
   *
   * As long as a property in the dot chain is a [BuckshotObject] then resolve() will continue
   * along until the last dot property is resolved, and then return it.
   */
  FrameworkProperty resolveProperty(String propertyNameChain){
    return BuckshotObject._resolvePropertyInternal(this, propertyNameChain.trim().split('.'));
  }

  FrameworkProperty resolveFirstProperty(String propertyNameChain){
    //TODO Make this a Future<FrameworkProperty> instead?
    return BuckshotObject._resolvePropertyInternal(
      this,
      [propertyNameChain.trim().split('.')[0]]
      );
  }

  static FrameworkProperty _resolvePropertyInternal(
                                    BuckshotObject currentObject,
                                    List<String> propertyChain){
    final prop = currentObject._getPropertyByName(propertyChain[0]);

    // couldn't resolve current property name to a property
    if (prop == null){
      db('property resolution err: ${propertyChain[0]}');
      throw new FrameworkPropertyResolutionException('Unable to resolve'
          ' FrameworkProperty: "${propertyChain[0]}".');
    }

    // Mmore properties in the chain, but cannot resolve further.
    // (NOTE!!!) Template parser will handle this exception in certain cases.
    // The Dart debugger currently stops on this exception even though it
    // is handled (reported).
    // TODO: Return null instead?
    if (prop.value is! BuckshotObject && propertyChain.length > 1)
      throw const FrameworkPropertyResolutionException('Unable to resolve'
          ' further.  Remaining properties in the chain while current property'
      ' value is not a BuckshotObject');

    // return the property if there are no further names to resolve or the property
    // is not a BuckshotObject
    if (prop.value is! BuckshotObject || propertyChain.length == 1) return prop;

    // recurse down to the next BuckshotObject and property name
    return _resolvePropertyInternal(prop.value, propertyChain.getRange(1, propertyChain.length - 1));

  }


  /*
   * Lowers = higher priority
   * Resources = 5
   * TemplateObject = 10
   * Core FrameworkElements = 15
   * Core Controls = 20
   * External Controls = 100
   */
  int _templatePriority() => 100;
}