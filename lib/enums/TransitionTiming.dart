
class TransitionTiming {
  const TransitionTiming(this._str);
  final String _str;
  
  static final linear = const TransitionTiming("linear");
  static final ease = const TransitionTiming("ease");
  static final easeIn = const TransitionTiming("ease-in");
  static final easeOut = const TransitionTiming("ease-out");
  static final easeInOut = const TransitionTiming("ease-in-out");
  static final cubicBezier = const TransitionTiming("cubic-bezier");
    
  String toString() => _str;
}
