// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

//render only, not used for template layout
class _GridCell extends FrameworkObject
{
  EventHandlerReference _ref;

  /// Represents the content inside the border.
  FrameworkProperty contentProperty;
  FrameworkProperty marginProperty;

  _GridCell()
  {
    _initGridCellProperties();

    stateBag[FrameworkObject.CONTAINER_CONTEXT] = contentProperty;
  }

  makeMe() => null;

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
  FrameworkElement get content => getValue(contentProperty);
  /// Sets the [contentProperty] value.
  set content(FrameworkElement value) => setValue(contentProperty, value);
  /// Sets the [marginProperty] value.
  set margin(Thickness value) => setValue(marginProperty, value);
  /// Gets the [marginProperty] value.
  Thickness get margin => getValue(marginProperty);

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
    Polly.makeFlexBox(rawElement);
  }

  /// Overridden [FrameworkObject] method is called when the framework requires elements to recalculate layout.
  void updateLayout(){
    if (content == null) return;

    //spoof the parent during the alignment pass
    content.parent = this;
    Polly.setFlexboxAlignment(content);
    content.parent = parent;
  }
}
