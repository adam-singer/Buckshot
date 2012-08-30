/**
* Represents the view of an standard calculator keypad layout.
*/
class StandardCalc extends View
{

  StandardCalc()
  {

    // Retrieve the template from the HTML page and deserialize it.
    Template
    .deserialize(_standardCalcView)
    .then((t){
      rootVisual = t;
    });
  }
}

// Setting the template in text in addition to the HTML file so that the app
// can be embedded into the Sandbox demo.  Alternatives to this would be to
// put template into the sandbox html page, or load it from a Uri.
String _standardCalcView = 
@'''
<grid halign='stretch' valign='stretch'>
      <rowdefinitions>
        <rowdefinition height='*1' />
        <rowdefinition height='*1' />
        <rowdefinition height='*1' />
        <rowdefinition height='*1' />
        <rowdefinition height='*1' />
        <rowdefinition height='*1' />
      </rowdefinitions>
      <columndefinitions>
        <columndefinition width='*1' />
        <columndefinition width='*1' />
        <columndefinition width='*1' />
        <columndefinition width='*1' />
        <columndefinition width='*1' />
      </columndefinitions>
      <button click='buttonClick_handler' style='{resource buttonDefaultStyle}' content='MC'></button>
      <button click='buttonClick_handler' grid.column='1' style='{resource buttonDefaultStyle}' content='MR'></button>
      <button click='buttonClick_handler' grid.column='2' style='{resource buttonDefaultStyle}' content='MS'></button>
      <button click='buttonClick_handler' grid.column='3' style='{resource buttonDefaultStyle}' content='M+'></button>
      <button click='buttonClick_handler' grid.column='4' style='{resource buttonDefaultStyle}' content='M-'></button>
      
      <button click='buttonClick_handler' grid.row='1' style='{resource buttonDefaultStyle}' content='<--'></button>
      <button click='buttonClick_handler' grid.column='1' grid.row='1' style='{resource buttonDefaultStyle}' content='CE'></button>
      <button click='buttonClick_handler' grid.column='2' grid.row='1' style='{resource buttonDefaultStyle}' content='C'></button>
      <button click='buttonClick_handler' grid.column='3' grid.row='1' style='{resource buttonDefaultStyle}' content='+-'></button>
      <button click='buttonClick_handler' grid.column='4' grid.row='1' style='{resource buttonDefaultStyle}' content='SQRT'></button>
      
      <button click='buttonClick_handler' grid.row='2' style='{resource buttonDefaultStyle}' content='7'></button>
      <button click='buttonClick_handler' grid.column='1' grid.row='2' style='{resource buttonDefaultStyle}' content='8'></button>
      <button click='buttonClick_handler' grid.column='2' grid.row='2' style='{resource buttonDefaultStyle}' content='9'></button>
      <button click='buttonClick_handler' grid.column='3' grid.row='2' style='{resource buttonDefaultStyle}' content='/'></button>
      <button click='buttonClick_handler' grid.column='4' grid.row='2' style='{resource buttonDefaultStyle}' content='%'></button>
      
      <button click='buttonClick_handler' grid.row='3' style='{resource buttonDefaultStyle}' content='4'></button>
      <button click='buttonClick_handler'  grid.column='1' grid.row='3' style='{resource buttonDefaultStyle}' content='5'></button>
      <button click='buttonClick_handler' grid.column='2' grid.row='3' style='{resource buttonDefaultStyle}' content='6'></button>
      <button click='buttonClick_handler' grid.column='3' grid.row='3' style='{resource buttonDefaultStyle}' content='*'></button>
      <button click='buttonClick_handler' grid.column='4' grid.row='3' style='{resource buttonDefaultStyle}' content='1/x'></button>
      
      <button click='buttonClick_handler' grid.row='4' style='{resource buttonDefaultStyle}' content='1'></button>
      <button click='buttonClick_handler' grid.column='1' grid.row='4' style='{resource buttonDefaultStyle}' content='2'></button>
      <button click='buttonClick_handler' grid.column='2' grid.row='4' style='{resource buttonDefaultStyle}' content='3'></button>
      <button click='buttonClick_handler' grid.column='3' grid.row='4' style='{resource buttonDefaultStyle}' content='-'></button>
      <button click='buttonClick_handler' grid.column='4' grid.row='4' grid.rowspan='2' style='{resource buttonDefaultStyle}' content='='></button>
      
      <button click='buttonClick_handler' grid.row='5' grid.columnspan='2' style='{resource buttonDefaultStyle}' content='0'></button>
      <button click='buttonClick_handler' grid.column='2' grid.row='5' style='{resource buttonDefaultStyle}' content='.'></button>
      <button click='buttonClick_handler' grid.column='3' grid.row='5' style='{resource buttonDefaultStyle}' content='+'></button>
    </grid>
''';