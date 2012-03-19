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
* A base class for control-type elements (buttons, etc). */
class Control extends FrameworkElement
{
  FrameworkProperty isEnabledProperty;
  
  FrameworkElement templateObject;
  
  bool _templateApplied = false;
  
  Control(){
    _initControlProperties();
  }
  
  void _initControlProperties(){
    
    isEnabledProperty = new FrameworkProperty(this, "isEnabled", (bool value){
      if (value){
        if (_component.attributes.containsKey('disabled'))
          _component.attributes.remove('disabled');
      }else{
        _component.attributes['disabled'] = 'disabled';
      }
    }, true);
    
    isEnabledProperty.stringToValueConverter = const StringToBooleanConverter();
  }
  
  bool get isEnabled() => getValue(isEnabledProperty);
  set isEnabled(bool value) => setValue(isEnabledProperty, value);
  
  void applyVisualTemplate(){
    if (_templateApplied) throw const FrameworkException('Attempted to apply visual template to control more than once.');
    
    _templateApplied = true;
    
    templateObject = BuckshotSystem.retrieveResource(this.templateName);

    if (templateObject != null){
      _component = templateObject._component;
    }
  }
  
  /// By convention, template name should always be: 'template_{ControlName}'
  String get templateName() => 'template_${type}';
  
  String get type() => "Control";
}
