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

    if (Polly.getCSS(element, 'display') == null){
      _model = FlexModel.Unknown;
    }else if (Polly.getCSS(element, 'display').endsWith('flex')){
      _model = FlexModel.Flex;
    }else if
    (Polly.getCSS(element, 'display').endsWith('flexbox')){
      _model = FlexModel.FlexBox;
    }
    else if (Polly.getCSS(element, 'display') == 'box'
      || Polly.getCSS(element, 'display').endsWith('-box')){
      _model = FlexModel.Box;
    }else{
      _model = FlexModel.Unknown;
    }

    return _model;
  }

  static final Box = const FlexModel(1);
  static final FlexBox = const FlexModel(2);
  static final Flex = const FlexModel(3);
  static final Unknown = const FlexModel(4);

  String toString() {
    switch(_val){
      case 1:
        return 'Box';
      case 2:
        return 'FlexBox';
      case 3:
        return 'Flex';
      case 4:
        return 'Unknown';
    }
  }
}