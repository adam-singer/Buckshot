
// adds a manual pause that only proceeds after clicking the browser
void pause() {
  document.body.on.click.add(expectAsync1((e){
    Expect.isTrue(true);
  }));
}

void layoutTests()
{
  // Take measurements of reference layout to make sure they exactly match
  // expected results.
  test('StackPanel Layout', (){
    buckshot.rootView = new StackPanelDebug();
        
    buckshot.namedElements.getValues().forEach((v)=> v.updateMeasurement());
    
    //references
    final spRoot = buckshot.namedElements['rootPanel'];
    final spChrome = buckshot.namedElements['chromePanel'];
    final bBlack = buckshot.namedElements['bBlack'];
    final bRed = buckshot.namedElements['bRed'];
    final bGreen = buckshot.namedElements['bGreen'];
    final bBlue = buckshot.namedElements['bBlue'];
    final lblHCenter = buckshot.namedElements['lblHCenter'];
    final lblRight = buckshot.namedElements['lblRight'];
    final lblLeft = buckshot.namedElements['lblLong'];
    final bCircle = buckshot.namedElements['bCircle'];
    final spHorizontal = buckshot.namedElements['spVerticalAlignment'];
    final lblTop = buckshot.namedElements['lblTop'];
    final lblVCenter = buckshot.namedElements['lblVCenter'];
    final lblBottom = buckshot.namedElements['lblBottom'];
    
    //offset test framework UI
    final topOffset = 98.5;
    final leftOffset = 18;
    
    window.requestLayoutFrame(
      expectAsync0((){
        /* root stackpanel */
        Expect.equals(0, spRoot.mostRecentMeasurement.bounding.top - topOffset, 'spRoot top');
        Expect.equals(0, spRoot.mostRecentMeasurement.bounding.left - leftOffset, 'spRoot left');
        Expect.equals(372, spRoot.mostRecentMeasurement.bounding.width, 'spRoot Width');
        Expect.equals(541, spRoot.mostRecentMeasurement.bounding.height, 'spRoot Height');
        
        
        /* "chrome" stackpanel */
        Expect.equals(120, spChrome.mostRecentMeasurement.bounding.width, 'spChrome Width');
        Expect.equals(30, spChrome.mostRecentMeasurement.bounding.height, 'spChrome Height');
        Expect.equals(0, spChrome.mostRecentMeasurement.bounding.top - topOffset, 'spChrome Top');
        Expect.equals(126, spChrome.mostRecentMeasurement.bounding.left - leftOffset, 'spChome Left');
        
        
        /* dots inside the "chrome" stackpanel */
        //black
        Expect.equals(10, bBlack.mostRecentMeasurement.bounding.width, 'bBlack Width');
        Expect.equals(10, bBlack.mostRecentMeasurement.bounding.height, 'bBlack Height');
        Expect.equals(10, bBlack.mostRecentMeasurement.bounding.top - topOffset, 'bBlack Top');
        Expect.equals(136, bBlack.mostRecentMeasurement.bounding.left - leftOffset, 'bBlack Left');
        
        //red
        Expect.equals(10, bRed.mostRecentMeasurement.bounding.width, 'bRed Width');
        Expect.equals(10, bRed.mostRecentMeasurement.bounding.height, 'bRed Height');
        Expect.equals(10, bRed.mostRecentMeasurement.bounding.top - topOffset, 'bRed Top');
        Expect.equals(166, bRed.mostRecentMeasurement.bounding.left - leftOffset, 'bRed Left');
        
        //green
        Expect.equals(10, bGreen.mostRecentMeasurement.bounding.width, 'bGreen Width');
        Expect.equals(10, bGreen.mostRecentMeasurement.bounding.height, 'bGreen Height');
        Expect.equals(10, bGreen.mostRecentMeasurement.bounding.top - topOffset, 'bGreen Top');
        Expect.equals(196, bGreen.mostRecentMeasurement.bounding.left - leftOffset, 'bGreen Left');
        
        //blue
        Expect.equals(10, bBlue.mostRecentMeasurement.bounding.width, 'bBlue Width');
        Expect.equals(10, bBlue.mostRecentMeasurement.bounding.height, 'bBlue Height');
        Expect.equals(10, bBlue.mostRecentMeasurement.bounding.top - topOffset, 'bBlue Top');
        Expect.equals(226, bBlue.mostRecentMeasurement.bounding.left - leftOffset, 'bBlue Left');
        
        
        /* Horizontal aligned elements in a vertical stackpanel */
        //centered
        Expect.equals(90, lblHCenter.mostRecentMeasurement.bounding.width, 'lblHCenter Width');
        Expect.equals(17, lblHCenter.mostRecentMeasurement.bounding.height, 'lblHCenter Height');
        Expect.equals(30, lblHCenter.mostRecentMeasurement.bounding.top - topOffset, 'lblHCenter Top');
        Expect.equals(141, lblHCenter.mostRecentMeasurement.bounding.left - leftOffset, 'lblHCenter Left');
        
        //right aligned
        Expect.equals(107, lblRight.mostRecentMeasurement.bounding.width, 'lblRight Width');
        Expect.equals(17, lblRight.mostRecentMeasurement.bounding.height, 'lblRight Height');
        Expect.equals(47, lblRight.mostRecentMeasurement.bounding.top - topOffset, 'lblRight Top');
        Expect.equals(265, lblRight.mostRecentMeasurement.bounding.left - leftOffset, 'lblRight Left');
        
        //left aligned
        Expect.equals(276, lblLeft.mostRecentMeasurement.bounding.width, 'lblLeft Width');
        Expect.equals(17, lblLeft.mostRecentMeasurement.bounding.height, 'lblLeft Height');
        Expect.equals(64, lblLeft.mostRecentMeasurement.bounding.top - topOffset, 'lblLeft Top');
        Expect.equals(0, lblLeft.mostRecentMeasurement.bounding.left - leftOffset, 'lblLeft Left');
        
        /* Circle (centered horizontally) */
        Expect.equals(160, bCircle.mostRecentMeasurement.bounding.width, 'bCircle Width');
        Expect.equals(160, bCircle.mostRecentMeasurement.bounding.height, 'bCircle Height');
        Expect.equals(81, bCircle.mostRecentMeasurement.bounding.top - topOffset, 'bCircle Top');
        Expect.equals(106, bCircle.mostRecentMeasurement.bounding.left - leftOffset, 'bCircle Left');
        
        /* Horizontal StackPanel Container */
        //container StackPanel
        Expect.equals(372, spHorizontal.mostRecentMeasurement.bounding.width, 'spHorizontal Width');
        Expect.equals(300, spHorizontal.mostRecentMeasurement.bounding.height, 'spHorizontal Height');
        Expect.equals(241, spHorizontal.mostRecentMeasurement.bounding.top - topOffset, 'spHorizontal Top');
        Expect.equals(0, spHorizontal.mostRecentMeasurement.bounding.left - leftOffset, 'spHorizontal Left');
        
        //now check the vertical alignment of elements within the horizontal StackPanel
        //container StackPanel
        Expect.equals(77, lblTop.mostRecentMeasurement.bounding.width, 'lblTop Width');
        Expect.equals(17, lblTop.mostRecentMeasurement.bounding.height, 'lblTop Height');
        Expect.equals(241, lblTop.mostRecentMeasurement.bounding.top - topOffset, 'lblTop Top');
        Expect.equals(0, lblTop.mostRecentMeasurement.bounding.left - leftOffset, 'lblTop Left');
        
        //container StackPanel
        Expect.equals(137, lblVCenter.mostRecentMeasurement.bounding.width, 'lblVCenter Width');
        Expect.equals(17, lblVCenter.mostRecentMeasurement.bounding.height, 'lblVCenter Height');
        Expect.equals(382.5, lblVCenter.mostRecentMeasurement.bounding.top - topOffset, 'lblVCenter Top');
        Expect.equals(77, lblVCenter.mostRecentMeasurement.bounding.left - leftOffset, 'lblVCenter Left');
        
        //container StackPanel
        Expect.equals(158, lblBottom.mostRecentMeasurement.bounding.width, 'lblBottom Width');
        Expect.equals(17, lblBottom.mostRecentMeasurement.bounding.height, 'lblBottom Height');
        Expect.equals(524, lblBottom.mostRecentMeasurement.bounding.top - topOffset, 'lblBottom Top');
        Expect.equals(214, lblBottom.mostRecentMeasurement.bounding.left - leftOffset, 'lblBottom Left');
        
      })   
    );
  });
  
  
  // Take measurements of reference layout to make sure they match
  // expected results.
  test('Border Layout', (){
    buckshot.rootView = new BorderDebug();
        
    buckshot.namedElements.getValues().forEach((v)=> v.updateMeasurement());
    
    //references
    final bLorumIpsum = buckshot.namedElements['bLorumIpsum'];
    final lblLorumIpsum = buckshot.namedElements['lblLorumIpsum'];
    final bHL_VS = buckshot.namedElements['bHL_VS'];
    final bHC_VS = buckshot.namedElements['bHC_VS'];
    final bHR_VS = buckshot.namedElements['bHR_VS'];
    final lblHL_VS = buckshot.namedElements['lblHL_VS'];
    final lblHC_VS = buckshot.namedElements['lblHC_VS'];
    final lblHR_VS = buckshot.namedElements['lblHR_VS'];
    final bHS_VT = buckshot.namedElements['bHS_VT'];
    final bHS_VC = buckshot.namedElements['bHS_VC'];
    final bHS_VB = buckshot.namedElements['bHS_VB'];
    final lblHS_VT = buckshot.namedElements['lblHS_VT'];
    final lblHS_VC = buckshot.namedElements['lblHS_VC'];
    final lblHS_VB = buckshot.namedElements['lblHS_VB'];
    final bLT = buckshot.namedElements['bLT'];
    final bCT = buckshot.namedElements['bCT'];
    final bRT = buckshot.namedElements['bRT'];
    final bRC = buckshot.namedElements['bRC'];
    final bRB = buckshot.namedElements['bRB'];
    final bCB = buckshot.namedElements['bCB'];
    final bLB = buckshot.namedElements['bLB'];
    final bLC = buckshot.namedElements['bLC'];
    final bCC = buckshot.namedElements['bCC'];
    
    //offset test framework UI
    final topOffset = 98.5;
    final leftOffset = 18;
    
//    pause();
    
    window.requestLayoutFrame(expectAsync0((){
      
      /* Big paragraph, check wrapping and alignment. */
      //Container
      Expect.equals(280, bLorumIpsum.mostRecentMeasurement.bounding.width, 'bLorumIpsum Width');
      Expect.equals(280, bLorumIpsum.mostRecentMeasurement.bounding.height, 'bLorumIpsum Height');
      Expect.equals(1, bLorumIpsum.mostRecentMeasurement.bounding.top - topOffset, 'bLorumIpsum Top');
      Expect.equals(19, bLorumIpsum.mostRecentMeasurement.bounding.left, 'bLorumIpsum Left');
      
      //TextBlock
      Expect.equals(260, lblLorumIpsum.mostRecentMeasurement.bounding.width, 'lblLorumIpsum Width');
      Expect.equals(238, lblLorumIpsum.mostRecentMeasurement.bounding.height, 'lblLorumIpsum Height');
      Expect.equals(22, lblLorumIpsum.mostRecentMeasurement.bounding.top - topOffset, 'lblLorumIpsum Top');
      Expect.equals(29, lblLorumIpsum.mostRecentMeasurement.bounding.left, 'lblLorumIpsum Left');
      
      /* Vertical Stretch, Horizontal Alignment */
      //HL_VS (Horizontal Left, Vertical Stretch)
      Expect.equals(42, bHL_VS.mostRecentMeasurement.bounding.width, 'bHL_VS Width');
      Expect.equals(300, bHL_VS.mostRecentMeasurement.bounding.height, 'bHL_VS Height');
      Expect.equals(293, bHL_VS.mostRecentMeasurement.bounding.top - topOffset, 'bHL_VS Top');
      Expect.equals(9, bHL_VS.mostRecentMeasurement.bounding.left, 'bHL_VS Left');
      
      Expect.equals(42, lblHL_VS.mostRecentMeasurement.bounding.width, 'lblHL_VS Width');
      Expect.equals(17, lblHL_VS.mostRecentMeasurement.bounding.height, 'lblHL_VS Height');
      Expect.equals(434.5, lblHL_VS.mostRecentMeasurement.bounding.top - topOffset, 'lblHL_VS Top');
      Expect.equals(9, lblHL_VS.mostRecentMeasurement.bounding.left, 'lblHL_VS Left');
      
      //HC_VS (Horizontal Center, Vertical Stretch)
      Expect.equals(45, bHC_VS.mostRecentMeasurement.bounding.width, 'bHC_VS Width');
      Expect.equals(300, bHC_VS.mostRecentMeasurement.bounding.height, 'bHC_VS Height');
      Expect.equals(595, bHC_VS.mostRecentMeasurement.bounding.top - topOffset, 'bHC_VS Top');
      Expect.equals(136, bHC_VS.mostRecentMeasurement.bounding.left, 'bHC_VS Left');
      
      Expect.equals(45, lblHC_VS.mostRecentMeasurement.bounding.width, 'lblHC_VS Width');
      Expect.equals(17, lblHC_VS.mostRecentMeasurement.bounding.height, 'lblHC_VS Height');
      Expect.equals(736.5, lblHC_VS.mostRecentMeasurement.bounding.top - topOffset, 'lblHC_VS Top');
      Expect.equals(136, lblHC_VS.mostRecentMeasurement.bounding.left, 'lblHC_VS Left');
      
      //HR_VS (Horizontal Right, Vertical Stretch)
      Expect.equals(44, bHR_VS.mostRecentMeasurement.bounding.width, 'bHR_VS Width');
      Expect.equals(300, bHR_VS.mostRecentMeasurement.bounding.height, 'bHR_VS Height');
      Expect.equals(897, bHR_VS.mostRecentMeasurement.bounding.top - topOffset, 'bHR_VS Top');
      Expect.equals(265, bHR_VS.mostRecentMeasurement.bounding.left, 'bHR_VS Left');
      
      Expect.equals(44, lblHR_VS.mostRecentMeasurement.bounding.width, 'lblHR_VS Width');
      Expect.equals(17, lblHR_VS.mostRecentMeasurement.bounding.height, 'lblHR_VS Height');
      Expect.equals(1038.5, lblHR_VS.mostRecentMeasurement.bounding.top - topOffset, 'lblHR_VS Top');
      Expect.equals(265, lblHR_VS.mostRecentMeasurement.bounding.left, 'lblHR_VS Left');
      
      /* Horizontal Stretch, Vertical Alignment */
      //HL_VS (Horizontal Left, Vertical Stretch)
      Expect.equals(300, bHS_VT.mostRecentMeasurement.bounding.width, 'bHS_VT Width');
      Expect.equals(17, bHS_VT.mostRecentMeasurement.bounding.height, 'bHS_VT Height');
      Expect.equals(1199, bHS_VT.mostRecentMeasurement.bounding.top - topOffset, 'bHS_VT Top');
      Expect.equals(9, bHS_VT.mostRecentMeasurement.bounding.left, 'bHS_VT Left');
      
      Expect.equals(44, lblHS_VT.mostRecentMeasurement.bounding.width, 'lblHS_VT Width');
      Expect.equals(17, lblHS_VT.mostRecentMeasurement.bounding.height, 'lblHS_VT Height');
      Expect.equals(1199, lblHS_VT.mostRecentMeasurement.bounding.top - topOffset, 'lblHS_VT Top');
      Expect.equals(137, lblHS_VT.mostRecentMeasurement.bounding.left, 'lblHS_VT Left');
      
      //HC_VS (Horizontal Center, Vertical Stretch)
      Expect.equals(300, bHS_VC.mostRecentMeasurement.bounding.width, 'bHS_VC Width');
      Expect.equals(17, bHS_VC.mostRecentMeasurement.bounding.height, 'bHS_VC Height');
      Expect.equals(1642.5, bHS_VC.mostRecentMeasurement.bounding.top - topOffset, 'bHS_VC Top');
      Expect.equals(9, bHS_VC.mostRecentMeasurement.bounding.left, 'bHS_VC Left');
      
      Expect.equals(45, lblHS_VC.mostRecentMeasurement.bounding.width, 'lblHS_VC Width');
      Expect.equals(17, lblHS_VC.mostRecentMeasurement.bounding.height, 'lblHS_VC Height');
      Expect.equals(1642.5, lblHS_VC.mostRecentMeasurement.bounding.top - topOffset, 'lblHS_VC Top');
      Expect.equals(136, lblHS_VC.mostRecentMeasurement.bounding.left, 'lblHS_VC Left');
      
      //HR_VS (Horizontal Right, Vertical Stretch)
      Expect.equals(300, bHS_VB.mostRecentMeasurement.bounding.width, 'bHS_VB Width');
      Expect.equals(17, bHS_VB.mostRecentMeasurement.bounding.height, 'bHS_VB Height');
      Expect.equals(2086, bHS_VB.mostRecentMeasurement.bounding.top - topOffset, 'bHS_VB Top');
      Expect.equals(9, bHS_VB.mostRecentMeasurement.bounding.left, 'bHS_VB Left');
      
      Expect.equals(43, lblHS_VB.mostRecentMeasurement.bounding.width, 'lblHS_VB Width');
      Expect.equals(17, lblHS_VB.mostRecentMeasurement.bounding.height, 'lblHS_VB Height');
      Expect.equals(2086, lblHS_VB.mostRecentMeasurement.bounding.top - topOffset, 'lblHS_VB Top');
      Expect.equals(137, lblHS_VB.mostRecentMeasurement.bounding.left, 'lblHS_VB Left');
      
      
      /* All Alignments, no stretch */
      //left, top
      Expect.equals(16, bLT.mostRecentMeasurement.bounding.width, 'bLT Width');
      Expect.equals(17, bLT.mostRecentMeasurement.bounding.height, 'bLT Height');
      Expect.equals(2105, bLT.mostRecentMeasurement.bounding.top - topOffset, 'bLT Top');
      Expect.equals(9, bLT.mostRecentMeasurement.bounding.left, 'bLT Left');
      
      //center, top
      Expect.equals(19, bCT.mostRecentMeasurement.bounding.width, 'bCT Width');
      Expect.equals(17, bCT.mostRecentMeasurement.bounding.height, 'bCT Height');
      Expect.equals(2407, bCT.mostRecentMeasurement.bounding.top - topOffset, 'bCT Top');
      Expect.equals(149, bCT.mostRecentMeasurement.bounding.left, 'bCT Left');
      
      //right, top
      Expect.equals(18, bRT.mostRecentMeasurement.bounding.width, 'bRT Width');
      Expect.equals(17, bRT.mostRecentMeasurement.bounding.height, 'bRT Height');
      Expect.equals(2709, bRT.mostRecentMeasurement.bounding.top - topOffset, 'bRT Top');
      Expect.equals(291, bRT.mostRecentMeasurement.bounding.left, 'bRT Left');
      
      //right, center
      Expect.equals(19, bRC.mostRecentMeasurement.bounding.width, 'bRC Width');
      Expect.equals(17, bRC.mostRecentMeasurement.bounding.height, 'bRC Height');
      Expect.equals(3152.5, bRC.mostRecentMeasurement.bounding.top - topOffset, 'bRC Top');
      Expect.equals(290, bRC.mostRecentMeasurement.bounding.left, 'bRC Left');
      
      //right, bottom
      Expect.equals(17, bRB.mostRecentMeasurement.bounding.width, 'bRB Width');
      Expect.equals(17, bRB.mostRecentMeasurement.bounding.height, 'bRB Height');
      Expect.equals(3596, bRB.mostRecentMeasurement.bounding.top - topOffset, 'bRB Top');
      Expect.equals(292, bRB.mostRecentMeasurement.bounding.left, 'bRB Left');
      
      //center, bottom
      Expect.equals(18, bCB.mostRecentMeasurement.bounding.width, 'bCB Width');
      Expect.equals(17, bCB.mostRecentMeasurement.bounding.height, 'bCB Height');
      Expect.equals(3898, bCB.mostRecentMeasurement.bounding.top - topOffset, 'bCB Top');
      Expect.equals(150, bCB.mostRecentMeasurement.bounding.left, 'bCB Left');
      
      //left, bottom
      Expect.equals(15, bLB.mostRecentMeasurement.bounding.width, 'bLB Width');
      Expect.equals(17, bLB.mostRecentMeasurement.bounding.height, 'bLB Height');
      Expect.equals(4200, bLB.mostRecentMeasurement.bounding.top - topOffset, 'bLB Top');
      Expect.equals(9, bLB.mostRecentMeasurement.bounding.left, 'bLB Left');
      
      //left, center
      Expect.equals(17, bLC.mostRecentMeasurement.bounding.width, 'bLC Width');
      Expect.equals(17, bLC.mostRecentMeasurement.bounding.height, 'bLC Height');
      Expect.equals(4360.5, bLC.mostRecentMeasurement.bounding.top - topOffset, 'bLC Top');
      Expect.equals(9, bLC.mostRecentMeasurement.bounding.left, 'bLC Left');
      
      //center, center
      Expect.equals(20, bCC.mostRecentMeasurement.bounding.width, 'bCC Width');
      Expect.equals(17, bCC.mostRecentMeasurement.bounding.height, 'bCC Height');
      Expect.equals(4662.5, bCC.mostRecentMeasurement.bounding.top - topOffset, 'bCC Top');
      Expect.equals(149, bCC.mostRecentMeasurement.bounding.left, 'bCC Left');
      
    }));
  });
}

class BorderDebug implements IView {
  final FrameworkElement _rootElement;

  BorderDebug()
  :
    _rootElement = buckshot.defaultPresentationProvider.deserialize(view);

  FrameworkElement get rootVisual() => _rootElement;

  static final String view =
'''
<stackpanel>
  <border margin='1' width='300' height='300' background='Orange'>
    <border name='bLorumIpsum' margin='10' padding='10' background='Black' horizontalalignment='stretch' verticalalignment='stretch'>
      <textblock name='lblLorumIpsum' horizontalalignment='stretch' verticalalignment='center' foreground='White'>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus nunc nunc, lacinia sit amet ultricies non, bibendum quis eros. Integer hendrerit volutpat velit sit amet iaculis. Curabitur eu arcu velit, non blandit nulla. Nullam diam dui, molestie non ultricies a, tristique nec nunc. Nullam hendrerit fringilla nulla non porttitor. Cras orci sapien, porttitor placerat dapibus vitae, pharetra a lectus. Nulla tincidunt lacinia elit ac tempus. Sed sed sem justo,</textblock>
    </border>
  </border>

  <border margin='1' width='300' height='300' background='Orange'>
    <border name='bHL_VS' background='Black' horizontalalignment='left' verticalalignment='stretch'>
      <textblock name='lblHL_VS' horizontalalignment='center' verticalalignment='center' foreground='White'>HL-VS</textblock>
    </border>
  </border>
  <border margin='1' width='300' height='300' background='Orange'>
    <border name='bHC_VS' background='Black' horizontalalignment='center' verticalalignment='stretch'>
      <textblock name='lblHC_VS' horizontalalignment='center' verticalalignment='center' foreground='White'>HC-VS</textblock>
    </border>
  </border>
  <border margin='1' width='300' height='300' background='Orange'>
    <border name='bHR_VS' background='Black' horizontalalignment='right' verticalalignment='stretch'>
      <textblock name='lblHR_VS' horizontalalignment='center' verticalalignment='center' foreground='White'>HR-VS</textblock>
    </border>
  </border>
  
  <border margin='1' width='300' height='300' background='Orange'>
    <border name='bHS_VT' background='Black' horizontalalignment='stretch' verticalalignment='top'>
      <textblock name='lblHS_VT' horizontalalignment='center' verticalalignment='center' foreground='White'>HS-VT</textblock>
    </border>
  </border>
  <border margin='1' width='300' height='300' background='Orange'>
    <border name='bHS_VC' background='Black' horizontalalignment='stretch' verticalalignment='center'>
      <textblock name='lblHS_VC' horizontalalignment='center' verticalalignment='center' foreground='White'>HS-VC</textblock>
    </border>
  </border>
  <border margin='1' width='300' height='300' background='Orange'>
    <border name='bHS_VB' background='Black' horizontalalignment='stretch' verticalalignment='bottom'>
      <textblock name='lblHS_VB' horizontalalignment='center' verticalalignment='center' foreground='White'>HS-VB</textblock>
    </border>
  </border>

  <border margin='1' width='300' height='300' background='Orange'>
    <border name='bLT' background='Black' horizontalalignment='left' verticalalignment='top'>
      <textblock horizontalalignment='center' verticalalignment='center' foreground='White'>LT</textblock>
    </border>
  </border>
  <border margin='1' width='300' height='300' background='Orange'>
    <border name='bCT' background='Black' horizontalalignment='center' verticalalignment='top'>
      <textblock horizontalalignment='center' verticalalignment='center' foreground='White'>CT</textblock>
    </border>
  </border>
  <border margin='1' width='300' height='300' background='Orange'>
    <border name='bRT' background='Black' horizontalalignment='right' verticalalignment='top'>
      <textblock horizontalalignment='center' verticalalignment='center' foreground='White'>RT</textblock>
    </border>
  </border>
  <border margin='1' width='300' height='300' background='Orange'>
    <border name='bRC' background='Black' horizontalalignment='right' verticalalignment='center'>
      <textblock horizontalalignment='center' verticalalignment='center' foreground='White'>RC</textblock>
    </border>
  </border>
  <border margin='1' width='300' height='300' background='Orange'>
    <border name='bRB' background='Black' horizontalalignment='right' verticalalignment='bottom'>
      <textblock horizontalalignment='center' verticalalignment='center' foreground='White'>RB</textblock>
    </border>
  </border>
  <border margin='1' width='300' height='300' background='Orange'>
    <border name='bCB' background='Black' horizontalalignment='center' verticalalignment='bottom'>
      <textblock horizontalalignment='center' verticalalignment='center' foreground='White'>CB</textblock>
    </border>
  </border>
  <border margin='1' width='300' height='300' background='Orange'>
    <border name='bLB' background='Black' horizontalalignment='left' verticalalignment='bottom'>
      <textblock horizontalalignment='center' verticalalignment='center' foreground='White'>LB</textblock>
    </border>
  </border>
  <border margin='1' width='300' height='300' background='Orange'>
    <border name='bLC' background='Black' horizontalalignment='left' verticalalignment='center'>
      <textblock horizontalalignment='center' verticalalignment='center' foreground='White'>LC</textblock>
    </border>
  </border>
  <border margin='1' width='300' height='300' background='Orange'>
    <border name='bCC' background='Black' horizontalalignment='center' verticalalignment='center'>
      <textblock horizontalalignment='center' verticalalignment='center' foreground='White'>CC</textblock>
    </border>
  </border>
</stackpanel>
''';

}


class StackPanelDebug implements IView {

  final FrameworkElement _rootElement;

  StackPanelDebug()
  :
    _rootElement = buckshot.defaultPresentationProvider.deserialize(view);

  FrameworkElement get rootVisual() => _rootElement;

  static final String view =
'''
<stackpanel name='rootPanel' background='Orange' margin='10'>
  <stackpanel name='chromePanel' orientation='horizontal' horizontalalignment='center' background='Yellow'>
    <border name='bBlack' margin='10' background='Black' width='10' height='10'></border>
    <border name='bRed' margin='10' background='Red' width='10' height='10'></border>
    <border name='bGreen' margin='10' background='Green' width='10' height='10'></border>
    <border name='bBlue' margin='10' background='Blue' width='10' height='10'></border>
  </stackpanel>

  <textblock name='lblHCenter' horizontalalignment='center'>center center</textblock>
  <textblock name='lblRight' horizontalalignment='right'>right right right</textblock>
  <textblock name='lblLong'>long long long long long long long long</textblock>
  <border name='bCircle' horizontalalignment='center' borderthickness='5' bordercolor='Purple' width='150' height='150' background='Yellow' cornerradius='150'></border>
  <stackpanel name='spVerticalAlignment' height='300' horizontalalignment='stretch' background='Gray' orientation='horizontal'>
    <textblock name='lblTop' verticalalignment='top'>top top top</textblock>
    <textblock name='lblVCenter' verticalalignment='center'>center center center</textblock>
    <textblock name='lblBottom' verticalalignment='bottom'>bottom bottom bottom</textblock>
  </stackpanel>
</stackpanel>
''';

}

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
    <styletemplate key='_borderAuto'>
      <setters>
        <stylesetter property="borderColor" value="Black"></stylesetter>
        <stylesetter property="borderThickness" value="1"></stylesetter>
        <stylesetter property="horizontalAlignment" value="stretch"></stylesetter>
        <stylesetter property="padding" value="5"></stylesetter>
        <stylesetter property="height" value="250"></stylesetter>
      </setters>
    </styletemplate>
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
    <rowdefinition height='auto'></rowdefinition>
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
    <grid horizontalalignment='stretch' verticalalignment='stretch'>
      <rowdefinitions>
        <rowdefinition height='*'></rowdefinition>
        <rowdefinition height='*.5'></rowdefinition>
        <rowdefinition height='*'></rowdefinition>
      </rowdefinitions>
      <columndefinitions>
        <columndefinition width='*'></columndefinition>
        <columndefinition width='*.5'></columndefinition>
        <columndefinition width='*'></columndefinition>
      </columndefinitions>
      <border background='#333333' grid.row='0' style='{resource _border}'>
        <textblock text='0,0' style='{resource _text}'></textblock>
      </border>
      <border background='#555555' grid.row='0' grid.column='1' style='{resource _border}'>
        <textblock text='1,0' style='{resource _text}'></textblock>
      </border>
      <border background='#777777' grid.row='0' grid.column='2' style='{resource _border}'>
        <textblock text='2,0' style='{resource _text}'></textblock>
      </border>
      <border background='#555555' grid.row='1' style='{resource _border}'>
        <textblock text='0,1' style='{resource _text}'></textblock>
      </border>
      <border background='#999999' grid.row='1' grid.column='1' style='{resource _border}'>
        <textblock text='1,1' style='{resource _text}'></textblock>
      </border>
      <border background='#BBBBBB' grid.row='1' grid.column='2' style='{resource _border}'>
        <textblock text='2,1' style='{resource _text}'></textblock>
      </border>
      <border background='#777777' grid.row='2' style='{resource _border}'>
        <textblock text='0,2' style='{resource _text}'></textblock>
      </border>
      <border background='#BBBBBB' grid.row='2' grid.column='1' style='{resource _border}'>
        <textblock text='1,2' style='{resource _text}'></textblock>
      </border>
      <border background='#EEEEEE' grid.row='2' grid.column='2' style='{resource _border}'>
        <textblock text='2,2' style='{resource _text}'></textblock>
      </border>
    </grid>
  </border>
  <border background='#555555' grid.row='1' grid.column='1' style='{resource _border}'>
    <textblock text='1,0' style='{resource _text}'></textblock>
  </border>
  <border background='#777777' grid.row='1' grid.column='2' style='{resource _border}'>
    <grid horizontalalignment='stretch' verticalalignment='stretch'>
      <rowdefinitions>
        <rowdefinition height='*'></rowdefinition>
        <rowdefinition height='*.5'></rowdefinition>
        <rowdefinition height='*'></rowdefinition>
      </rowdefinitions>
      <columndefinitions>
        <columndefinition width='*'></columndefinition>
        <columndefinition width='*.5'></columndefinition>
        <columndefinition width='*'></columndefinition>
      </columndefinitions>
      <border background='#333333' grid.row='0' style='{resource _border}'>
        <textblock text='0,0' style='{resource _text}'></textblock>
      </border>
      <border background='#555555' grid.row='0' grid.column='1' style='{resource _border}'>
        <textblock text='1,0' style='{resource _text}'></textblock>
      </border>
      <border background='#777777' grid.row='0' grid.column='2' style='{resource _border}'>
        <textblock text='2,0' style='{resource _text}'></textblock>
      </border>
      <border background='#555555' grid.row='1' style='{resource _border}'>
        <textblock text='0,1' style='{resource _text}'></textblock>
      </border>
      <border background='#999999' grid.row='1' grid.column='1' style='{resource _border}'>
        <textblock text='1,1' style='{resource _text}'></textblock>
      </border>
      <border background='#BBBBBB' grid.row='1' grid.column='2' style='{resource _border}'>
        <textblock text='2,1' style='{resource _text}'></textblock>
      </border>
      <border background='#777777' grid.row='2' style='{resource _border}'>
        <textblock text='0,2' style='{resource _text}'></textblock>
      </border>
      <border background='#BBBBBB' grid.row='2' grid.column='1' style='{resource _border}'>
        <textblock text='1,2' style='{resource _text}'></textblock>
      </border>
      <border background='#EEEEEE' grid.row='2' grid.column='2' style='{resource _border}'>
        <textblock text='2,2' style='{resource _text}'></textblock>
      </border>
    </grid>
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
    <grid horizontalalignment='stretch' verticalalignment='stretch'>
      <rowdefinitions>
        <rowdefinition height='*'></rowdefinition>
        <rowdefinition height='*.5'></rowdefinition>
        <rowdefinition height='*'></rowdefinition>
      </rowdefinitions>
      <columndefinitions>
        <columndefinition width='*'></columndefinition>
        <columndefinition width='*.5'></columndefinition>
        <columndefinition width='*'></columndefinition>
      </columndefinitions>
      <border background='#333333' grid.row='0' style='{resource _border}'>
        <textblock text='0,0' style='{resource _text}'></textblock>
      </border>
      <border background='#555555' grid.row='0' grid.column='1' style='{resource _border}'>
        <textblock text='1,0' style='{resource _text}'></textblock>
      </border>
      <border background='#777777' grid.row='0' grid.column='2' style='{resource _border}'>
        <textblock text='2,0' style='{resource _text}'></textblock>
      </border>
      <border background='#555555' grid.row='1' style='{resource _border}'>
        <textblock text='0,1' style='{resource _text}'></textblock>
      </border>
      <border background='#999999' grid.row='1' grid.column='1' style='{resource _border}'>
        <textblock text='1,1' style='{resource _text}'></textblock>
      </border>
      <border background='#BBBBBB' grid.row='1' grid.column='2' style='{resource _border}'>
        <textblock text='2,1' style='{resource _text}'></textblock>
      </border>
      <border background='#777777' grid.row='2' style='{resource _border}'>
        <textblock text='0,2' style='{resource _text}'></textblock>
      </border>
      <border background='#BBBBBB' grid.row='2' grid.column='1' style='{resource _border}'>
        <textblock text='1,2' style='{resource _text}'></textblock>
      </border>
      <border background='#EEEEEE' grid.row='2' grid.column='2' style='{resource _border}'>
        <textblock text='2,2' style='{resource _text}'></textblock>
      </border>
    </grid>
  </border>
  <border background='#BBBBBB' grid.row='3' grid.column='1' style='{resource _border}'>
    <textblock text='1,2' style='{resource _text}'></textblock>
  </border>
  <border background='#EEEEEE' grid.row='3' grid.column='2' style='{resource _border}'>
    <grid horizontalalignment='stretch' verticalalignment='stretch'>
      <rowdefinitions>
        <rowdefinition height='*'></rowdefinition>
        <rowdefinition height='*.5'></rowdefinition>
        <rowdefinition height='*'></rowdefinition>
      </rowdefinitions>
      <columndefinitions>
        <columndefinition width='*'></columndefinition>
        <columndefinition width='*.5'></columndefinition>
        <columndefinition width='*'></columndefinition>
      </columndefinitions>
      <border background='#333333' grid.row='0' style='{resource _border}'>
        <textblock text='0,0' style='{resource _text}'></textblock>
      </border>
      <border background='#555555' grid.row='0' grid.column='1' style='{resource _border}'>
        <textblock text='1,0' style='{resource _text}'></textblock>
      </border>
      <border background='#777777' grid.row='0' grid.column='2' style='{resource _border}'>
        <textblock text='2,0' style='{resource _text}'></textblock>
      </border>
      <border background='#555555' grid.row='1' style='{resource _border}'>
        <textblock text='0,1' style='{resource _text}'></textblock>
      </border>
      <border background='#999999' grid.row='1' grid.column='1' style='{resource _border}'>
        <textblock text='1,1' style='{resource _text}'></textblock>
      </border>
      <border background='#BBBBBB' grid.row='1' grid.column='2' style='{resource _border}'>
        <textblock text='2,1' style='{resource _text}'></textblock>
      </border>
      <border background='#777777' grid.row='2' style='{resource _border}'>
        <textblock text='0,2' style='{resource _text}'></textblock>
      </border>
      <border background='#BBBBBB' grid.row='2' grid.column='1' style='{resource _border}'>
        <textblock text='1,2' style='{resource _text}'></textblock>
      </border>
      <border background='#EEEEEE' grid.row='2' grid.column='2' style='{resource _border}'>
        <textblock text='2,2' style='{resource _text}'></textblock>
      </border>
    </grid>
  </border>
</grid>
''';

}

/**
* View(s) will bind to properties in this view model */
class ViewModel extends ViewModelBase implements IMainViewModel {

FrameworkProperty titleProperty;

ViewModel(){
  titleProperty = new FrameworkProperty(this, "title", (_){});
}

String get title() => getValue(titleProperty);
set title(String value) => setValue(titleProperty, value);
}

//view model contract
interface IMainViewModel{

  FrameworkProperty titleProperty;

  String get title();
  set title(String value);
}