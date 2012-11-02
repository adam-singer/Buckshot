// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

library simple_logger;

import 'dart:io';

/**
 * Seriously Simple Logger.
 */
class Logger
{
  final _logHandle;
  final _contexts = new List<String>();
  final String _lineTerminator;

  // Indicates whether the log file is open or closed.
  var isOpen = true;

  /**
   * Initializes the class and opens the log file at [fileName].
   */
  Logger(String fileName) :
    _logHandle = new File(fileName).openOutputStream(FileMode.WRITE),
    _lineTerminator = Platform.operatingSystem == 'windows' ? '\r\n' : '\n'
  {
    _logHandle.onError = (e){
      print('error while writing to log.');
      exit(1);
    };

    _write('>>> Log Start');
  }

  /**
   * Pushes a new logging context onto the stack.
   */
  void pushContext(String context){
    if (context == null || context.isEmpty) return;

    _contexts.add(context);
  }

  /**
   * Pops the most recent context off the stack.
   */
  void popContext(){
    if (_contexts.isEmpty) return;
    _contexts.removeLast();
  }

  /**
   * Closes the log file. Future log writes will be ignored.
   */
  void close(){
    _write('>>> Log End');
    _logHandle.onClosed = (){
      isOpen = false;
    };
    _logHandle.close();

  }

  /**
   * Gets the current context stack.  The string is empty of no contexts
   * are in the stack.
   */
  String get context => _contexts.isEmpty ? '' : '$_contexts';

  /**
   * Writes a [logEntry] to the log, with optional [newContext] added
   * to the context stack.
   */
  void write(logEntry, [String newContext = '']){
    if (!newContext.isEmpty){
      pushContext(newContext);
    }

    _write('$logEntry');
  }

  /**
   * Writes a [logEntry] with the given [context] and then immediately
   * pops the context off the stack.
   *
   * If the context is null or empty, then the log entry is written with
   * no context added.
   */
  void writeAndPop(logEntry, String context){
    if (context != null && !context.isEmpty){
      pushContext(context);
    }

    _write('$logEntry');

    if (context != null && !context.isEmpty){
      popContext();
    }
  }

  void _write(String entry){
    if (_logHandle.closed) return;
    _logHandle.writeString('[${new Date.now()}]$context $entry$_lineTerminator');
  }

}