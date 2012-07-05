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

/**
* Renders raw html to the browser.
*
* In xml, the [htmlString] property must be assigned to directly, not in node form:
* 
* ### Good: 
*     <rawhtml htmlstring='<div style="width:100px"></div>'></rawhtml>
*
* ### Bad:
*     <rawhtml>
*         <htmlstring>
*             <!-- won't render -->
*             <div></div>
*         </htmlstring>
*     </rawhtml>
*/
class RawHtml extends FrameworkElement
{
  /// A framework property representing the raw html string.
  FrameworkProperty htmlStringProperty;
 
  FrameworkObject makeMe() => new RawHtml();
  
  RawHtml()
  {
    Dom.appendBuckshotClass(rawElement, "rawhtml");
       
    _initRawHtmlProperties();
  }
  
  void _initRawHtmlProperties(){
    
    htmlStringProperty = new FrameworkProperty(
      this,
      "htmlString",
      (String value){
        rawElement.innerHTML = value.toString();
      });
  }
    
  String get htmlString() => getValue(htmlStringProperty);
  set htmlString(String value) => setValue(htmlStringProperty, value);
  
  void createElement(){
    rawElement = new DivElement();
  }
  
  void updateLayout(){}

  String get type() => "RawHtml";
}
