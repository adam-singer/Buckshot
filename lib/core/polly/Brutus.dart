// Copyright (c) 2012, John Evans
// http://www.buckshotui.org
// See LICENSE file for Apache 2.0 licensing information.


/**
 * Support class for [Polly] that tracks an manages manual alignments for a
 * [FrameworkElement] within a parent container.
 */
class Brutus
{
  EventHandlerReference _eventReference;
  var _preservedWidth;
  var _preservedHeight;
  var _preservedLeftMargin;
  var _preservedTopMargin;

  final FrameworkElement element;

  HorizontalAlignment manualHorizontalAlignment;
  VerticalAlignment manualVerticalAlignment;

  Brutus.with(this.element);


  /**
   * Enables given manual vertical [alignment] of element within it's parent
   * container.
   */
  void enableManualVerticalAlignment(VerticalAlignment alignment){

  }

  disableManualVerticalAlignment(){

  }

  /**
   * Enables given manual horizontal [alignment] of element within it's parent
   * container.
   */
  void enableManualHorizontalAlignment(HorizontalAlignment alignment){
    if (manualHorizontalAlignment != null){
      disableManualHorizontalAlignment();
    }

    if (alignment == HorizontalAlignment.left) return;

    manualHorizontalAlignment = alignment;

    void handleHorizontalStretch(){
      //save the width value for later restoral
      _preservedWidth = element.rawElement.style.width;
    }

    void handleHorizontalCenter(){
      _preservedLeftMargin = element.margin;
    }

    void handleHorizontalRight(){
      _preservedLeftMargin = element.margin;
    }

    switch(alignment){
      case HorizontalAlignment.stretch:
        handleHorizontalStretch();
        break;
      case HorizontalAlignment.center:
        handleHorizontalCenter();
        break;
      case HorizontalAlignment.right:
        handleHorizontalRight();
        break;
    }

    _subscribeMeasurementChanged();
  }

  void disableManualHorizontalAlignment(){

    if (manualHorizontalAlignment == null) return;

    _unsubscribeMeasurementChanged();

    manualHorizontalAlignment = null;

    void handleHorizontalStretch(){

      element.rawElement.style.width = _preservedWidth;

      _preservedWidth = null;
    }

    void handleHorizontalCenter(){
      element.margin = _preservedLeftMargin;

      _preservedLeftMargin = null;
    }

    void handleHorizontalRight(){
      element.margin = _preservedLeftMargin;

      _preservedLeftMargin = null;
    }

    switch(manualHorizontalAlignment){
      case HorizontalAlignment.stretch:
        handleHorizontalStretch();
        break;
      case HorizontalAlignment.left:
        return;
      case HorizontalAlignment.center:
        handleHorizontalCenter();
        break;
      case HorizontalAlignment.right:
        handleHorizontalRight();
        break;
    }
  }

  void clearAllManualAlignments(){
    disableManualHorizontalAlignment();
    disableManualVerticalAlignment();
  }

  void _subscribeMeasurementChanged(){
    if (_eventReference != null) return;

    //assign event handler reference to statebag
    _eventReference =
        element.parent.measurementChanged + _sizeChangedEventHandler;

  }

  void _unsubscribeMeasurementChanged(){
    if (_eventReference == null) return;

    element.parent.measurementChanged - _eventReference;

    _eventReference = null;
  }
  void _sizeChangedEventHandler(_, MeasurementChangedEventArgs args){

    void handleHorizontalStretch(){
      if (element.hasProperty('padding')){
        final calcWidth = args.newMeasurement.client.width -
            (element.dynamic.padding.left +
             element.dynamic.padding.right +
             element.margin.left +
             element.margin.right +
             ((element.parent.hasProperty('padding'))
              ? element.parent.dynamic.padding.left +
                  element.parent.dynamic.padding.right
              : 0));
        element.rawElement.style.width = '${calcWidth}px';
      }else{
        final calcWidth = args.newMeasurement.client.width -
            (element.margin.left + element.margin.right +
             ((element.parent.hasProperty('padding'))
              ? element.parent.dynamic.padding.left +
                  element.parent.dynamic.padding.right
              : 0));
        element.rawElement.style.width = '${calcWidth}px';
      }
    }

    void handleHorizontalCenter(){
      element
        .updateMeasurementAsync
        .then((ElementRect r){
          final position =
              (args.newMeasurement.client.width / 2) - (r.bounding.width / 2);
          element.rawElement.style.margin =
              '${_preservedLeftMargin.top}px'
              ' ${_preservedLeftMargin.right}px'
              ' ${_preservedLeftMargin.bottom}px'
              ' ${position + _preservedLeftMargin.left}px';
      });
    }

    void handleHorizontalRight(){
      element
      .updateMeasurementAsync
      .then((ElementRect r){
        final position = args.newMeasurement.client.width - r.bounding.width;
        element.rawElement.style.margin =
            '${_preservedLeftMargin.top}px'
            ' ${_preservedLeftMargin.right}px'
            ' ${_preservedLeftMargin.bottom}px'
            ' ${position + _preservedLeftMargin.left}px';
    });
    }

    void handleHorizontalLeft(){
      //throw const NotImplementedException();
    }

    if(manualHorizontalAlignment != null){

      switch(manualHorizontalAlignment){
        case HorizontalAlignment.stretch:
          handleHorizontalStretch();
          break;
        case HorizontalAlignment.center:
          handleHorizontalCenter();
          break;
        case HorizontalAlignment.right:
          handleHorizontalRight();
          break;
        default:
          throw const BuckshotException('HorizontalAlignment.left'
            ' invalid here.');
      }
    }

    if (manualVerticalAlignment != null){
      throw const NotImplementedException();
    }
  }
}
