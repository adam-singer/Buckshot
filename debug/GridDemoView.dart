class GridDemoView implements IView
{
  final Grid _rootElement;
  final IMainViewModel _vm;

  GridDemoView.with(this._vm)
  :
    _rootElement = buckshot.defaultPresentationProvider.deserialize(view)
  {
    new Binding(buckshot.windowWidthProperty, buckshot.domRoot.widthProperty);
    new Binding(buckshot.windowHeightProperty, buckshot.domRoot.heightProperty);

    _rootElement.dataContext = _vm;

    _rootElement.measurementChanged + (_, MeasurementChangedEventArgs args){
      _vm.title = "Grid: (${args.newMeasurement.bounding.left}, ${args.newMeasurement.bounding.top}), (${args.newMeasurement.bounding.width}, ${args.newMeasurement.bounding.height})";
    };

//    _rootElement.mouseMove + (_, MouseEventArgs args){
//     _vm.title = "Grid: (${args.mouseX}, ${args.mouseY}), (${args.windowX}, ${args.windowY})";
//    };
  }

  FrameworkElement get rootVisual() => _rootElement;


  static final String view =
'''
<grid margin='10' 
horizontalalignment='stretch' verticalalignment='stretch'>
<resourcecollection>
  <styletemplate key='_border'>
    <setters>
      <stylesetter property="borderColor" value="Black"></stylesetter>
      <stylesetter property="borderThickness" value="1"></stylesetter>
      <stylesetter property="verticalAlignment" value="stretch"></stylesetter>
      <stylesetter property="horizontalAlignment" value="stretch"></stylesetter>
      <stylesetter property="padding" value="5"></stylesetter>
    </setters>
  </styletemplate>
  <styletemplate key='_text'>
    <setters>
      <stylesetter property="verticalAlignment" value="center"></stylesetter>
      <stylesetter property="horizontalAlignment" value="center"></stylesetter>
    </setters>
  </styletemplate>
</resourcecollection>
  <rowdefinitions>
    <rowdefinition height='50'></rowdefinition>
    <rowdefinition height='*'></rowdefinition>
    <rowdefinition height='*.5'></rowdefinition>
    <rowdefinition height='*'></rowdefinition>
  </rowdefinitions>
  <columndefinitions>
    <columndefinition width='*'></columndefinition>
    <columndefinition width='*.5'></columndefinition>
    <columndefinition width='*'></columndefinition>
  </columndefinitions>
  <textblock horizontalalignment='center' fontsize='36' fontfamily='Consolas'
  margin='5' grid.columnspan='3' text='{data title}'></textblock>
  <border background='#333333' grid.row='1' style='{resource _border}'>
    <textblock text='0,0' style='{resource _text}'></textblock>
  </border>
  <border background='#555555' grid.row='1' grid.column='1' style='{resource _border}'>
    <textblock text='1,0' style='{resource _text}'></textblock>
  </border>
  <border background='#777777' grid.row='1' grid.column='2' style='{resource _border}'>
    <textblock text='2,0' style='{resource _text}'></textblock>
  </border>
  <border background='#555555' grid.row='2' style='{resource _border}'>
    <textblock text='0,1' style='{resource _text}'></textblock>
  </border>
  <border background='#999999' grid.row='2' grid.column='1' style='{resource _border}'>
    <textblock text='1,1' style='{resource _text}'></textblock>
  </border>
  <border background='#BBBBBB' grid.row='2' grid.column='2' style='{resource _border}'>
    <textblock text='2,1' style='{resource _text}'></textblock>
  </border>
  <border background='#777777' grid.row='3' style='{resource _border}'>
    <textblock text='0,2' style='{resource _text}'></textblock>
  </border>
  <border background='#BBBBBB' grid.row='3' grid.column='1' style='{resource _border}'>
    <textblock text='1,2' style='{resource _text}'></textblock>
  </border>
  <border background='#EEEEEE' grid.row='3' grid.column='2' style='{resource _border}'>
    <textblock text='2,2' style='{resource _text}'></textblock>
  </border>
</grid>
''';

}
