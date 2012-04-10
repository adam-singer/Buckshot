
/**
* Represents a view that displays the Life matrix.
*/
class PlayfieldView extends LayoutCanvas implements IView
{

  final PlayfieldViewModel vm;
  
  FrameworkElement get rootVisual() => this;
  
  PlayfieldView(this.vm){
    this.cursor = Cursors.Crosshair;
    this.horizontalAlignment = HorizontalAlignment.left;
    this.verticalAlignment = VerticalAlignment.top;
    //this.background = new SolidColorBrush(new Color(Colors.Orange));
  }
  
}
