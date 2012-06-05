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
* Implements a layout container where elements can be arranged left/top position.
* Element overlapping is supported.
*
* This class is **not** related to the HTML5 <Canvas> element. */
class LayoutCanvas extends Panel
{
  /// Represents the offset position of an element within the LayoutCanvas
  /// from the top of the LayoutCanvas container boundary.
  static AttachedFrameworkProperty topProperty;
  /// Represents the offset position of an element within the LayoutCanvas
  /// from the left of the LayoutCanvas container boundary.
  static AttachedFrameworkProperty leftProperty;

  /// Overridden [LucaObject] method.
  FrameworkObject makeMe() => new LayoutCanvas();

  LayoutCanvas(){
    _Dom.appendBuckshotClass(_component, "layoutcanvas");

  }

  void onChildrenChanging(ListChangedEventArgs args){
      super.onChildrenChanging(args);

      args.oldItems.forEach((element){

        //restore the element's previous 'margin' state
        element.margin = element._stateBag["margin"];
        element._stateBag.remove("margin");

        //_component.removeChild(element._component);
        element._component.style.position = "inherit";

        element.attachedPropertyChanged - _onAttachedPropertyChanging;
      });

      args.newItems.forEach((element){
        element._component.style.position = "absolute";
        var l = LayoutCanvas.getLeft(element);

        var t = LayoutCanvas.getTop(element);

        //Since we are borrowing 'margin' to effect the canvas layout
        //preserve the element's original margin state.
        // (we can borrow margin because it has no place in a canvas layout anyway)
        element._stateBag["margin"] = element.margin;

        element.margin = new Thickness.specified(t, 0, 0, l);

        _component.nodes.add(element._component);

        element.attachedPropertyChanged + _onAttachedPropertyChanging;
      });

  }

  void _onAttachedPropertyChanging(Object sender, AttachedPropertyChangedEventArgs args){
    //the attached property value changed so call it's callback to adjust the value
//    db('sender', sender);
    Function f = args.property.propertyChangedCallback;
    f(sender, args.value);
  }


  /**
  * Sets the top value of the element relative to a parent LayoutCanvas container */
  static void setTop(FrameworkElement element, int value){
    if (element == null) return;

    if (value < 0) value = 0;

    if (LayoutCanvas.topProperty == null)
      LayoutCanvas.topProperty = new AttachedFrameworkProperty("top",
        (FrameworkElement e, int v){
        e.margin = new Thickness.specified(v, 0, 0, LayoutCanvas.getLeft(e));
      });

    FrameworkObject.setAttachedValue(element, topProperty, value);

  }

  /**
  * Returns the value currently assigned to the LayoutCanvas.topProperty for the given element. */
  static int getTop(FrameworkElement element){
    if (element == null) return 0;

    var value = FrameworkObject.getAttachedValue(element, topProperty);

    if (LayoutCanvas.topProperty == null || value == null)
      LayoutCanvas.setTop(element, 0);

    return FrameworkObject.getAttachedValue(element, topProperty);
  }

  /**
  * Sets the left value of the element relative to a parent LayoutCanvas container */
  static void setLeft(FrameworkElement element, int value){
    if (element == null) return;

    if (value < 0) value = 0;

    if (LayoutCanvas.leftProperty == null)
      LayoutCanvas.leftProperty = new AttachedFrameworkProperty("left",
        (FrameworkElement e, int v){
          e.margin = new Thickness.specified(LayoutCanvas.getTop(e), 0, 0, v);
      });

    FrameworkObject.setAttachedValue(element, leftProperty, value);
  }

  /**
  * Returns the value currently assigned to the LayoutCanvas.leftProperty for the given element */
  static int getLeft(FrameworkElement element){
    if (element == null) return 0;

    var value = FrameworkObject.getAttachedValue(element, leftProperty);

    if (LayoutCanvas.leftProperty == null || value == null)
      LayoutCanvas.setLeft(element, 0);

    return FrameworkObject.getAttachedValue(element, leftProperty);
  }

  /// Overridden [FrameworkObject] method.
  void CreateElement(){
    _component = new DivElement();
    _component.style.overflow = "hidden";
  }

  /// Overridden [FrameworkObject] method.
  updateLayout(){ }

  String get type() { return "LayoutCanvas"; }
}

