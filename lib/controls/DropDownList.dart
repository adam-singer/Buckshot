// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


/**
* A control for displaying a list of items (and corresponding values) in a drop down pick list.
*/
class DropDownList extends Control
{
  FrameworkProperty itemsProperty;
  FrameworkProperty itemsSourceProperty;
  FrameworkProperty selectedItemProperty;
  FrameworkProperty selectedIndexProperty; //TODO implement this property
  
  FrameworkEvent<SelectedItemChangedEventArgs<DropDownListItem>> selectionChanged;
    
  DropDownList()
  :
    selectionChanged = new FrameworkEvent<SelectedItemChangedEventArgs<DropDownListItem>>()
  {
    Browser.appendClass(rawElement, "dropdownlist");
    _initDropDownListProperties();
  }
  
  void _initDropDownListProperties(){
    itemsProperty = new FrameworkProperty(this, "items", (ObservableList<DropDownListItem> v){}, new ObservableList<DropDownListItem>());
    
    itemsSourceProperty = new FrameworkProperty(this, "itemsSource", (List<String> v){
      _updateDDL();
    });   
    
    selectedItemProperty = new FrameworkProperty(this, "selectedItem", (DropDownListItem v){}, new DropDownListItem());
    
    items.listChanged + (_, __) {
      if (!_isLoaded) return;
      _updateDDL();
    };
        
    void doNotify(){
      DropDownListItem selected;
      
      if (itemsSource != null && !itemsSource.isEmpty()) {
        selectedItemProperty.value.name = itemsSource[rawElement.dynamic.selectedIndex];
        selectedItemProperty.value.value = itemsSource[rawElement.dynamic.selectedIndex];
        selected = selectedItemProperty.value;
      }else if (!items.isEmpty()){
        selected = items[rawElement.dynamic.selectedIndex];
        selectedItemProperty.value.name = selected.name;
        selectedItemProperty.value.value = selected.value;
      }    
      
      if (selected != null) selectionChanged.invoke(this, new SelectedItemChangedEventArgs<DropDownListItem>(selected));
    }
    
    this.loaded + (_, __){
      _updateDDL();
      doNotify();
    };
    
    rawElement.on.change.add((e) => doNotify());
  }
  
  void _updateDDL(){
    rawElement.elements.clear();
    
    if (itemsSource != null){
      itemsSource.forEach((i){
        var option = new OptionElement();
        option.attributes['value'] = '$i';
        option.text = '$i';
        rawElement.elements.add(option);
      });
      
    }else{
      items.forEach((DropDownListItem i){
        var option = new OptionElement();
        option.attributes['value'] = i.value;
        option.text = i.name;
        
        rawElement.elements.add(option);
      }); 
    }
  }
  
  DropDownListItem get selectedItem() => getValue(selectedItemProperty);
  
  List<String> get itemsSource() => getValue(itemsSourceProperty);
  
  ObservableList<DropDownListItem> get items() => getValue(itemsProperty);
  
  /// Overridden [BuckshotObject] method.
  BuckshotObject makeMe() => new DropDownList();
  
  /// Overridden [FrameworkObject] method for generating the html representation of the DDL.
  void createElement(){
    rawElement = new Element.tag('select');
  }
    
  String get type() => "DropDownList";
}


class DropDownListItem extends BuckshotObject
{
  FrameworkProperty nameProperty;
  FrameworkProperty valueProperty;
  
  DropDownListItem(){
    _initDropDownListItemProperties();
  }
  
  /// Overridden [BuckshotObject] method.
  BuckshotObject makeMe() => new DropDownListItem();
  
  void _initDropDownListItemProperties(){
    nameProperty = new FrameworkProperty(this, "name", (String v){}, '');
    
    valueProperty = new FrameworkProperty(this, "value", (Dynamic v){}, null);
  }
  
  String get name() => getValue(nameProperty);
  set name(String v) => setValue(nameProperty, v);
  
  Dynamic get value() => getValue(valueProperty);
  set value(Dynamic v) => setValue(valueProperty, v);
  
  
  String get type() => "DropDownListItem";
}