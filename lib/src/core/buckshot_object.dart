// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Base class for all objects participating in the framework.
*/
class BuckshotObject extends HashableObject
{
  final HashMap<String, Dynamic> stateBag;
  final List<Binding> _bindings;
  final Set<FrameworkProperty> _frameworkProperties;
  final HashMap<String, FrameworkEvent> _bindableEvents;
  final HashMap<String, Function> _eventHandlers;

  BuckshotObject() :
    _frameworkProperties = new Set<FrameworkProperty>(),
    stateBag = new HashMap<String, Dynamic>(),
    _bindings = new List<Binding>(),
    _bindableEvents = new HashMap<String, FrameworkEvent>(),
    _eventHandlers = new HashMap<String, Function>();

  /// Gets a boolean value indicating whether the given object
  /// is a container or not.
  bool get isContainer => this is IFrameworkContainer;

  BuckshotObject.register() :
    _frameworkProperties = new Set<FrameworkProperty>(),
    stateBag = new HashMap<String, Dynamic>(),
    _bindings = new List<Binding>(),
    _bindableEvents = new HashMap<String, FrameworkEvent>(),
    _eventHandlers = new HashMap<String, Function>();
  
  /**
   * Registers an event for later lookup during template event binding
   * 
   * This will go away once Dart supports reflection on all platforms.
   */
  void registerEvent(String name, FrameworkEvent event){
    if (reflectionEnabled) return;
    _bindableEvents[name.toLowerCase()] = event;
  }
  
  void registerEventHandler(String name, func(sender, args)){
    if (reflectionEnabled) return;
    _eventHandlers[name.toLowerCase()] = func;
  }
  
  /**
   * Returns true if the given [eventName] is present.
   */
  bool hasEvent(String eventName)
  {
    if (!reflectionEnabled){
      return _bindableEvents.containsKey(eventName.toLowerCase());
    }
    
    bool hasEventInternal(classMirror){
      final result = classMirror
          .variables
          .getKeys()
          .some((k){
            if (k.startsWith('_')) return false;
            //TODO: provide a better checking here (= is FrameworkEvent)
            return '${eventName}' == k.toLowerCase();
          });

      if (result) return result;

      if (classMirror.superclass.simpleName != 'BuckshotObject'){
        return hasEventInternal(classMirror.superclass);
      }

      return false;
    }

    return hasEventInternal(buckshot.reflectMe(this).type);
  }

  abstract makeMe();
  
  /**
   * Returns a boolean value indicting whether the object contains
   * a [FrameworkProperty] by the given friendly [propertyName].
   */
  bool hasProperty(String propertyName){
    bool hasPropertyInternal(classMirror){
      final result = classMirror
          .variables
          .getKeys()
          .some((k){
            if (k.startsWith('_')) return false;
            //TODO: provide a better checking here (= is FrameworkProperty)
            return '${propertyName}property' == k.toLowerCase();
          });

      if (result) return result;

      if (classMirror.superclass.simpleName != 'BuckshotObject'){
        return hasPropertyInternal(classMirror.superclass);
      }

      return false;
    }

    if (reflectionEnabled){
      return hasPropertyInternal(buckshot.reflectMe(this).type);
    }else{
      final pLower = propertyName.toLowerCase();
      return _frameworkProperties.some((FrameworkProperty p) =>
              p.propertyName.toLowerCase() == pLower);
    }
  }


  Future<FrameworkProperty> getEventByName(String eventName){
    if (!reflectionEnabled){
      final c = new Completer();
      
      if (_bindableEvents.containsKey(eventName.toLowerCase())){
        c.complete(_bindableEvents[eventName.toLowerCase()]);
      }else{
        c.complete(null);
      }
      
      return c.future;
    }
    
    
    Future<FrameworkProperty> getEventNameInternal(String eventNameLowered,
        classMirror){
      final c = new Completer();

      var name = '';

      classMirror
      .variables
      .getKeys()
      .some((k){
        if (eventNameLowered == k.toLowerCase()){
          name = k;
          return true;
        }
        return false;
      });

      if (name == ''){
        if (classMirror.superclass.simpleName != 'BuckshotObject')
  //          && classMirror.superclass.simpleName != 'Object')
        {
          getEventNameInternal(eventNameLowered, classMirror.superclass)
            .then((result) => c.complete(result));
        }else{
          c.complete(null);
        }

      }else{
        buckshot.reflectMe(this)
          .getField(name)
          .then((im){
            c.complete(im.reflectee);
          });
      }

      return c.future;
    }

    return getEventNameInternal(eventName.toLowerCase(), 
        buckshot.reflectMe(this).type);
  }

  //TODO: Move a generalized version of this into Miriam
  /**
   *  A [Future] that returns a [FrameworkProperty] matching the given
   * [propertyName].
   *
   * Case Insensitive.
   */
  Future<FrameworkProperty> getPropertyByName(String propertyName){
    Future<FrameworkProperty> getPropertyNameInternal(String propertyName,
        classMirror){
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
          getPropertyNameInternal(propertyName, classMirror.superclass)
            .then((result) => c.complete(result));
        }else{
          c.complete(null);
        }

      }else{
        buckshot.reflectMe(this)
          .getField(name)
          .then((im){
            c.complete(im.reflectee);
          });
      }

      return c.future;
    }

    if (reflectionEnabled){
      return getPropertyNameInternal(propertyName.toLowerCase(),
          buckshot.reflectMe(this).type);
    }else{
      final cc = new Completer();
      final result = _frameworkProperties.filter((FrameworkProperty p) =>
              p.propertyName.toLowerCase() == propertyName.toLowerCase());

      if (result.length == 0)
        {
          cc.complete(null);
        }else{
          cc.complete(result.iterator().next());
        }
      
      return cc.future;
    }
  }

  FrameworkProperty _getPropertyByName(String propertyName){
    throw const NotImplementedException('Convert to async .getPropertyName()'
        ' instead.');
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
        print('>>> property resolution failed. obj: ${currentObject} chain: ${propertyChain}');
        c.complete(null);
      }else{
        // More properties in the chain, but cannot resolve further.
        if (prop.value is! BuckshotObject && propertyChain.length > 1){
          print('>>> property resolution failed. obj: ${currentObject} value: ${prop.value} chain: ${propertyChain}');
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
  
  String get safeName => '${toString()}${hashCode()}';
  
  String toString() => super
                        .toString()
                        .replaceFirst("Instance of '", '')
                        .replaceFirst("'", '');

}