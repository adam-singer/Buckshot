part of core_buckshotui_org;

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
*              presentationpanel defaults to Stack
*              so doesn't need to be declared unless you
*              want to change or customize
*         -->
*         <presentationpanel>
*             <stack></stack>
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
* ## Try It Yourself ##
* Select the "Collections" example on the Buckshot Sandbox:
* [Sandbox](http://www.buckshotui.org/sandbox/?demo=collections)
*/
class CollectionPresenter extends FrameworkElement implements FrameworkContainer
{
  static const String OBJECT_CONTENT = '__CollectionPresenterData__';
  static const String TEMPLATE_CONTENT =
      '__collection_presenter_template_content__';
  var _eHandler;

  /// Represents the [Panel] element which will contain the generated UI for
  /// each element of the collection.
  FrameworkProperty<Panel> presentationPanel;

  /// Represents the UI that will display for each item in the collection.
  FrameworkProperty<String> itemsTemplate;

  /** Represents the collection to be used by the CollectionPresenter */
  FrameworkProperty<Collection> collection;


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

    presentationPanel =
        new FrameworkProperty(this, "presentationPanel", (Panel p){
      assert(p != null);
      assert(p.parent == null);

      if (!rawElement.elements.isEmpty()) {
         rawElement.elements[0].remove();
      }

      p.addToLayoutTree(this);
      assert(p.parent == this);
    }, new Stack());

    itemsTemplate = new FrameworkProperty(this, "itemsTemplate");

    collection = new FrameworkProperty(this, 'collection');
  }

  @override onFirstLoad(){
    invalidate();
  }

  //IFrameworkContainer interface
  get containerContent => presentationPanel.value;

  void invalidate() => _updateCollection();

  void _updateCollection(){
    log('Invalidating CollectionPresenter', element:this, logLevel: Level.FINE);
    var values = collection.value;

 //   log('values from collection property ${collection.value}');

    if (values == null){
      // fall back to dataContext as Collection source
      final dc = resolveDataContext();

      if (dc == null && presentationPanel.value.isLoaded){
        presentationPanel.value.children.clear();
        return;
      } else if (dc == null){
          return;
      }

      values = dc.value;
    //  log('datacontext propertyName: ${dc.propertyName}, value: ${dc.value}', element: this);
    }

    if (values is! Collection){
  //    log('*** values collection: $values', element: this);
      throw const BuckshotException("Expected dataContext object"
        " to be of type Collection.");
    }

    presentationPanel.value.rawElement.elements.clear();
    _addItems(values);

    // If an observable list, watch it and add/remove items as necessary.
    if (values is ObservableList && _eHandler == null){
      _eHandler = values.listChanged + (_, ListChangedEventArgs args) {
         if(!args.newItems.isEmpty()){
           _addItems(args.newItems);
         }

         if (args.oldItems.isEmpty()) return;
         _removeItems(args.oldItems);
      };
    }
  }

  void _removeItems(Collection items){
    int count = 0;
    for(final element in presentationPanel.value.children){
      if (items.some((item) => item == element.stateBag[OBJECT_CONTENT])){
        presentationPanel.value.children.remove(element);
        count++;
      }

      if (count == items.length){
        // found them all
        break;
      }
    }
  }

  void _addItems(Collection items){
    if (itemsTemplate.value == null){
      //no template, then just call toString on the object.
      items.forEach((iterationObject){
        final it = new TextBlock()
        ..hAlign.value = HorizontalAlignment.stretch
        ..text.value = '$iterationObject'
        ..stateBag[OBJECT_CONTENT] = iterationObject;
        iterationObject.stateBag[TEMPLATE_CONTENT] = it;
        itemCreated.invokeAsync(this, new ItemCreatedEventArgs(it));
        presentationPanel.value.children.add(it);
      });
    }else{
      //if template, then bind the object to the template datacontext
      items.forEach((iterationObject){
        Template
        .deserialize(itemsTemplate.value)
        .then((FrameworkElement it){
          it..stateBag[OBJECT_CONTENT] = iterationObject
              ..dataContext.value = iterationObject;
          iterationObject.stateBag[TEMPLATE_CONTENT] = it;
          itemCreated.invokeAsync(this, new ItemCreatedEventArgs(it));
          presentationPanel.value.children.add(it);
        });
      });
    }
}

}



class ItemCreatedEventArgs extends EventArgs{
  final Dynamic itemCreated;

  ItemCreatedEventArgs(this.itemCreated);
}
