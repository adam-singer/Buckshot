// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Event arguement class for the [ObservableList] listChanged [FrameworkEvent]. */
class ListChangedEventArgs<T> extends EventArgs{
  /// Represents a list of items that were removed from the List.
  final List<T> oldItems;
  /// Represents a list of items that were added to the List.
  final List<T> newItems;

  ListChangedEventArgs(this.oldItems, this.newItems){}

  BuckshotObject makeMe() => null;

  String get type() => "ListChangedEventArgs";
}