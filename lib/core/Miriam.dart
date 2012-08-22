// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#library('utils.buckshotui.org');

#import('dart:mirrors');


/**
 * Reflection and Mirror Utilities for Buckshot.
 */
class Miriam
{
  final MirrorSystem _mirror;
  static Map<String, ClassMirror> _mirrorCache;

  MirrorSystem get mirror() => _mirror;

  Miriam()
      :
        _mirror = currentMirrorSystem(){
        if (_mirrorCache == null){
          _mirrorCache = {};
        }
      }

  /**
   * Returns a new instance of a given object using it's default constructor
   */
  newInstanceOf(Object object){
    throw const NotImplementedException();
  }

  mirrorOf(object) => reflect(object);

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
