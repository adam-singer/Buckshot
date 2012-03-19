//   Copyright (c) 2012, John Evans & LUCA Studios LLC
//
//   http://www.lucastudios.com/contact
//   John: https://plus.google.com/u/0/115427174005651655317/about
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

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
    
    Expect.isTrue(rbg._radioButtonList.isEmpty());
  }
  
  void failIfRadioButtonExists(){
    RadioButtonGroup rbg = new RadioButtonGroup();
    
    RadioButton rb1 = new RadioButton();
    rb1.groupName = "test";
    rb1.value = "0";
    
    rbg.addRadioButton(rb1);
    
    Expect.throws(
      () => rbg.addRadioButton(rb1),
      (e) => (e is FrameworkException)
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
      (e) => (e is FrameworkException)
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
    
    Expect.equals(rbg._radioButtonList.length, 2);
    
  }
  
  
}
