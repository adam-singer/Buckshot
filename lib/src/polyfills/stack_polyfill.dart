// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
 * Polyfill for containers which represent a horizontal or vertical stack of
 * child elements, with each child having it's own alignment capability in the
 * cross-axis.
 */
class StackPolyfill extends Polyfill
{

  StackPolyfill(FrameworkElement stackElement) : super(stackElement);

  @override void invalidate(){

    log('invalidate stack polyfill', element:element, logLevel: Level.INFO);
  }

  /**
   * Sets the orientation of the stack panel.
   */
  set orientation(Orientation orientation){
    (element as FrameworkContainer)
      .content
      .forEach((e){
        e.rawElement.style.display =
          (orientation == Orientation.vertical)
            ? 'table'
            : 'inline-table';
      });

    invalidate();
  }
}
