#import('../../lib/Buckshot.dart', prefix:"BuckshotUI");
#import('../../extensions/codemirror/CodeMirror.dart', prefix:"CodeMirror");
#import('dart:html');
#source('View.dart');

void main() {
  CodeMirror.initializeCodeMirrorExtensions();
  BuckshotUI.buckshot.rootView = new View();
}
