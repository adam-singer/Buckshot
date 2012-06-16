#library('Buckshot_Extensions_CodeMirror');
#import('dart:html');
#import('../../lib/Buckshot.dart');

void initializeCodeMirrorExtensions(){
  buckshot.registerElement(new CodeMirror());
}
class CodeMirror  extends Control implements IFrameworkContainer {
  FrameworkObject makeMe() => new CodeMirror();
  
  CodeMirror() {    
    String wrapperHTML = """<div>
  <div style="overflow: hidden; position: relative; width: 3px; height: 0px;"> <!-- Wraps and hides input textarea -->
          <textarea style="position: absolute; padding: 0; width: 1px; height: 1em" wrap="off" 
            autocorrect="off" autocapitalize="off"></textarea>
  </div>

  <div class="CodeMirror-scrollbar"> <!-- The vertical scrollbar. Horizontal scrolling is handled by the scroller itself. -->
    <div class="CodeMirror-scrollbar-inner"></div> <!-- The empty scrollbar content, used solely for managing the scrollbar thumb. -->
  </div> <!-- This must be before the scroll area because it's float-right. -->

  <div class="CodeMirror-scroll" tabindex="-1">
    <div style="position: relative"> <!-- Set to the height of the text, causes scrolling -->
      <div style="position: relative"> <!-- Moved around its parent to cover visible view -->
        <div class="CodeMirror-gutter">
          <div class="CodeMirror-gutter-text"></div>
        </div>
        <!-- Provides positioning relative to (visible) text origin -->
        <div class="CodeMirror-lines">
          <div style="position: relative; z-index: 0">
            <div style="position: absolute; width: 100%; height: 0; overflow: hidden; visibility: hidden;"></div>
            <pre class="CodeMirror-cursor">&#160;</pre> <!-- Absolutely positioned blinky cursor -->
            <div style="position: relative; z-index: -1"></div>
            <div></div> <!-- DIVs containing the selection and the actual code -->
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
""";
    rawElement = new Element.html(wrapperHTML); 
    Dom.appendClass(rawElement, "buckshot_codemirror");
  }
  
  get content() {
    
  }
  
  String get type() => "CodeMirror";
}
