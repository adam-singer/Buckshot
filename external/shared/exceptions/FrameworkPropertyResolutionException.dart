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
  /// The description of the exception that occurred.
  final String message;

  const FrameworkPropertyResolutionException(String this.message);
}
