// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Implements an [Exception] object for [IPresentationFormatProvider] operations.
*
* ## See Also
* * [BuckshotTemplateProvider]
*/
class PresentationProviderException implements Exception
{
  final String _msg;
  
  const PresentationProviderException(this._msg);
  
  String toString() => _msg === null ? 'PresentationProviderException' : 'PresentationProviderException: $_msg';
}
