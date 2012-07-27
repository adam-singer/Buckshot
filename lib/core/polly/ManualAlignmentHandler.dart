// Copyright (c) 2012, John Evans
// http://www.buckshotui.org
// See LICENSE file for Apache 2.0 licensing information.


/**
 * Tracks an manages manual horizontal and vertical alignments for a
 * [FrameworkElement] within a parent container.
 */
class ManualAlignmentHandler
{
  final FrameworkElement element;

  HorizontalAlignment manualHorizontalAlignment;
  VerticalAlignment manualVerticalAlignment;

  ManualAlignmentHandler.with(this.element);

  void _clearManualHorizontalAlignment(){

  }

  void _clearManualVerticalAlignment(){

  }

  void enableHorizontalStretch(){
    //save the width value for later restoral
    element.stateBag['__WIDTH_SHIM__'] = element.rawElement.style.width;

    if (element.stateBag['__MEASUREMENT_CHANGED_EVENT_REF__'] == null){

      //assign event handler reference to statebag
      element.stateBag['__MEASUREMENT_CHANGED_EVENT_REF__'] =
          element.parent.measurementChanged + widthManualStretchHandler;
    }

    manualHorizontalAlignment = HorizontalAlignment.stretch;
  }

  void disableHorizontalStretch(){
    //ignore if not already stretching horizontally.
    if (manualHorizontalAlignment == null ||
        manualHorizontalAlignment != HorizontalAlignment.stretch){
      return;
    }


    if (element.stateBag['__MEASUREMENT_CHANGED_EVENT_REF__'] != null){

      if (element._manualAlignmentHandler != null)

      //unsubscribe the event
      element.parent.measurementChanged -
      element.stateBag['__MEASUREMENT_CHANGED_EVENT_REF__'];

      element.stateBag['__MEASUREMENT_CHANGED_EVENT_REF__'] = null;

      //restore the original width value
      if (element.stateBag.containsKey('__WIDTH_SHIM__')){
        element.rawElement.style.width =
            element.stateBag['__WIDTH_SHIM__'];
      }
    }
  }

  // Event handler for manual handling of horizontal element stretching
  void widthManualStretchHandler(_, MeasurementChangedEventArgs args){
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
}
