// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
 * Enumerates alignment locations for controls such as [DockPanel].
 */
class DockLocation {
  final String _str;
  
  const DockLocation(this._str);
  
  static final top = const DockLocation('top');
  static final bottom = const DockLocation('bottom');
  static final left = const DockLocation('left');
  static final right = const DockLocation('right');
  
  String toString() => _str;
}
