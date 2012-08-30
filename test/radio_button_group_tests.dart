
class RadioButtonGroupTests extends TestGroupBase 
{

  void registerTests(){
    this.testGroupName = "RadioButtonGroup Tests";
    
    testList["Null RadioButton add"] = nullRadioButtonAdd;
    testList["Fail on RadioButton already exists"] = failIfRadioButtonExists;
    testList["Fail if groupName different"] = failIfGroupNameDifferent;
    testList["Succeed adding second button"] = succeedAddingSecondButton;
  }
  
  
  void nullRadioButtonAdd(){
    RadioButtonGroup rbg = new RadioButtonGroup();
    
    rbg.addRadioButton(null);
    
    Expect.isTrue(rbg.radioButtonList.isEmpty());
  }
  
  void failIfRadioButtonExists(){
    RadioButtonGroup rbg = new RadioButtonGroup();
    
    RadioButton rb1 = new RadioButton();
    rb1.groupName = "test";
    rb1.value = "0";
    
    rbg.addRadioButton(rb1);
    
    Expect.throws(
      () => rbg.addRadioButton(rb1),
      (e) => (e is BuckshotException)
    );
  }
  
  void failIfGroupNameDifferent(){
    RadioButtonGroup rbg = new RadioButtonGroup();
    
    RadioButton rb1 = new RadioButton();
    rb1.groupName = "test";
    rb1.value = "0";
    
    rbg.addRadioButton(rb1);
    
    RadioButton rb2 = new RadioButton();
    rb2.groupName = "test2";
    rb2.value = "1";
    
    Expect.throws(
      () => rbg.addRadioButton(rb2),
      (e) => (e is BuckshotException)
    );
  }
  
  void succeedAddingSecondButton(){
    RadioButtonGroup rbg = new RadioButtonGroup();
    
    RadioButton rb1 = new RadioButton();
    rb1.groupName = "test";
    rb1.value = "0";
    
    rbg.addRadioButton(rb1);
    
    RadioButton rb2 = new RadioButton();
    rb2.groupName = "test";
    rb2.value = "1";
    
    rbg.addRadioButton(rb2);
    
    Expect.equals(rbg.radioButtonList.length, 2);
    
  }
  
  
}
