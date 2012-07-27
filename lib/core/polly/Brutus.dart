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
  var _prezervedRightMargin;

  final FrameworkElement element;

  HorizontalAlignment manualHorizontalAlignment;
  VerticalAlignment manualVerticalAlignment;

  Brutus.with(this.element);

  void enableManualHorizontalAlignment(HorizontalAlignment alignment){
    if (manualHorizontalAlignment != null){
      disableManualHorizontalAlignment();
    }

    manualHorizontalAlignment = alignment;

    void handleHorizontalStretch(){
      //save the width value for later restoral
      _preservedWidth = element.rawElement.style.width;

      _subscribeMeasurementChanged();
    }

    void handleHorizontalCenter(){
      throw const NotImplementedException();
    }

    void handleHorizontalRight(){
      throw const NotImplementedException();
    }

    void handleHorizontalLeft(){
      throw const NotImplementedException();
    }

    switch(alignment){
      case HorizontalAlignment.stretch:
        handleHorizontalStretch();
        break;
      case HorizontalAlignment.left:
        handleHorizontalLeft();
        break;
      case HorizontalAlignment.center:
        handleHorizontalCenter();
        break;
      case HorizontalAlignment.right:
        handleHorizontalRight();
        break;
    }
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
      throw const NotImplementedException();
    }

    void handleHorizontalRight(){
      throw const NotImplementedException();
    }

    void handleHorizontalLeft(){
      throw const NotImplementedException();
    }


    switch(manualHorizontalAlignment){
      case HorizontalAlignment.stretch:
        handleHorizontalStretch();
        break;
      case HorizontalAlignment.left:
        handleHorizontalLeft();
        break;
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
  }


  void _clearManualHorizontalAlignment(){

  }

  void _clearManualVerticalAlignment(){

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
      throw const NotImplementedException();
    }

    void handleHorizontalRight(){
      throw const NotImplementedException();
    }

    void handleHorizontalLeft(){
      throw const NotImplementedException();
    }

    if (manualHorizontalAlignment != null){
      switch(manualHorizontalAlignment){
        case HorizontalAlignment.stretch:
          handleHorizontalStretch();
          break;
        case HorizontalAlignment.left:
          handleHorizontalLeft();
          break;
        case HorizontalAlignment.center:
          handleHorizontalCenter();
          break;
        case HorizontalAlignment.right:
          handleHorizontalRight();
          break;
      }
    }

    if (manualVerticalAlignment != null){

    }
  }
}
