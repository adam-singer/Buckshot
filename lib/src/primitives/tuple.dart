// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Represents a pair of like values. */
class Tuple<T1, T2>
{
  final T1 first;
  final T2 second;
  
  const Tuple(this.first, this.second);
}