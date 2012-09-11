// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

class TabItem extends Control implements IFrameworkContainer
{
  FrameworkProperty headerProperty;
  FrameworkProperty iconProperty;
  FrameworkProperty closeEnabledProperty;
  FrameworkProperty closeButtonVisiblityProperty;
  FrameworkProperty contentProperty;
  
  FrameworkElement _visualTemplate;
  
  TabItem(){
    Browser.appendClass(rawElement, "TabItem"); 
        
    _initTabItemProperties();
    
    stateBag[FrameworkObject.CONTAINER_CONTEXT] = contentProperty;
  }
   
  TabItem.register();
  makeMe() => new TabItem();
  
  get content => getValue(contentProperty);
  
  void _initTabItemProperties(){
    headerProperty = new FrameworkProperty(this, 'header');
    
    iconProperty = new FrameworkProperty(this, 'icon');
    
    contentProperty = new FrameworkProperty(this, 'content', 
        defaultValue: 'hello johnny');
    
    closeButtonVisiblityProperty = new FrameworkProperty(this, 
        'closeButtonVisibility',
        propertyChangedCallback: (Visibility value){
          if (value == Visibility.visible 
              && getValue(closeEnabledProperty) == false){
            setValue(closeButtonVisiblityProperty, Visibility.collapsed);
          }
        },
        defaultValue: Visibility.collapsed,
        converter: const StringToVisibilityConverter());
    
    closeEnabledProperty = new FrameworkProperty(this, 'closeEnabled',
        propertyChangedCallback: (bool value){
          if (value == false){
            setValue(closeButtonVisiblityProperty, Visibility.collapsed);          
          }
        },
        defaultValue: true,
        converter: const StringToBooleanConverter());
  }
}
