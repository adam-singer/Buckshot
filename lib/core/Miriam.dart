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

  MirrorSystem get mirror() => _mirror;

  Miriam()
      : _mirror = currentMirrorSystem();

  /**
   * Returns a new instance of a given object using it's default constructor
   */
  newInstanceOf(Object object){
    throw const NotImplementedException();
  }

  /**
   * Returns true if a given [InterfaceMirror] derives from any
   * of the given [classNames].  This function will walk up the
   * inheritance tree until it either finds a match or reaches
   * [Object]
   */
  bool derivesFrom(InterfaceMirror im, List<String> classNames){
    if (classNames.indexOf(im.simpleName) > -1) return true;
    if (im.superclass() == null || im.superclass().simpleName == 'Object') return false;

    return derivesFrom(im.superclass(), classNames);
  }

  /**
   * Returns the InterfaceMirror of a given [name] by searching through all
   * available in-scope libraries.
   *
   * Case insensitive.
   *
   * Returns null if not found.
   */
  InterfaceMirror getObjectByName(String name){

    final lowerName = name.toLowerCase();
    var result;

    _mirror
      .libraries()
      .forEach((String lName, LibraryMirror libMirror){
        libMirror
          .classes()
          .forEach((String cName, InterfaceMirror classMirror){
            if (classMirror.simpleName.toLowerCase() == lowerName){
              result = classMirror;
            }
          });
      });

    return result;
  }


  /**
  * Returns a list of Futures for any Types where the type subclasses from
  * the given list [subclassingFrom].  Optionally, may further restrict the
  * query by providing a list of library names. */
  List<Future> getInstancesOf(List<String> subclassingFrom,
      [List<String> onlyFromLibraries]){
    var flist = [];

    _mirror.libraries().forEach((String lName, LibraryMirror libMirror){
      libMirror.classes().forEach((String cName, InterfaceMirror classMirror){

        if(derivesFrom(classMirror, subclassingFrom))
        {
          print('registering ${classMirror}!');
          flist.add(classMirror.newInstance('', []));
        }
      });
    });

    return flist;
  }
}
