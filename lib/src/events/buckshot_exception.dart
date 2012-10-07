// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


/**
* Implements a general framework [Exception] object. */
class BuckshotException implements Exception
{
  final String _msg;
  
  const BuckshotException(this._msg);
  
  String toString() => _msg === null ? 'BuckshotException' : 'BuckshotException: $_msg';
}


