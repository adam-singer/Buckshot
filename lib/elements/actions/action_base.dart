// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


/**
* Base class for event-driven [FrameworkElement] actions.
*/
class ActionBase extends TemplateObject {

  FrameworkProperty eventProperty;

  /// A [String] representing the name of the target element to be operated
  /// on by the action.
  FrameworkProperty targetNameProperty;
  FrameworkProperty _sourceProperty;
  FrameworkElement _target;

  FrameworkElement get source => getValue(_sourceProperty);
  FrameworkElement get targetElement => _target;

  String get targetName => getValue(targetNameProperty);
  set targetName(String v) => setValue(targetNameProperty, v);

  final HashMap <String, EventHandlerReference> _ref;

  ActionBase()
  : _ref = new HashMap<String, EventHandlerReference>()
  {
    _initActionBaseProperties();
  }
  
  ActionBase.register() : super.register(),
    _ref = new HashMap<String, EventHandlerReference>();
  
  makeMe() => null;

  void _initActionBaseProperties(){

    targetNameProperty = new FrameworkProperty(this, 'targetName');

    _sourceProperty = new FrameworkProperty(this, '_source');

    eventProperty = new FrameworkProperty(this, 'event', (String e){

      var src = getValue(_sourceProperty);

      // set the event against the source element if it is available,
      // otherwise we wait until the source is available and set the
      // event then.
      if (src != null){
        _setEvent(e);
      }else{
        var ref;
        ref = _sourceProperty.propertyChanging + (_, PropertyChangingEventArgs args) {
          _setEvent(e);
          _sourceProperty.propertyChanging - ref;
        };
      }

    });
  }

  //TODO optimize this once reflection is in place.
  _setEvent(String eventName){
    var ee = eventName.toLowerCase();

    //only allow one registration per event
    if (_ref.containsKey(ee)) return;

    var _source = getValue(_sourceProperty);

    if (_source == null && _source is! FrameworkElement){
      throw const BuckshotException('action source is null or is not a FrameworkElement');
    }

    switch(ee){
      case 'click':
        _ref[ee] = _source.click + (_, __) => onEventTrigger();
        break;
      case 'mouseenter':
        _ref[ee] = _source.mouseEnter + (_, __) => onEventTrigger();
        break;
      case 'mouseleave':
        _ref[ee] = _source.mouseLeave + (_, __) => onEventTrigger();
        break;
      case 'mousemove':
        _ref[ee] = _source.mouseMove + (_, __) => onEventTrigger();
        break;
      case 'mouseup':
        _ref[ee] = _source.mouseUp + (_, __) => onEventTrigger();
        break;
      case 'mousedown':
        _ref[ee] = _source.mouseDown + (_, __) => onEventTrigger();
        break;
      case 'gotfocus':
        _ref[ee] = _source.gotFocus + (_, __) => onEventTrigger();
        break;
      case 'lostfocus':
        _ref[ee] = _source.lostFocus + (_, __) => onEventTrigger();
        break;
      case 'loaded':
        _ref[ee] = _source.loaded + (_, __) => onEventTrigger();
        break;
      case 'unloaded':
        _ref[ee] = _source.unloaded + (_,__) => onEventTrigger();
        break;
    }
  }

  abstract void onEventTrigger();

  /// Helper method used to set the target for the given action.
  /// Should
  void resolveTarget(){
    var tgt = getValue(targetNameProperty);
    if (tgt == null){
      if (source.name != null)
      {
        setValue(targetNameProperty, source.name);
      }

      _target = source;
    }else{
      var el = buckshot.namedElements[targetName];

      if (el == null)
        throw const BuckshotException('action Target was not found.');

      _target = el;
    }
  }
}
