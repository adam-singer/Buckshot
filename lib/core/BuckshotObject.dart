// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Base class for all objects participating in the framework.
*/
class BuckshotObject extends HashableObject{
  final HashMap<String, Dynamic> _stateBag;
  final List<Binding> _bindings;
  final Set<FrameworkProperty> _frameworkProperties;

  BuckshotObject():
    _stateBag = new HashMap<String, Dynamic>(),
    _bindings = new List<Binding>(),
    _frameworkProperties = new Set<FrameworkProperty>();

  /// Factory method for creating derived BuckshotObjects.
  abstract BuckshotObject makeMe();

  /// Gets the stateBag [HashMap<String, Dynamic>] for the object.
  HashMap<String, Dynamic> get stateBag() => _stateBag;

  /// Gets a boolean value indicating whether the given object
  /// is a container or not.
  bool get isContainer() => this is IFrameworkContainer;

  /// Returns a boolean value indicting whether the object contains
  /// a [FrameworkProperty] by the given friendly [propertyName].
  bool hasProperty(String propertyName) =>
      _frameworkProperties.some((FrameworkProperty p) =>
          p.propertyName.toLowerCase() == propertyName.toLowerCase());

  /// A [Future] that returns a [FrameworkProperty] matching the given
  /// [propertyName].
  Future<FrameworkProperty> getPropertyByName(String propertyName) =>
      _functionToFuture(() => _getPropertyByName(propertyName));

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
    //TODO Make this a Future<FrameworkProperty> instead?
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
    FrameworkProperty prop = currentObject._getPropertyByName(propertyChain[0]);

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
    if (!(prop.value is BuckshotObject) || propertyChain.length == 1) return prop;

    // recurse down to the next BuckshotObject and property name
    return _resolvePropertyInternal(prop.value, propertyChain.getRange(1, propertyChain.length - 1));
  }

  String safeName(String name) => '${name}${hashCode()}';

  abstract String get type();

  String toString() => type;
}