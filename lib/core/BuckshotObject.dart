// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Base class for all objects participating in the framework.
*/
class BuckshotObject extends HashableObject{
  final HashMap<String, Dynamic> stateBag;
  final List<Binding> _bindings;

  //TODO: remove once reflection handles all FrameworkProperty resolution
//  final Set<FrameworkProperty> _frameworkProperties;

  BuckshotObject():
    stateBag = new HashMap<String, Dynamic>(),
    _bindings = new List<Binding>();
//    _frameworkProperties = new Set<FrameworkProperty>();

  /// Gets a boolean value indicating whether the given object
  /// is a container or not.
  bool get isContainer() => this is IFrameworkContainer;

  /// Returns a boolean value indicting whether the object contains
  /// a [FrameworkProperty] by the given friendly [propertyName].
  bool hasProperty(String propertyName){
    bool hasPropertyInternal(classMirror, propertyName){
      final result = classMirror
          .variables
          .getKeys()
          .some((k){
            return '${propertyName}property' == k.toLowerCase();
          });

      if (result) return result;

      if (classMirror.superclass.simpleName != 'BuckshotObject'){
        return hasPropertyInternal(classMirror.superclass, propertyName);
      }

      return false;
    }

    return hasPropertyInternal(buckshot.miriam.mirrorOf(this).type, propertyName);
  }
//      _frameworkProperties.some((FrameworkProperty p) =>
//          p.propertyName.toLowerCase() == propertyName.toLowerCase());


  /**
   *  A [Future] that returns a [FrameworkProperty] matching the given
   * [propertyName].
   *
   * Case Insensitive.
   */
  Future<FrameworkProperty> getPropertyByName(String propertyName){
    return _getPropertyNameInternal(propertyName.toLowerCase(), buckshot.miriam.mirrorOf(this).type);
  }

  Future<FrameworkProperty> _getPropertyNameInternal(String propertyName, classMirror){
    final c = new Completer();

    if (this is DataTemplate){
      c.complete((this as DataTemplate).getProperty(propertyName));
      return c.future;
    }

    var name = '';

    classMirror
      .variables
      .getKeys()
      .some((k){
        if ('${propertyName}property' == k.toLowerCase()){
          name = k;
          return true;
        }
        return false;
      });


    if (name == ''){
      if (classMirror.superclass.simpleName != 'BuckshotObject')
//          && classMirror.superclass.simpleName != 'Object')
      {
        _getPropertyNameInternal(propertyName, classMirror.superclass)
          .then((result) => c.complete(result));
      }else{
        c.complete(null);
      }

    }else{
      buckshot.miriam.mirrorOf(this)
        .getField(name)
        .then((im){
          c.complete(im.reflectee);
        });
    }

    return c.future;
  }

  FrameworkProperty _getPropertyByName(String propertyName){
    throw const NotImplementedException('Convert to async .getPropertyName()'
        ' instead.');
//    Collection<FrameworkProperty> result =
//        _frameworkProperties.filter((FrameworkProperty p) =>
//            p.propertyName.toLowerCase() == propertyName.toLowerCase());
//
//    if (result.length == 0) return null;
//    return result.iterator().next();
  }


  /**
   * Returns a [Future][FrameworkProperty] from a
   * dot-notation [propertyNameChain].
   *
   * Property name queries are case in-sensitive.
   *
   * ## Examples ##
   * * "background" - returns the 'background' FrameworkProperty of
   *  the root [BuckshotObject].
   * * "content.background" - returns the 'background' FrameworkProperty of
   * the [BuckshotObject] assigned to the 'content' property.
   *
   * As long as a property in the dot chain is a [BuckshotObject] then
   * resolveProperty() will continue along until the last dot property is
   * resolved, and then return it via a [Future].
   */
  Future<FrameworkProperty> resolveProperty(String propertyNameChain){
    return BuckshotObject
              ._resolvePropertyInternal(this,
                  propertyNameChain.trim().split('.'));
  }

  /**
   * Returns a [Future][FrameworkProperty] from the first property mentioned
   * in a dot-notation [propertyNameChain].
   *
   * Property name queries are case in-sensitive.
   *
   * ## Examples ##
   * * "background" - returns the 'background' FrameworkProperty of
   *  the root [BuckshotObject].
   * * "content.background" - returns the 'content' FrameworkProperty.
   */
  Future<FrameworkProperty> resolveFirstProperty(String propertyNameChain){
    return BuckshotObject._resolvePropertyInternal(
      this,
      [propertyNameChain.trim().split('.')[0]]
      );
  }

  static Future<FrameworkProperty> _resolvePropertyInternal(
                                    BuckshotObject currentObject,
                                    List<String> propertyChain){
    final c = new Completer();

    currentObject.getPropertyByName(propertyChain[0]).then((prop){
      // couldn't resolve current property name to a property
      if (prop == null){
        c.complete(null);
      }else{
        // More properties in the chain, but cannot resolve further.
        if (prop.value is! BuckshotObject && propertyChain.length > 1){
          c.complete(null);
        }else{
          // return the property if there are no further names to resolve or
          // the property is not a BuckshotObject
          if (prop.value is! BuckshotObject || propertyChain.length == 1){
            c.complete(prop);
          }else{
            // recurse down to the next BuckshotObject and property name
            _resolvePropertyInternal(prop.value,
                propertyChain.getRange(1, propertyChain.length - 1))
            .then((result) => c.complete(result));
          }
        }
      }
    });

    return c.future;
  }
}