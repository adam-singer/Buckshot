
class FrameworkObjectTests extends TestGroupBase {

  registerTests(){
    this.testGroupName = "FrameworkObject Tests";
    
    testList["name property registration"] = namePropertyRegistration;
    //TODO test for throws on attempts to assign name more than once.
  }
  
  // Tests that assignment to the name property of a FrameworkObject
  // properly registers it with buckshot.namedElements
  void namePropertyRegistration(){
    var b = new Border();
    b.name = "hello";
    
    Expect.isTrue(buckshot.namedElements.containsKey("hello"));
  }
  
}
