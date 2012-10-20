// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
 * A general purpose container for displaying another Buckshot element.
 * ContentPresenter is typically used as a placeholder element within a
 * template, where actual content may vary.
 */
class ContentPresenter extends FrameworkElement implements FrameworkContainer
{
  /// Represents the content inside the border.
  FrameworkProperty<Dynamic> content;

  ContentPresenter()
  {
    Browser.appendClass(rawElement, "ContentPresenter");

    stateBag[FrameworkObject.CONTAINER_CONTEXT] = content;

    _initContentPresenterProperties();

  }

  ContentPresenter.register() : super.register();
  makeMe() => new ContentPresenter();

  FrameworkElement currentContent;

  void _initContentPresenterProperties(){
    content = new FrameworkProperty(
      this,
      "content",
      (value){
        //log('setting content presenter content to: $value', element:this);
        if (currentContent != null){
          currentContent.removeFromLayoutTree();
        }
        //accomodate strings by converting them silently to TextBlock
        if (value is String){
            value = new TextBlock()..text.value = value;
        }

        currentContent = value;

        if (value == null) return;
        value.addToLayoutTree(this);
      });
  }

  /// Gets the [contentProperty] value.
  get containerContent => content.value;
}
