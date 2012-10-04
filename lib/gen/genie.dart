#library('codegen_core_buckshotui_org');

#import('dart:json');
#import('package:xml/xml.dart');
#import('dart:io');

//#import('dart:isolate');
//#import('dart:mirrors');


Logger log = new Logger();

/**
 * Contains a list of valid extensions that the generator should
 * generate code for.
 */
List<String> validTemplateExtensions = ['.html', '.buckshot', '.xml'];

/**
 * Seriously Simple Logger.
 */
class Logger
{
  final logFile = new File('log.tmp');

  var logHandle;

  Logger(){
    logHandle = logFile.openOutputStream(FileMode.WRITE);

    logHandle.onError = (e){
      print('error while writing to log.');
      exit(1);
    };

    _write('>>> Log Start\n');
  }

  void close(){
    _write('>>> Log End\n');
    logHandle.close();
  }

  _write(String entry){
    logHandle.writeString('[${new Date.now()}] $entry');
  }

  void write(logEntry){
    _write('$logEntry\n');
  }
}

List<GenOption> _options;


class GenOption
{
  final String _str;

  const GenOption(this._str);

  static const ONLY_G_FILES = const GenOption('ONLY_G_FILES');
  static const NO_BINDINGS = const GenOption('NO_BINDINGS');
  static const NO_EVENTS = const GenOption('NO_EVENTS');
  static const NO_ELEMENTS = const GenOption('NO_ELEMENTS');
  static const NO_TYPE_LOOKUP = const GenOption('NO_TYPE_LOOKUP');
  static const EVENTS_TO_TOP = const GenOption('EVENTS_TO_TOP');
  static const EMBED_TEMPLATE = const GenOption('EMBED_TEMPLATE');
  static const NO_COMMENTS = const GenOption('NO_COMMENTS');

  String toString() => _str;
}

/**
 * Returns a JSON string containing a map of filename:filedata pairs.
 *
 * ## Example Usage ##
 *     genCode('Foo', XML.parse("<textblock text='hello world!' />");, ['noevents']);
 *
 * ## Options ##
 * * onlyg - returns only the _g classes, not the dev-usable ones.
 * * nobindings - supresses generation of binding FrameworkProperty stubs.
 * * noevents - suppresses generation of event handler stubs.
 * * noelements - suppresses generation of named element fields.
 * * nocomments - suppresses generation of descriptives.
 * * notypelookup - suppresses attempts to find the matching Type of a
 * named element.
 * * eventstotop - puts event handlers into top level instead of in view model.
 * * embedtemplate - puts a string of the template in the class and uses it.
 */
String genCode(String baseFileName, XmlElement template, [List<GenOption> options]){
  if (options == null)
  {
    options = [];
  }

  _options = options;

//  final test = spawnUri('buckshot.dart');
//  final m = mirrorSystemOf(test);
//  print('$m');

  final results = new Map<String, String>();


  // simple {data} bindings
  // event hooks
  // named elements (as FrameworkObject for now)

  String view;
  String view_g;
  String vm;
  String vm_g;

  if (!_hasOption(GenOption.ONLY_G_FILES)){
    view =
'''
class $baseFileName extends _${baseFileName}_g 
{
    ${new DataContext().generate()}
}
''';

    results['$baseFileName'] = view;
  }


  return JSON.stringify(results);
}



bool _hasOption(GenOption option) =>
    _options.some((f) => f == option);

abstract class GeneratorComponent
{
  abstract String generate();
}

class DataContext implements GeneratorComponent
{
  String generate(){
    final f = new StringBuffer();

    if (!_hasOption(GenOption.NO_COMMENTS)){
      f.add(
          '''   
          // You can set the datacontext of the view to a different view model by
          // returning a different value in "setDataContext()" below.
      ''');
    }

    f.add(
        '''
        setDataContext(){
        return super.setDataContext();
        }
    ''');

    return f.toString();
  }
}
