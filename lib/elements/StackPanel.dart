// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Provides a container that stacks child elements vertically or horizontally. */
class StackPanel extends Panel
{
  FrameworkProperty orientationProperty;

  FrameworkObject makeMe() => new StackPanel();

  StackPanel()
  {
    Browser.appendClass(rawElement, "stackpanel");
    orientationProperty = new FrameworkProperty(
      this,
      "orientation",
      (Orientation value){
        Browser.setFlexBoxOrientation(rawElement, value);
      },
      Orientation.vertical, converter:new StringToOrientationConverter());
  }

  void onChildrenChanging(ListChangedEventArgs args){
    super.onChildrenChanging(args);

    if (!args.oldItems.isEmpty()){
      args.oldItems.forEach((FrameworkElement element){
        element.removeFromLayoutTree();
      });
    }

    if (!args.newItems.isEmpty()){
      args.newItems.forEach((FrameworkElement element){
        element.addToLayoutTree(this);
      });
    }
  }

  set orientation(Orientation value) => setValue(orientationProperty, value);
  Orientation get orientation() => getValue(orientationProperty);

  void createElement(){
    rawElement = new DivElement();
    Browser.makeFlexBox(rawElement);
    //rawElement.style.flexFlow = 'column';
    rawElement.style.overflow = 'hidden';
  }

  void updateLayout(){
    Browser.setVerticalFlexBoxAlignment(rawElement, VerticalAlignment.top);
    Browser.setHorizontalFlexBoxAlignment(rawElement, HorizontalAlignment.left);
    if (orientation == Orientation.vertical){
      children.forEach((child){
        Browser.setXPCSS(child.rawElement, 'flex', 'none');
        Browser.setHorizontalItemFlexAlignment(child.rawElement, child.hAlign);
      });
    }else{
      children.forEach((child){
        Browser.setXPCSS(child.rawElement, 'flex', 'none');
        Browser.setVerticalItemFlexAlignment(child.rawElement, child.vAlign);      
      });
    }
  }

  String get type() => "StackPanel";
}
