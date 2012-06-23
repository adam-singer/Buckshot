//   Copyright (c) 2012, John Evans & LUCA Studios LLC
//
//   http://www.lucastudios.com/contact
//   John: https://plus.google.com/u/0/115427174005651655317/about
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

#library('Buckshot Control Generator');

#import('../lib/Buckshot.dart');
#import('../external/dartxml/lib/xml.dart');
#import('dart:html');

/**
* Takes a string of BuckshotXML and returns a string representing a
* dart Class of the resulting object.
*/
Future<String> generateClassFromXmlTemplate(String buckshotXml){
  var c = new Completer();

  doIt() => c.complete(_generateTemplate(buckshotXml));
  //doIt() => c.complete('hello world');

  try{
    window.setTimeout(doIt, 0);
  }catch (Exception e){
    c.completeException(e);
  }

  return c.future;
}

String _generateTemplate(String xml){
  Buckshot b = new Buckshot('#BuckshotHost');
  var oldContext = buckshot.switchContextTo(b);

  var result = b.defaultPresentationProvider.deserialize(xml);

  StringBuffer s = new StringBuffer();

  _header(s, 'UserView');

  _constructor(s, b, 'UserView');

  _namedElementsDeclaration(s, b);

  _template(s, xml);

  _IView(s);

  _footer(s);

  buckshot.switchContextTo(oldContext);

  UserView v = new UserView();
  buckshot.rootView = v;

  v.btnClear.click + (_, __) => document.body.elements.clear();

//  var content='data:text/plain, $r';
//
//  window.location.href = content;

  return s.toString();
}


void _header(StringBuffer s, String className)
{
  s.add(
'''
/**
* ** GENERATED CODE **
*/
class ${className} implements IView
{
''');

}

void _footer(StringBuffer s){
  s.add(
'''
}
''');

}

void _namedElementsDeclaration(StringBuffer s, Buckshot b){
  if (b.namedElements.length > 0){
s.add('''

  /// Strongly typed representations of all named elements.
''');
    b.namedElements.forEach((name, FrameworkObject el){
      s.add(
'''
  final ${el.type} ${name};
''');
    });
  }

}

void _template(StringBuffer s, String templateXml){
  s.add(
'''

  // Raw template representing the view.
  static final String _viewTemplate = 
\'\'\'
${templateXml}
\'\'\';
''');

}

void _IView(StringBuffer s){
  s.add('''
  // Deserialized view.
  final FrameworkElement _view;

  /// Gets the visual root of the view. (IView interface)
  FrameworkElement get rootVisual() => _view;
''');

}

void _constructor(StringBuffer s, Buckshot b, String className){

  s.add(
'''

${className}()
:
''');
    if (b.namedElements.length > 0){
      s.add(
'''
  _view = buckshot.defaultPresentationProvider.deserialize(_viewTemplate),
''');

      int i = 0;
      b.namedElements.forEach((name, FrameworkObject el){
        s.add(
'''
  ${name} = buckshot.namedElements["${name}"]${++i == b.namedElements.length ? ';' : ','}
''');
      });
    }else{
      s.add(
'''
  _view = buckshot.deserialize(_viewTemplate);
''');
    }

}




/**
* ** GENERATED CODE **
*/
class UserView implements IView
{
  /// Object representation of the named [FrameworkElement]: tbUserInput TextArea
  final TextArea tbUserInput;

  /// Object representation of the named [FrameworkElement]: btnRefresh Button
  final Button btnRefresh;

  /// Object representation of the named [FrameworkElement]: ddlBinding DropDownList
  final DropDownList ddlBinding;

  /// Object representation of the named [FrameworkElement]: btnClear Button
  final Button btnClear;

  /// Object representation of the named [FrameworkElement]: borderContent Border
  final Border borderContent;

  /// Object representation of the named [FrameworkElement]: ddlControls DropDownList
  final DropDownList ddlControls;

  /// Object representation of the named [FrameworkElement]: ddlMediaExtensions DropDownList
  final DropDownList ddlMediaExtensions;

  /// Object representation of the named [FrameworkElement]: ddlElements DropDownList
  final DropDownList ddlElements;


  // Raw template representing the view.
  static final String _viewTemplate =
'''
<stackpanel orientation="horizontal" halign="center">
  <resourcecollection>
    <color key="buckshotBlue" value="#165284"></color>

    <var key="sidewidth" value="270"></var>

    <styletemplate key="sideboxdark">
      <setters>
        <stylesetter property="margin" value="0,0,10,0"></stylesetter>
        <stylesetter property="horizontalAlignment" value="stretch"></stylesetter>
        <stylesetter property="padding" value="20"></stylesetter>
        <stylesetter property="background" value="{resource buckshotBlue}"></stylesetter>
      </setters>
    </styletemplate>
    
    <styletemplate key="sidebox">
      <setters>
        <stylesetter property="margin" value="0,0,10,0"></stylesetter>
        <stylesetter property="horizontalAlignment" value="stretch"></stylesetter>
        <stylesetter property="padding" value="20"></stylesetter>
        <stylesetter property="background" value="SteelBlue"></stylesetter>
      </setters>
    </styletemplate>
    
    <styletemplate key="sideboxtext">
      <setters>
        <stylesetter property="foreground" value="White"></stylesetter>
        <stylesetter property="fontSize" value="18"></stylesetter>
      </setters>
    </styletemplate>
    
    <styletemplate key="iotext">
      <setters>
        <stylesetter property="margin" value="15,0,0,0"></stylesetter>
        <stylesetter property="fontFamily" value="courier"></stylesetter>
        <stylesetter property="fontSize" value="20"></stylesetter>
      </setters>
    </styletemplate>
  </resourcecollection>

  <stackpanel width="{resource sidewidth}">
    <border width="{resource sidewidth}">
    <image halign="center" width="193" height="135" alt="Buckshot Logo Candidate" 
        sourceuri="http://www.lucastudios.com/img/lucaui_logo_candidate2.png"></image>
    </border>
    <border style="{resource sideboxdark}">
      <stackpanel>
          <textblock foreground="White" fontSize="48" text="Buckshot"></textblock>
          <textblock fontfamily="arial" foreground="White" text="A Better Way To Web"></textblock>
      </stackpanel>
    </border>
    <border style="{resource sidebox}">
      <stackpanel>
        <textblock style="{resource sideboxtext}">
        Buckshot is a User Interface framework for the web written in Google Dart.  On this page you can explore how the framework's simple layout structure makes designing and working with web pages easy.
        </textblock>
        <textblock foreground="White" margin="10,0,0,0" fontSize="14">
        (this page is 100% generated with Buckshot)
        </textblock>
      </stackpanel>
    </border>
    <border style="{resource sidebox}">
      <textblock style="{resource sideboxtext}">
      Buckshot is currently in the ALPHA stage of development. That means you may find some things that don't work as expected.
      </textblock>
    </border>
    <border style="{resource sidebox}">
       <hyperlink targetName="_blank" navigateto="https://github.com/prujohn/Buckshot/wiki">
          <textblock style="{resource sideboxtext}">Buckshot Project Site</textblock>
       </hyperlink>
    </border>
    <border style="{resource sidebox}">
       <hyperlink targetName="_blank" navigateto="http://www.lucastudios.com/trybuckshot/docs/">
          <textblock style="{resource sideboxtext}">Library Documentation</textblock>
       </hyperlink>
    </border>

  </stackpanel>
  <stackpanel margin="0,0,0,10" width="700">
    <!-- border.halign="stretch" isn't working properly here (textblock wont center), so setting width explicitely instead -->
    <textblock margin="0,10" fontsize="20" fontfamily="arial" text="Select a sample or design your own in the Input area below."></textblock>
    <stackpanel margin="0,0,10,0" orientation="horizontal">
      <textblock margin="0,10,0,0" text="Elements:" fontfamily="arial"></textblock>
      <dropdownlist name="ddlElements">
        <items>
          <dropdownlistitem name='' value=''></dropdownlistitem>
          <dropdownlistitem name='Hello World' value='helloworld'></dropdownlistitem>
          <dropdownlistitem name='StackPanel' value='stackpanel'></dropdownlistitem>
          <dropdownlistitem name='Border' value='border'></dropdownlistitem>
          <dropdownlistitem name='Grid' value='grid'></dropdownlistitem>
          <dropdownlistitem name='Layout Canvas' value='layoutcanvas'></dropdownlistitem>
          <dropdownlistitem name='This Page!' value='thispage'></dropdownlistitem>
        </items>
      </dropdownlist>
    </stackpanel>
    <stackpanel margin="0,0,10,0" orientation="horizontal">
      <textblock margin="0,10,0,0" text="Controls:" fontfamily="arial"></textblock>
      <dropdownlist name="ddlControls">
        <items>
          <dropdownlistitem name='' value=''></dropdownlistitem>
          <dropdownlistitem name='ListBox' value='listbox'></dropdownlistitem>
          <dropdownlistitem name='DropDownList' value='dropdownlist'></dropdownlistitem>
          <dropdownlistitem name='Slider' value='slider'></dropdownlistitem>
          <dropdownlistitem name='Button' value='button'></dropdownlistitem>
          <dropdownlistitem name='Radio Buttons' value='radiobuttons'></dropdownlistitem>
          <dropdownlistitem name='Checkboxes' value='checkboxes'></dropdownlistitem>
          <dropdownlistitem name='Hyperlink' value='hyperlink'></dropdownlistitem>
          <dropdownlistitem name='Image' value='image'></dropdownlistitem>
        </items>
      </dropdownlist>
    </stackpanel>
    <stackpanel margin="0,0,10,0" orientation="horizontal">
      <TextBlock text="Binding Demos:" margin="0,5,0,0" fontfamily="arial"></TextBlock>
      <dropdownlist name="ddlBinding">
        <items>
          <dropdownlistitem name='' value=''></dropdownlistitem>
          <dropdownlistitem name='Resource Binding' value='resourcebinding'></dropdownlistitem>
          <dropdownlistitem name='Element Binding' value='elementbinding'></dropdownlistitem>
          <dropdownlistitem name='Data Binding' value='databinding'></dropdownlistitem>
          <dropdownlistitem name='Collections Demo' value='collections'></dropdownlistitem>
        </items>
      </dropdownlist>
    </stackpanel>
    <stackpanel margin="0,0,10,0" orientation="horizontal">
      <TextBlock text="Media Extensions:" margin="0,5,0,0" fontfamily="arial"></TextBlock>
      <dropdownlist name="ddlMediaExtensions">
        <items>
          <dropdownlistitem name='' value=''></dropdownlistitem>
          <dropdownlistitem name='YouTube' value='youtube'></dropdownlistitem>
          <dropdownlistitem name='Hulu' value='hulu'></dropdownlistitem>
          <dropdownlistitem name='Vimeo' value='vimeo'></dropdownlistitem>
          <dropdownlistitem name='FunnyOrDie' value='funnyordie'></dropdownlistitem>
        </items>
      </dropdownlist>
    </stackpanel>
    <TextBlock style="{resource iotext}" text="Input (you can edit this or create your own):"></TextBlock>
    <textarea placeholder="Type something here or select one of the samples from above." spellcheck="false" 
      name="tbUserInput" minheight="300" maxwidth="700"></textarea>
    <StackPanel orientation="horizontal">
       <button name="btnRefresh" content="Refresh Output"></button>
       <button name="btnClear" margin="0,0,0,5" content="Clear All"></button>
    </StackPanel>
    <TextBlock style="{resource iotext}" text="Output:"></TextBlock>
    <border name="borderContent" margin="0,0,10,0" width="690" borderThickness="3" borderColor="{resource buckshotBlue}">
    </border>
  </stackpanel>
</stackpanel>

''';
  // Deserialized view.
  final FrameworkElement _view;

  /// Gets the visual root of the view. (IView interface)
  FrameworkElement get rootVisual() => _view;

UserView()
:
  _view = Template.deserialize(_viewTemplate),
  tbUserInput = buckshot.namedElements["tbUserInput"],
  btnRefresh = buckshot.namedElements["btnRefresh"],
  ddlBinding = buckshot.namedElements["ddlBinding"],
  btnClear = buckshot.namedElements["btnClear"],
  borderContent = buckshot.namedElements["borderContent"],
  ddlControls = buckshot.namedElements["ddlControls"],
  ddlMediaExtensions = buckshot.namedElements["ddlMediaExtensions"],
  ddlElements = buckshot.namedElements["ddlElements"];
}