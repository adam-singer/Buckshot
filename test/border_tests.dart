
class BorderTests extends TestGroupBase
{
  registerTests(){
    this.testGroupName = "Border Tests";
    
    testList["createFromXml"] = createFromXml;
    testList["nullable content"] = nullableContent;
  }
  
  void nullableContent(){
    Border b = new Border();
    TextBlock tb = new TextBlock();
    tb.text = "hello";
    
    b.content = tb;
    Expect.equals(tb, b.content, "first assignment of textblock");
    
    b.content = null;
    Expect.isNull(b.content);
    
    b.content = tb;
    Expect.equals(tb, b.content, "second assignment of textblock");
    
  }
  
  void createFromXml(){
    String t = "<border><border/>";
    
    //TODO: finish
  }
}
