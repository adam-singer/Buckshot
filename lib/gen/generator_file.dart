part of genie_buckshot_org;

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
    if (validTemplateExtensions.some((ext) => fileNameAndPath.endsWith(ext))){
      fileType = TEMPLATE;
    }else if(fileNameAndPath.endsWith('.html')){
      fileType = HTML;
    }else{
      throw new Exception('File extension not supported by Buckshot Generator.'
      ' Must be one of $validTemplateExtensions, or ".html"');
    }
  }

  String get nameCamelCase => '';


  String toString() => fileNameAndPath;
}