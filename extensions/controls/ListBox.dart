// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

//TODO add mouse state template properties

#library('listbox.controls.buckshotui.org');

#import('../../lib/Buckshot.dart');
#import('package:DartNet-Event-Model/events.dart');
#import('../../external/shared/shared.dart');
#import('../../external/web/web.dart');


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

  FrameworkProperty borderColorProperty;
  FrameworkProperty borderThicknessProperty;
  FrameworkProperty highlightColorProperty;
  FrameworkProperty selectColorProperty;

  CollectionPresenter _presenter;
  Border _border;

  int _selectedIndex = -1;

  final FrameworkEvent<SelectedItemChangedEventArgs> selectionChanged;

  int get selectedIndex() => _selectedIndex;

  ListBox()
  :
    selectionChanged = new FrameworkEvent<SelectedItemChangedEventArgs>()
  {
    Browser.appendClass(rawElement, "listbox");

    _initListBoxProperties();

    //applyVisualTemplate() is called before the constructor
    //so we expect template to be assigned

    _presenter = Template.findByName("__buckshot_listbox_presenter__", template);
    _border = Template.findByName("__buckshot_listbox_border__", template);

    if (_presenter == null)
      throw const BuckshotException('element not found in control template');

    _presenter.itemCreated + _OnItemCreated;

  }

  String get defaultControlTemplate() {
    return
    '''<controltemplate controlType="${this.templateName}">
          <template>
            <border bordercolor="{template borderColor}" 
                    borderthickness="{template borderThickness}" 
                    horizontalScrollEnabled="{template horizontalScrollEnabled}" 
                    verticalScrollEnabled="{template verticalScrollEnabled}"
                    name="__buckshot_listbox_border__"
                    cursor="Arrow">
                <collectionPresenter name="__buckshot_listbox_presenter__" 
                                      halign='stretch'>
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

      setValue(selectedItemProperty, item.stateBag[CollectionPresenter.SBO]);

      selectionChanged.invoke(this, new SelectedItemChangedEventArgs(item.stateBag[CollectionPresenter.SBO]));

    };

    item.mouseEnter + (_, __) => onItemMouseEnter(item);

    item.mouseLeave + (_, __) => onItemMouseLeave(item);

    item.mouseDown + (_, __) => onItemMouseDown(item);

    item.mouseUp + (_, __) => onItemMouseUp(item);
  }

  get content() => template;

  /// Override this method to implement your own mouse over behavior for items in
  /// the ListBox.
  void onItemMouseDown(item){
    if (item.hasProperty("background")){
      item.dynamic.background = getValue(selectColorProperty);
    }
  }

  /// Override this method to implement your own mouse over behavior for items in
  /// the ListBox.
  void onItemMouseUp(item){
    if (item.hasProperty("background")){
      item.dynamic.background = getValue(highlightColorProperty);
    }
  }

  /// Override this method to implement your own mouse over behavior for items in
  /// the ListBox.
  void onItemMouseEnter(FrameworkElement item){
    if (item.hasProperty("background")){
      item.stateBag["__lb_item_bg_brush__"] = item.dynamic.background;
      item.dynamic.background = getValue(highlightColorProperty);
    }
  }

  /// Override this method to implement your own mouse out behavior for items in
  /// the ListBox.
  void onItemMouseLeave(FrameworkElement item){
    if (item.stateBag.containsKey("__lb_item_bg_brush__")){
      item.dynamic.background = item.stateBag["__lb_item_bg_brush__"];
    }
  }


  void _initListBoxProperties(){

    highlightColorProperty = new FrameworkProperty(this, "highlightColor", (_){
    }, new SolidColorBrush(new Color.predefined(Colors.PowderBlue)), converter:const StringToSolidColorBrushConverter());

    selectColorProperty = new FrameworkProperty(this, "selectColor", (_){
    }, new SolidColorBrush(new Color.predefined(Colors.SkyBlue)), converter:const StringToSolidColorBrushConverter());

    borderColorProperty = new FrameworkProperty(this, "borderColor", (v){
      if (_border == null) return;
      _border.borderColor = v;
    }, new SolidColorBrush(new Color.predefined(Colors.Black)), converter:const StringToSolidColorBrushConverter());

    borderThicknessProperty = new FrameworkProperty(this, "borderThickness", (v){
    }, new Thickness(1), converter:const StringToThicknessConverter());

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
}
