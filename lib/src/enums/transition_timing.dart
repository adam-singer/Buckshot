part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

class TransitionTiming {
  const TransitionTiming(this._str);
  final String _str;
  
  static const linear = const TransitionTiming("linear");
  static const ease = const TransitionTiming("ease");
  static const easeIn = const TransitionTiming("ease-in");
  static const easeOut = const TransitionTiming("ease-out");
  static const easeInOut = const TransitionTiming("ease-in-out");
  static const cubicBezier = const TransitionTiming("cubic-bezier");
    
  String toString() => _str;
}
