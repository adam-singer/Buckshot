part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn
// See LICENSE file for Apache 2.0 licensing information.

/**
* Override base class for the native hashCode() function, which is
* currently too slow. */
class HashableObject
{
  static int _hashNum = 0;
  final int _assignedHash;

  HashableObject() : _assignedHash = HashableObject._hashNum++;

  int get hashCode => _assignedHash;

}