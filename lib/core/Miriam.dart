// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#library('utils.buckshotui.org');

#import('dart:mirrors');


/**
 * Reflection and Mirror Utilities for Buckshot.
 *
 * This is a singleton class, easily referenced through
 * the [Miriam.context] getter.
 */
class Miriam
{
  final MirrorSystem _mirror;
  static Map<String, ClassMirror> _mirrorCache;

  MirrorSystem get mirror() => _mirror;
  static Miriam _ref;

  static Miriam get context() => new Miriam();

  factory Miriam()
  {
    if (_ref != null) return _ref;

    _ref = new Miriam._internal();
    return _ref;
  }

  Miriam._internal()
        :
        _mirror = currentMirrorSystem(){
          if (_mirrorCache == null){
            _mirrorCache = {};
          }
  }

  /**
   * Returns true if a given [ClassMirror] derives from any
   * of the given [classNames].  This function will walk up the
   * inheritance tree until it either finds a match or reaches
   * [Object]
   */
  bool derivesFrom(ClassMirror im, List<String> classNames){
    if (classNames.indexOf(im.simpleName) > -1) return true;
    if (im.superclass == null ||
        im.superclass.simpleName == 'Object') return false;

    return derivesFrom(im.superclass, classNames);
  }

  /**
   * Returns the InterfaceMirror of a given [name] by searching through all
   * available in-scope libraries.
   *
   * Case insensitive.
   *
   * Returns null if not found.
   */
  ClassMirror getObjectByName(String name){

    final lowerName = name.toLowerCase();

    if (_mirrorCache.containsKey(lowerName)){
      //print('[Miriam] Returning cached mirror of "$lowerName"');
      return _mirrorCache[lowerName];
    }

    var result;

    _mirror
      .libraries
      .forEach((String lName, LibraryMirror libMirror){
        libMirror
          .classes
          .forEach((String cName, ClassMirror classMirror){
            if (classMirror.simpleName.toLowerCase() == lowerName){
              result = classMirror;
            }
          });
      });

    if (result != null){
      //cache result;
      //print('[Miriam] caching mirror "$lowerName"');
      _mirrorCache[lowerName] = result;
    }

    return result;
  }
}
