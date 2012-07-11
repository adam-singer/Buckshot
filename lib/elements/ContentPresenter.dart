// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
 * A general purpose container for displaying another Buckshot element.
 * ContentPresenter is typically used as a placeholder element within a 
 * template, where actual content may vary.
 */
class ContentPresenter extends FrameworkElement implements IFrameworkContainer
{
  /// Represents the content inside the border.
  FrameworkProperty contentProperty;
  
/// Overridden [BuckshotObject] method for creating new borders.
  FrameworkObject makeMe() => new ContentPresenter();
  
  ContentPresenter()
  {
    Dom.appendBuckshotClass(rawElement, "ContentPresenter");

    _initContentPresenterProperties();

    this._stateBag[FrameworkObject.CONTAINER_CONTEXT] = contentProperty;
  }

  FrameworkElement currentContent;
  
  void _initContentPresenterProperties(){
    contentProperty = new FrameworkProperty(
      this,
      "content",
      (value){
        if (currentContent != null){
          currentContent.removeFromLayoutTree();
        }

        //if the content is previously a textblock and the value is a String then just
        //replace the text property with the new string
//        if (content is TextBlock && value is String){
//          (content as TextBlock).text = value;
//          return;
//        }

        //accomodate strings by converting them silently to TextBlock
        if (value is String){
            var tempStr = value;
            value = new TextBlock();
            value.text = tempStr;
        }
        
        currentContent = value;

        value.addToLayoutTree(this);        
      });
  }
  
  /// Gets the [contentProperty] value.
  get content() => getValue(contentProperty);
  /// Sets the [contentProperty] value.
  set content(value) => setValue(contentProperty, value);
  
  String get type() => "ContentPresenter";
}
