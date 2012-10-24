part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Implements an [Exception] object for [IPresentationFormatProvider] operations.
*
* ## See Also
* * [BuckshotTemplateProvider]
*/
class TemplateException implements Exception
{
  final String _msg;

  const TemplateException(this._msg);

  String toString() => _msg == null ? 'TemplateException' : 'TemplateException: $_msg';
}
