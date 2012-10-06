// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* A base class for control-type elements (buttons, etc). */
class Control extends FrameworkElement
{
  FrameworkProperty isEnabledProperty;

  FrameworkElement template;

  Future templateApplied;
  final Completer _c;

  String get defaultControlTemplate => '';

  bool _visualTemplateApplied = false;    // flags if visual template applied
  bool _templateApplied = false;          // flags if a template was used during applyVisualTemplate();
  bool _templateBindingsApplied = false;  // flags if template bindings have been applied

//  final HashMap<FrameworkProperty, String> _allTemplateBindings;

  Control()
      :
        _c = new Completer()
//  : _allTemplateBindings = new HashMap<FrameworkProperty, String>()
  {
    templateApplied = _c.future;
    Browser.appendClass(rawElement, "control");
    _initControlProperties();
  }

  Control.register() : super.register(),
    _c = new Completer();
  makeMe() => null;

  void _initControlProperties(){

    isEnabledProperty = new FrameworkProperty(this, "isEnabled", (bool value){
      if (value){
        if (rawElement.attributes.containsKey('disabled'))
          rawElement.attributes.remove('disabled');
      }else{
        rawElement.attributes['disabled'] = 'disabled';
      }
    }, true, converter:const StringToBooleanConverter());

  }

  bool get isEnabled => getValue(isEnabledProperty);
  set isEnabled(bool value) => setValue(isEnabledProperty, value);

  void applyVisualTemplate(){
    if (_visualTemplateApplied)
      throw const BuckshotException('Attempted to apply visual template more than once.');

    if (templateApplied == null){
      templateApplied = _c.future;
    }

    assert(templateApplied != null);

    _visualTemplateApplied = true;

    if (!defaultControlTemplate.isEmpty()){
      Template
      .deserialize(defaultControlTemplate)
      .then((_) => _finishApplyVisualTemplate());
    }else{
      _finishApplyVisualTemplate();
    }
  }

  void _finishApplyVisualTemplate(){
    var t = FrameworkResource.retrieveResource(this.templateName);

    if (t == null){
      template = this;
      super.applyVisualTemplate();
      return;
    }

    _templateApplied = true;

    template = t.template;

    rawElement = template.rawElement;
    template.parent = this;
    _c.complete(true);
  }

  onLoaded(){
    //returning if we have already done this, or if no template was actually used for this control
    if (_templateBindingsApplied || !_templateApplied) return;
    _templateBindingsApplied = true;

    _bindTemplateBindings();

    finishOnLoaded();
  }

  finishOnLoaded(){
    template.onAddedToDOM();
  }

  onUnLoaded(){
    //returning if we have already done this, or if no template was actually used for this control
    if (!_templateApplied) return;

    template.isLoaded = false;
  }

  void _bindTemplateBindings(){
    void _getAllTemplateBindings(HashMap<FrameworkProperty, String> list, FrameworkElement element){

      element
        ._templateBindings
        .forEach((k, v){
          list[k] = v;
        });

      if (element is! IFrameworkContainer) return;

      if (element.content is List){
        element.content.forEach((FrameworkElement child) => _getAllTemplateBindings(list, child));
      }else if (element.content is FrameworkElement){
        _getAllTemplateBindings(list, element.content);
      }
    }

    var tb = new HashMap<FrameworkProperty, String>();

    _getAllTemplateBindings(tb, template);

    tb.forEach((FrameworkProperty k, String v){
      getPropertyByName(v)
        .then((prop){
          if (prop == null){
            throw const BuckshotException('Attempted binding to null property in'
                ' Control.');
          }

          new Binding(prop, k);
        });
    });
  }

  /// Gets a standardized name for assignment to the [ControlTemplate] 'controlType' property.
  String get templateName => 'template_${hashCode()}';

  int _templatePriority() => 100;
}
