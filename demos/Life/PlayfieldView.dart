
/**
* Represents a view that displays the Life matrix.
*/
class PlayfieldView extends Grid implements IView
{

  final PlayfieldViewModel vm;
  
  FrameworkElement get rootVisual() => this;
  
  PlayfieldView(this.vm){
    //this.background = new SolidColorBrush(new Color(Colors.Orange));
  }
  
}
