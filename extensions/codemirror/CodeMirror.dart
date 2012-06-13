#library('Buckshot_Extensions_CodeMirror');

#import('../../lib/Buckshot.dart');

void initializeCodeMirrorExtensions(){
  buckshot.registerElement(new CodeMirror());
}
class CodeMirror extends FrameworkElement {
  FrameworkObject makeMe() => new CodeMirror();
  
  CodeMirror() {
    Dom.appendClass(rawElement, "buckshot_codemirror");
  }
  
  void CreateElement() {
    rawElement = Dom.createByTag("textarea");
  }
  
  String get type() => "CodeMirror";
}
