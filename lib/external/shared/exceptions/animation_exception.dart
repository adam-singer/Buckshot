// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

class AnimationException implements Exception {

  final String _msg;
  
  const AnimationException(this._msg);
  
  String toString() => _msg === null ? 'AnimationException' : 'AnimationException: $_msg';
}
