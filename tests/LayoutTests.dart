
void layoutTests()
{
  // adds a manual pause that only proceeds after clicking the browser
  void pause() {
    document.body.on.click.add(expectAsync1((e){
      Expect.isTrue(true);
    }));
  }
  
  // tests measurements on a given element
  void measure(FrameworkElement element, num top, num left, num width, num height){
    Expect.equals(top, element.mostRecentMeasurement.bounding.top, '${element.name} top');
    Expect.equals(left, element.mostRecentMeasurement.bounding.left, '${element.name} left');
    Expect.equals(width, element.mostRecentMeasurement.bounding.width, '${element.name} Width');
    Expect.equals(height, element.mostRecentMeasurement.bounding.height, '${element.name} Height');
  }
  
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
        
    window.requestLayoutFrame(
      expectAsync0((){
        /* root stackpanel */
        measure(spRoot, 98.5, 18, 372, 541);
        
        /* "chrome" stackpanel */
        measure(spChrome, 98.5, 144, 120, 30);       
        
        /* dots inside the "chrome" stackpanel */
        //black
        measure(bBlack, 108.5, 154, 10, 10);
        
        //red
        measure(bRed, 108.5, 184, 10, 10);
        
        //green
        measure(bGreen, 108.5, 214, 10, 10);
        
        //blue
        measure(bBlue, 108.5, 244, 10, 10);
        
        
        /* Horizontal aligned elements in a vertical stackpanel */
        //centered
        measure(lblHCenter, 128.5, 159, 90, 17);
        
        //right aligned
        measure(lblRight, 145.5, 283, 107, 17);
        
        //left aligned
        measure(lblLeft, 162.5, 18, 276, 17);
        
        /* Circle (centered horizontally) */
        measure(bCircle, 179.5, 124, 160, 160);
        
        /* Horizontal StackPanel Container */
        //container StackPanel
        measure(spHorizontal, 339.5, 18, 372, 300);
        
        //now check the vertical alignment of elements within the horizontal StackPanel
        //container StackPanel
        measure(lblTop, 339.5, 18, 77, 17);
        
        //container StackPanel
        measure(lblVCenter, 481, 95, 137, 17);
        
        //container StackPanel
        measure(lblBottom, 622.5, 232, 158, 17);
        
      })   
    );
  });
    
  
  // Take measurements of reference layout to make sure they match
  // expected results.
  test('Grid Layout', (){
    buckshot.rootView = new GridDebug();
    
    buckshot.namedElements.getValues().forEach((v)=> v.updateMeasurement());
    
//    pause();
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
    
//    pause();
    
    window.requestLayoutFrame(expectAsync0((){
      
      /* Big paragraph, check wrapping and alignment. */
      //Container
      measure(bLorumIpsum, 99.5, 19, 280, 280);
      
      //TextBlock
      measure(lblLorumIpsum, 120.5, 29, 260, 238);
      
      
      /* Vertical Stretch, Horizontal Alignment */
      //HL_VS (Horizontal Left, Vertical Stretch)
      measure(bHL_VS, 391.5, 9, 42, 300);
      measure(lblHL_VS, 533, 9, 42, 17);
            
      //HC_VS (Horizontal Center, Vertical Stretch)
      measure(bHC_VS, 693.5, 136, 45, 300);
      measure(lblHC_VS, 835, 136, 45, 17);
      
      //HR_VS (Horizontal Right, Vertical Stretch)
      measure(bHR_VS, 995.5, 265, 44, 300);
      measure(lblHR_VS, 1137, 265, 44, 17);

      
      /* Horizontal Stretch, Vertical Alignment */
      //HS_VT (Horizontal Stretch, Vertical Top)
      measure(bHS_VT, 1297.5, 9, 300, 17);
      measure(lblHS_VT, 1297.5, 137, 44, 17);
      
      //HS_VC (Horizontal Stretch, Vertical Center)
      measure(bHS_VC, 1741, 9, 300, 17);
      measure(lblHS_VC, 1741, 136, 45, 17);
      
      //HS_VB (Horizontal Stretch, Vertical Bottom)
      measure(bHS_VB, 2184.5, 9, 300, 17);
      measure(lblHS_VB, 2184.5, 137, 43, 17);
      
      
      /* All Alignments, no stretch */
      //left, top
      measure(bLT, 2203.5, 9, 16, 17);

      //center, top
      measure(bCT, 2505.5, 149, 19, 17);
      
      //right, top
      measure(bRT, 2807.5, 291, 18, 17);
      
      //right, center
      measure(bRC, 3251, 290, 19, 17);
      
      //right, bottom
      measure(bRB, 3694.5, 292, 17, 17);
      
      //center, bottom
      measure(bCB, 3996.5, 150, 18, 17);
      
      //left, bottom
      measure(bLB, 4298.5, 9, 15, 17);
      
      //left, center
      measure(bLC, 4459, 9, 17, 17);
      
      //center, center
      measure(bCC, 4761, 149, 20, 17);
      
    }));
  });
}

class BorderDebug implements IView {
  final FrameworkElement _rootElement;

  BorderDebug()
  :
    _rootElement = buckshot.deserialize(buckshot.getTemplate('#borderTest'));

  FrameworkElement get rootVisual() => _rootElement;
}


class StackPanelDebug implements IView {

  final FrameworkElement _rootElement;

  StackPanelDebug()
  :
    _rootElement = buckshot.deserialize(buckshot.getTemplate('#stackPanelTest'));

  FrameworkElement get rootVisual() => _rootElement;
}

class GridDebug implements IView
{
  final FrameworkElement _rootElement;

  GridDebug()
  :
    _rootElement = buckshot.deserialize(buckshot.getTemplate('#gridTest'));

  FrameworkElement get rootVisual() => _rootElement;
}