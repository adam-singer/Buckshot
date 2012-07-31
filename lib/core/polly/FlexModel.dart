// Copyright (c) 2012, John Evans
// http://www.buckshotui.org
// See LICENSE file for Apache 2.0 licensing information.


/**
 * Enumerates flexbox model variations and provides detection utility. */
class FlexModel
{
  final int _val;
  static FlexModel _model;

  const FlexModel(this._val);

  /**
   * Static method that returns the correct FlexModel enum of
   * the given [element].
   */
  static FlexModel getFlexModel(Element element){

    //since the model is the same for all elements cache it.
    if (_model != null) return _model;
    
    if (element.style.display == null && 
        element.attributes.containsKey('data-buckshot-flexbox')){
      _model = FlexModel.Manual;
    }else if (Polly.getCSS(element, 'display').endsWith('flex')){
      _model = FlexModel.Flex;
    }else if
    (Polly.getCSS(element, 'display').endsWith('flexbox')){
      _model = FlexModel.FlexBox;
    }else if (element.attributes.containsKey('data-buckshot-flexbox')){
      _model = FlexModel.Manual;
    }else{
      throw new BuckshotException('Unable to determine flex box model.');
    }

    return _model;
  }

  static final FlexBox = const FlexModel(2);
  static final Flex = const FlexModel(3);
  static final Unknown = const FlexModel(4);
  static final Manual = const FlexModel(5);

  String toString() {
    switch(_val){
      case 2:
        return 'FlexBox';
      case 3:
        return 'Flex';
      case 4:
        return 'Unknown';
      case 5:
        return 'Manual';
    }
  }
}