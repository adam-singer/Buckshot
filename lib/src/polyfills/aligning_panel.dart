
/**
 * Polyfill for a flexbox containing a single child element which can
 * align top, bottom, left, right, center, and stretch.
 */
class AligningPanel extends Polyfill
{
  var _eventReference;
  Thickness _childMargin;
  num _childWidth;
  num _childHeight;
  FrameworkElement _currentChild;
  ElementRect _previousHeight;
  ElementRect _previousWidth;

  AligningPanel(FrameworkElement panelElement) : super(panelElement)
  {
    if (element is! IFrameworkContainer){
      throw const BuckshotException('Element must implement IFramworkContainer'
          ' in order to work with this polyfill.');
    }

    element.loaded + (_, __){
      assert(_eventReference == null);
      _eventReference = element.measurementChanged + onMeasurementChanged;
      //db('measurement change subscribed', element);
    };

    element.unloaded + (_, __){
      assert(_eventReference != null);

      element.measurementChanged - _eventReference;
      _eventReference = null;
    };
  }

  void onMeasurementChanged(sender, MeasurementChangedEventArgs args){
    invalidate();
  }

  void invalidate(){
    num newTop = 0;
    num newLeft = 0;
    final container = element as IFrameworkContainer;
    if (!element.isLoaded) return;
    if (container.content == null) return;

    if (container.content == null){
      _clearChildSettings();
      return;
    }

    final child = container.content as FrameworkElement;

    if (child != _currentChild){
      _initChild(child);
    }

    if (element.mostRecentMeasurement == null) return;

    //db('invalidate w:${element.mostRecentMeasurement.bounding.width} h:${element.mostRecentMeasurement.bounding.height}', element);

    if (_currentChild.hAlign == HorizontalAlignment.left &&
        _currentChild.vAlign == VerticalAlignment.top){
      // happy path
      return;
    }

    _currentChild
      .updateMeasurementAsync
      .then((ElementRect childRect){

        switch(_currentChild.vAlign){
          case VerticalAlignment.stretch:
            _handleVerticalStretch(childRect);
            break;
          case VerticalAlignment.center:
            newTop = _handleVerticalCenter(childRect);
            break;
          case VerticalAlignment.bottom:
            newTop = _handleVerticalBottom(childRect);
            break;
        }

        switch(_currentChild.hAlign){
          case HorizontalAlignment.stretch:
            _handleHorizontalStretch(childRect);
            break;
          case HorizontalAlignment.center:
            newLeft = _handleHorizontalCenter(childRect);
            break;
          case HorizontalAlignment.right:
            newLeft = _handleHorizontalRight(childRect);
            break;
        }

        _setMarginPosition(newTop, newLeft);

    });
  }



  void _setMarginPosition(num newTop, num newLeft){
    if (_childMargin == null){
      _currentChild.rawElement.style.margin = '${newTop}px 0px 0px ${newLeft}px';
    }else{
      _currentChild.rawElement.style.margin =
          '${newTop + _childMargin.top}px  ${_childMargin.right}px'
          ' ${_childMargin.bottom}px ${newLeft + _childMargin.left}px';
    }
  }

  void _handleVerticalStretch(ElementRect childRect){
    final elementRect = element.mostRecentMeasurement;

    //db('vertical stretch w:${elementRect.bounding.width} h:${elementRect.bounding.height}', element);

    num offset = 0;

    offset += _currentChild.margin.bottom + _currentChild.margin.top;

    /****** This section is experimental for the Button control *******/
    final tE = _currentChild is Control ? _currentChild.template : _currentChild;

    final sy = getValue(tE.shadowYProperty);

    if (sy != null){
      offset += (sy.abs() * 2);
    }

    final ty = getValue(tE.translateYProperty);

    if (ty != null){
      offset += (ty.abs() * 2);
    }

    final by = getValue(tE.shadowBlurProperty);
    if (by != null){
      offset += (by.abs() * 2);
    }
    /*******************************************************************/

    if (_currentChild.hasProperty('padding')){
      offset += _currentChild.padding.top + _currentChild.padding.bottom;
    }

    if (_currentChild.hasProperty('borderThickness')){
      offset += _currentChild.borderThickness.bottom + _currentChild.borderThickness.top;
    }

    if (element.hasProperty('padding')){
      offset += element.padding.top + element.padding.bottom;
    }

    if (element.hasProperty('borderThickness')){
      offset += element.borderThickness.bottom + element.borderThickness.top;
    }

    final calcHeight = elementRect.bounding.height - offset;

    if (_previousHeight == null || elementRect.bounding.height < _previousHeight.bounding.height){
        _clearVerticalHeights(_currentChild);
    }

    //db('child height before: ${_currentChild.rawElement.style.height}', _currentChild);
    _currentChild.rawElement.style.height = '${calcHeight}px';
    //db('child height after: ${_currentChild.rawElement.style.height}', _currentChild);
    _previousHeight = elementRect;
  }

  num _handleVerticalCenter(ElementRect childRect){
    final elementRect = element.mostRecentMeasurement;

    num offset = 0;

    if (element.hasProperty('padding')){
      offset += element.padding.top + element.padding.bottom;
    }

    if (_currentChild.hasProperty('borderThickness')){
      offset += _currentChild.borderThickness.top + _currentChild.borderThickness.bottom;
    }

    return ((elementRect.client.height / 2) -
        ((childRect.bounding.height + offset) / 2));
  }

  num _handleVerticalBottom(ElementRect childRect){
    final elementRect = element.mostRecentMeasurement;

    num offset = 0;

    offset += _currentChild.margin.bottom;

    if (_currentChild.hasProperty('borderThickness')){
      offset += _currentChild.borderThickness.bottom + _currentChild.borderThickness.top;
    }

    if (element.hasProperty('padding')){
      offset += element.padding.top;
    }

    if (element.hasProperty('borderThickness')){
      offset += element.borderThickness.bottom + element.borderThickness.top;
    }

    return elementRect.bounding.height - (childRect.bounding.height + offset);

  }

  void _handleHorizontalStretch(ElementRect childRect){
    final elementRect = element.mostRecentMeasurement;

    num offset = 0;

    /****** This section is experimental for the Button control *******/
    final tE = _currentChild is Control ? _currentChild.template : _currentChild;

    final sx = getValue(tE.shadowXProperty);

    if (sx != null){
      offset += (sx.abs() * 2);
    }

    final tx = getValue(tE.translateXProperty);

    if (tx != null){
      offset += (tx.abs() * 2);
    }

    final bx = getValue(tE.shadowBlurProperty);
    if (bx != null){
      offset += (bx.abs() * 2);
    }
    /*******************************************************************/

    offset += _currentChild.margin.left + _currentChild.margin.right;

    if (_currentChild.hasProperty('padding')){
      offset += _currentChild.padding.left + _currentChild.padding.right;
    }

    if (_currentChild.hasProperty('borderThickness')){
      offset += _currentChild.borderThickness.left + _currentChild.borderThickness.right;
    }

    if (element.hasProperty('padding')){
      offset += element.padding.left + element.padding.right;
    }

    if (element.hasProperty('borderThickness')){
      offset += element.borderThickness.left + element.borderThickness.right;
    }

    if (_previousWidth == null || elementRect.bounding.width < _previousWidth.bounding.width){
      _clearHorizontalWidths(_currentChild);
    }

    final calcWidth = elementRect.bounding.width - offset;

    _currentChild.rawElement.style.width = '${calcWidth}px';

    _previousWidth = elementRect;
  }

  num _handleHorizontalCenter(ElementRect childRect){
    final elementRect = element.mostRecentMeasurement;

    num offset = 0;

    if (element.hasProperty('padding')){
      offset += element.padding.left + element.padding.right;
    }

    if (_currentChild.hasProperty('borderThickness')){
      offset += _currentChild.borderThickness.left + _currentChild.borderThickness.right;
    }

    return ((elementRect.client.width / 2) -
        ((childRect.bounding.width + offset) / 2));

  }

  num _handleHorizontalRight(ElementRect childRect){
    final elementRect = element.mostRecentMeasurement;

    num offset = 0;

    offset += _currentChild.margin.right;

    if (_currentChild.hasProperty('borderThickness')){
      offset += _currentChild.borderThickness.right + _currentChild.borderThickness.left;
    }

    if (element.hasProperty('padding')){
      offset += element.padding.left;
    }

    if (element.hasProperty('borderThickness')){
      offset += element.borderThickness.right + element.borderThickness.left;
    }

    return elementRect.bounding.width - (childRect.bounding.width + offset);
  }


  void _initChild(FrameworkElement child){
    //db('init child', child);
    child.rawElement.style.display = 'table';

    if (_currentChild != null){
      _restoreChildSettings(_currentChild);
    }

    _captureChildSettings(child);

    _currentChild = child;

  }

  void _restoreChildSettings(FrameworkElement childElement){
    childElement.width = _childWidth;
    childElement.height = _childHeight;
    childElement.margin = _childMargin;
  }

  void _clearChildSettings(){
    _childWidth = null;
    _childHeight = null;
    _childMargin = null;
  }

  void _captureChildSettings(FrameworkElement childElement){
    _childWidth = childElement.width;
    _childHeight = childElement.height;
    _childMargin = childElement.margin;
  }


  void _clearVerticalMargins(FrameworkElement nextElement){
    return;
    if (!nextElement._polyfills.containsKey('layout')) return;

    //print('${element._polyfills['alignmentpanel']._childMargin}');
    nextElement.margin = element._polyfills['layout']._childMargin;

    if (nextElement.content == null) return;
    _clearVerticalMargins(nextElement.content);
  }

  // Clears descendent alignmentpanels height so layout pass can work when
  // the parent container is shrinking.
  // (firefox)
  void _clearVerticalHeights(FrameworkElement nextElement){
    if (!nextElement._polyfills.containsKey('layout')) return;

    //db('...clearing verticle', element);
    nextElement.rawElement.style.height = 'auto';

    if (nextElement.content == null) return;

    if (nextElement.content.vAlign == VerticalAlignment.bottom){
      final m = nextElement._polyfills['layout']._childMargin;

      nextElement.content.rawElement.style.margin = '${m.top}px ${m.right}px ${m.bottom}px ${m.left}px';
    }

    if (nextElement.content.vAlign == VerticalAlignment.stretch){
      nextElement.content.rawElement.style.height = '0px';
    }

    _clearVerticalHeights(nextElement.content);

  }

  // Clears descendent alignmentpanels width so layout pass can work when
  // the parent container is shrinking.
  // (firefox)
  void _clearHorizontalWidths(FrameworkElement nextElement){
    if (!nextElement._polyfills.containsKey('layout')) return;

    //db('...clearing verticle', element);
    nextElement.rawElement.style.width = 'auto';
    if (nextElement.content == null) return;

    if (nextElement.content.hAlign == HorizontalAlignment.right){
      final m = nextElement._polyfills['layout']._childMargin;

      nextElement.content.rawElement.style.margin = '${m.top}px ${m.right}px ${m.bottom}px ${m.left}px';
    }

    if (nextElement.content.hAlign == HorizontalAlignment.stretch){
      nextElement.content.rawElement.style.width = '0px';
    }

    _clearHorizontalWidths(nextElement.content);
  }
}

