// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

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

  LayoutCanvas(){
    Browser.appendClass(rawElement, "layoutcanvas");
    registerAttachedProperty('layoutcanvas.top', LayoutCanvas.setTop);
    registerAttachedProperty('layoutcanvas.left', LayoutCanvas.setLeft);
  }

  void onChildrenChanging(ListChangedEventArgs args){
      super.onChildrenChanging(args);

      args.oldItems.forEach((element){

        //restore the element's previous 'margin' state
        element.margin = element.stateBag["margin"];
        element.stateBag.remove("margin");

        //rawElement.removeChild(element.rawElement);
        element.rawElement.style.position = "inherit";

        element.attachedPropertyChanged - _onAttachedPropertyChanging;
      });

      args.newItems.forEach((element){
        element.rawElement.style.position = "absolute";
        var l = LayoutCanvas.getLeft(element);

        var t = LayoutCanvas.getTop(element);

        //Since we are borrowing 'margin' to effect the canvas layout
        //preserve the element's original margin state.
        // (we can borrow margin because it has no place in a canvas layout anyway)
        element.stateBag["margin"] = element.margin;

        element.margin = new Thickness.specified(t, 0, 0, l);

        rawElement.nodes.add(element.rawElement);

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
  static void setTop(FrameworkElement element, value){
    if (element == null) return;

    assert(value is String || value is num);

    value = const StringToNumericConverter().convert(value);

    if (value < 0) value = 0;

    if (LayoutCanvas.topProperty == null)
      LayoutCanvas.topProperty = new AttachedFrameworkProperty("top",
        (FrameworkElement e, int v){
        e.margin = new Thickness.specified(v, 0, 0, LayoutCanvas.getLeft(e));
      });

    AttachedFrameworkProperty.setValue(element, topProperty, value);

  }

  /**
  * Returns the value currently assigned to the LayoutCanvas.topProperty for the given element. */
  static num getTop(FrameworkElement element){
    if (element == null) return 0;

    var value = AttachedFrameworkProperty.getValue(element, topProperty);

    if (LayoutCanvas.topProperty == null || value == null)
      LayoutCanvas.setTop(element, 0);

    return AttachedFrameworkProperty.getValue(element, topProperty);
  }

  /**
  * Sets the left value of the element relative to a parent LayoutCanvas container */
  static void setLeft(FrameworkElement element, value){
    if (element == null) return;

    assert(value is String || value is num);

    value = const StringToNumericConverter().convert(value);

    if (value < 0) value = 0;

    if (LayoutCanvas.leftProperty == null)
      LayoutCanvas.leftProperty = new AttachedFrameworkProperty("left",
        (FrameworkElement e, int v){
          e.margin = new Thickness.specified(LayoutCanvas.getTop(e), 0, 0, v);
      });

    AttachedFrameworkProperty.setValue(element, leftProperty, value);
  }

  /**
  * Returns the value currently assigned to the LayoutCanvas.leftProperty for the given element */
  static num getLeft(FrameworkElement element){
    if (element == null) return 0;

    var value = AttachedFrameworkProperty.getValue(element, leftProperty);

    if (LayoutCanvas.leftProperty == null || value == null)
      LayoutCanvas.setLeft(element, 0);

    return AttachedFrameworkProperty.getValue(element, leftProperty);
  }

  /// Overridden [FrameworkObject] method.
  void createElement(){
    rawElement = new DivElement();
    rawElement.style.overflow = "hidden";
  }
}

