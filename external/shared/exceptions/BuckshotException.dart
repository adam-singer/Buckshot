// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


/**
* Implements a general framework [Exception] object. */
class BuckshotException extends ExceptionBase
{
  const BuckshotException([var msg]);
  
  String get type() => "FrameworkException";
}


