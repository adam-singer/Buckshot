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
  
  FrameworkElement template;
  
  String get defaultControlTemplate() => '';
  
  bool _visualTemplateApplied = false;    // flags if visual template applied
  bool _templateApplied = false;          // flags if a template was used during applyVisualTemplate();
  bool _templateBindingsApplied = false;  // flags if template bindings have been applied
  
//  final HashMap<FrameworkProperty, String> _allTemplateBindings;
  
  Control()
//  : _allTemplateBindings = new HashMap<FrameworkProperty, String>()
  {
    _Dom.appendBuckshotClass(_component, "control");
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
    }, true, converter:const StringToBooleanConverter());
    
  }
  
  bool get isEnabled() => getValue(isEnabledProperty);
  set isEnabled(bool value) => setValue(isEnabledProperty, value);
  
  void applyVisualTemplate(){ 
    if (_visualTemplateApplied)
      throw const FrameworkException('Attempted to apply visual template more than once.');
    
    _visualTemplateApplied = true;
    
    if (!defaultControlTemplate.isEmpty()){
      Buckshot.defaultPresentationProvider.deserialize(defaultControlTemplate);
    }
    
    var t = Buckshot.retrieveResource(this.templateName);
    
    if (t == null){
      template = this;
      super.applyVisualTemplate();
      return;
    }
    
    _templateApplied = true;
    
    template = t.template;
    
    template.parent = this;
    _component = template._component;

    var ref;
    ref = this.loaded + (_, __){

      
      this.loaded - ref;
    };
  }
  
  onLoaded(){
    //returning if we have already done this, or if no template was actually used for this control
    if (_templateBindingsApplied || !_templateApplied) return;
    _templateBindingsApplied = true;
    
    _bindTemplateBindings();
  }
  
  void _bindTemplateBindings(){
    var tb = new HashMap<FrameworkProperty, String>();
    
    _getAllTemplateBindings(tb, template);
    
    tb.forEach((FrameworkProperty k, String v){
      var prop = this._getPropertyByName(v);
      if (prop == null){
        throw const FrameworkException('Attempted binding to null property in Control.');
      }
        new Binding(prop, k);
    });
  }
  
  void _getAllTemplateBindings(HashMap<FrameworkProperty, String> list, FrameworkElement element){
    
    element
      ._templateBindings
      .forEach((k, v){
        list[k] = v;  
      });
      
    if (element is! IFrameworkContainer) return;
    
    if (element.dynamic.content is List){
      element.dynamic.content.forEach((FrameworkElement child) => _getAllTemplateBindings(list, child));    
    }else if (element.dynamic.content is FrameworkElement){
      _getAllTemplateBindings(list, element.dynamic.content);
    }
  }
  
  /// Gets a standardized name for assignment to the [ControlTemplate] 'controlType' property.
  String get templateName() => 'template_${type}';
  
  String get type() => "Control";
}
