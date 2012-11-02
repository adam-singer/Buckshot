library generator_core_buckshotui_org;

import 'dart:io';
import 'dart:json';
import 'package:xml/xml.dart';
import 'package:html5lib/parser.dart' as html;

import 'package:buckshot/gen/genie.dart';

void generateCode(){

  final fileNames = _getChangedFiles(new Options().arguments);
  if (fileNames.isEmpty){
    return;
  }

  log.pushContext('generator');

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

      log.write('Working on "${gs.name}, ${gs.fileType}"');

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
  log.popContext();
  log.close();
}

List<String> _getChangedFiles(List<String> rawArgs){
  return
    rawArgs
      .filter((arg) =>
          arg.startsWith('--changed') &&
          (validTemplateExtensions.some((ext) => arg.endsWith(ext)) ||
              arg.endsWith('.html')))
      .map((arg) => arg.replaceFirst('--changed=', ''));
}


Map<String, String> _generateFromXMLTemplate(String name, String templateData){
  return JSON.parse(genCode(name, XML.parse(templateData)));
}

Map<String, String> _generateFromHTML(String name, String htmlData){
  return {'html' : htmlData};
}



