// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

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
  registerElement(new StackPanel.register());
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


/**
* A general utility service for the Buckshot framework.
*
* Use the globally available 'buckshot' object to access the
* framework system.  It is normally not necessary to create your own instance
* of the [Buckshot] class.
*/
class Buckshot extends FrameworkObject
{


  StyleElement _buckshotCSS;

  /// Bindable window width/height properties.  Readonly, so can only
  /// bind from, not to.
  FrameworkProperty windowWidthProperty;
  /// Bindable window width/height properties.  Readonly, so can only
  /// bind from, not to.
  FrameworkProperty windowHeightProperty;

  /// Pass the ID of the element in the DOM where buckshot will render content.
  Buckshot([String buckshotRootID = _defaultRootID])
  {
    hierarchicalLoggingEnabled = true;

    //initialize Polly's statics
    Polly.init();

    _initCSS();

    _initializeBuckshotProperties();

    if (reflectionEnabled) return;

    _registerCoreElements();
  }


  /** Deprecated.  Use top-level registerElement() instead. */
  @deprecated void registerElement(BuckshotObject o){
    if (reflectionEnabled) return;

    _objectRegistry['${o.toString().toLowerCase()}'] = o.makeMe;
    _log.info('Element (${o}) registered to framework.');
  }

  @deprecated void registerAttachedProperty(String property, setterFunction){
    if (reflectionEnabled) return;

    _objectRegistry[property] = setterFunction;
    _log.info('Attached property (${property}) registered to framework.');
  }

  void _initCSS(){
    document.head.elements.add(
      new Element.html('<style id="__BuckshotCSS__"></style>'));

    _buckshotCSS = document.head.query('#__BuckshotCSS__');

    assert(_buckshotCSS != null);

    if (_buckshotCSS == null){
      _log.warning('Unable to initialize Buckshot StyleSheet.');
    }
  }

  void _initializeBuckshotProperties(){

    windowWidthProperty = new FrameworkProperty(
      this, "windowWidth", defaultValue:window.innerWidth);

    windowHeightProperty = new FrameworkProperty(
      this, "windowHeight", defaultValue:window.innerHeight);

    window.on.resize.add((e){

      //any elements bound to these properties will also get updated...
      if (window.innerWidth != windowWidth){
        setValue(windowWidthProperty, window.innerWidth);
      }

      if (window.innerHeight != windowHeight){
        setValue(windowHeightProperty, window.innerHeight);
      }
    });
  }

  /// Gets the innerWidth of the window
  int get windowWidth => getValue(windowWidthProperty);

  /// Gets the innerHeight of the window
  int get windowHeight => getValue(windowHeightProperty);

  // Wrappers to prevent propagation of static warnings elsewhere.
  reflectMe(object) => reflect(object);
  get mirrorSystem() => currentMirrorSystem();

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

      mirrorSystem
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
}