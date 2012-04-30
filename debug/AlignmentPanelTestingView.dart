

class AlignmentPanelTestingView implements IView {
  final FrameworkElement _rootElement;
  
  AlignmentPanelTestingView()
  :
    _rootElement = buckshot.defaultPresentationProvider.deserialize(view);

  
  FrameworkElement get rootVisual() => _rootElement;
  
  
  static final String view = 
'''
<stackpanel>
<border margin='1' width='300' height='300' background='Orange'>
  <border background='Black' width='50' horizontalalignment='center' verticalalignment='stretch'>
    <textblock horizontalalignment='center' verticalalignment='center' foreground='White'>hi</textblock>
  </border>
  <!--<textblock horizontalalignment='stretch' verticalalignment='bottom'>hello world</textblock>-->
</border>
<border margin='1' width='300' height='300' background='Orange'>
  <border background='Black' horizontalalignment='stretch' verticalalignment='center'>
    <textblock horizontalalignment='center' verticalalignment='center' foreground='White'>hi</textblock>
  </border>
  <!--<textblock horizontalalignment='stretch' verticalalignment='bottom'>hello world</textblock>-->
</border>
<border margin='1' width='300' height='300' background='Orange'>
  <border background='Black' horizontalalignment='center' verticalalignment='center'>
    <textblock horizontalalignment='center' verticalalignment='center' foreground='White'>hi</textblock>
  </border>
  <!--<textblock horizontalalignment='stretch' verticalalignment='bottom'>hello world</textblock>-->
</border>
</stackpanel>
''';
  
}
