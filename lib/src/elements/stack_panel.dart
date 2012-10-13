// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Provides a container that stacks child elements vertically or horizontally. */
class Stack extends Panel
{
  FrameworkProperty orientationProperty;

  StackPolyfill _polyfill;
  Function _redraw;


  Stack()
  {
    Browser.appendClass(rawElement, "Stack");

    if (Polly.flexModel != FlexModel.Flex){
      _polyfill = new StackPolyfill(this);
      _polyfills['stack'] = _polyfill;

      _redraw = (){
        _polyfill.invalidate();
      };
    }else{
      _redraw = (){
        if (orientation == Orientation.vertical){
          children.forEach((FrameworkElement child){
            Polly.setItemHorizontalCrossAxisAlignment(child, child.hAlign);
          });
        }else{
          children.forEach((child){
            Polly.setItemVerticalCrossAxisAlignment(child, child.vAlign);
          });
        }
      };
    }

    initStackProperties();
  }

  Stack.register() : super.register();
  @override makeMe() => new Stack();

  void initStackProperties(){
    orientationProperty = new FrameworkProperty(
      this,
      "orientation",
      propertyChangedCallback:
        (Orientation value){

          if (_polyfill != null){
            _polyfill.orientation = value;
          }else{
            rawElement.style.flexFlow =
                (value == Orientation.vertical) ? 'column' : 'row';
          }
        },
      defaultValue: Orientation.vertical,
      converter:const StringToOrientationConverter());
  }

  @override void onChildrenChanging(ListChangedEventArgs args){
    super.onChildrenChanging(args);

    if (!args.oldItems.isEmpty()){
      args.oldItems.forEach((FrameworkElement element){
        element.removeFromLayoutTree();
      });
    }

    if (!args.newItems.isEmpty()){
      args.newItems.forEach((FrameworkElement element){
        element.addToLayoutTree(this);
      });

      updateLayout();
    }
  }

  set orientation(Orientation value) => setValue(orientationProperty, value);
  Orientation get orientation => getValue(orientationProperty);

  @override void createElement(){
    rawElement = new DivElement();
    Polly.makeFlexBox(rawElement);
    //rawElement.style.flexFlow = 'column';
    rawElement.style.overflow = 'hidden';

    Polly.setVerticalFlexBoxAlignment(this, VerticalAlignment.top);
    Polly.setHorizontalFlexBoxAlignment(this, HorizontalAlignment.left);
  }

  @override void updateLayout(){
    // set alignment of children along the cross access
    if (!isLoaded) return;
    _log.fine('updateLayout ($this)');
    _redraw();
  }
}
