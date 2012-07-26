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
    Polly.makeFlexBox(this);
  }

  /// Overridden [FrameworkObject] method is called when the framework requires elements to recalculate layout.
  void updateLayout(){
    if (content == null) return;
    
    Polly.setXPCSS(content.rawElement, 'flex', 'none');
    
    if (content.hAlign != null){
        if(content.hAlign == HorizontalAlignment.stretch){
          Polly.setXPCSS(content.rawElement, 'flex', '1 1 auto');
        }
        
        Polly.setHorizontalFlexBoxAlignment(rawElement, content.hAlign);
    }

    if (content.vAlign != null){
      Polly.setVerticalFlexBoxAlignment(rawElement, content.vAlign);
    }
  }

  String get type() => "_GridCell";
}
