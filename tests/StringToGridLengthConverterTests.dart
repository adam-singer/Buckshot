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

class StringToGridLengthConverterTests extends TestGroupBase
{
  StringToGridLengthConverter c = const StringToGridLengthConverter();
  
  void registerTests()
  {
    testGroupName = "String to GridLength Converter Tests";
    
    //reflection would sure be nice instead of this...
    testList["auto"] = testAuto;
    testList["pixel"] = testPixel;
    testList["star no value"] = testStarNoValue;
    testList["star with value"] = testStarValue;
  }
  
  
  void testAuto(){
    GridLength l = c.convert("auto");
    Expect.equals(GridUnitType.auto, l.gridUnitType);
  }
  
  void testPixel(){
    GridLength l = c.convert("45");
    Expect.equals(45, l.value);
    Expect.equals(GridUnitType.pixel, l.gridUnitType);
    
  }
  
  void testStarNoValue(){
    GridLength l = c.convert("*");
    Expect.equals(1, l.value);
    Expect.equals(GridUnitType.star, l.gridUnitType);
  }
  
  void testStarValue(){
    GridLength l = c.convert("*.5");
    Expect.equals(.5, l.value);
    Expect.equals(GridUnitType.star, l.gridUnitType);
    
    GridLength l2 = c.convert(".5*");
    Expect.equals(.5, l2.value);
    Expect.equals(GridUnitType.star, l2.gridUnitType);
  }
  
}
