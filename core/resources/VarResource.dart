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
* Provides a dynamic resource for statically binding virtually anything to a [FrameworkProperty].
*
* ## Lucaxml Example Usage
*    <resourcecollection>
*        <!-- simple values -->
*        <var key="stringresource" value="hello world!"></var>
*        <var key="numericresource" value="150"></var>
*        <var key="urlresource" value="http://www.lucastudios.com/img/lucaui_logo_candidate2.png"></var>
*
*        <!-- objects (templates, if you will) -->
*        <var key="contentresource">
*            <stackpanel>
*               <textblock text="line 1"></textblock>
*               <textblock text="line 2"></textblock>
*            </stackpanel>
*        </var>
*    </resourcecollection>
*
*    <!-- Now we can bind to the resources in various ways... -->
*    <textblock text="{resource stringresource}"></textblock>
*    <image alt="image test" sourceuri="{resource urlresource}"></image>
*    <border background="Orange" width="{resource numericresource}" content="{resource contentresource}"></border>
*
* ## See Also
* * [StyleTemplate]
* * [Color]
* * [SolidColorBrush]
* * [LinearGradientBrush]
* * [RadialGradientBrush]
*
*/
class VarResource extends FrameworkResource
{
  FrameworkProperty valueProperty;
  
  BuckshotObject makeMe() => new VarResource();
  
  VarResource(){
    _initVarProperties();
    
    //meta data for binding system
    this._stateBag[FrameworkResource.RESOURCE_PROPERTY] = valueProperty;
    this._stateBag[FrameworkObject.CONTAINER_CONTEXT] = valueProperty;
  }
  
  void _initVarProperties(){
    valueProperty = new FrameworkProperty(this, "value", (Dynamic v){}, null);
  }
  
  Dynamic get value() => getValue(valueProperty);
  set value(Dynamic c) => setValue(valueProperty, c);
  
  String get type() => "Var";
}
