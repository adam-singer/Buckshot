// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* A base class for control-type elements (buttons, etc). */
abstract class Control extends FrameworkElement
{
  FrameworkProperty<bool> isEnabled;

  FrameworkElement template;

  /**
   * Required getter for all controls.  Can return one of three values:
   *
   * * Empty String: means the default createElement() method will be used.
   * * String: Expects the string to be a control template.
   * * ControlTemplate: A concrete control template.
   */
  abstract get defaultControlTemplate;

  bool _visualTemplateApplied = false;    // flags if visual template applied
  bool _templateApplied = false;          // flags if a template was used during applyVisualTemplate();
  bool _templateBindingsApplied = false;  // flags if template bindings have been applied

  Control()
  {
    Browser.appendClass(rawElement, "control");
    _initControlProperties();
  }

  Control.register() : super.register();
  makeMe() => null;

  void _initControlProperties(){
    isEnabled = new FrameworkProperty(this, "isEnabled",
      propertyChangedCallback: (bool value){
        if (value){
          if (rawElement.attributes.containsKey('disabled'))
            rawElement.attributes.remove('disabled');
        }else{
          rawElement.attributes['disabled'] = 'disabled';
        }
      },
      defaultValue: true,
      converter: const StringToBooleanConverter());
  }

  void applyVisualTemplate(){
    assert(!_visualTemplateApplied && !_templateApplied);

    _visualTemplateApplied = true;

    if (defaultControlTemplate is ControlTemplate){
      final tName = XML.parse(defaultControlTemplate.rawData).attributes['controlType'];
      assert(tName != null);
      assert(!tName.isEmpty());
      Template
        .deserialize(defaultControlTemplate.rawData)
        .then((_) => _finishApplyVisualTemplate(tName));
    } else if (defaultControlTemplate is String && !defaultControlTemplate.isEmpty()){
      final tName = XML.parse(defaultControlTemplate).attributes['controlType'];
      assert(tName != null);
      assert(!tName.isEmpty());
      Template
        .deserialize(defaultControlTemplate)
        .then((_) => _finishApplyVisualTemplate(tName));
    }else{
      final tName = templateName;
      assert(tName != null);
      assert(!tName.isEmpty());
      _finishApplyVisualTemplate('');
    }
  }

  void _finishApplyVisualTemplate(String t){
    if (t.isEmpty()){
      template = this;
      super.applyVisualTemplate();
      return;
    }

    final controlTemplate = getResource(t) as ControlTemplate;
    assert(controlTemplate != null);

    _templateApplied = true;

    template = controlTemplate.template.value;

    //log('control template applied: $template', element: this);

    rawElement = template.rawElement;
    template.parent = this;
  }

  onLoaded(){
    //returning if we have already done this, or if no template was actually used for this control
    if (_templateBindingsApplied || !_templateApplied) return;
    _templateBindingsApplied = true;

    _bindTemplateBindings();

    finishOnLoaded();
  }

  finishOnLoaded(){
    //log('adding to DOM: $template', element: this);
    template.onAddedToDOM();
  }

  onUnLoaded(){
    //returning if we have already done this, or if no template was actually used for this control
    if (!_templateApplied) return;

    template.isLoaded = false;
  }

  void _bindTemplateBindings(){
    var tb = new HashMap<FrameworkProperty, String>();

    _getAllTemplateBindings(tb, template);

//    log('*** template bindings: $tb', element:this);

    tb.forEach((FrameworkProperty k, String v){
      getPropertyByName(v)
        .then((prop){
         //log('setting template binding from $prop to $k', element: this);
          assert(prop != null);
          new Binding(prop, k);
        });
    });
  }

  void _getAllTemplateBindings(bindingMap, element){

    element
      ._templateBindings
      .forEach((k, v){
        bindingMap[k] = v;
      });

    if (element is! FrameworkContainer) return;

    if (element.containerContent is List){
      element
        .containerContent
        .forEach((FrameworkElement child) =>
            _getAllTemplateBindings(bindingMap, child));
    }else if (element.containerContent is FrameworkElement){
      _getAllTemplateBindings(bindingMap, element.containerContent);
    }
  }

  /// Gets a standardized name for assignment to the [ControlTemplate] 'controlType' property.
  String get templateName => 'template_${hashCode()}';
}
