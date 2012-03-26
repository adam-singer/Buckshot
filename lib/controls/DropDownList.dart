//   Copyright (c) 2012, John Evans & LUCA Studios LLC
//
//   http://www.lucastudios.com/contact
//   John: https://plus.google.com/u/0/115427174005651655317/about
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.


/**
* A control for displaying a list of items (and corresponding values) in a drop down pick list.
*/
class DropDownList extends Control
{
  FrameworkProperty itemsProperty;
  FrameworkProperty itemsSourceProperty;
  FrameworkProperty selectedItemProperty;
  
  FrameworkEvent<SelectedItemChangedEventArgs<DropDownListItem>> selectionChanged;
  
  DropDownList()
  :
    selectionChanged = new FrameworkEvent<SelectedItemChangedEventArgs<DropDownListItem>>()
  {
      _Dom.appendBuckshotClass(_component, "dropdownlist");
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
        selectedItemProperty.value.name = itemsSource[_component.dynamic.selectedIndex];
        selectedItemProperty.value.value = itemsSource[_component.dynamic.selectedIndex];
        selected = selectedItemProperty.value;
      }else if (!items.isEmpty()){
        selected = items[_component.dynamic.selectedIndex];
        selectedItemProperty.value.name = selected.name;
        selectedItemProperty.value.value = selected.value;
      }    
      
      if (selected != null) selectionChanged.invoke(this, new SelectedItemChangedEventArgs<DropDownListItem>(selected));
    }
    
    this.loaded + (_, __){
      _updateDDL();
      doNotify();
    };
    
    _component.on.change.add((e) => doNotify());
  }
  
  void _updateDDL(){
    _component.elements.clear();
    
    if (itemsSource != null){
      itemsSource.forEach((i){
        var option = _Dom.createByTag('option');
        option.attributes['value'] = '$i';
        option.text = '$i';
        _component.elements.add(option);
      });
      
    }else{
      items.forEach((DropDownListItem i){
        var option = _Dom.createByTag('option');
        option.attributes['value'] = i.value;
        option.text = i.name;
        
        _component.elements.add(option);
      }); 
    }
  }
  
  DropDownListItem get selectedItem() => getValue(selectedItemProperty);
  
  List<String> get itemsSource() => getValue(itemsSourceProperty);
  
  ObservableList<DropDownListItem> get items() => getValue(itemsProperty);
  
  /// Overridden [BuckshotObject] method.
  BuckshotObject makeMe() => new DropDownList();
  
  /// Overridden [FrameworkObject] method for generating the html representation of the DDL.
  void CreateElement(){
    _component = _Dom.createByTag('select');
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