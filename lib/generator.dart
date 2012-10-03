#library('generator_core_buckshotui_org');

#import('dart:io');
#import('dart:json');
#import('package:xml/xml.dart');
#import('package:html5lib/html5parser.dart', prefix:'html');

#import('package:buckshot/gen/genie.dart');

void generateCode(List<String> fileNames){

  final out = new File('test.tmp').openOutputStream();


  log.write('$fileNames');

  out.onError = (e){
    log.write('build.dart error! $e');
    out.close();
    log.close();
    exit(1);
  };

  for(final fileNameAndPath in fileNames){

    final gs = new GeneratorFile(fileNameAndPath);

    final fs = new File(fileNameAndPath);

    if (!fs.existsSync()) continue;

    try{
      var fileText = fs.readAsTextSync();
      var result;

      if (fileNameAndPath.endsWith('.html')){
        result = _generateFromHTML(fs.name, fileText);
        log.write('html>> ${result}');

      }else if (fileNameAndPath.endsWith('.buckshot')){
        result = _generateFromXMLTemplate(fs.name, fileText);

        out.writeString('${result.getValues()}');
      }else{
        throw new Exception('File type not supported by Buckshot code generator.');
      }

    } on XmlException catch(xmlE){
      log.write('<<XML ERROR>> $xmlE');
    } on Exception catch(e){
      log.write('<<GENERAL ERROR>> $e');
    }
  }

  out.close();
  log.close();
}

Map<String, String> _generateFromXMLTemplate(String name, String templateData){
  return JSON.parse(genCode(name, XML.parse(templateData)));
}

Map<String, String> _generateFromHTML(String name, String htmlData){
  return {'html' : htmlData};
}


/**
 * Provides utilities and info on a .html or .buckshot file.
 */
class GeneratorFile
{
  const HTML = 'HTML';
  const TEMPLATE = 'TEMPLATE';

  final String fileNameAndPath;
  String fileType;
  String path;
  String name;
  String fileData;


  GeneratorFile(this.fileNameAndPath){
    final fs = new File(fileNameAndPath);
    if (!fs.existsSync()) return;

    _parseFileType();
    _parseName();
    _getFileData();
  }

  void _getFileData(){
    final fs = new File(fileNameAndPath);
    fileData = fs.readAsTextSync();
  }

  void _parseName(){

    final index = fileNameAndPath.contains(Platform.pathSeparator)
        ? fileNameAndPath.lastIndexOf(Platform.pathSeparator) + 1
        : 0;

    final extIndex = fileNameAndPath.indexOf('.', index);

    name = fileNameAndPath.substring(index, extIndex);
  }

  void _parseFileType(){
    if (fileNameAndPath.endsWith('.html')){
      fileType = HTML;
    }else if (fileNameAndPath.endsWith('.buckshot')){
      fileType = TEMPLATE;
    }else{
      throw new Exception('File extension not supported by Buckshot Generator.'
          ' Must be .html or .buckshot');
    }
  }

  String get nameCamelCase => '';


  String toString() => fileNameAndPath;
}
