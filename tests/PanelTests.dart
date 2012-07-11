
class PanelTests extends TestGroupBase 
{

  registerTests(){
    this.testGroupName = "Panel Tests";
    
    testList["Fail on child already has parent"] = failOnChildAlreadyHasParent;
    testList["Succeed child no parent"] = succeedOnChildHasNoParent;
  }
  
  void succeedOnChildHasNoParent(){
    Panel p1 = new Panel();
    TextBlock tbTest = new TextBlock();
    p1.children.add(tbTest);
    
    Expect.equals(p1.children[0], tbTest);
  }
  
  void failOnChildAlreadyHasParent(){
    Panel p1 = new Panel();
    TextBlock tbTest = new TextBlock();
    p1.children.add(tbTest);
    
    Expect.equals(p1.children[0], tbTest);
    
    Panel p2 = new Panel();
    
    Expect.throws(
    ()=> p2.children.add(tbTest),
    (e)=> (e is BuckshotException)
    );
  }
}
