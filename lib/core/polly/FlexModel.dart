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
  static FlexModel getFlexModel(FrameworkElement element){

    //since the model is the same for all elements cache it.
    if (_model != null) return _model;

    if (Polly.getXPCSS(element.rawElement, 'display') == null){
      _model = FlexModel.Unknown;
    }else if (Polly.getXPCSS(element.rawElement, 'display').endsWith('flex')){
      _model = FlexModel.Flex;
    }else if
    (Polly.getXPCSS(element.rawElement, 'display').endsWith('flexbox')){
      _model = FlexModel.FlexBox;
    }else if (Polly.getXPCSS(element.rawElement, 'display') == 'box'
      || Polly.getXPCSS(element.parent.rawElement, 'display').endsWith('-box')){
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
}