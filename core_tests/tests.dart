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

#import('dart:html');
//#import('dart:dom', prefix:'dom');

//may need to adjust these paths if you have the files a different location
#import('UnitTestFramework.dart');

#import('../../../src/dart/client/testing/unittest/unittest_html.dart');

#import('../core/LUCA_UI_Framework.dart');

#source('UIBuilder.dart');
#source('InitializationTests.dart');
#source('FrameworkFundamentalsTests.dart');
#source('FrameworkPropertyTests.dart');
#source('FrameworkElementTests.dart');
#source('BindingTests.dart');
#source('BorderTests.dart');
#source('ButtonTests.dart');
#source('ControlTests.dart');
#source('FrameworkEventTests.dart');
#source('FrameworkExceptionTests.dart');
#source('FrameworkObjectTests.dart');
#source('LayoutCanvasTests.dart');
#source('ObservableListTests.dart');
#source('PanelTests.dart');
#source('StackPanelTests.dart');
#source('TextBlockTests.dart');
#source('GridTests.dart');
#source('GridCellTests.dart');
#source('TextBoxTests.dart');
#source('RadioButtonGroupTests.dart');
#source('DomHelpersTests.dart');
#source('StyleTemplateTests.dart');
#source('LucaxmlPresentationProviderTests.dart');
#source('StringToGridLengthConverterTests.dart');
#source('ResourceTests.dart');
#source('VarResourceTests.dart');

void main() {
 
//  try{
    new LucaSystem();
//    }
//    catch(FrameworkException e){
//      window.alert("Buckshot Framework initialization failed: ${e}");
//      return;
//    }
//    catch(Exception e, final stack){
//      window.alert("General system exception: ${e} $stack");
//      return;
//    }
    
  TestFramework tester;
  
//  try{
    tester = new TestFramework();
//  }
//  catch(FrameworkException e){
//    window.alert("Test Framework initialization failed: ${e.message}");
//    return;
//  }
//  catch (Exception e){
//    window.alert("Test Framework initialization failed: ${e.toString()}");
//    return;
//  }

  //hope to find these with reflection eventually...
  
  tester.addTestGroup(new InitializationTests());
  tester.addTestGroup(new FrameworkFundamentalsTests());
  tester.addTestGroup(new FrameworkElementTests());
  tester.addTestGroup(new FrameworkPropertyTests());
  tester.addTestGroup(new FrameworkEventTests());
  tester.addTestGroup(new FrameworkExceptionTests());
  tester.addTestGroup(new BindingTests());
  tester.addTestGroup(new LucaxmlPresentationProviderTests());
  tester.addTestGroup(new TextBoxTests());
  tester.addTestGroup(new BorderTests());
  tester.addTestGroup(new ButtonTests());
  tester.addTestGroup(new ControlTests());
  tester.addTestGroup(new FrameworkObjectTests());
  tester.addTestGroup(new ObservableListTests());
  tester.addTestGroup(new PanelTests());
  tester.addTestGroup(new StackPanelTests());
  tester.addTestGroup(new TextBlockTests());
  tester.addTestGroup(new LayoutCanvasTests());
  tester.addTestGroup(new RadioButtonGroupTests());
  tester.addTestGroup(new GridTests());
  tester.addTestGroup(new GridCellTests());
  tester.addTestGroup(new DomHelpersTests());
  tester.addTestGroup(new StyleTemplateTests());
  tester.addTestGroup(new StringToGridLengthConverterTests());
  tester.addTestGroup(new ResourceTests());
  tester.addTestGroup(new VarResourceTests());
  
  tester.executeTests();
}
