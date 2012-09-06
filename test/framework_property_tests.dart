
/**
* Tests related to the FrameworkProperty model */
class FrameworkPropertyTests extends TestGroupBase 
{

  void registerTests(){
    this.testGroupName = "FrameworkProperty Tests";
    
    testList["resolve 1st level property"] = resolveFirstLevelProperty;
    testList["resolve nth level property"] = resolveNthLevelProperty;
    testList["resolve returns null on property not found"] = resolveNullOnPropertyNotFound;
    testList["resolve returns null on orphan properties"] = resolveNullOnOrphanProperties;
    testList["resolve is case in-sensitive"] = resolveIsCaseInSensitive;
  }
  
  void resolveFirstLevelProperty(){
    Border b = new Border();
    b.background = new SolidColorBrush(new Color.predefined(Colors.Red));
    
    b.resolveProperty("background")
    .then(expectAsync1((result){
      Expect.isTrue(result.value is SolidColorBrush);      
    }));
  }
  
  void resolveNthLevelProperty(){
    Border b1 = new Border();
    Border b2 = new Border();
    Border b3 = new Border();
    Border b4 = new Border();
    b1.content = b2;
    b2.content = b3;
    b3.content = b4;
    
    //set some properties
    b3.width = 45;
    b4.height = 26;
    
    //get the background from the deepest nested border
    b1.resolveProperty("content.content.content.height")
      .then(expectAsync1((result){
        Expect.equals(26, result.value);      
      }));
    
    //get the width from the 2nd nested border (b3)
    b1.resolveProperty("content.content.width")
      .then(expectAsync1((result){
        Expect.equals(45, result.value);      
      }));
  }
  
  void resolveNullOnPropertyNotFound(){
    Border b = new Border();
    
    b.resolveProperty("foo")
      .then(expectAsync1((result){
        Expect.isNull(result);
      }));
  }
  
  void resolveIsCaseInSensitive(){
    Border b = new Border();
    b.background = new SolidColorBrush(new Color.predefined(Colors.Red));
    
    b.resolveProperty("BaCkGrOuNd")
      .then(expectAsync1((result){
        Expect.isTrue(result.value is SolidColorBrush);
      }));
  }
  
  void resolveNullOnOrphanProperties(){
    Border b = new Border();
    b.background = new SolidColorBrush(new Color.predefined(Colors.Red));
    
    b.resolveProperty("background.foo")
      .then(expectAsync1((result){
        Expect.isNull(result);
      }));
  }
  
}
