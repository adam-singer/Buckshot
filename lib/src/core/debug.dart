// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/*
 * Top-level Logging and Debug
 */

var _log = new Logger('buckshot')..level = Level.WARNING;

// setting some logs at the top level to prevent excessive new-ups.
var _propertyLog = new Logger('buckshot.properties')..level = Level.WARNING;
var _getPropertyLog = new Logger('buckshot.properties.get')
                        ..level = Level.WARNING;
var _setPropertyLog = new Logger('buckshot.properties.set')
                        ..level = Level.WARNING;
var _resourceLog = new Logger('buckshot.resources')..level = Level.WARNING;
var _bindingLog = new Logger('buckshot.binding')..level = Level.WARNING;
var _polyfillLog = new Logger('buckshot.polyfill')..level = Level.INFO;
var _logEvents = new ObservableList<String>();

/**
 * Writes a [Logger] [message] at Level.WARNING with optional FrameworkElement
 * [element] info.
 */
void log(String message, [FrameworkObject element]){
  if (element == null){
    _log.warning(message);
    return;
  }

  new Logger('buckshot.${element}').warning("($element) $message");
}

/**
 * Writes a [Logger] [message] at Level.SEVERE with optional FrameworkElement
 * [element] info.
 */
void logSevere(String message, [FrameworkObject element]){
  if (element == null){
    _log.severe(message);
    return;
  }

  new Logger('buckshot.${element}').severe("($element) $message");
}

/**
 * Debug function that pretty prints an element tree to stdout.
 */
void printTree(startWith, [int indent = 0]){
  if (startWith == null || startWith is! FrameworkElement) return;

  String space(int n){
    var s = new StringBuffer();
    for(int i = 0; i < n; i++){
      s.add(' ');
    }
    return s.toString();
  }

  print('${space(indent)}${_elementAndName(startWith)}'
        '(Parent=${_elementAndName(startWith.parent)})');

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

