// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Event arguements supporting routable events. */
class RoutedEventArgs extends EventArgs{
  bool cancelBubble = false;
  
  String get _type() => "RoutedEventArgs";
}

//TODO **************** Not yet implemented.
