// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

//render only, not used for template layout
class _GridCell extends FrameworkObject
{
  EventHandlerReference _ref;

  /// Represents the content inside the border.
  FrameworkProperty<FrameworkElement> content;
  FrameworkProperty<Thickness> margin;
  static int _gridCellCount = 0;

  _GridCell()
  {
    _initGridCellProperties();

    stateBag[FrameworkObject.CONTAINER_CONTEXT] = content;
    name.value = 'grid_cell_${_gridCellCount++}';
  }

  makeMe() => null;

  void _initGridCellProperties(){
    //register the dependency properties
    content = new FrameworkProperty(
      this,
      "content",(c)
      {
        if (content.previousValue != null){
          content.previousValue.removeFromLayoutTree();
        }
        if (c != null){
          c.addToLayoutTree(this);
        }
      });

    margin = new FrameworkProperty(
      this,
      "margin",
      (value){
        rawElement.style.margin = '${value.top}px ${value.right}px ${value.bottom}px ${value.left}px';
      }, new Thickness(0), converter:const StringToThicknessConverter());
  }

  /// Overridden [FrameworkObject] method for generating the html representation of the border.
  void createElement(){
    rawElement = new DivElement()
                    ..style.overflow = "hidden"
                    ..style.position = "absolute"
 //                   ..style.background = 'Red'
                    ..style.display ='table';


    Polly.makeFlexBox(rawElement);
  }

  /// Overridden [FrameworkObject] method is called when the framework requires elements to recalculate layout.
  void updateLayout(){
    if (content == null) return;

   // db('updating gridcell layout for', content);
    //spoof the parent during the alignment pass
    content.value.parent = this;
    Polly.setFlexboxAlignment(content.value);
    content.value.parent = parent;
  }
}
