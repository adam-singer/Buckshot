library genie_buckshot_org;

import 'dart:json';
import 'package:xml/xml.dart';
import 'dart:io';
import 'package:buckshot/gen/logger.dart';

part 'generator_file.dart';
part 'gen_option.dart';


Logger log = new Logger('generator.log');

/**
 * Contains a list of valid extensions that the generator should
 * generate code for.
 */
List<String> validTemplateExtensions = ['.html', '.buckshot', '.xml'];

List<GenOption> _options;

/**
 * Returns a JSON string containing a map of filename:filedata pairs.
 *
 * ## Example Usage ##
 *     genCode('Foo', XML.parse("<textblock text='hello world!' />");, [GenOption.NO_EVENTS]);
 */
String genCode(String baseFileName, XmlElement template, [List<GenOption> options = const []]){
  log.pushContext('genie');
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

  log.popContext();
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
