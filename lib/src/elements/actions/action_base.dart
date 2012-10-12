// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


/**
* Base class for event-driven [FrameworkElement] actions.
*/
abstract class ActionBase extends TemplateObject {

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

  _setEvent(String eventName){
    var ee = eventName.toLowerCase();

    //only allow one registration per event
    if (_ref.containsKey(ee)) return;

    var _source = getValue(_sourceProperty);

    if (_source == null && _source is! FrameworkElement){
      throw const BuckshotException('action source is null or'
          ' is not a FrameworkElement');
    }

    if (!reflectionEnabled){
      if (_source._bindableEvents.containsKey(ee)){
        _ref[ee] = _source._bindableEvents[ee] + (_, __) => onEventTrigger();
      }
    }else{
      // TODO Implement reflection lookup on event bindings.
      throw const NotImplementedException('Needs mirror-based impl');
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
