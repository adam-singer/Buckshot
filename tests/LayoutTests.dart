
/// Baseline measurements are taken using Dartium.
/// This set of tests takes sample measurements of layout elements and
/// compares them against expected values.
void layoutTests()
{

  // Milliseconds to wait for the layout to complete before performing
  // tests.
  final int layoutAllowance = 550;

  // Setting to true will cause the unit test run to pause after each layout
  // is drawn to allow for visual inspection.  Clicking in the browser window
  // will cause the test to proceed.
  final bool usePause = true;

  // Take measurements of reference layout to make sure they match
  // expected results.
  test('Border Layout', (){
    buckshot.rootView = new BorderDebug();

    window.setTimeout(expectAsync0((){

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

    if (usePause) pause();

    window.requestLayoutFrame(expectAsync0((){

      /* Big paragraph, check wrapping and alignment. */
      //Container
      measureElement(bLorumIpsum, 11, 11, 280, 280);

      //TextBlock
      measureElement(lblLorumIpsum, 32, 21, 260, 238);

      /* Vertical Stretch, Horizontal Alignment */
      //HL_VS (Horizontal Left, Vertical Stretch)
      measureElement(bHL_VS, 303, 1, 42, 300);
      measureElement(lblHL_VS, 444.5, 1, 42, 17);

      //HC_VS (Horizontal Center, Vertical Stretch)
      measureElement(bHC_VS, 605, 128, 45, 300);
      measureElement(lblHC_VS, 746.5, 128, 45, 17);

      //HR_VS (Horizontal Right, Vertical Stretch)
      measureElement(bHR_VS, 907, 257, 44, 300);
      measureElement(lblHR_VS, 1048.5, 257, 44, 17);


      /* Horizontal Stretch, Vertical Alignment */
      //HS_VT (Horizontal Stretch, Vertical Top)
      measureElement(bHS_VT, 1209, 1, 300, 17);
      measureElement(lblHS_VT, 1209, 129, 44, 17);

      //HS_VC (Horizontal Stretch, Vertical Center)
      measureElement(bHS_VC, 1652.5, 1, 300, 17);
      measureElement(lblHS_VC, 1652.5, 128, 45, 17);

      //HS_VB (Horizontal Stretch, Vertical Bottom)
      measureElement(bHS_VB, 2096, 1, 300, 17);
      measureElement(lblHS_VB, 2096, 129, 43, 17);


      /* All Alignments, no stretch */
      //left, top
      measureElement(bLT, 2115, 1, 16, 17);

      //center, top
      measureElement(bCT, 2417, 141, 19, 17);

      //right, top
      measureElement(bRT, 2719, 283, 18, 17);

      //right, center
      measureElement(bRC, 3162.5, 282, 19, 17);

      //right, bottom
      measureElement(bRB, 3606, 284, 17, 17);

      //center, bottom
      measureElement(bCB, 3908, 142, 18, 17);

      //left, bottom
      measureElement(bLB, 4210, 1, 15, 17);

      //left, center
      measureElement(bLC, 4370.5, 1, 17, 17);

      //center, center
      measureElement(bCC, 4672.5, 141, 20, 17);

    }));

    }), layoutAllowance);

  });


  // Take measurements of reference layout to make sure they exactly match
  // expected results.
  test('StackPanel Layout', (){
    buckshot.rootView = new StackPanelDebug();

    window.setTimeout(expectAsync0((){

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

    if (usePause) pause();

    window.requestLayoutFrame(
      expectAsync0((){
        /* root stackpanel */
        measureElement(spRoot, 10, 10, 372, 541);

        /* "chrome" stackpanel */
        measureElement(spChrome, 10, 136, 120, 30);

        /* dots inside the "chrome" stackpanel */
        //black
        measureElement(bBlack, 20, 146, 10, 10);

        //red
        measureElement(bRed, 20, 176, 10, 10);

        //green
        measureElement(bGreen, 20, 206, 10, 10);

        //blue
        measureElement(bBlue, 20, 236, 10, 10);


        /* Horizontal aligned elements in a vertical stackpanel */
        //centered
        measureElement(lblHCenter, 40, 151, 90, 17);

        //right aligned
        measureElement(lblRight, 57, 275, 107, 17);

        //left aligned
        measureElement(lblLeft, 74, 10, 276, 17);

        /* Circle (centered horizontally) */
        measureElement(bCircle, 91, 116, 160, 160);

        /* Horizontal StackPanel Container */
        //container StackPanel
        measureElement(spHorizontal, 251, 10, 372, 300);

        //now check the vertical alignment of elements within the horizontal StackPanel
        //container StackPanel
        measureElement(lblTop, 251, 10, 77, 17);

        //container StackPanel
        measureElement(lblVCenter, 392.5, 87, 137, 17);

        //container StackPanel
        measureElement(lblBottom, 534, 224, 158, 17);

      })
    );

    }), layoutAllowance);

  });


  // Take measurements of reference layout to make sure they match
  // expected results.
  test('Grid Layout', (){
    buckshot.rootView = new GridDebug();

    // Adding a delay to allow the layout to complete
    // otherwise some measurements will still be 0. Especially in JS.
    window.setTimeout(expectAsync0((){

      buckshot.namedElements.getValues().forEach((v)=> v.updateMeasurement());

      //references
      final borderRoot = buckshot.namedElements['borderContainer'];
      final gridTest = buckshot.namedElements['gridTest'];
      final rectRow0 = buckshot.namedElements['rectRow0'];
      final rectRow1 = buckshot.namedElements['rectRow1'];
      final rectRow2 = buckshot.namedElements['rectRow2'];
      final rectRow3 = buckshot.namedElements['rectRow3'];
      final rectCol0 = buckshot.namedElements['rectCol0'];
      final rectCol1 = buckshot.namedElements['rectCol1'];
      final rectCol2 = buckshot.namedElements['rectCol2'];
      final rectCol3 = buckshot.namedElements['rectCol3'];
      final rectCol4 = buckshot.namedElements['rectCol4'];
      final lblTitle = buckshot.namedElements['lblTitle'];
      final borderCircle1 = buckshot.namedElements['borderCircle1'];
      final borderCircle2 = buckshot.namedElements['borderCircle2'];
      final borderCircle3 = buckshot.namedElements['borderCircle3'];
      final borderCircle4 = buckshot.namedElements['borderCircle4'];
      final lblLT = buckshot.namedElements['lblLT'];
      final lblCT = buckshot.namedElements['lblCT'];
      final lblRT = buckshot.namedElements['lblRT'];
      final lblRC = buckshot.namedElements['lblRC'];
      final lblRB = buckshot.namedElements['lblRB'];
      final lblCB = buckshot.namedElements['lblCB'];
      final lblLB = buckshot.namedElements['lblLB'];
      final lblLC = buckshot.namedElements['lblLC'];
      final lblCC = buckshot.namedElements['lblCC'];

      if (usePause) pause();

      window.requestLayoutFrame(

        expectAsync0((){
          /* Root Border */
          measureElement(borderRoot, 0, 0, 502, 502);

          /* Test Grid */
          measureElement(gridTest, 1, 1, 500, 500);

          /* Rows */
          measureElement(rectRow0, 1, 1, 500, 50);
          measureElement(rectRow1, 51, 1, 500, 100);
          measureElement(rectRow2, 151, 1, 500, 150);
          measureElement(rectRow3, 301, 1, 500, 200);

          /* Columns */
          measureElement(rectCol0, 1, 1, 50, 500);
          measureElement(rectCol1, 1, 51, 100, 500);
          measureElement(rectCol2, 1, 151, 200, 500);
          measureElement(rectCol3, 1, 351, 50, 500);
          measureElement(rectCol4, 1, 401, 100, 500);

          /* Title */
          measureElement(lblTitle, 10.5, 195, 111, 31);

          /* Circles */
          measureElement(borderCircle1, 1, 1, 50, 50);
          measureElement(borderCircle2, 1, 451, 50, 50);
          measureElement(borderCircle3, 451, 451, 50, 50);
          measureElement(borderCircle4, 451, 1, 50, 50);

          /* Alignment inside GridCell */
          measureElement(lblLT, 51, 51, 16, 17);
          measureElement(lblCT, 51, 216, 19, 17);
          measureElement(lblRT, 51, 383, 18, 17);
          measureElement(lblRC, 167.5, 382, 19, 17);
          measureElement(lblRB, 284, 384, 17, 17);
          measureElement(lblCB, 284, 217, 18, 17);
          measureElement(lblLB, 284, 51, 15, 17);
          measureElement(lblLC, 167.5, 51, 17, 17);
          measureElement(lblCC, 167.5, 216, 20, 17);


        })
      );


    }), layoutAllowance);


  });
}


class BorderDebug implements IView {
  final FrameworkElement _rootElement;

  BorderDebug()
  :
    _rootElement = Template.deserialize(Template.getTemplate('#borderTest'));

  FrameworkElement get rootVisual() => _rootElement;
}


class StackPanelDebug implements IView {

  final FrameworkElement _rootElement;

  StackPanelDebug()
  :
    _rootElement = Template.deserialize(Template.getTemplate('#stackPanelTest'));

  FrameworkElement get rootVisual() => _rootElement;
}

class GridDebug implements IView
{
  final FrameworkElement _rootElement;

  GridDebug()
  :
    _rootElement = Template.deserialize(Template.getTemplate('#gridTest'));

  FrameworkElement get rootVisual() => _rootElement;
}

/// Tests the given measurements against the bounding measurements of a given element.
void measureElement(FrameworkElement element, num top, num left, num width, num height){
//  dumpMeasurements(element);
//  Expect.approxEquals(top, element.mostRecentMeasurement.bounding.top, tolerance:1.5, reason:'${element.name} top');
  Expect.approxEquals(top, element.mostRecentMeasurement.bounding.top, .5, '${element.name} top');
  Expect.approxEquals(left, element.mostRecentMeasurement.bounding.left, .5, '${element.name} left');
  Expect.approxEquals(width, element.mostRecentMeasurement.bounding.width, .5, '${element.name} Width');
  Expect.approxEquals(height, element.mostRecentMeasurement.bounding.height, .5, '${element.name} Height');
}

/// Adds a manual pause that only proceeds after clicking the browser.
void pause() {

  document.body.on.click.add(expectAsync1((e){
    Expect.isTrue(true);
  }));
}

/// Performs a stdio dump of [FrameworkElement] measurement.
void dumpMeasurements(FrameworkElement element){
  if (element.mostRecentMeasurement == null){
    print('Measurement not available.');
    return;
  }

  print('${element.name}');
  print('   bounding.top: ${element.mostRecentMeasurement.bounding.top}');
  print('   bounding.left: ${element.mostRecentMeasurement.bounding.left}');
  print('   bounding.right: ${element.mostRecentMeasurement.bounding.right}');
  print('   bounding.width: ${element.mostRecentMeasurement.bounding.width}');
  print('   bounding.height: ${element.mostRecentMeasurement.bounding.height}');
  print('   client.top: ${element.mostRecentMeasurement.client.top}');
  print('   client.left: ${element.mostRecentMeasurement.client.left}');
  print('   client.width: ${element.mostRecentMeasurement.client.width}');
  print('   client.height: ${element.mostRecentMeasurement.client.height}');
  print('   offset.top: ${element.mostRecentMeasurement.offset.top}');
  print('   offset.left: ${element.mostRecentMeasurement.offset.left}');
  print('   offset.width: ${element.mostRecentMeasurement.offset.width}');
  print('   offset.height: ${element.mostRecentMeasurement.offset.height}');
  print('   scroll.top: ${element.mostRecentMeasurement.scroll.top}');
  print('   scroll.left: ${element.mostRecentMeasurement.scroll.left}');
  print('   scroll.width: ${element.mostRecentMeasurement.scroll.width}');
  print('   scroll.height: ${element.mostRecentMeasurement.scroll.height}');


}
