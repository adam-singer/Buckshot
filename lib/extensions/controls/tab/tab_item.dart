// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

class TabItem extends Control
{
  FrameworkProperty headerProperty;
  
  TabItem(){
    Browser.appendClass(rawElement, "TabItem"); 
    
    _initTabItemProperties();
  }
   
  TabItem.register();
  makeMe() => new TabItem();
  
  void _initTabItemProperties(){
    headerProperty = new FrameworkProperty(this, 'header', defaultValue:'Hi');
  }
}
