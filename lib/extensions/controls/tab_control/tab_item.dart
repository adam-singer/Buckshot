part of tabcontrol_controls_buckshot;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

class TabItem extends Control implements FrameworkContainer
{
  FrameworkProperty<FrameworkElement> header;
  FrameworkProperty<FrameworkElement> icon;
  FrameworkProperty<bool> closeEnabled;
  FrameworkProperty<Visibility> _closeButtonVisiblity;
  FrameworkProperty<dynamic> content;

  FrameworkElement _visualTemplate;

  TabItem(){
    Browser.appendClass(rawElement, "TabItem");

    _initTabItemProperties();

    stateBag[FrameworkObject.CONTAINER_CONTEXT] = content;
  }

  TabItem.register() : super.register();
  makeMe() => new TabItem();

  get containerContent => content.value;

  void _initTabItemProperties(){
    header = new FrameworkProperty(this, 'header');

    icon = new FrameworkProperty(this, 'icon');

    content = new FrameworkProperty(this, 'content',
        propertyChangedCallback:(value){
          // ensure that the content has a parent assigned so that
          // .onAddedToDOM() will bind events successfully.
          if (value is FrameworkElement && value.parent == null){
            value.parent = this;
          }
    });

    _closeButtonVisiblity = new FrameworkProperty(this,
        'closeButtonVisibility',
        propertyChangedCallback: (Visibility value){
          if (value == Visibility.visible
              && closeEnabled.value == false){
            _closeButtonVisiblity.value = Visibility.collapsed;
          }
        },
        defaultValue: Visibility.collapsed,
        converter: const StringToVisibilityConverter());

    closeEnabled = new FrameworkProperty(this, 'closeEnabled',
        propertyChangedCallback: (bool value){
          if (value == false){
            _closeButtonVisiblity.value = Visibility.collapsed;
          }
        },
        defaultValue: true,
        converter: const StringToBooleanConverter());
  }

  get defaultControlTemplate => '';
}
