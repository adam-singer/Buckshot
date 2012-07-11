
class DomHelpersTests extends TestGroupBase 
{

  registerTests(){
    
    this.testGroupName = "DOM Helpers Tests";
    
    testList["Class Attribute Appends Properly To Null"] = classAppendsToNullClassAttribute;
    testList["Class Attribute Appends To Existing"] = classAppendsToExistingClassAttribute;
  }
  
  void classAppendsToNullClassAttribute(){
    Element el = Dom.createByTag("div");
    
    Expect.isFalse(el.attributes.containsKey("class"));
    
    Dom.appendClass(el, "foo");
    
    Expect.equals("foo", el.attributes["class"], 'doesnt equal foo');
  }
  
  void classAppendsToExistingClassAttribute(){
    Element el = Dom.createByTag("div");
    
    Expect.isFalse(el.attributes.containsKey("class"));
    
    Dom.appendClass(el, "foo");
    
    Expect.equals("foo", el.attributes["class"], "doesn't equal 'foo'");
    
    Dom.appendClass(el, "bar");
    
    Expect.equals("foo bar", el.attributes["class"], 'doesnt equal foo bar');
  }
  
}
