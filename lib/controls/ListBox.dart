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
* A control that provides a scrollable list of selectable items.
*/
class ListBox extends Control implements IFrameworkContainer
{
  FrameworkProperty horizontalScrollEnabledProperty;
  FrameworkProperty verticalScrollEnabledProperty;
  FrameworkProperty selectedItemProperty;
  /// Represents the [Panel] element which will contain the generated UI for
  /// each element of the collection.
  FrameworkProperty presentationPanelProperty;
  
  /// Represents the UI that will display for each item in the collection.
  FrameworkProperty itemsTemplateProperty;
  
  CollectionPresenter _presenter;
  
  int _selectedIndex = -1;
  
  final FrameworkEvent<SelectedItemChangedEventArgs> selectionChanged;
  
  int get selectedIndex() => _selectedIndex;
  
  /// Overridden [BuckshotObject] method.
  FrameworkObject makeMe() => new ListBox();
  
  ListBox()
  :
    selectionChanged = new FrameworkEvent<SelectedItemChangedEventArgs>()
  {
    _Dom.appendBuckshotClass(_component, "listbox"); 
    
    _initListBoxProperties();
    
//    this._component.style.border = "solid black 1px";

    //applyVisualTemplate() is called before the constructor
    //so we expect template to be assigned
    if (template == null)
      throw const FrameworkException('control template was not found.');
    
    _presenter = Buckshot.findByName("__buckshot_listbox_presenter__", template);
    
    if (_presenter == null)
      throw const FrameworkException('element not found in control template');
        
    _presenter.itemCreated + _OnItemCreated;
    
    // selectionChanged + (_, args) => print('Selected ${args.selectedItem} at index: $selectedIndex');
  }
  
      
  String get defaultControlTemplate() {
    return 
    '''<controltemplate controlType="${this.templateName}">
          <template>
            <border bordercolor=Black 
                    borderthickness=1 
                    horizontalScrollEnabled="{template horizontalScrollEnabled}" 
                    verticalScrollEnabled="{template verticalScrollEnabled}">
                <collectionPresenter name="__buckshot_listbox_presenter__" 
                                      horizontalAlignment=stretch>
                </collectionPresenter>
            </border>
          </template>
        </controltemplate>
    ''';
  }
    
  void _OnItemCreated(sender, ItemCreatedEventArgs args){
    FrameworkElement item = args.itemCreated;
        
    item.click + (_, __) {
      
      _selectedIndex = _presenter.presentationPanel.children.indexOf(item);
      
      setValue(selectedItemProperty, item._stateBag[CollectionPresenter._SBO]);
      
      selectionChanged.invoke(this, new SelectedItemChangedEventArgs(item._stateBag[CollectionPresenter._SBO]));
          
    };
    
    item.mouseEnter + (_, __) => onItemMouseEnter(item);
    
    item.mouseLeave + (_, __) => onItemMouseLeave(item);
    
    item.mouseDown + (_, __) => onItemMouseDown(item);
    
    item.mouseUp + (_, __) => onItemMouseUp(item);
  }
  
  get content() => template;
  
  void onItemMouseDown(item){
    if (item.hasProperty("background")){
      item.dynamic.background = new SolidColorBrush(new Color.predefined(Colors.SkyBlue));
    }
  }
  
  void onItemMouseUp(item){
    if (item.hasProperty("background")){
      item.dynamic.background = new SolidColorBrush(new Color.predefined(Colors.PowderBlue));
    }
  }
  
  /// Override this method to implement your own mouse over behavior for items in
  /// the ListBox.
  void onItemMouseEnter(FrameworkElement item){
    if (item.hasProperty("background")){
      item._stateBag["__lb_item_bg_brush__"] = item.dynamic.background;
      item.dynamic.background = new SolidColorBrush(new Color.predefined(Colors.PowderBlue));
    }
  }
  
  /// Override this method to implement your own mouse out behavior for items in
  /// the ListBox.
  void onItemMouseLeave(FrameworkElement item){
    if (item._stateBag.containsKey("__lb_item_bg_brush__")){
      item.dynamic.background = item._stateBag["__lb_item_bg_brush__"];
    }
  }
  
  
  void _initListBoxProperties(){
    
    selectedItemProperty = new FrameworkProperty(this, "selectedItem", (_){});
    
    presentationPanelProperty = new FrameworkProperty(this, "presentationPanel", (Panel p){
      if (_presenter == null) return;
      _presenter.presentationPanel = p;
    });
        
    itemsTemplateProperty = new FrameworkProperty(this, "itemsTemplate", (value){
      if (_presenter == null) return;
      _presenter.itemsTemplate = value;
    });
    
    
    horizontalScrollEnabledProperty = new FrameworkProperty(this, "horizontalScrollEnabled", (bool value){

    }, false, converter:const StringToBooleanConverter());
    
    verticalScrollEnabledProperty = new FrameworkProperty(this, "verticalScrollEnabled", (bool value){

    }, true, converter:const StringToBooleanConverter());
  }
  
  
  String get type() => "ListBox";
}
