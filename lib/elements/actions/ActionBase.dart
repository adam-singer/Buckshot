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
* Base class for event-driven Element actions.
*/
class ActionBase extends BuckshotObject {
  
  FrameworkProperty eventProperty;
  
  FrameworkElement _source;
  
  FrameworkElement get source() => _source;
  
  final HashMap <String, EventHandlerReference> _ref;
  
  ActionBase()
  : _ref = new HashMap<String, EventHandlerReference>()
  {
    _initActionBaseProperties();
  }
  
  void _initActionBaseProperties(){
    eventProperty = new FrameworkProperty(this, 'event', (e){
      if (_source != null){ 
        _setEvent(e);
      }else{
        void checkSource(){
          if (_source != null){
            _setEvent(e);
          }else{
            window.setTimeout(checkSource, 1);
          }
        }
        
        window.setTimeout(checkSource, 1);
      }
    });
  }
  
  //TODO optimize this once reflection is in place.
  _setEvent(String eventName){
    var ee = eventName.toLowerCase();
    
    //only allow one registration per event
    //TODO should this constraint be in place?
    if (_ref.containsKey(ee)) return;
    
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
  
  String get type() => "ActionBase";
  
}
