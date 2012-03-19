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
* CollectionPresents provides a way to declaratively display a list of arbitrary
* data.
*
* ## Lucaxml Usage Example:
*
*     <collectionpresenter datacontext="{data someCollection}">
*         <!-- 
*              presentationpanel defaults to stackpanel
*              so doesn't need to be declared unless you
*              want to change or customize
*         -->
*         <presentationpanel>
*             <stackpanel></stackpanel>
*         </presentationpanel>
*         <!-- 
*             itemstemplate declares the output that will be 
*             added to the presentationpanel for each iteration
*             of the collection
*         -->
*         <itemstemplate>
*              <textblock text="{data somedata}"></textblock>
*         <itemstemplate>
*     </collectionpresenter>
*
* ## Try It Yourself
* Select the "Collections" example on the LUCA UI Try It website: [Try LUCA UI](http://www.lucastudios.com/trylucaui) 
*/
class CollectionPresenter extends Control
{
  static final String _SBO = '__CollectionPresenterData__';
  var _eHandler;
  
  /// Represents the [Panel] element which will contain the generated UI for
  /// each element of the collection.
  FrameworkProperty presentationPanelProperty;
  
  /// Represents the UI that will display for each item in the collection.
  FrameworkProperty itemsTemplateProperty;
  
  final FrameworkEvent<ItemCreatedEventArgs> itemCreated;
  
  final IPresentationFormatProvider _pfp;
  
  /// Overridden [LucaObject] method.
  FrameworkObject makeMe() => new CollectionPresenter();
  
  CollectionPresenter()
  : 
    _pfp = new LucaxmlPresentationProvider(),
    itemCreated = new FrameworkEvent<ItemCreatedEventArgs>()
  {
    _Dom.appendClass(_component, "luca_ui_collectionpresenter");
    _initCollectionPresenterProperties();    
  }
  
  void _initCollectionPresenterProperties(){
        
    presentationPanelProperty = new FrameworkProperty(this, "presentationPanel", (Panel p){
      if (p.parent != null)
        throw const FrameworkException("Element is already child of another element.");
      
      if (!_component.elements.isEmpty())
         _component.elements[0].remove();
      
      p.loaded + (_,__) => _updateCollection();
      
      _component.elements.add(p._component);

    }, new StackPanel());
        
    itemsTemplateProperty = new FrameworkProperty(this, "itemsTemplate", (_){});
    
  }
  
  /// Gets the [presentationPanelProperty] value.
  Panel get presentationPanel() => getValue(presentationPanelProperty);
  /// Sets the [presentationPanelProperty] value.
  set presentationPanel(Panel value) => setValue(presentationPanelProperty, value);
  
  /// Gets the [itemsTemplateProperty] value.
  String get itemsTemplate() => getValue(itemsTemplateProperty);
  /// Sets the [itemsTemplateProperty] value.
  set itemsTemplate(String value) => setValue(itemsTemplateProperty, value);
    
  void _updateCollection(){        
    var dc = this.resolveDataContext();
    
    if (dc == null && presentationPanel._isLoaded)
      {
        presentationPanel.children.clear();
        return;
      } else if (dc == null){
        return;
      }
   
    var values = getValue(dc);
    
    if (values is ObservableList && _eHandler == null){
      _eHandler = values.listChanged + (_, __) => _updateCollection();
    }
    
    if (!(values is Collection)) throw const FrameworkException("Expected dataContext object to be of type Collection.");
    
    presentationPanel._component.elements.clear();
    
    if (itemsTemplate == null){
      //no template, then just call toString on the object.
      values.forEach((iterationObject){
        var it = _pfp.deserialize('<textblock>${iterationObject}</textblock>');
        it._stateBag[_SBO] = iterationObject;
        itemCreated.invoke(this, new ItemCreatedEventArgs(it));
        presentationPanel.children.add(it);
      });
    }else{
      //if template, then bind the object to the template datacontext
      values.forEach((iterationObject){
        var it = _pfp.deserialize(itemsTemplate);
        it._stateBag[_SBO] = iterationObject;
        it.dataContext = iterationObject;
        itemCreated.invoke(this, new ItemCreatedEventArgs(it));
        presentationPanel.children.add(it);
      });
    }
  }
  
  /// Overridden [FrameworkObject] method.
  void updateLayout(){ }
  
  /// Overriden [FrameworkObject] method.
  void CreateElement(){

    _component = _Dom.createByTag("div");
  }
  
  String get _type() => "CollectionPresenter";
}


class ItemCreatedEventArgs extends EventArgs{
  final Dynamic itemCreated;
  
  ItemCreatedEventArgs(this.itemCreated);
}
