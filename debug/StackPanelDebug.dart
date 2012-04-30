class StackPanelDebug implements IView {

  final FrameworkElement _rootElement;

  StackPanelDebug()
  :
    _rootElement = buckshot.defaultPresentationProvider.deserialize(view);

  FrameworkElement get rootVisual() => _rootElement;

  static final String view =
'''
<stackpanel background='Orange' margin='10'>
  <stackpanel orientation='horizontal' horizontalalignment='center'>
    <border margin='10' background='Black' width='10' height='10'></border>
    <border margin='10' background='Red' width='10' height='10'></border>
    <border margin='10' background='Green' width='10' height='10'></border>
    <border margin='10' background='Blue' width='10' height='10'></border>
  </stackpanel>

  <textblock horizontalalignment='center'>short</textblock>
  <textblock horizontalalignment='right'>medium medium medium</textblock>
  <textblock>long long long long long long long long</textblock>
  <border horizontalalignment='center' borderthickness='5' bordercolor='Purple' width='300' height='300' background='Yellow' cornerradius='300'></border>
</stackpanel>
''';

}
