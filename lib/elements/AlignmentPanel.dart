
/** A virtual panel that correctly aligns a single child element */
class AlignmentPanel extends FrameworkObject
{
 
  
  
  
  /// Overridden [FrameworkObject] method.
  void CreateElement(){
    _component = _Dom.createByTag("div");
    _component.style.overflow = "hidden";
    _component.style.display = "inline-block";
  }
  
  void updateLayout(){
  
  }
  
  String get type() => "AlignmentPanel";
  
}
