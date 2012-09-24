#library('codegen_core_buckshotui_org');

#import('dart:json');
#import('package:dart_xml/xml.dart');
//#import('dart:isolate');
//#import('dart:mirrors');

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
String genCode(String baseFileName, XmlElement template, [List<String> options]){
  if (options == null)
  {
    options = [];
  }

//  final test = spawnUri('buckshot.dart');
//  final m = mirrorSystemOf(test);
//  print('$m');

  final results = new Map<String, String>();

  bool hasOption(String option) =>
      options.some((f) => f == option);

  String setDataContext(){
    final f = new StringBuffer();

    if (!hasOption('nocomments')){
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

  // simple {data} bindings
  // event hooks
  // named elements (as FrameworkObject for now)

  String view;
  String view_g;
  String vm;
  String vm_g;

  if (!hasOption('onlyg')){
    view =
'''
class $baseFileName extends _${baseFileName}_g 
{
    ${setDataContext()}
}
''';

    results['$baseFileName'] = view;
  }


  return JSON.stringify(results);
}

