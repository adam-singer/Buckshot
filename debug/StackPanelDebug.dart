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
    <border margin='10' background='Black' width='10' height='10'></border>
    <border margin='10' background='Black' width='10' height='10'></border>
    <border margin='10' background='Black' width='10' height='10'></border>
  </stackpanel>

  <textblock horizontalalignment='center'>short</textblock>
  <textblock horizontalalignment='right'>medium medium medium</textblock>
  <textblock>long long long long long long long long</textblock>
</stackpanel>
''';

}
