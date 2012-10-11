
/**
 * Polyfill for a flexbox containing a single child element which can
 * align top, bottom, left, right, center, and stretch
 */
class AligningPanel extends Polyfill
{
  IFrameworkContainer _panel;

  void begin(FrameworkElement element){
    if (element is! IFrameworkContainer){
      throw const BuckshotException('Element must implement IFramworkContainer'
          ' in order to work with this polyfill.');
    }

    _panel = element;
  }

  void end(){

  }

}

