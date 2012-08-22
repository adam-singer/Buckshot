// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


/**
* A base class for all Panel-type elements.
*
* ## See Also
* * [Grid]
* * [LayoutCanvas]
* * [StackPanel]
* * [TreeView]
*/
class Panel extends FrameworkElement implements IFrameworkContainer {
  /// An observable list of the child elements associated with the panel.
  final ObservableList<FrameworkElement> children;
  static final String childHasParentExceptionMessage
  = "Element is already child of another element.";

  /// Represents the background [Color] value of the panel.
  FrameworkProperty backgroundProperty;

  Panel()
  : children = new ObservableList<FrameworkElement>()
  {
    Browser.appendClass(rawElement, "Panel");

    stateBag[FrameworkObject.CONTAINER_CONTEXT] = children;

    backgroundProperty = new FrameworkProperty(
      this,
      "background",
      (Brush value){
        if (value == null){
          rawElement.style.background = "None";
          return;
        }
        value.renderBrush(rawElement);
      }, converter:const StringToSolidColorBrushConverter());

    children.listChanged + (_, args) => onChildrenChanging(args);
  }

  void onChildrenChanging(ListChangedEventArgs args){
    args.oldItems.forEach((item){
      item.parent = null;
    });

    args.newItems.forEach((item){
      if (item.parent != null){
        throw const BuckshotException(childHasParentExceptionMessage);
      }
      item.parent = this;
    });
  }

  // IFrameworkContainer interface
  get content() => children;

  /// Sets the [backgroundProperty] value.
  set background(Brush value) => setValue(backgroundProperty, value);
  /// Gets the [backgroundProperty] value.
  Brush get background() => getValue(backgroundProperty);

  /// Overridden [FrameworkObject] method.
  void createElement(){
    rawElement = new DivElement();
    rawElement.style.overflow = "hidden";
  }

}
