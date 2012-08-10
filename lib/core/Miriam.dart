// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#library('utils.buckshotui.org');

#import('dart:mirrors');


/**
 * Reflection and Mirror Utilities.
 */
class Miriam
{
  final MirrorSystem _mirror;

  MirrorSystem get mirror() => _mirror;

  Miriam()
      : _mirror = currentMirrorSystem();

  /**
   * Returns true if a given [InterfaceMirror] derives from any
   * of the given [classNames].  This function will walk up the
   * inheritance tree until it either finds a match or reaches
   * [Object]
   */
  bool derivesFrom(InterfaceMirror im, List<String> classNames){
    if (classNames.indexOf(im.simpleName) > -1) return true;
    if (im.superclass().simpleName == 'Object') return false;
    return derivesFrom(im.superclass(), classNames);
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
          flist.add(classMirror.newInstance('',[]));
        }
      });
    });

    return flist;
  }
}
