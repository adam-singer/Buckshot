// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


class ExceptionBase implements Exception{
  /// Description of the exception that occured.
 
  const ExceptionBase([var msg]);
  
  String get type() => "ExceptionBase";
}