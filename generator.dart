#library('generator_core_buckshotui_org');

#import('dart:io');
#import('dart:json');
#import('package:dart-xml/xml.dart');

#import('lib/gen/genie.dart');

void generateCode(){
  final out = new File('test.tmp').openOutputStream();
  
  out.onError = (e){
    print('build.dart error! $e');
    exit(1);
  };
      
  var result = JSON.parse(genCode('Foo', XML.parse(test)));
  
  out.writeString(result.getValues()[0]);
   
  out.close();
}


String test =
'''
<stack orientation="horizontal" halign="center">
  <resourcecollection>
    <color key="buckshotBlue" value="#165284"></color>
   
    <styletemplate key="iotext">
       <setters>
          <setter property="margin" value="15,0,0,0" />
          <setter property="fontFamily" value="Arial" />
          <setter property="fontSize" value="20" />
       </setters>
    </styletemplate>
    <styletemplate key='headerText'>
       <setters>
          <setter property='fontSize' value='18' />
          <setter property='fontFamily' value='Arial' />
          <setter property='margin' value='15,0,0,0' />
       </setters>
    </styletemplate>
    <styletemplate key='defaultText'>
       <setters>
          <setter property='fontSize' value='14' />
          <setter property='fontFamily' value='Arial' />
          <setter property='margin' value='0,3' />
       </setters>
    </styletemplate>
  </resourcecollection>

  <stack minWidth='250'>
    <textblock style="{resource iotext}" text="Select A Sample"/>
    <border minHeight='300' halign='stretch' borderthickness='1' bordercolor='SteelBlue' padding='5'>
      <stack>       
      <treeview treenodeselected='selection_handler'>
     <treenode header='App Demos' childvisibility='visible'>
            <treenode header='Calculator' tag='app.calc' />
            <treenode header='Simple Todo List' tag='app.todo' />
       </treenode>
       <treenode header='Elements' tag=''>
        <treenode header='TextBlock' tag='textblock' />
        <treenode header='Stack' tag='stack' />
        <treenode header='Border' tag='border' />
        <treenode header='Grid' tag='grid' />
        <treenode header='RawHtml' tag='rawhtml' />
        <treenode header='LayoutCanvas' tag='layoutcanvas' />
       </treenode>
       <treenode header='Controls' tag=''>
        <treenode header='TreeView' tag='treeview' />
        <treenode header='DockPanel' tag='dockpanel' />
        <treenode header='ListBox' tag='listbox' />
        <treenode header='DropDownList' tag='dropdownlist' />
        <treenode header='TextBox' tag='textbox' />
        <treenode header='Slider' tag='slider' />
        <treenode header='Button' tag='button' />
        <treenode header='RadioButton' tag='radiobutton' />
        <treenode header='CheckBox' tag='checkbox' />
        <treenode header='Hyperlink' tag='hyperlink' />
       </treenode>
       <treenode header='Binding Demos' tag=''>
        <treenode header='Resource Binding' tag='resources' />
        <treenode header='Element Binding' tag='elementbinding' />
        <treenode header='Data Binding' tag='databinding' />
        <treenode header='Binding To Collections' tag='collections' />
       </treenode>
       <treenode header='Media Extensions' tag=''>
        <treenode header='YouTube' tag='youtube' />
        <treenode header='Hulu' tag='hulu' />
        <treenode header='Vimeo' tag='vimeo' />
        <treenode header='FunnyOrDie' tag='funnyordie' />
       </treenode>
      </treeview>  
      </stack>
    </border>
  </stack>
  <stack margin="0,0,0,10" halign='stretch'>
    <textblock style="{resource iotext}" text="Output:"/>
    <border content='{data renderedOutput}' margin="0,0,10,0" minheight='200' 
    width="680" borderThickness="3" borderColor="{resource buckshotBlue}"
    cornerradius='4' padding='5'/>
    <textblock style="{resource iotext}" text="Template:"/>
    <textarea placeholder="Type something here or select one of the samples to the left." spellcheck="false" 
      text='{data templateText, mode=twoway}' minwidth='690' maxwidth='690' minheight="200" />
    <stack orientation="horizontal">
       <button click='refresh_handler' content="Generate Output"></button>
       <button click='clearAll_handler' margin="0,0,0,5" content="Clear All"></button>
    </stack>
  </stack>
</stack>
''';