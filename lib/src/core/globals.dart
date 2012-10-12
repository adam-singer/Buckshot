// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


/**
* Represents the globally available instance of Buckshot.
*
* It is normally not be necessary to create your own instance
* of the [Buckshot] class.
*/
Buckshot buckshot = new Buckshot();

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

/**
 * Writes a log [message] at Level.WARNING with optional FrameworkElement
 * [element] info.
 */
db(String message, [FrameworkObject element]){
  if (element == null){
    _log.warning(message);
    return;
  }

  _log.warning("($element) $message");
}

/**
 * Debug function that pretty prints an element tree. */
printTree(startWith, [int indent = 0]){
  if (startWith == null || startWith is! FrameworkElement) return;

  String space(int n){
    var s = new StringBuffer();
    for(int i = 0; i < n; i++){
      s.add(' ');
    }
    return s.toString();
  }

  _log.warning('${space(indent)}${_elementAndName(startWith)}(Parent=${_elementAndName(startWith.parent)})');

  if (startWith is IFrameworkContainer){
    if ((startWith as IFrameworkContainer).content is List){
      (startWith as IFrameworkContainer)
        .content
        .forEach((e) => printTree(e, indent + 3));
    }else{
      printTree(startWith.content, indent + 3);
    }
  }
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

/**
 * A [ResourceCollection] template representing default property settings
 * for Buckshot controls.
 *
 * Buckshot will use this theme template if no other is found.
 */
final String defaultTheme =
'''
<resourcecollection>
  <!-- 
  "Theme: 50 Shades of Grrr" 
  -->

  <color key='theme_debug' value='Orange' />

  <!-- 
  Default Palette 
  -->
  <color key='theme_background_light' value='White' />
  <color key='theme_background_dark' value='WhiteSmoke' />
  <color key='theme_background_mouse_hover' value='LightGray' />
  <color key='theme_background_mouse_down' value='DarkGray' />

  <!-- 
  Default Brushes 
  -->
  <solidcolorbrush key='theme_light_brush' color='{resource theme_background_light}' />
  <solidcolorbrush key='theme_dark_brush' color='{resource theme_background_dark}' />

  <!-- 
  Shadows 
  --> 
  <color key='theme_shadow_color' value='Black' />
  <var key='theme_shadow_x' value='0' />
  <var key='theme_shadow_y' value='0' />
  <var key='theme_shadow_blur' value='0' />

  <!-- 
  Border 
  -->
  <color key='theme_border_color' value='LightGray' />
  <color key='theme_border_color_dark' value='DarkGray' />
  <var key='theme_border_thickness' value='1' />
  <var key='theme_border_padding' value='5' />
  <var key='theme_border_corner_radius' value='0' />
  <!-- Note that border does not have a default background brush. -->

  <!-- 
  Text 
  -->
  <var key='theme_text_font_family' value='Arial' />
  <color key='theme_text_foreground' value='Black' />

  <!-- 
  TextBox 
  -->
  <color key='theme_textbox_border_color' value='Black' />
  <color key='theme_textbox_foreground' value='Black' />
  <solidcolorbrush key='theme_textbox_background' color='{resource theme_background_light}' />
  <var key='theme_textbox_border_thickness' value='1' />
  <var key='theme_textbox_corner_radius' value='0' />
  <var key='theme_textbox_border_style' value='solid' />
  <var key='theme_textbox_padding' value='1' />

  <!-- 
  Button 
  -->
  <color key='theme_button_border_color' value='LightGray' />
  <solidcolorbrush key='theme_button_background' color='{resource theme_background_dark}' />
  <lineargradientbrush key='theme_button_background_hover' direction='vertical'>
    <stops>
       <gradientstop color='{resource theme_background_dark}' />
       <gradientstop color='{resource theme_background_mouse_hover}' />
    </stops>
  </lineargradientbrush>
  <var key='theme_button_border_thickness' value='{resource theme_border_thickness}' />
  <var key='theme_button_padding' value='{resource theme_border_padding}' />

  <!-- 
  Accordion
  -->
  <var key='theme_accordion_header_padding' value='{resource theme_border_padding}' />
  <var key='theme_accordion_header_border_thickness' value='0,0,1,0' />
  <lineargradientbrush key='theme_accordion_background_hover_brush' direction='vertical'>
    <stops>
       <gradientstop color='{resource theme_background_dark}' />
       <gradientstop color='{resource theme_background_mouse_hover}' />
    </stops>
  </lineargradientbrush>
  <solidcolorbrush key='theme_accordion_background_mouse_down_brush' color='{resource theme_background_mouse_down}' />
  <solidcolorbrush key='theme_accordion_header_background_brush' color='{resource theme_background_dark}' />
  <solidcolorbrush key='theme_accordion_body_background_brush' color='{resource theme_debug}' />

  <!-- 
  Menu & MenuStrip
  -->
  <var key='theme_menu_padding' value='{resource theme_border_padding}' />
    <lineargradientbrush key='theme_menu_background_hover_brush' direction='vertical'>
    <stops>
       <gradientstop color='{resource theme_background_dark}' />
       <gradientstop color='{resource theme_background_mouse_hover}' />
    </stops>
  </lineargradientbrush>
  <solidcolorbrush key='theme_menu_background_mouse_down_brush' color='{resource theme_background_mouse_down}' />
  <solidcolorbrush key='theme_menu_background_brush' color='{resource theme_background_dark}' />

  <!--
  TabControl
  -->
  
  <var key='zoidberg' value='http://www.buckshotui.org/resources/images/zoidberg.jpg' />
  <var key='buckshot_logo_uri' value='http://www.buckshotui.org/resources/images/buckshot_logo.png' />
</resourcecollection>
''';

// Holds a registry of resources.
final HashMap<String, FrameworkResource> _resourceRegistry =
new HashMap<String, FrameworkResource>();

// Holds a registry of global event handlers when reflection is not
// enabled.
final HashMap<String, EventHandler> _globalEventHandlers =
new HashMap<String, EventHandler>();

// Logging
var _log = new Logger('buckshot')..level = Level.WARNING;

// setting some logs at the top level to prevent excessive new-ups.
var _propertyLog = new Logger('buckshot.properties')..level = Level.WARNING;
var _getPropertyLog = new Logger('buckshot.properties.get')..level = Level.WARNING;
var _setPropertyLog = new Logger('buckshot.properties.set')..level = Level.WARNING;
var _resourceLog = new Logger('buckshot.resources')..level = Level.WARNING;
var _bindingLog = new Logger('buckshot.binding')..level = Level.WARNING;
var _logEvents = new ObservableList<String>();
