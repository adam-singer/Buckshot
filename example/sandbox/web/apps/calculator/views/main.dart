class Main extends View
{

  Main() : super.fromTemplate(_main)
  {
    ready.then((t){
      rootVisual.dataContext = new ViewModel();
    });
  }
}


// Setting the template in text in addition to the HTML file so that the app
// can be embedded into the Sandbox demo.  Alternatives to this would be to
// put template into the sandbox html page, or load it from a Uri.
String _main =
@'''
<stack>
    <resourcecollection>
    
        <lineargradientbrush key="calcBackground" direction="vertical">
          <stops>
            <gradientstop color="#FEFEFF" />
            <gradientstop color="#CECEFF" />  
          </stops>
        </lineargradientbrush>
        
        <lineargradientbrush key="outputBackground" direction="vertical">
          <stops>
            <gradientstop color="#DFDFFF" />  
            <gradientstop color="#FEFEFF" />
          </stops>
        </lineargradientbrush>
        
      <styletemplate key='calcDefaultText'>
        <setters>
          <setter property='fontFamily' value='Consolas' />
          <setter property='fontSize' value='16' />
        </setters>
      </styletemplate>
                  
      <styletemplate key='calcStyle'>
        <setters>
          <setter property='background' value='{resource calcBackground}' />
          <setter property='borderThickness' value='1' />
          <setter property='cornerRadius' value='5' />
          <setter property='borderColor' value='Black' />
        </setters>
      </styletemplate>        
        
        <styletemplate key='calcHeader'>
          <setters>
            <setter property='background' value='{resource calcBackground}' />
            <setter property='cornerRadius' value='5' />
          <setter property='vAlign' value='stretch' />
          <setter property='hAlign' value='stretch' />  
          </setters>
        </styletemplate>
        
      <styletemplate key='borderSeperator'>
        <setters>
          <setter property='borderThickness' value='1' />
          <setter property='vAlign' value='bottom' />
          <setter property='hAlign' value='stretch' />
        </setters>
      </styletemplate>

      <styletemplate key='borderOutput'>
        <setters>
          <setter property='background' value='{resource outputBackground}' />
          <setter property='height' value='50' />
          <setter property='hAlign' value='stretch' />
          <setter property='borderThickness' value='1' />
          <setter property='borderColor' value='#777777' />
          <setter property='cornerRadius' value='3' />
          <setter property='margin' value='5,10' />
          <setter property='padding' value='5,0' />
        </setters>
      </styletemplate>

      <styletemplate key='textblockOutput'>
        <setters>
          <setter property='fontSize' value='32' />
          <setter property='hAlign' value='right' />
          <setter property='vAlign' value='bottom' />
          <setter property='fontFamily' value='Consolas' />
        </setters>
      </styletemplate>
      
      <styletemplate key='textblockSubOutput'>
        <setters>
          <setter property='fontSize' value='14' />
          <setter property='fontFamily' value='Consolas' />
        </setters>
      </styletemplate>
      
      <styletemplate key='buttonDefaultStyle'>
        <setters>
          <setter property='vAlign' value='stretch' />
          <setter property='hAlign' value='stretch' />
          <setter property='margin' value='3' />
        </setters>
      </styletemplate>    
    </resourcecollection>

    <border style='{resource calcStyle}'>
      <grid width='{data width}' height='400'>
        <rowdefinitions>
          <rowdefinition height='50' />
          <rowdefinition height='70' />
          <rowdefinition height='*1' />
        </rowdefinitions>
        <border style='{resource calcHeader}'></border>
        <border style='{resource borderSeperator}'></border>
        <stack orientation='horizontal' valign='center' margin='0,0,0,2'>
            <image width='50' alt="Buckshot Logo" sourceuri="apps/calculator/resources/buckshot_logo.png" />
          <stack>
            <textblock style='{resource calcDefaultText}' text='Buckshot' />
            <textblock style='{resource calcDefaultText}' text='Calculator' />
          </stack>
        </stack>
        <stack orientation='horizontal' valign='center' halign='right' margin='0,5,0,0'>
          <textblock style='{resource calcDefaultText}' text='Mode:' margin='0,0,0,5' />
          <dropdownlist on.selectionChanged='selectionChanged_handler'>
            <items>
              <dropdownitem name='Standard' value='Standard' />
              <dropdownitem name='Extended' value='Extended' />
            </items>
          </dropdownlist>
        </stack>
        <border grid.row='1' style='{resource borderOutput}'>
          <!-- 
          In the output grid, we are overlapping several elements,
          while using alignment to make them appear in different
          areas of the grid cell.
          -->
          <grid halign='stretch' valign='stretch'>
             <columndefinitions>
                <columndefinition width='*' />
             </columndefinitions>
             <rowdefinitions>
                <rowdefinition height='*' />
             </rowdefinitions>
            <textblock style='{resource textblockSubOutput}' valign='bottom' text='{data memoryMarker}' />
            <textblock style='{resource textblockSubOutput}' text='{data subOutput}' />
            <textblock style='{resource textblockOutput}' text='{data output}' />
          </grid>
        </border>
        <border margin='5,5' halign='stretch' valign='stretch' grid.row='2' content='{data keypad}'></border>
      </grid>
    </border>
</stack>
''';