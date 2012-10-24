part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


/**
* A base class for all Panel-type elements.
*
* ## See Also
* * [Grid]
* * [LayoutCanvas]
* * [Stack]
* * [TreeView]
*/
class Panel extends FrameworkElement implements FrameworkContainer
{
  /// An observable list of the child elements associated with the panel.
  final ObservableList<FrameworkElement> children =
      new ObservableList<FrameworkElement>();

  static const String childHasParentExceptionMessage
  = "(Panel) Element is already child of another element.";

  /// Represents the background [Color] value of the panel.
  FrameworkProperty<Brush> background;

  Panel()
  {
    Browser.appendClass(rawElement, "Panel");

    stateBag[FrameworkObject.CONTAINER_CONTEXT] = children;

    background = new FrameworkProperty(
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

  Panel.register() : super.register();
  makeMe() => null;

  void onChildrenChanging(ListChangedEventArgs args){
    args.oldItems.forEach((item){
      item.parent = null;
    });

    args.newItems.forEach((item){
      assert(item.parent == null);
      item.parent = this;
    });
  }

  // IFrameworkContainer interface
  get containerContent => children;

  /// Overridden [FrameworkObject] method.
  void createElement(){
    rawElement = new DivElement();
    rawElement.style.overflow = "hidden";
  }

}
