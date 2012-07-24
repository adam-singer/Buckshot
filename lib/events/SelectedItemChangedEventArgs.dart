// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Provides a generic EventArgs class for [FrameworkElement]s that need
* to notify when an item selection has changed.
*
* ## See Also
* * [DropDownList]
*/
class SelectedItemChangedEventArgs<T> extends EventArgs {
  final T selectedItem;
  
  SelectedItemChangedEventArgs(this.selectedItem){}
}
