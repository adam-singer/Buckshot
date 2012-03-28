class DartBugs extends TestGroupBase
{
  registerTests(){
    this.testGroupName = "Dart Bug Tests ::";
    
    testList["borderRadiusReturnsNull"] = borderRadiusReturnsNull;
    testList['SVG elements returning css'] = svgElementReturningCss;
  }
  
  
  void svgElementReturningCss(){
    var se = new SVGSVGElement();
    var r = new SVGElement.tag('rect');
    se.elements.add(r);
    
    r.style.setProperty('fill','Red');
    
    var result = r.style.getPropertyValue('fill');
    Expect.isNotNull(result);
  }
  
  // http://www.dartbug.com/2332
  void borderRadiusReturnsNull(){
    var e = new Element.tag('div');
    e.style.borderRadius = '10px';

    var result = e.style.borderRadius;
    Expect.isNotNull(result);
  }
}
