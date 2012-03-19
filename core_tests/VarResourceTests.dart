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

class VarResourceTests extends TestGroupBase
{
  final IPresentationFormatProvider p;
  
  VarResourceTests() : p = new LucaxmlPresentationProvider() {}
  
  registerTests(){
    
    this.testGroupName = "VarResource Tests";
    
    testList["String values work"] = stringValuesWork;
    testList["Object values work"] = objectValuesWork;
  }
  
  void objectValuesWork(){
    var t = '''
<resourcecollection>
  <var key="contenttest">
    <textblock text="hello world!"></textblock>
  </var>
</resourcecollection>
''';
    
    p.deserialize(t);
    
    var result = LucaSystem.retrieveResource("contenttest");
    
    Expect.isTrue(result is TextBlock);
  }
  
  void stringValuesWork(){
    var t = '''
  <resourcecollection>
<var key="test" value="hello world!"></var>
<var key="colortest" value="#007777"></var>
<var key="numtest" value="150"></var>
<var key="urltest" value="http://www.lucastudios.com/img/lucaui_logo_candidate2.png"></var>
</resourcecollection>
''';
    p.deserialize(t);
    
    Expect.equals("hello world!", LucaSystem.retrieveResource("test"));
    Expect.equals("#007777", LucaSystem.retrieveResource("colortest"));
    Expect.equals("150", LucaSystem.retrieveResource("numtest"));
    Expect.equals("http://www.lucastudios.com/img/lucaui_logo_candidate2.png", LucaSystem.retrieveResource("urltest"));
  }
}
