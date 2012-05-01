//   Copyright (c) 2012, John Evans & LUCA Studios LLC
//
//   http://www.lucastudios.com/contact
//   John: https://plus.google.com/u/0/115427174005651655317/about
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.


/**
* Base class for event-driven [FrameworkElement] actions.
*/
class ActionBase extends BuckshotObject {
  
  FrameworkProperty eventProperty;
  
  /// A [String] representing the name of the target element to be operated
  /// on by the action.
  FrameworkProperty targetNameProperty;
  FrameworkProperty _sourceProperty;
  FrameworkElement _target;
  
  FrameworkElement get source() => getValue(_sourceProperty);
  FrameworkElement get target() => _target;
      
  String get targetName() => getValue(targetNameProperty);
  set targetName(String v) => setValue(targetNameProperty, v);
  
  final HashMap <String, EventHandlerReference> _ref;
  
  ActionBase()
  : _ref = new HashMap<String, EventHandlerReference>()
  {
    _initActionBaseProperties();
  }
    
  void _initActionBaseProperties(){
  
    targetNameProperty = new FrameworkProperty(this, 'targetName', (_){});
    
    _sourceProperty = new FrameworkProperty(this, '_source', (_){});
    
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
  
  String get type() => "ActionBase";
  
}
