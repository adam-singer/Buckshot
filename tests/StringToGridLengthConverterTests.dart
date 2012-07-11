
class StringToGridLengthConverterTests extends TestGroupBase
{
  StringToGridLengthConverter c = const StringToGridLengthConverter();
  
  void registerTests()
  {
    testGroupName = "String to GridLength Converter Tests";
    
    //reflection would sure be nice instead of this...
    testList["auto"] = testAuto;
    testList["pixel"] = testPixel;
    testList["star no value"] = testStarNoValue;
    testList["star with value"] = testStarValue;
  }
  
  
  void testAuto(){
    GridLength l = c.convert("auto");
    Expect.equals(GridUnitType.auto, l.gridUnitType);
  }
  
  void testPixel(){
    GridLength l = c.convert("45");
    Expect.equals(45, l.value);
    Expect.equals(GridUnitType.pixel, l.gridUnitType);
    
  }
  
  void testStarNoValue(){
    GridLength l = c.convert("*");
    Expect.equals(1, l.value);
    Expect.equals(GridUnitType.star, l.gridUnitType);
  }
  
  void testStarValue(){
    GridLength l = c.convert("*.5");
    Expect.equals(.5, l.value);
    Expect.equals(GridUnitType.star, l.gridUnitType);
    
    GridLength l2 = c.convert(".5*");
    Expect.equals(.5, l2.value);
    Expect.equals(GridUnitType.star, l2.gridUnitType);
  }
  
}
