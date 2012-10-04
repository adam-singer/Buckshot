#library('generator_core_buckshotui_org');

#import('dart:io');
#import('dart:json');
#import('package:xml/xml.dart');
#import('package:html5lib/html5parser.dart', prefix:'html');

#import('package:buckshot/gen/genie.dart');

void generateCode(){

  final fileNames = _getChangedFiles(new Options().arguments);
  if (fileNames.isEmpty()){
    return;
  }

  final out = new File('test.tmp').openOutputStream();

  log.write('$fileNames');

  out.onError = (e){
    log.write('build.dart error! $e');
    out.close();
    log.close();
    exit(1);
  };

  for(final fileNameAndPath in fileNames){

    try{
      final gs = new GeneratorFile(fileNameAndPath);
      if (gs.fileData == null){
        throw const Exception('Could not read file data.');
      }

      var result;

      if (gs.fileType == GeneratorFile.HTML){
        result = _generateFromHTML(gs.name, gs.fileData);
        log.write('html>> ${result}');

      }else if (gs.fileType == GeneratorFile.TEMPLATE){
        result = _generateFromXMLTemplate(gs.name, gs.fileData);

        out.writeString('${result.getValues()}');
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

List<String> _getChangedFiles(List<String> rawArgs){
  return
    rawArgs
      .filter((arg) =>
          arg.startsWith('--changed') &&
          validTemplateExtensions
            .some((ext) => arg.endsWith(ext)))
      .map((arg) => arg.replaceFirst('--changed=', ''));
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
  static const HTML = 'HTML';
  static const TEMPLATE = 'TEMPLATE';

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
    }else if (fileNameAndPath.endsWith('.buckshot') ||
        fileNameAndPath.endsWith('.xml')){
      fileType = TEMPLATE;
    }else{
      throw new Exception('File extension not supported by Buckshot Generator.'
          ' Must be .html or .buckshot');
    }
  }

  String get nameCamelCase => '';


  String toString() => fileNameAndPath;
}
