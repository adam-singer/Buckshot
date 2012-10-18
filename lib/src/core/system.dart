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

/**
 * Registers an object to the framework.
 *
 * This function is only used when reflection is not supported. It will be
 * removed once reflection is supported on all Dart platforms.
 */
void registerElement(BuckshotObject o){
  hierarchicalLoggingEnabled = true;
  if (reflectionEnabled) return;

  _objectRegistry['${o.toString().toLowerCase()}'] = o.makeMe;
  _log.info('Element (${o}) registered to framework.');
}


/**
 * Registers an attached property [setterFunction] to the framework.
 *
 * This function is only used when reflection is not supported. It will be
 * removed once reflection is supported on all Dart platforms.
 */
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
  registerElement(new TextBox.register());
  registerElement(new Slider.register());
  registerElement(new Button.register());
  registerElement(new DropDownList.register());

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
}

bool _frameworkInitialized = false;

Future _initFramework(){
  if (_frameworkInitialized) return new Future.immediate(true);
  _frameworkInitialized = true;

  hierarchicalLoggingEnabled = true;

  _log.on.record.add((LogRecord record){
    final event = '[${record.loggerName} - ${record.level}'
      ' - ${record.sequenceNumber}] ${record.message}';
    _logEvents.add(event);
    print(event);
  });

  // Initializes the system object name.
  buckshot.name.value = '__sys__';

  if (!Polly.browserOK){
    _log.warning('Buckshot Warning: Browser may not be compatible with Buckshot'
    ' framework.');
  }

  _log.config(reflectionEnabled
                ? 'Reflection enabled.'
                : 'Reflection disabled.');

  _initCSS();

  if (!reflectionEnabled){
    _registerCoreElements();
  }

  //any elements bound to these properties will also get updated...
  window.on.resize.add((e){
    if (window.innerWidth != windowWidth){
      windowWidth.value = window.innerWidth;
    }

    if (window.innerHeight != windowHeight){
      windowHeight.value = window.innerHeight;
    }
  });



  return _loadTheme()
    .chain((_) => _loadResources())
    .chain((_){
      if (!FrameworkAnimation._started){
        FrameworkAnimation._startAnimatonLoop();
      }

      _log.info('Framework initialized.');
      return new Future.immediate(true);
    });
}

bool _themeLoaded = false;
Future _loadTheme(){

  if (_themeLoaded) return new Future.immediate(false);
  _themeLoaded = true;

  if (document.body.attributes.containsKey('data-buckshot-theme')){
    _log.info('loading custom theme (${document.body.attributes['data-buckshot-theme']})');
    return Template.deserialize(document.body.attributes['data-buckshot-theme']);
  }else{
    _log.info('loading default theme');
    return Template.deserialize(defaultTheme);
  }
}

bool _resourcesLoaded = false;
Future _loadResources(){
  if (_resourcesLoaded) return new Future.immediate(false);
  _resourcesLoaded = true;

  if (!document.body.attributes.containsKey('data-buckshot-resources')){
    return new Future.immediate(false);
  }

  _log.info('loading app resources'
      ' (${document.body.attributes['data-buckshot-resources']})');

  return Template
      .deserialize(document.body.attributes['data-buckshot-resources']);
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
  bind(windowHeight, element.height);
  bind(windowWidth, element.width);
}

/**
 * Bindable window width property.
 *
 * Typically you will not need to bind to this directly.  Use the
 * bindToWindowDimensions() function instead.
 */
FrameworkProperty windowWidth = new FrameworkProperty(
    buckshot, "windowWidth", defaultValue:window.innerWidth);

/**
 * Bindable window height property.
 *
 * Typically you will not need to bind to this directly.  Use the
 * bindToWindowDimensions() function instead.
 */
FrameworkProperty windowHeight = new FrameworkProperty(
    buckshot, "windowHeight", defaultValue:window.innerHeight);


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
  final el = query('#${elementID}');

  if (el == null){
    throw new BuckshotException('Could not find DOM element with '
        'ID of "${elementID}"');
  }

  return _initFramework()
    .chain((_) => view.ready)
    .chain((rootVisual){
      el.elements.clear();
      final b = new Border()
        ..isLoaded = true;
      el.elements.add(b.rawElement);
      b.content.value = rootVisual;
      _log.fine('View ($rootVisual) set to DOM at ($elementID)');
      return new Future.immediate(rootVisual);
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
    res = res.stateBag[FrameworkResource.RESOURCE_PROPERTY].value;
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
  _resourceRegistry[resource.key.value.trim().toLowerCase()] = resource;
}

/**
 * Sets the value of a given [FrameworkProperty] [property] to a given [value].
 *
 * This function is deprecated. Assign to property.value directly.
 */
@deprecated void setValue(FrameworkProperty property, Dynamic value){
  property.value = value;
}

/**
 * Gets the current value of a given [FrameworkProperty] object.
 *
 * This function is deprecated.  Use property.value getter to get the latest
 * value.
 */
@deprecated getValue(FrameworkProperty property){
  assert(property != null);
  return property.value;
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




