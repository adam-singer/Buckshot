// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
 * Represents the globally available instance of the buckshot utility class.
 */
@deprecated final buckshot = new _buckshot();

const String _defaultRootID = "#BuckshotHost";

final Map<String, Dynamic> _mirrorCache = new Map<String, Dynamic>();

/// Central registry of named [FrameworkObject] elements.
final HashMap<String, FrameworkObject> namedElements =
    new HashMap<String, FrameworkObject>();

final HashMap<String, Function> _objectRegistry =
    new HashMap<String, Dynamic>();

void registerElement(BuckshotObject o){
  hierarchicalLoggingEnabled = true;
  if (reflectionEnabled) return;

  _objectRegistry['${o.toString().toLowerCase()}'] = o.makeMe;
  _log.info('Element (${o}) registered to framework.');
}

void registerAttachedProperty(String property, setterFunction){
  hierarchicalLoggingEnabled = true;
  if (reflectionEnabled) return;

  _objectRegistry[property] = setterFunction;
  _log.info('Attached property (${property}) registered to framework.');
}

void _registerCoreElements(){
  registerElement(new Ellipse.register());
  registerElement(new Rectangle.register());
  registerElement(new Stack.register());
  registerElement(new LayoutCanvas.register());
  registerElement(new Grid.register());
  registerElement(new Border.register());
  registerElement(new ContentPresenter.register());
  registerElement(new TextArea.register());
  registerElement(new TextBlock.register());
  registerElement(new CheckBox.register());
  registerElement(new RadioButton.register());
  registerElement(new Hyperlink.register());
  registerElement(new Image.register());
  registerElement(new RawHtml.register());
  registerElement(new ColumnDefinition.register());
  registerElement(new RowDefinition.register());
  registerElement(new DropDownItem.register());
  registerElement(new CollectionPresenter.register());

  //resources
  registerElement(new ResourceCollection.register());
  registerElement(new Color.register());
  registerElement(new LinearGradientBrush.register());
  registerElement(new GradientStop.register());
  registerElement(new SolidColorBrush.register());
  registerElement(new RadialGradientBrush.register());
  registerElement(new Setter.register());
  registerElement(new StyleTemplate.register());
  registerElement(new Var.register());
  registerElement(new ControlTemplate.register());
  registerElement(new AnimationResource.register());
  registerElement(new AnimationKeyFrame.register());
  registerElement(new AnimationState.register());

  //actions
  registerElement(new SetProperty.register());
  registerElement(new ToggleProperty.register());

  registerElement(new TextBox.register());
  registerElement(new Slider.register());
  registerElement(new Button.register());
  registerElement(new DropDownList.register());
}

bool _frameworkInitialized = false;

Future _initFramework(){

  if (_frameworkInitialized) return new Future.immediate(true);
  _frameworkInitialized = true;

  hierarchicalLoggingEnabled = true;

  _log.on.record.add((LogRecord record){
    final event = '[${record.loggerName} - ${record.level} - ${record.sequenceNumber}] ${record.message}';
    _logEvents.add(event);
    print(event);
  });

  // Initializes the system object.
  buckshot.name = '__sys__';

  if (!Polly.browserOK){
    _log.warning('Buckshot Warning: Browser may not be compatible with Buckshot'
    ' framework.');
  }

  _log.config(reflectionEnabled
                ? 'Reflection enabled.'
                : 'Reflection disabled.');

  Polly.init();

  _initCSS();

  if (!reflectionEnabled){
    _registerCoreElements();
  }

  window.on.resize.add((e){

    //any elements bound to these properties will also get updated...
    if (window.innerWidth != windowWidth){
      setValue(windowWidthProperty, window.innerWidth);
    }

    if (window.innerHeight != windowHeight){
      setValue(windowHeightProperty, window.innerHeight);
    }
  });

  return Template
           .deserialize(defaultTheme)
           .chain((_){
             if (!FrameworkAnimation._started){
               FrameworkAnimation._startAnimatonLoop();
             }

             _log.info('Framework initialized.');
             return new Future.immediate(true);
           });

}

StyleElement _buckshotCSS;
void _initCSS(){
  document.head.elements.add(
      new Element.html('<style id="__BuckshotCSS__"></style>'));

    _buckshotCSS = document.head.query('#__BuckshotCSS__');

    assert(_buckshotCSS != null);

    if (_buckshotCSS == null){
      _log.warning('Unable to initialize Buckshot StyleSheet.');
    }
  }


/**
 * Returns the InterfaceMirror of a given [name] by searching through all
 * available in-scope libraries.
*
 * Case insensitive.
*
 * Returns null if not found.
 */
getObjectByName(String name){
  final lowerName = name.toLowerCase();

  if (!reflectionEnabled){
    if (!_objectRegistry.containsKey(lowerName)) return null;
    return _objectRegistry[lowerName]();
  }else{
    if (_mirrorCache.containsKey(lowerName)){
      _log.fine('Returning cached object ($lowerName) from mirrorCache.');
      return _mirrorCache[lowerName];
    }

    var result;

    buckshot
    .mirrorSystem
    .libraries
    .forEach((String lName, libMirror){
      libMirror
      .classes
      .forEach((String cName, classMirror){
        if (classMirror.simpleName.toLowerCase() == lowerName){
          result = classMirror;
        }
      });
    });

    if (result != null){
      //cache result;
      _log.fine('Caching mirror object ($lowerName)');
      _mirrorCache[lowerName] = result;
    }

    return result;
  }
}

/**
 * Helper function which takes an [element] and binds it's
 * width and height values to the dimensions of the viewport.
 *
 * Currently only supports desktop browsers.
 */
void bindToWindowDimensions(FrameworkElement element){
  bind(windowHeightProperty, element.heightProperty);
  bind(windowWidthProperty, element.widthProperty);
}


/**
 * Bindable window width property.
 *
 * Typically you will not need to bind to this directly.  Use the
 * bindToWindowDimensions() function instead.
 */
FrameworkProperty windowWidthProperty = new FrameworkProperty(
    buckshot, "windowWidth", defaultValue:window.innerWidth);

/**
 * Bindable window height property.
 *
 * Typically you will not need to bind to this directly.  Use the
 * bindToWindowDimensions() function instead.
 */
FrameworkProperty windowHeightProperty = new FrameworkProperty(
    buckshot, "windowHeight", defaultValue:window.innerHeight);


/// Gets the innerWidth of the window
num get windowWidth => getValue(windowWidthProperty);

/// Gets the innerHeight of the window
num get windowHeight => getValue(windowHeightProperty);

/**
 * Register global event handlers here when reflection is not enabled.  Global
 * handlers are necessary in some cases, such as when content is generated
 * within a databound CollectinoPresenter template.
 */
void registerGlobalEventHandler(String handlerName, EventHandler handler){
  if (reflectionEnabled) return;
  _globalEventHandlers[handlerName.toLowerCase()] = handler;
}

/**
 * Sets a [View] into the DOM for rendering. Returns a future which completes
 * when the view is ready (fully deserialized and constructed).
 *
 * ## Placement in DOM ##
 * By default Views will look for a DOM element with the 'BuckshotHost' ID,
 * but you can supply an optional ID to render the content elsewhere.  This
 * will allow you to render Buckshot content to multiple places on the page,
 * although typically you will have only one rendering location.
 *
 * ## Implicit Container For Root Views ##
 * Buckshot places root views into an implicit [Border] root container.  You
 * can manipulate this container with:
 *
 *     myView.rootVisual.parent.{...}
 *
 * This is useful if you want to do things like set explicit width & height
 * values for the root container, but you can also set other typical [Border]
 * properties like borderWidth, borderThickness, etc.
 */
Future<FrameworkElement> setView(View view, [String elementID = 'BuckshotHost'])
{
  return _initFramework()
          .chain((_) => view.ready)
          .chain((t){
            final el = query('#${elementID}');

            if (el == null){
              throw new BuckshotException('Could not find DOM element with '
                  'ID of "${elementID}"');
            }

            final b = new Border();
            el.elements.clear();
            b.isLoaded = true;
            el.elements.add(b.rawElement);
            b.content = t;
            _log.fine('View ($t) set to DOM at ($elementID)');

            return new Future.immediate(t);
          });
}




/**
 * Creates a binding between [from] and [to], with optional [bindingMode]
 * and [converter] parameters.
 *
 * Typically bindings are set via template declarations, but in some cases
 * it may be necessary to declare a binding in code.
 *
 * To remove the binding, call .unregister() on the returned [Binding] object.
 */
Binding bind(FrameworkProperty from, FrameworkProperty to,
             {BindingMode bindingMode : BindingMode.OneWay,
              IValueConverter converter :const _DefaultConverter()}){
  return new Binding(from, to, bindingMode, converter);
}


/**
 * Returns a resource object with the given [resourceKey].
 *
 * If the optional [converter] is supplied, then the value returned is
 * first passed through converter.convert();
 */
getResource(String resourceKey, [IValueConverter converter = null]){
  if (_resourceRegistry == null) return null;

  String lowered = resourceKey.trim().toLowerCase();

  if (!_resourceRegistry.containsKey(lowered)) return null;

  var res = _resourceRegistry[lowered];

  // TODO: check the rawData field of the resource to see if it is a template.
  // Deserialize it if so.

  if (res.stateBag.containsKey(FrameworkResource.RESOURCE_PROPERTY)){
    // resource property defined so return it's value
    res = getValue(res.stateBag[FrameworkResource.RESOURCE_PROPERTY]);
  }

  return converter == null ? res : converter.convert(res);
}

/**
 * Registers a [FrameworkResource] to the framework.
 *
 * Will be deprecated when mirror-based reflection is supported on all
 * platforms.
 */
void registerResource(FrameworkResource resource){
  _resourceRegistry[resource.key.trim().toLowerCase()] = resource;
}


/**
 * Sets the value of a given [FrameworkProperty] to a given [v]. */
Future setValueAsync(FrameworkProperty property, Dynamic value)
{
  Completer c = new Completer();

   doIt(foo){

     if (property.stringToValueConverter != null && value is String){
       value = property.stringToValueConverter.convert(value);
     }


     if (property.value == value) return;

      property.previousValue = property.value;
      property.value = value;

      // 3 different activities take place when a FrameworkProperty value changes,
      // in this order of precedence:
      //    1) callback - lets the FrameworkProperty do any work it wants to do
      //    2) bindings - fires any bindings associated with the FrameworkProperty
      //    3) event - notifies any subscribers that the FrameworkProperty
      //       value changed

      // 1) callback
      Function f = property.propertyChangedCallback;
      f(value);

      // 2) bindings
      Binding._executeBindingsFor(property);

      // 3) event
      if (property.propertyChanging.hasHandlers)
        property.propertyChanging.invoke(property.sourceObject,
          new PropertyChangingEventArgs(property.previousValue, value));

      c.complete(null);
   }

   window.requestAnimationFrame(doIt);

   return c.future;
}

/**
 * Sets the value of a given [FrameworkProperty] [property] to a given [value].
 */
void setValue(FrameworkProperty property, Dynamic value)
{
   if (property.stringToValueConverter != null && value is String){
     value = property.stringToValueConverter.convert(value);
   }

   if (property.value === value) return;

    property.previousValue = property.value;
    property.value = value;

    _setPropertyLog.finest('(${property.sourceObject}) property (${property.propertyName}) to ($value)');

    // 3 different activities take place when a FrameworkProperty value changes,
    // in this order of precedence:
    //    1) callback - lets the FrameworkProperty do any work it wants to do
    //    2) bindings - fires any bindings associated with the FrameworkProperty
    //    3) event - notifies any subscribers that the FrameworkProperty
    //       value changed

    // 1) callback
    Function f = property.propertyChangedCallback;
    f(value);

    // 2) bindings
    Binding._executeBindingsFor(property);

    // 3) event
    if (property.propertyChanging.hasHandlers)
      property.propertyChanging.invoke(property.sourceObject,
        new PropertyChangingEventArgs(property.previousValue, value));

}

/**
 * Gets the current value of a given [FrameworkProperty] object.
 */
getValue(FrameworkProperty property){
  assert(property != null);

  if (property != null){
    _getPropertyLog.finest('(${property.sourceObject}) property (${property.propertyName}) value (${property.value})');
  }else{
    _getPropertyLog.warning('Attempted getValue() on null property.');
  }
  return (property == null) ? null : property.value;
}

String _elementAndName(FrameworkObject o){
  return (o == null || o.name == null || o.name.trim() == '')
      ? '$o'
      : '$o[${o.name}]';
}


Future _functionToFuture(Function f){
  Completer c = new Completer();

  void doIt(foo) => c.complete(f());

  try{
    window.requestAnimationFrame(doIt);
  }on Exception catch (e){
    c.completeException(e);
  }

  return c.future;
}

// Holds a registry of resources.
final HashMap<String, FrameworkResource> _resourceRegistry =
new HashMap<String, FrameworkResource>();

// Holds a registry of global event handlers when reflection is not
// enabled.
final HashMap<String, EventHandler> _globalEventHandlers =
new HashMap<String, EventHandler>();




