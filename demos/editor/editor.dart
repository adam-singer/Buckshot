#import('../../lib/Buckshot.dart');
#import('../../extensions/codemirror/CodeMirror.dart');
#import('dart:html');
#source('View.dart');

void main() {
  initializeCodeMirrorExtensions();
  buckshot.rootView = new View();
}
