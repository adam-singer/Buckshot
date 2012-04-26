#import('ControlGenerator.dart');
#import('dart:html');

//blah

String get testTemplate() =>
'''
<stackpanel orientation="horizontal" horizontalAlignment="center">
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
    <image horizontalAlignment="center" width="193" height="135" alt="Buckshot Logo Candidate" 
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
    <!-- border.horizontalAlignment="stretch" isn't working properly here (textblock wont center), so setting width explicitely instead -->
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

main(){
  generateClassFromXmlTemplate(testTemplate).then((reply){
    var e = new Element.tag('pre');
    e.text = reply;
    document.body.elements.add(e);
    print(reply);
  });
}
