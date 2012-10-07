// Copyright (c) 2012, John Evans
// https://github.com/prujohn
// See LICENSE file for Apache 2.0 licensing information.

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