//   Copyright (c) 2012, John Evans
//
//   https://plus.google.com/u/0/115427174005651655317/about
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

  void _initContentPresenterProperties(){
    contentProperty = new FrameworkProperty(
      this,
      "content",
      (value){
        if (contentProperty.previousValue != null){
          contentProperty.previousValue.removeFromLayoutTree();
        }

        //if the content is previously a textblock and the value is a String then just
        //replace the text property with the new string
        if (content is TextBlock && value is String){
          (content as TextBlock).text = value;
          return;
        }

        //accomodate strings by converting them silently to TextBlock
        if (value is String){
            var tempStr = value;
            value = new TextBlock();
            value.text = tempStr;
        }

        value.addToLayoutTree(this);        
      });
  }
  
  /// Gets the [contentProperty] value.
  get content() => getValue(contentProperty);
  /// Sets the [contentProperty] value.
  set content(value) => setValue(contentProperty, value);
  
  String get type() => "ContentPresenter";
}
