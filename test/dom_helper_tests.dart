
class DomHelpersTests extends TestGroupBase 
{

  registerTests(){
    
    this.testGroupName = "DOM Helpers Tests";
    
    testList["Class Attribute Appends Properly To Null"] = classAppendsToNullClassAttribute;
    testList["Class Attribute Appends To Existing"] = classAppendsToExistingClassAttribute;
  }
  
  void classAppendsToNullClassAttribute(){
    Element el = new DivElement();
    
    Expect.isFalse(el.attributes.containsKey("class"));
    
    Browser.appendClass(el, "foo");
    
    Expect.equals("foo", el.attributes["class"], 'doesnt equal foo');
  }
  
  void classAppendsToExistingClassAttribute(){
    Element el = new DivElement();
    
    Expect.isFalse(el.attributes.containsKey("class"));
    
    Browser.appendClass(el, "foo");
    
    Expect.equals("foo", el.attributes["class"], "doesn't equal 'foo'");
    
    Browser.appendClass(el, "bar");
    
    Expect.equals("foo bar", el.attributes["class"], 'doesnt equal foo bar');
  }
  
}
