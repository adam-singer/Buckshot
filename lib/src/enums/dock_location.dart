// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
 * Enumerates alignment locations for controls such as [DockPanel].
 */
class DockLocation {
  final String _str;
  
  const DockLocation(this._str);
  
  static const top = const DockLocation('top');
  static const bottom = const DockLocation('bottom');
  static const left = const DockLocation('left');
  static const right = const DockLocation('right');
  
  String toString() => _str;
}
