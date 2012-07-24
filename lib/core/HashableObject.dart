// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


#library('shared.buckshotui.org');

/**
* Base class for any type that needs to be [Hashable]. */
class HashableObject implements Hashable
{
  static int _hashNum = 0;
  final int _assignedHash;
  
  HashableObject() : _assignedHash = HashableObject._hashNum++
  {}
  
  int hashCode() => _assignedHash;
  
}