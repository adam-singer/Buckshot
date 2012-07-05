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

//render only, not used for template layout
class _GridCell extends FrameworkObject
{
  EventHandlerReference _ref;

  /// Represents the content inside the border.
  FrameworkProperty contentProperty;
  FrameworkProperty marginProperty;
  
  _GridCell()
  {
    Dom.appendBuckshotClass(rawElement, "GridCell");

    _initGridCellProperties();

    this._stateBag[FrameworkObject.CONTAINER_CONTEXT] = contentProperty;
  }

  void _initGridCellProperties(){
    //register the dependency properties
    contentProperty = new FrameworkProperty(
      this,
      "content",(c)
      {
        if (contentProperty.previousValue != null){
          contentProperty.previousValue.removeFromLayoutTree();
        }
        if (c != null){
          c.addToLayoutTree(this);
        }
      });

    marginProperty = new FrameworkProperty(
      this,
      "margin",
      (value){
        rawElement.style.margin = '${value.top}px ${value.right}px ${value.bottom}px ${value.left}px';
      }, new Thickness(0), converter:const StringToThicknessConverter());
  }

  /// Gets the [contentProperty] value.
  FrameworkElement get content() => getValue(contentProperty);
  /// Sets the [contentProperty] value.
  set content(FrameworkElement value) => setValue(contentProperty, value);
  /// Sets the [marginProperty] value.
  set margin(Thickness value) => setValue(marginProperty, value);
  /// Gets the [marginProperty] value.
  Thickness get margin() => getValue(marginProperty);

  void updateMeasurement(){
    rawElement
      .rect
      .then((ElementRect r) { mostRecentMeasurement = r;});
  }


  /// Overridden [FrameworkObject] method for generating the html representation of the border.
  void createElement(){
    rawElement = new DivElement();
    rawElement.style.overflow = "hidden";
    rawElement.style.position = "absolute";
    Dom.makeFlexBox(this);
  }

  /// Overridden [FrameworkObject] method is called when the framework requires elements to recalculate layout.
  void updateLayout(){
    if (content == null) return;
    
    Dom.setXPCSS(content.rawElement, 'flex', 'none');
    
    if (content.hAlign != null){
        if(content.hAlign == HorizontalAlignment.stretch){
          Dom.setXPCSS(content.rawElement, 'flex', '1 1 auto');
        }
        
        Dom.setHorizontalFlexBoxAlignment(this, content.hAlign);
    }

    if (content.vAlign != null){
      Dom.setVerticalFlexBoxAlignment(this, content.vAlign);
    }
  }

  String get type() => "_GridCell";
}
