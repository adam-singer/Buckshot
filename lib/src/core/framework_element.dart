// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Represents a base class for all visual elements in the framework.
* Generally speaking all elements that render DOM output should derive
* from this class.
*/
class FrameworkElement extends FrameworkObject
{
  StyleTemplate _style;

  final HashMap<FrameworkProperty, String> _templateBindings =
    new HashMap<FrameworkProperty, String>();

  final HashMap<String, String> _transitionProperties =
      new HashMap<String, String>();

  // registered polyfills
  final HashMap<String, Dynamic> _polyfills = new HashMap<String, Object>();

  FrameworkProperty<bool> userSelect;
  /// Represents the margin [Thickness] area outside the FrameworkElement boundary.
  FrameworkProperty<Thickness> margin;
  /// Represents the width of the FrameworkElement.
  FrameworkProperty<num> width;
  /// Represents the height of the FrameworkElement.
  FrameworkProperty<num> height;
  /// Represents the HTML 'ID' property of the FrameworkElement.
  FrameworkProperty<String> htmlID;
  /// Represents the maximum width property of the FrameworkElement.
  FrameworkProperty<num> maxWidth;
  /// Represents the minimum height property of the FrameworkElement.
  FrameworkProperty<num> minWidth;
  /// Represents the maximum height property of the FrameworkElement.
  FrameworkProperty<num> maxHeight;
  /// Represents the minimum height proeprty of the FrameworkElement.
  FrameworkProperty<num> minHeight;
  /// Represents the shape the cursor will take when passing over the FrameworkElement.
  FrameworkProperty<Cursors> cursor;
  /// Represents a general use [Object] property of the FrameworkElement.
  FrameworkProperty<Object> tag;
  /// Represents the horizontal alignment of this FrameworkElement inside another element.
  FrameworkProperty<HorizontalAlignment> hAlign;
  /// Represents the [VerticalAlignment] of this FrameworkElement inside another element.
  FrameworkProperty<VerticalAlignment> vAlign;
  /// Represents the html z order of this FrameworkElement in relation to other elements.
  FrameworkProperty<int> zOrder;
  /// Represents the actual adjusted width of the FrameworkElement.
  FrameworkProperty<num> actualWidth;
  /// Represents the actual adjusted height of the FrameworkElement.
  FrameworkProperty<num> actualHeight;
  /// Represents the opacity value [Double] of the FrameworkElement.
  AnimatingFrameworkProperty<num> opacity;
  /// Represents the [Visibility] property of the FrameworkElement.
  AnimatingFrameworkProperty<Visibility> visibility;
  /// Represents the [StyleTemplate] value that is currently applied to the FrameworkElement.
  FrameworkProperty<StyleTemplate> style;
  /// Represents whether an element is draggable
  FrameworkProperty<bool> draggable;

  FrameworkProperty<num> shadowX;
  FrameworkProperty<num> shadowY;
  FrameworkProperty<num> shadowBlur;
  FrameworkProperty<num> shadowSize;
  FrameworkProperty<Color> shadowColor;
  FrameworkProperty<String> shadowInset;

  AnimatingFrameworkProperty<num> translateX;
  AnimatingFrameworkProperty<num> translateY;
  AnimatingFrameworkProperty<num> translateZ;
  AnimatingFrameworkProperty<num> scaleX;
  AnimatingFrameworkProperty<num> scaleY;
  AnimatingFrameworkProperty<num> scaleZ;
  AnimatingFrameworkProperty<num> rotateX;
  AnimatingFrameworkProperty<num> rotateY;
  AnimatingFrameworkProperty<num> rotateZ;
  FrameworkProperty<num> transformOriginX;
  FrameworkProperty<num> transformOriginY;
  FrameworkProperty<num> transformOriginZ;
  FrameworkProperty<num> perspective;

  FrameworkProperty<ObservableList<ActionBase>> actions;

  //events
  /// Fires when the DOM gives the FrameworkElement focus.
  FrameworkEvent<EventArgs> gotFocus;
  /// Fires when the DOM removes focus from the FrameworkElement.
  FrameworkEvent<EventArgs> lostFocus;
  /// Fires when the mouse enters the boundary of the FrameworkElement.
  FrameworkEvent<EventArgs> mouseEnter;
  /// Fires when the mouse leaves the boundary of the FrameworkElement.
  FrameworkEvent<EventArgs> mouseLeave;
  /// Fires when a mouse click occurs on the FrameworkElement.
  FrameworkEvent<MouseEventArgs> click;
  /// Fires when the mouse position changes over the FrameworkElement.
  FrameworkEvent<MouseEventArgs> mouseMove;
  /// Fires when the mouse button changes to a down position while over the FrameworkElement.
  FrameworkEvent<MouseEventArgs> mouseDown;
  /// Fires when the mouse button changes to an up position while over the FrameworkElement.
  FrameworkEvent<MouseEventArgs> mouseUp;
//  FrameworkEvent<KeyEventArgs> keyUp;
//  FrameworkEvent<KeyEventArgs> keyDown;

  //TODO mouseWheel, onScroll;

  //---------------------------------------------------------------------
  // Drag events
  //---------------------------------------------------------------------

  /// Fires when an object is dragged into the drop target's boundary
  FrameworkEvent<DragEventArgs> dragEnter;
  /// Fires when an object is dragged out of the drop target's boundary.
  FrameworkEvent<DragEventArgs> dragLeave;
  /// Fires repeatedly when an object is over a target's boundary.
  FrameworkEvent<DragEventArgs> dragOver;
  /// Fires when an object is dropped within a target's boundary.
  FrameworkEvent<DragEventArgs> drop;
  /// Fires when an object starts being dragged.
  FrameworkEvent<DragEventArgs> dragStart;
  /// Fires when an object stops being dragged.
  FrameworkEvent<DragEventArgs> dragEnd;

  FrameworkElement()
  {
    Browser.appendClass(rawElement, "FrameworkElement");

    //give a blank style so merging works immediately
    _style = new StyleTemplate();

    _initFrameworkProperties();

    _initFrameworkEvents();

    if (reflectionEnabled){
      return;
    }

    _registerEvents();

  }

  FrameworkElement.register() : super.register();
  makeMe() => null;


  static void _doTransform(FrameworkElement e){

    var tx = e.translateX.value;
    var ty = e.translateY.value;
    var tz = e.translateZ.value;
    var sx = e.scaleX.value;
    var sy = e.scaleY.value;
    var sz = e.scaleZ.value;
    var rx = e.rotateX.value;
    var ry = e.rotateY.value;
    var rz = e.rotateZ.value;

    // set to identity if null
    if (tx == null) tx = 0;
    if (ty == null) ty = 0;
    if (tz == null) tz = 0;
    if (sx == null) sx = 1;
    if (sy == null) sy = 1;
    if (sz == null) sz = 1;
    if (rx == null) rx = 0;
    if (ry == null) ry = 0;
    if (rz == null) rz = 0;

    e.rawElement.style.transform =
        '''
        translateX(${tx}px) translateY(${ty}px) translateZ(${tz}px)
        scaleX(${sx}) scaleY(${sy}) scaleZ(${sz}) 
        rotateX(${rx}deg) rotateY(${ry}deg) rotateZ(${rz}deg)
        ''';
  }

  static void _drawShadow(FrameworkElement e){
    var sx = e.shadowX.value;
    var sy = e.shadowY.value;
    var b = e.shadowBlur.value;
    var s = e.shadowSize.value;
    var c = e.shadowColor.value;
    var inset = e.shadowInset.value;

    // set nulls
    sx = (sx == null) ? '' : '${sx}px';
    sy = (sy == null) ? '' : '${sy}px';
    b = (b == null) ? '' : '${b}px';
    s = (s == null) ? '' : '${s}px';

    if (c != null){
      c = '${c.toColorString()}';
    }else{
      c = new Color.predefined(Colors.Black).toColorString();
    }
    if (inset == null) inset = '';
    if (inset is bool){
      inset = (inset) ? 'inset' : '';
    }

    e.rawElement.style.boxShadow = '$sx $sy $b $s $c $inset'.trim();
  }

  static void _setTransformOrigin(FrameworkElement e){
    var tx = e.transformOriginX.value;
    var ty = e.transformOriginY.value;
    var tz = e.transformOriginZ.value;

    if (tx == null) tx = 0;
    if (ty == null) ty = 0;
    if (tz == null) tz = 0;

    e.rawElement.style.transformOrigin = '${tx}px ${ty}px ${tz}px';
  }

  void _initFrameworkProperties(){

    userSelect = new FrameworkProperty(this, 'userSelect',
        propertyChangedCallback:
          (bool value){
            rawElement.style.userSelect = value ? 'all' : 'none';
          },
        defaultValue: false,
        converter: const StringToBooleanConverter());

    shadowX = new FrameworkProperty(this, 'shadowX',
        propertyChangedCallback: (_) => _drawShadow(this),
        converter:const StringToNumericConverter());

    shadowY = new FrameworkProperty(this, 'shadowY',
        propertyChangedCallback: (_) => _drawShadow(this),
        converter:const StringToNumericConverter());

    shadowBlur = new FrameworkProperty(this, 'shadowBlur',
        propertyChangedCallback: (_) => _drawShadow(this),
        converter:const StringToNumericConverter());

    shadowSize = new FrameworkProperty(this, 'shadowSize',
        propertyChangedCallback: (_) => _drawShadow(this),
        converter:const StringToNumericConverter());

    shadowColor = new FrameworkProperty(this, 'shadowColor',
        propertyChangedCallback: (_) => _drawShadow(this),
        converter:const StringToColorConverter());

    shadowInset = new FrameworkProperty(this, 'shadowInset',
        propertyChangedCallback: (_) => _drawShadow(this),
        converter:const StringToBooleanConverter());

    actions = new FrameworkProperty(this, 'actions',
        (ObservableList<ActionBase> aList){
          if (actions != null){
            throw const BuckshotException('FrameworkElement.actionsProperty'
                ' collection can only be assigned once.');
          }

          aList.listChanged + (_, ListChangedEventArgs args){
            if (args.oldItems.length > 0)
              throw const BuckshotException('Actions cannot be removed once'
                  ' added to the collection.');

            //assign this element as the source to any new actions
            args.newItems.forEach((ActionBase action){
              action._source.value = this;
            });
        };
    }, new ObservableList<ActionBase>());


    //TODO: propogate this property in elements that use virtual containers

    perspective = new FrameworkProperty(this, "perspective", (num value){
      Polly.setCSS(rawElement, 'perspective', '$value');
    },converter:const StringToNumericConverter());

    translateX = new AnimatingFrameworkProperty(this, "translateX",
      'transform',
      propertyChangedCallback:(num value) => _doTransform(this),
      converter:const StringToNumericConverter());

    translateY = new AnimatingFrameworkProperty(this, "translateY",
      'transform',
      propertyChangedCallback:(num value) => _doTransform(this),
      converter:const StringToNumericConverter());


    translateZ = new AnimatingFrameworkProperty(this, "translateZ",
      'transform',
      propertyChangedCallback:(num value) => _doTransform(this),
      converter:const StringToNumericConverter());


    scaleX = new AnimatingFrameworkProperty(this, "scaleX",
      'transform',
      propertyChangedCallback:(num value) => _doTransform(this),
      converter:const StringToNumericConverter());


    scaleY = new AnimatingFrameworkProperty(this, "scaleY",
        'transform',
        propertyChangedCallback:(num value) => _doTransform(this),
        converter:const StringToNumericConverter());


    scaleZ = new AnimatingFrameworkProperty(this, "scaleZ",
        'transform',
        propertyChangedCallback:(num value) => _doTransform(this),
        converter:const StringToNumericConverter());

    rotateX = new AnimatingFrameworkProperty(this, "rotateX",
        'transform',
        propertyChangedCallback:(num value) => _doTransform(this),
        converter:const StringToNumericConverter());


    rotateY = new AnimatingFrameworkProperty(this, "rotateY",
        'transform',
        propertyChangedCallback:(num value) => _doTransform(this),
        converter:const StringToNumericConverter());


    rotateZ = new AnimatingFrameworkProperty(this, "rotateZ",
        'transform',
        propertyChangedCallback:(num value) => _doTransform(this),
        converter:const StringToNumericConverter());


    transformOriginX = new FrameworkProperty(this, "transformOriginX",
      (num value){
        _setTransformOrigin(this);
    }, converter:const StringToNumericConverter());

    transformOriginY = new FrameworkProperty(this, "transformOriginY",
      (num value){
        _setTransformOrigin(this);
    }, converter:const StringToNumericConverter());

    transformOriginZ = new FrameworkProperty(this, "transformOriginZ",
      (num value){
        _setTransformOrigin(this);
    }, converter:const StringToNumericConverter());

    opacity = new AnimatingFrameworkProperty(
      this,
      "opacity",
      'opacity',
      propertyChangedCallback:(value){
        if (value < 0.0) value = 0.0;
        if (value > 1.0) value = 1.0;
        rawElement.style.opacity = value.toStringAsPrecision(2);
        //rawElement.style.filter = "alpha(opacity=${value * 100})";
      },
      converter:const StringToNumericConverter());

    visibility = new AnimatingFrameworkProperty(
      this,
      "visibility",
      'visibility',
      propertyChangedCallback:(Visibility value){
        if (value == Visibility.visible){
          rawElement.style.visibility = '$value';

          rawElement.style.display =
              stateBag["display"] == null ? "inherit" : stateBag["display"];
          stateBag.remove("display");
        }else{
          //preserve in case some element is using "inline" or some other fancy display value
          stateBag["display"] = rawElement.style.display;
          rawElement.style.visibility = '$value';

          rawElement.style.display = "none";
        }
      },
      converter:const StringToVisibilityConverter());

    zOrder = new FrameworkProperty(
      this,
      "zOrder",
      (num value){
        rawElement.style.zIndex = value.toInt().toString(); //, null);
      }, converter:const StringToNumericConverter());

    margin = new FrameworkProperty(
      this,
      "margin",
      (Thickness value){
        rawElement.style.margin = '${value.top}px ${value.right}px ${value.bottom}px ${value.left}px'; //, null);
        if (parent != null) parent.updateLayout();
      }, new Thickness(0), converter:const StringToThicknessConverter());

    actualWidth = new FrameworkProperty(this, "actualWidth");

    actualHeight = new FrameworkProperty(this, "actualHeight");

    width = new FrameworkProperty(
      this,
      "width",
      (Dynamic value) => calculateWidth(value),
      defaultValue:"auto",
      converter:const StringToNumericConverter());

    height = new FrameworkProperty(
      this,
      "height",
      (Dynamic value) => calculateHeight(value),
      defaultValue:"auto",
      converter:const StringToNumericConverter());

    minHeight = new FrameworkProperty(
      this,
      "minHeight",
      (value){
        rawElement.style.minHeight = '${value}px';
      }, converter:const StringToNumericConverter());

    maxHeight = new FrameworkProperty(
      this,
      "maxHeight",
      (value){
        rawElement.style.maxHeight = '${value}px';
      }, converter:const StringToNumericConverter());

    minWidth = new FrameworkProperty(
      this,
      "minWidth",
      (value){
        rawElement.style.minWidth = '${value}px';
      }, converter:const StringToNumericConverter());

    maxWidth = new FrameworkProperty(
      this,
      "maxWidth",
      (value){
        rawElement.style.maxWidth = '${value}px';
      }, converter:const StringToNumericConverter());

    cursor = new FrameworkProperty(
      this,
      "cursor",
      (Cursors value){
        rawElement.style.cursor = '$value';
      }, converter:const StringToCursorConverter());

    tag = new FrameworkProperty(
      this,
      "tag",
      (value){});

    hAlign = new FrameworkProperty(
      this,
      "hAlign",
      (HorizontalAlignment value){
        updateMeasurementAsync.then((_){
          if (parent != null) parent.updateLayout();
        });
      },
      HorizontalAlignment.left, converter:const StringToHorizontalAlignmentConverter());

    vAlign = new FrameworkProperty(
      this,
      "vAlign",
      (VerticalAlignment value){
        updateMeasurementAsync.then((_){
          if (parent != null) parent.updateLayout();
        });
      },
      VerticalAlignment.top, converter:const StringToVerticalAlignmentConverter());

    style = new FrameworkProperty(
      this,
      "style",
      (StyleTemplate value){
        if (value == null){
          //setting non-null style to null
          _style._unregisterElement(this);
          style.previousValue = _style;
          _style = new StyleTemplate();
          style.value = _style;
        }else{
          //replacing style with style
          if (_style != null) _style._unregisterElement(this);
          value._registerElement(this);
          _style = value;
        }
      }, new StyleTemplate());

    draggable = new FrameworkProperty(
      this,
      "draggable",
      (bool value) {
        rawElement.draggable = value;
      },
      false,
      converter:const StringToBooleanConverter());
  }

  /// ** Internal Use Only **
  void calculateWidth(value){
    if (value == "auto"){
      rawElement.style.width = "auto"; //, null);
      this.updateMeasurementAsync.then((_){
        if (this is FrameworkContainer){
          updateLayout();
        }else{
          if (parent != null) parent.updateLayout();
        }
      });
      return;
    }

    if (minWidth.value != null && value < minWidth.value){
      width.value = minWidth.value;
    }

    if (maxWidth.value != null && value > maxWidth.value){
      width.value = maxWidth.value;
    }

    rawElement.style.width = '${value}px';

    this.updateMeasurementAsync.then((_){
      if (this is FrameworkContainer){
        updateLayout();
      }else{
        if (parent != null) parent.updateLayout();
      }
    });

  }

  /// ** Internal Use Only **
  void calculateHeight(value){
    if (value == "auto"){
      rawElement.style.height = "auto";//, null);
      this.updateMeasurementAsync.then((_){
        if (this is FrameworkContainer){
          updateLayout();
        }else{
          if (parent != null) parent.updateLayout();
        }
      });
      return;
    }

    if (minHeight.value != null && value < minHeight.value){
      height.value = minHeight.value;
    }

    if (maxHeight.value != null && value > maxHeight.value){
      height.value =  maxHeight.value;
    }

   rawElement.style.height = '${value}px'; //, null);

   this.updateMeasurementAsync.then((_){
     if (this is FrameworkContainer){
       updateLayout();
     }else{
       if (parent != null) parent.updateLayout();
     }
   });

  }

  //TODO: throw exception (maybe) if element is not loaded in DOM
  Future<ElementRect> get updateMeasurementAsync{
   Completer c = new Completer();

   rawElement.rect.then((ElementRect r){
    actualWidth.value = r.bounding.width;
    actualHeight.value = r.bounding.height;
    this.mostRecentMeasurement = r;
    c.complete(r);
   });

   return c.future;
  }



  void _initFrameworkEvents(){
//
//    void keyHandler(e){
//      if (!keyUp.hasHandlers) return;
//
//      e.stopPropagation();
//
//      var ev = new KeyEventArgs(e.keyCode, e.charCode);
//      ev.altKey = e.altKey;
//      ev.shiftKey = e.shiftKey;
//      ev.ctrlKey = e.ctrlKey;
//
//      keyUp.invoke(this, ev);
//    }
//
//    keyUp = new FrameworkEvent<EventArgs>
//    ._watchFirstAndLast(
//      () => rawElement.on.keyUp.add(keyHandler),
//      () => rawElement.on.keyUp.add(keyHandler)
//      );
//
//    keyDown = new FrameworkEvent<EventArgs>
//    ._watchFirstAndLast(
//      () => rawElement.on.keyDown.add(keyHandler),
//      () => rawElement.on.keyDown.add(keyHandler)
//      );

    void mouseUpHandler(e){
      if (!mouseUp.hasHandlers) return;

      e.stopPropagation();

      Polly
      .localMouseCoordinate(rawElement, e.pageX, e.pageY)
      .then((p){
        mouseUp.invoke(this, new MouseEventArgs(p.x, p.y, e.pageX, e.pageY));
      });
    }

    mouseUp = new BuckshotEvent<MouseEventArgs>
    ._watchFirstAndLast(
      () => rawElement.on.mouseUp.add(mouseUpHandler),
      () => rawElement.on.mouseUp.remove(mouseUpHandler)
    );

    void mouseDownHandler(e){
      rawElement.focus();

      if (!mouseDown.hasHandlers) return;

      e.stopPropagation();


      Polly
      .localMouseCoordinate(rawElement, e.pageX, e.pageY)
      .then((p){
        mouseDown.invoke(this, new MouseEventArgs(p.x, p.y, e.pageX, e.pageY));
      });
    }

    mouseDown = new BuckshotEvent<MouseEventArgs>
    ._watchFirstAndLast(
      () => rawElement.on.mouseDown.add(mouseDownHandler),
      () => rawElement.on.mouseDown.remove(mouseDownHandler)
    );


    void mouseMoveHandler(e){
      if (!mouseMove.hasHandlers) return;

      e.stopPropagation();

      Polly
      .localMouseCoordinate(rawElement, e.pageX, e.pageY)
      .then((p){
        mouseMove.invoke(this, new MouseEventArgs(p.x, p.y, e.pageX, e.pageY));
      });
    }

    mouseMove = new BuckshotEvent<MouseEventArgs>
    ._watchFirstAndLast(
      () => rawElement.on.mouseMove.add(mouseMoveHandler),
      () => rawElement.on.mouseMove.remove(mouseMoveHandler)
    );

    void clickHandler(e){
      rawElement.focus();

      if (!click.hasHandlers) return;

      e.stopPropagation();

      Polly
      .localMouseCoordinate(rawElement, e.pageX, e.pageY)
      .then((p){
        click.invokeAsync(this, new MouseEventArgs(p.x, p.y, e.pageX, e.pageY));
      });
    }

    click = new BuckshotEvent<MouseEventArgs>
    ._watchFirstAndLast(
      () => rawElement.on.click.add(clickHandler),
      () => rawElement.on.click.remove(clickHandler)
    );


    void gotFocusHandler(e){
      if (!gotFocus.hasHandlers) return;

      e.stopPropagation();

      gotFocus.invoke(this, new EventArgs());
    }

    gotFocus = new BuckshotEvent<EventArgs>
    ._watchFirstAndLast(
      () => rawElement.on.focus.add(gotFocusHandler),
      () => rawElement.on.focus.remove(gotFocusHandler)
    );

    void lostFocusHandler(e){
      if (!lostFocus.hasHandlers) return;

      e.stopPropagation();

      lostFocus.invoke(this, new EventArgs());
    }

    lostFocus = new BuckshotEvent<EventArgs>
    ._watchFirstAndLast(
      () => rawElement.on.blur.add(lostFocusHandler),
      () => rawElement.on.blur.remove(lostFocusHandler)
    );

    bool isMouseReallyOut = true;

    void mouseEnterHandler(e){
      if (!mouseEnter.hasHandlers) return;

      e.stopPropagation();

     if (isMouseReallyOut && mouseLeave.hasHandlers){
       isMouseReallyOut = false;
       mouseEnter.invoke(this, new EventArgs());
     }else if(!mouseLeave.hasHandlers){
       //TODO add a temp handler for mouse out so the
       //logic works correctly when only the mouseenter
       //event is subscribed to (corner case).
       mouseEnter.invoke(this, new EventArgs());
     }
    }

    mouseEnter = new BuckshotEvent<EventArgs>
    ._watchFirstAndLast(
      () => rawElement.on.mouseOver.add(mouseEnterHandler),
      () => rawElement.on.mouseOver.remove(mouseEnterHandler)
    );

    void mouseLeaveHandler(e){
      if (!mouseLeave.hasHandlers) return;

      e.stopPropagation();

      rawElement.rect.then((ElementRect r){

        Polly
        .localMouseCoordinate(rawElement, e.pageX, e.pageY)
        .then((p){
          if (p.x > -1 && p.y > -1 && p.x < r.bounding.width
              && p.y < r.bounding.height){
            isMouseReallyOut = false;
            return;
          }

          isMouseReallyOut = true;
          mouseLeave.invoke(this, new EventArgs());
        });
      });
    }


    mouseLeave = new BuckshotEvent<EventArgs>
    ._watchFirstAndLast(
      () => rawElement.on.mouseOut.add(mouseLeaveHandler),
      () => rawElement.on.mouseOut.remove(mouseLeaveHandler)
    );

    _initFrameworkDragEvents();
  }

  void _initFrameworkDragEvents() {

    // Handle enter events where an element is entering
    // another element's area
    void dragEnterHandler(e) {
      if (!dragEnter.hasHandlers) return;

      dragEnter.invoke(this, new DragEventArgs(e.dataTransfer));
    }

    dragEnter = new BuckshotEvent<DragEventArgs>
    ._watchFirstAndLast(
      () => rawElement.on.dragEnter.add(dragEnterHandler),
      () => rawElement.on.dragEnter.remove(dragEnterHandler)
    );

    // Handle dragleave events
    void dragLeaveHandler(e) {
      if (!dragLeave.hasHandlers) return;

      dragLeave.invoke(this, new DragEventArgs(e.dataTransfer));
    }

    dragLeave = new BuckshotEvent<DragEventArgs>
    ._watchFirstAndLast(
      () => rawElement.on.dragLeave.add(dragLeaveHandler),
      () => rawElement.on.dragLeave.remove(dragLeaveHandler)
    );

    // Handle dragover events
    void dragOverHandler(e) {
      if (!dragOver.hasHandlers) return;

      e.stopPropagation();

      dragOver.invoke(this, new DragEventArgs(e.dataTransfer));
    }

    dragOver = new BuckshotEvent<DragEventArgs>
    ._watchFirstAndLast(
      () => rawElement.on.dragOver.add(dragOverHandler),
      () => rawElement.on.dragOver.remove(dragOverHandler)
    );

    // Handle drop events
    void dropHandler(e) {
      if (!drop.hasHandlers) return;

      e.preventDefault();
      e.stopPropagation();

      drop.invoke(this, new DragEventArgs(e.dataTransfer));
    }

    drop = new BuckshotEvent<DragEventArgs>
    ._watchFirstAndLast(
      () => rawElement.on.drop.add(dropHandler),
      () => rawElement.on.drop.remove(dropHandler)
    );

    // Handle dragstart events
    void dragStartHandler(e) {
      if (!dragStart.hasHandlers) return;

      dragStart.invoke(this, new DragEventArgs(e.dataTransfer));
    }

    dragStart = new BuckshotEvent<DragEventArgs>
    ._watchFirstAndLast(
      () => rawElement.on.dragStart.add(dragStartHandler),
      () => rawElement.on.dragStart.remove(dragStartHandler)
    );

    // Handle dragend events
    void dragEndHandler(e) {
      if (!dragEnd.hasHandlers) return;

      dragEnd.invoke(this, new DragEventArgs(e.dataTransfer));
    }

    dragEnd = new BuckshotEvent<DragEventArgs>
    ._watchFirstAndLast(
      () => rawElement.on.dragEnd.add(dragEndHandler),
      () => rawElement.on.dragEnd.remove(dragEndHandler)
    );
  }

  void _registerEvents(){
    registerEvent('dragend', dragEnd);
    registerEvent('dragstart', dragStart);
    registerEvent('drop', drop);
    registerEvent('dragover', dragOver);
    registerEvent('dragenter', dragEnter);
    registerEvent('dragleave', dragLeave);
    registerEvent('gotfocus', gotFocus);
    registerEvent('lostfocus', lostFocus);
    registerEvent('click', click);
    registerEvent('mouseleave', mouseLeave);
    registerEvent('mouseenter', mouseEnter);
    registerEvent('mousedown', mouseDown);
    registerEvent('mouseup', mouseUp);
    registerEvent('mousemove', mouseMove);
  }
}
