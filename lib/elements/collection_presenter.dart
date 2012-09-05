// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* CollectionPresents provides a way to declaratively display a list of arbitrary
* data.
*
* ## Buckshot Template Usage Example:
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
* Select the "Collections" example on the Buckshot Sandbox: [Try Buckshot](http://www.lucastudios.com/trybuckshot)
*/
class CollectionPresenter extends FrameworkElement implements IFrameworkContainer
{
  static final String SBO = '__CollectionPresenterData__';
  var _eHandler;

  /// Represents the [Panel] element which will contain the generated UI for
  /// each element of the collection.
  FrameworkProperty presentationPanelProperty;

  /// Represents the UI that will display for each item in the collection.
  FrameworkProperty itemsTemplateProperty;

  final FrameworkEvent<ItemCreatedEventArgs> itemCreated;

  CollectionPresenter()
  :
    itemCreated = new FrameworkEvent<ItemCreatedEventArgs>()
  {
    Browser.appendClass(rawElement, "collectionpresenter");
    _initCollectionPresenterProperties();
    
    registerEvent('itemcreated', itemCreated);
  }
  
  CollectionPresenter.register() : super.register(),
    itemCreated = new FrameworkEvent<ItemCreatedEventArgs>();
  makeMe() => new CollectionPresenter();

  void _initCollectionPresenterProperties(){
    presentationPanelProperty = new FrameworkProperty(this, "presentationPanel", (Panel p){
      if (p.parent != null)
        throw const BuckshotException("Element is already child of another element.");

      if (!rawElement.elements.isEmpty())
         rawElement.elements[0].remove();

      p.loaded + (_,__) => _updateCollection();

      p.addToLayoutTree(this);

    }, new StackPanel());

    itemsTemplateProperty = new FrameworkProperty(this, "itemsTemplate");
  }

  /// Gets the [presentationPanelProperty] value.
  Panel get presentationPanel => getValue(presentationPanelProperty);
  /// Sets the [presentationPanelProperty] value.
  set presentationPanel(Panel value) => setValue(presentationPanelProperty, value);

  //IFrameworkContainer interface
  get content => presentationPanel;

  /// Gets the [itemsTemplateProperty] value.
  String get itemsTemplate => getValue(itemsTemplateProperty);
  /// Sets the [itemsTemplateProperty] value.
  set itemsTemplate(String value) => setValue(itemsTemplateProperty, value);

  void _updateCollection(){

    var dc = resolveDataContext();

    if (dc == null && presentationPanel._isLoaded){
        presentationPanel.children.clear();
        return;
    } else if (dc == null){
        return;
    }

    var values = getValue(dc);

    if (values is ObservableList && _eHandler == null){
      _eHandler = values.listChanged + (_, __) => _updateCollection();
    }

    if (values is! Collection)
      throw const BuckshotException("Expected dataContext object"
        " to be of type Collection.");

    presentationPanel.rawElement.elements.clear();

    if (itemsTemplate == null){
      //no template, then just call toString on the object.
      values.forEach((iterationObject){
        Template.deserialize('<textblock halign="stretch">'
          '${iterationObject}</textblock>')
          .then((it){
            it.stateBag[SBO] = iterationObject;
            itemCreated.invoke(this, new ItemCreatedEventArgs(it));
            presentationPanel.children.add(it);
          });
      });
    }else{
      //if template, then bind the object to the template datacontext
      values.forEach((iterationObject){
        Template
        .deserialize(itemsTemplate)
        .then((it){
          it.stateBag[SBO] = iterationObject;
          it.dataContext = iterationObject;
          itemCreated.invoke(this, new ItemCreatedEventArgs(it));
          presentationPanel.children.add(it);
        });
      });
    }
  }

  /// Overridden [FrameworkObject] method.
  void updateLayout(){ }

  /// Overriden [FrameworkObject] method.
  void createElement(){
    rawElement = new DivElement();
  }
}


class ItemCreatedEventArgs extends EventArgs{
  final Dynamic itemCreated;

  ItemCreatedEventArgs(this.itemCreated);
}
