/**
* Enumerates game states. */
class GameState {
  final int _val;
  
  const GameState(this._val);
  
  static final playing = const GameState(1);
  static final paused = const GameState(2);
}
