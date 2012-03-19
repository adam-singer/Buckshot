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

class TestFramework {
  final int _failureMessageIndent = 50;
  final List<TestGroupBase> _tests;
  final TestViewModel _vm;
  
  TestFramework() : 
    _tests = new List<TestGroupBase>(),
    _vm = new TestViewModel()
  {
    LucaSystem.unitTestEnabled = true;
    LucaSystem.rootView = new TestView.with(_vm);
  } 

  void addTestGroup(TestGroupBase testGroup)
  {
    _tests.add(testGroup);  
  }
  
  void executeTests(){
    var totalTests = 0;
    var totalPassed = 0;
    
    _tests.forEach((test){
      Tuple<int> result = _executeTestGroup(test);
      totalPassed += result.first;
      totalTests += result.second;
    });
    
    _vm.addTestMessage(_vm.rootPanel, "Total: $totalTests, Passed: $totalPassed");
  }
  
  /**
  * Executes and displays results of tests for a given test [group] */
  Tuple<int> _executeTestGroup(TestGroupBase group){
    var contentPanel = new TestGroupView(_vm.rootPanel, group).rootVisual;
    int passedCount = 0;
 
    group.testList.forEach((testName, value) { 
          bool result = _executeTest(testName, value, contentPanel);
          
          if (!result)
            {
            //turn header text red
            var h = contentPanel.parent.children[0].children[1];
            h.foreground = new SolidColorBrush(new Color.hex("#FFCCCC"));
            }
          passedCount =  result ? passedCount + 1 : passedCount;
      });
    
    //collapse the group if all tests pass
    if (passedCount == group.testList.length){
      var p = contentPanel.parent;
      var h = p.children[0];
      var b = h.children[0];
      b.click.invoke(this, new EventArgs());
    }
    
    return new Tuple<int>.with(passedCount, group.testList.length);
  }
   
  /**
  * Executes an individual test. Should not be called directly */
  bool _executeTest(String testName, Function test, StackPanel currentPanel){
    var testText = _vm.addTestMessage(currentPanel, "$testName... ");

    testText.foreground = new SolidColorBrush(new Color.hex("#FFCCCC"));
    try{
      test();
    }catch(ExpectException e){
      testText.text = testText.text + "FAILED.";
      var failMsg = _vm.addTestMessage(currentPanel, "... ${e.message}", _failureMessageIndent);
      failMsg.foreground = new SolidColorBrush(new Color.hex("#FFCCCC"));
      return false;
    }catch(FrameworkException e){
      testText.text = testText.text + "FAILED.";
      var failMsg = _vm.addTestMessage(currentPanel, "... FrameworkException: ${e.message}", _failureMessageIndent);
      failMsg.foreground = new SolidColorBrush(new Color.hex("#FFCCCC"));
      return false;
    }catch(Exception e){
      testText.text = testText.text + "FAILED.";
      var failMsg = _vm.addTestMessage(currentPanel, "... Exception: ${e.toString()}", _failureMessageIndent);
      failMsg.foreground = new SolidColorBrush(new Color.hex("#FFCCCC"));
      return false;
    }
    
    testText.foreground = new SolidColorBrush(new Color.hex("#00FF00"));
    testText.text = testText.text + "passed.";
    
    return true;
  } 

}
