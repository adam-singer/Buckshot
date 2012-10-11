// Copyright (c) 2012, John Evans
// http://www.buckshotui.org
// See LICENSE file for Apache 2.0 licensing information.

//TODO: Handle updates when margin/padding on watched elements is changed.

/**
 * Flexbox polyfill.  Supports horizontal and vertical alignments within
 * a parent container, including stretch.
 */
class _FlexboxPolyfill
{
  EventHandlerReference _eventReference;
  var _preservedWidth;
  var _preservedHeight;
  var _preservedLeftMargin;
  var _preservedTopMargin;

  final FrameworkElement element;

  HorizontalAlignment manualHorizontalAlignment;
  VerticalAlignment manualVerticalAlignment;

  _FlexboxPolyfill.with(this.element);

  /**
   * Enables given manual vertical [alignment] of element within it's parent
   * container.
   */
  void enableManualVerticalAlignment(VerticalAlignment alignment){
    if (manualVerticalAlignment != null && manualVerticalAlignment == alignment){
      return;
    }

    if (manualVerticalAlignment != null){
      disableManualVerticalAlignment();
    }

    if (alignment == VerticalAlignment.top) return;

    //db('>>> enabling vertical alignment', element);

    manualVerticalAlignment = alignment;

    void handleVerticalStretch(){
      //save the width value for later restoral
      _preservedHeight = element.rawElement.style.height;
    }

    void handleVerticalCenter(){
      _preservedTopMargin = element.margin;
    }

    void handleVerticalBottom(){
      _preservedTopMargin = element.margin;
    }

    switch(alignment){
      case VerticalAlignment.stretch:
        handleVerticalStretch();
        break;
      case VerticalAlignment.center:
        handleVerticalCenter();
        break;
      case VerticalAlignment.bottom:
        handleVerticalBottom();
        break;
    }

    _subscribeMeasurementChanged();
  }

  disableManualVerticalAlignment(){
    if (manualVerticalAlignment == null) return;

    //db('>>> disabling vertical alignment', element);

    if (manualHorizontalAlignment == null){
      _unsubscribeMeasurementChanged();
    }

    void handleVerticalStretch(){

      element.rawElement.style.height = _preservedHeight;

      _preservedHeight = null;
    }

    void handleVerticalCenter(){
      element.margin = _preservedTopMargin;

      _preservedTopMargin = null;
    }

    void handleVerticalBottom(){
      element.margin = _preservedTopMargin;

      _preservedTopMargin = null;
    }

    switch(manualVerticalAlignment){
      case VerticalAlignment.stretch:
        handleVerticalStretch();
        break;
      case VerticalAlignment.top:
        return;
      case VerticalAlignment.center:
        handleVerticalCenter();
        break;
      case VerticalAlignment.bottom:
        handleVerticalBottom();
        break;
    }

    manualVerticalAlignment = null;
  }

  /**
   * Enables given manual horizontal [alignment] of element within it's parent
   * container.
   */
  void enableManualHorizontalAlignment(HorizontalAlignment alignment){

    if (manualHorizontalAlignment != null &&
        manualHorizontalAlignment == alignment){
      return;
    }

    if (manualHorizontalAlignment != null){
      disableManualHorizontalAlignment();
    }

    if (alignment == HorizontalAlignment.left) return;

//    db('enable manual horizontal alignment', element);

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

    if (manualVerticalAlignment == null){
      _unsubscribeMeasurementChanged();
    }


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

    manualHorizontalAlignment = null;
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
    num newTop = 0;
    num newLeft = 0;

    final el = element as FrameworkElement;
    final elp = element.parent as FrameworkElement;

    void handleHorizontalStretch(){
      final num parentPaddingOffset = elp.hasProperty('padding')
                  ? elp.padding.left +
                      elp.padding.right
                  : 0;

      final num borderRadiusOffset = el.hasProperty('borderThickness')
              ? (el as Border).borderThickness.left +
                  (el as Border).borderThickness.right
              : 0;

      final measurementOffset = parentPaddingOffset + borderRadiusOffset;

      if (el.hasProperty('padding')){
        final calcWidth = args.newMeasurement.client.width -
            ((el as Border).padding.left +
                (el as Border).padding.right +
             element.margin.left +
             element.margin.right +
             measurementOffset);

        el.rawElement.style.width = '${calcWidth}px';
      }else{
        final calcWidth = args.newMeasurement.client.width -
            (el.margin.left +
                el.margin.right +
             measurementOffset);

        element.rawElement.style.width = '${calcWidth}px';
      }
    }

    void handleHorizontalCenter(ElementRect r){
      final num parentPaddingOffset = elp.hasProperty('padding')
          ? elp.padding.left +
              elp.padding.right
          : 0;

      final num borderRadiusOffset = el.hasProperty('borderThickness')
              ? el.borderThickness.left +
                  el.borderThickness.right
              : 0;

      final num measurementOffset = parentPaddingOffset + borderRadiusOffset;


      newLeft = ((args.newMeasurement.client.width / 2) -
          ((r.bounding.width + measurementOffset) / 2));
    }

    void handleHorizontalRight(ElementRect r){
      if (element.parent.rawElement.attributes.containsKey('data-buckshot-flexbox')
          && element.parent.rawElement.attributes['data-buckshot-flexbox'] == 'Multi'){
        // Ignore setting cross axis right on multi element flexboxes for now...
        return;
      }

      num offset = 0;

      offset += el.margin.right + el.margin.left;

      if (el.hasProperty('borderThickness')){
        offset += el.borderThickness.left + el.borderThickness.right;
      }

      if (elp.hasProperty('padding')){
        offset += elp.padding.right;
      }

      if (elp.hasProperty('borderThickness')){
        offset += elp.borderThickness.left + elp.borderThickness.right;
      }

      newLeft = args.newMeasurement.client.width -
          (r.client.width + offset);
    }

    void handleVerticalStretch(){
      final sh = el.rawElement.style.height;

      final offset = _getElementVerticalOffset(el);

      final calcHeight = args.newMeasurement.bounding.height - offset;

      el.rawElement.style.height = '${calcHeight}px';
     //db('starting height: $sh, ending height: ${el.rawElement.style.height}, parentHeight: ${args.newMeasurement.bounding.height}, parent: $elp[${elp.name}]', element);
    }

    void handleVerticalCenter(ElementRect r){

      final num parentPaddingOffset = (elp.hasProperty('padding'))
                ? elp.padding.top +
                    elp.padding.bottom
                : 0;

      final num borderRadiusOffset = el.hasProperty('borderThickness')
              ? el.borderThickness.top +
                  el.borderThickness.bottom
              : 0;

      final num measurementOffset = parentPaddingOffset + borderRadiusOffset;

      newTop = ((args.newMeasurement.client.height / 2) -
          ((r.client.height + measurementOffset) / 2));

     // db('*** vertical center parent height:${args.newMeasurement.client.height}, element height: ${r.client.height}, $position', element);
    }

    void handleVerticalBottom(ElementRect r){
      if (element.parent.rawElement.attributes.containsKey('data-buckshot-flexbox')
          && element.parent.rawElement.attributes['data-buckshot-flexbox'] == 'Multi'){
        // Ignore setting cross axis bottom on multi element flexboxes for now...
        return;
      }

      num offset = 0;

      offset += el.margin.bottom;

      if (el.hasProperty('borderThickness')){
        offset += el.borderThickness.bottom + el.borderThickness.top;
      }

      if (elp.hasProperty('padding')){
        offset += elp.padding.top;
      }

      if (elp.hasProperty('borderThickness')){
        offset += elp.borderThickness.bottom + elp.borderThickness.top;
      }

      newTop = args.newMeasurement.bounding.height -
          (r.bounding.height + offset);
    }

    el
    .updateMeasurementAsync
    .then((ElementRect r){

      if(manualHorizontalAlignment != null){
        switch(manualHorizontalAlignment){
          case HorizontalAlignment.stretch:
            handleHorizontalStretch();
            break;
          case HorizontalAlignment.center:
            handleHorizontalCenter(r);
            break;
          case HorizontalAlignment.right:
            handleHorizontalRight(r);
            break;
          default:
            print('Brutus: Invalid alignment.');
            break;
        }
      }

      if (manualVerticalAlignment != null){
        switch(manualVerticalAlignment){
          case VerticalAlignment.stretch:
            handleVerticalStretch();
            break;
          case VerticalAlignment.center:
            handleVerticalCenter(r);
            break;
          case VerticalAlignment.bottom:
            handleVerticalBottom(r);
            break;
          default:
            print('Brutus: Invalid alignment.');
            break;
        }
      }

     if (_preservedLeftMargin != null){
       el.rawElement.style.margin =
            '${newTop + _preservedLeftMargin.top}px'
            ' ${_preservedLeftMargin.right}px'
            ' ${_preservedLeftMargin.bottom}px'
            ' ${newLeft + _preservedLeftMargin.left}px';
     }else if (_preservedTopMargin != null){
        el.rawElement.style.margin =
            '${newTop + _preservedTopMargin.top}px'
            ' ${_preservedTopMargin.right}px'
            ' ${_preservedTopMargin.bottom}px'
            ' ${newLeft + _preservedTopMargin.left}px';
      }
    });
  }

  num _getElementHorizontalOffset(FrameworkElement el){
    final parent = el.parent;

    num offset = 0;

    offset += el.margin.left + el.margin.right;

    if (el.hasProperty('padding')){
      offset += el.padding.left + el.padding.right;
    }

    if (el.hasProperty('borderThickness')){
      offset += el.borderThickness.left + el.borderThickness.right;
    }

    if (parent.hasProperty('padding')){
      offset += parent.padding.left + parent.padding.right;
    }

    if (parent.hasProperty('borderThickness')){
      offset += parent.borderThickness.left + parent.borderThickness.right;
    }

    return offset;
  }

  num _getElementVerticalOffset(FrameworkElement el){
    final parent = el.parent;

    num offset = 0;

    offset += el.margin.bottom + el.margin.top;

    if (el.hasProperty('padding')){
      offset += el.padding.top + el.padding.bottom;
    }

    if (el.hasProperty('borderThickness')){
      offset += el.borderThickness.bottom + el.borderThickness.top;
    }

    if (parent.hasProperty('padding')){
      offset += parent.padding.top + parent.padding.bottom;
    }

    if (parent.hasProperty('borderThickness')){
      offset += parent.borderThickness.bottom + parent.borderThickness.top;
    }

    return offset;
  }
}
