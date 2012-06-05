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
    _Dom.appendBuckshotClass(_component, "GridCell");

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
        _component.style.margin = '${value.top}px ${value.right}px ${value.bottom}px ${value.left}px';
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
    _component
      .rect
      .then((ElementRect r) { mostRecentMeasurement = r;});
  }


  /// Overridden [FrameworkObject] method for generating the html representation of the border.
  void CreateElement(){
    _component = new DivElement();
    _component.style.overflow = "hidden";
    _component.style.position = "absolute";
    _Dom.makeFlexBox(this);
  }

  /// Overridden [FrameworkObject] method is called when the framework requires elements to recalculate layout.
  void updateLayout(){
    if (content != null){
      if (content.horizontalAlignment != null){
        if (content.horizontalAlignment == HorizontalAlignment.stretch){

          //TODO need better way to check CSS3 support than each time.
          //(ala Modernizr)
          if (!_Dom.attemptSetXPCSS(content.rawElement, 'flex', '1')){
            //shim
            if (_ref == null){
              _ref = this.measurementChanged + (source, MeasurementChangedEventArgs args){
                if (content is! Border){
                  content.rawElement.style.width = '${args.newMeasurement.client.width - (content.margin.left + content.margin.right)}px';
                }else{
                  content.rawElement.style.width = '${args.newMeasurement.client.width - (content.dynamic.padding.left + content.dynamic.padding.right + content.margin.left + content.margin.right)}px';
                }
              };
            }
          }
        }else{
          if (!_Dom.attemptSetXPCSS(content.rawElement, 'flex', 'none')){
            //shim
            if (_ref != null){
              this.measurementChanged - _ref;
              _ref = null;
              content.rawElement.style.width = 'auto';
            }
          }
          _Dom.setHorizontalFlexBoxAlignment(this, content.horizontalAlignment);
        }
      }

      if (content.verticalAlignment != null){
        _Dom.setVerticalFlexBoxAlignment(this, content.verticalAlignment);
      }
    }
  }

  String get type() => "_GridCell";
}
