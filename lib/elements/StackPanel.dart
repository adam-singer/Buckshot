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
    Dom.appendBuckshotClass(rawElement, "stackpanel");
    orientationProperty = new FrameworkProperty(
      this,
      "orientation",
      (Orientation value){
        Dom.setFlexBoxOrientation(this, value);
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
    Dom.makeFlexBox(this);
    //rawElement.style.flexFlow = 'column';
    rawElement.style.overflow = 'hidden';
  }

  void updateLayout(){
    Dom.setVerticalFlexBoxAlignment(this, VerticalAlignment.top);
    Dom.setHorizontalFlexBoxAlignment(this, HorizontalAlignment.left);
    if (orientation == Orientation.vertical){
      children.forEach((child){
        Dom.setXPCSS(child.rawElement, 'flex', 'none');
        Dom.setHorizontalItemFlexAlignment(child, child.hAlign);
      });
    }else{
      children.forEach((child){
        Dom.setXPCSS(child.rawElement, 'flex', 'none');
        Dom.setVerticalItemFlexAlignment(child, child.vAlign);      
      });
    }
  }

  String get type() => "StackPanel";
}
