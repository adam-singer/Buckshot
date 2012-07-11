
class GridTests extends TestGroupBase
{
  registerTests(){
    this.testGroupName = "Grid Tests";
    
    testList["Attached Properties < 0 = 0"] = attachedPropertiesLessThanZero;
  }
  
  //validates that attached properties set to < 0 will actually set to 0
  void attachedPropertiesLessThanZero(){
    TextBlock tb = new TextBlock();
    
    Grid.setColumn(tb, -5);
    Grid.setRow(tb, -5);
    Grid.setColumnSpan(tb, -5);
    Grid.setRowSpan(tb, -5);
    
    Expect.equals(0, Grid.getColumn(tb));
    Expect.equals(0, Grid.getRow(tb));
    Expect.equals(0, Grid.getColumnSpan(tb));
    Expect.equals(0, Grid.getRowSpan(tb));
  }
  
}
