class StackPanelDebug implements IView {

  final FrameworkElement _rootElement;

  StackPanelDebug()
  :
    _rootElement = buckshot.defaultPresentationProvider.deserialize(view);

  FrameworkElement get rootVisual() => _rootElement;

  static final String view =
'''
<stackpanel background='Orange' margin='10'>
  <stackpanel orientation='horizontal' horizontalalignment='center' background='Yellow'>
    <border margin='10' background='Black' width='10' height='10'></border>
    <border margin='10' background='Red' width='10' height='10'></border>
    <border margin='10' background='Green' width='10' height='10'></border>
    <border margin='10' background='Blue' width='10' height='10'></border>
  </stackpanel>

  <textblock horizontalalignment='center'>center center</textblock>
  <textblock horizontalalignment='right'>right right right</textblock>
  <textblock>long long long long long long long long</textblock>
  <border horizontalalignment='center' borderthickness='5' bordercolor='Purple' width='150' height='150' background='Yellow' cornerradius='150'></border>
  <stackpanel height='300' horizontalalignment='stretch' background='Gray' orientation='horizontal'>
    <textblock verticalalignment='top'>top top top</textblock>
    <textblock verticalalignment='center'>center center center</textblock>
    <textblock verticalalignment='bottom'>bottom bottom bottom</textblock>
  </stackpanel>
</stackpanel>
''';

}
