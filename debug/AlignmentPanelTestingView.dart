

class AlignmentPanelTestingView implements IView {
  final FrameworkElement _rootElement;

  AlignmentPanelTestingView()
  :
    _rootElement = buckshot.defaultPresentationProvider.deserialize(view);


  FrameworkElement get rootVisual() => _rootElement;


  static final String view =
'''
<stackpanel>
<border name='stretch_stretch' margin='1' width='300' height='300' background='Orange'>
  <border background='Black' padding='10' horizontalalignment='stretch' verticalalignment='stretch'>
    <textblock horizontalalignment='stretch' verticalalignment='center' foreground='White'>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus nunc nunc, lacinia sit amet ultricies non, bibendum quis eros. Integer hendrerit volutpat velit sit amet iaculis. Curabitur eu arcu velit, non blandit nulla. Nullam diam dui, molestie non ultricies a, tristique nec nunc. Nullam hendrerit fringilla nulla non porttitor. Cras orci sapien, porttitor placerat dapibus vitae, pharetra a lectus. Nulla tincidunt lacinia elit ac tempus. Sed sed sem justo,</textblock>
  </border>
  <!--<textblock horizontalalignment='stretch' verticalalignment='bottom'>hello world</textblock>-->
</border>
<border margin='1' width='300' height='300' background='Orange'>
  <border background='Black' horizontalalignment='left' verticalalignment='stretch'>
    <textblock horizontalalignment='center' verticalalignment='center' foreground='White'>hi</textblock>
  </border>
  <!--<textblock horizontalalignment='stretch' verticalalignment='bottom'>hello world</textblock>-->
</border>
<border margin='1' width='300' height='300' background='Orange'>
  <border background='Black' horizontalalignment='center' verticalalignment='stretch'>
    <textblock horizontalalignment='center' verticalalignment='center' foreground='White'>hi</textblock>
  </border>
  <!--<textblock horizontalalignment='stretch' verticalalignment='bottom'>hello world</textblock>-->
</border>
<border margin='1' width='300' height='300' background='Orange'>
  <border background='Black' horizontalalignment='right' verticalalignment='stretch'>
    <textblock horizontalalignment='center' verticalalignment='center' foreground='White'>hi</textblock>
  </border>
  <!--<textblock horizontalalignment='stretch' verticalalignment='bottom'>hello world</textblock>-->
</border>

<border margin='1' width='300' height='300' background='Orange'>
  <border background='Black' horizontalalignment='stretch' verticalalignment='top'>
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
  <border background='Black' horizontalalignment='stretch' verticalalignment='bottom'>
    <textblock horizontalalignment='center' verticalalignment='center' foreground='White'>hi</textblock>
  </border>
  <!--<textblock horizontalalignment='stretch' verticalalignment='bottom'>hello world</textblock>-->
</border>

<border margin='1' width='300' height='300' background='Orange'>
  <border background='Black' horizontalalignment='left' verticalalignment='top'>
    <textblock horizontalalignment='center' verticalalignment='center' foreground='White'>hi</textblock>
  </border>
  <!--<textblock horizontalalignment='stretch' verticalalignment='bottom'>hello world</textblock>-->
</border>
<border margin='1' width='300' height='300' background='Orange'>
  <border background='Black' horizontalalignment='center' verticalalignment='top'>
    <textblock horizontalalignment='center' verticalalignment='center' foreground='White'>hi</textblock>
  </border>
  <!--<textblock horizontalalignment='stretch' verticalalignment='bottom'>hello world</textblock>-->
</border>
<border margin='1' width='300' height='300' background='Orange'>
  <border background='Black' horizontalalignment='right' verticalalignment='top'>
    <textblock horizontalalignment='center' verticalalignment='center' foreground='White'>hi</textblock>
  </border>
  <!--<textblock horizontalalignment='stretch' verticalalignment='bottom'>hello world</textblock>-->
</border>
<border margin='1' width='300' height='300' background='Orange'>
  <border background='Black' horizontalalignment='right' verticalalignment='center'>
    <textblock horizontalalignment='center' verticalalignment='center' foreground='White'>hi</textblock>
  </border>
  <!--<textblock horizontalalignment='stretch' verticalalignment='bottom'>hello world</textblock>-->
</border>
<border margin='1' width='300' height='300' background='Orange'>
  <border background='Black' horizontalalignment='right' verticalalignment='bottom'>
    <textblock horizontalalignment='center' verticalalignment='center' foreground='White'>hi</textblock>
  </border>
  <!--<textblock horizontalalignment='stretch' verticalalignment='bottom'>hello world</textblock>-->
</border>
<border margin='1' width='300' height='300' background='Orange'>
  <border background='Black' horizontalalignment='center' verticalalignment='bottom'>
    <textblock horizontalalignment='center' verticalalignment='center' foreground='White'>hi</textblock>
  </border>
  <!--<textblock horizontalalignment='stretch' verticalalignment='bottom'>hello world</textblock>-->
</border>
<border margin='1' width='300' height='300' background='Orange'>
  <border background='Black' horizontalalignment='left' verticalalignment='bottom'>
    <textblock horizontalalignment='center' verticalalignment='center' foreground='White'>hi</textblock>
  </border>
  <!--<textblock horizontalalignment='stretch' verticalalignment='bottom'>hello world</textblock>-->
</border>
<border margin='1' width='300' height='300' background='Orange'>
  <border background='Black' horizontalalignment='left' verticalalignment='center'>
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
