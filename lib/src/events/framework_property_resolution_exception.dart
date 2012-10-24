part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Represents an [Exception] object that is throwing during failed attempts
* to resolve a property from a dot-notation string.
*
* See [LucaObject] resolveProperty() method.
*/
class FrameworkPropertyResolutionException implements Exception
{
  final String _msg;
  
  const FrameworkPropertyResolutionException(this._msg);
  
  String toString() => _msg == null ? 'FrameworkPropertyResolutionException' : 'FrameworkPropertyResolutionException: $_msg';
}
