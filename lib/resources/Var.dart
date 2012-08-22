// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Provides a dynamic resource for statically binding virtually anything to a [FrameworkProperty].
*
* ## Template Example Usage
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
*/
class Var extends FrameworkResource implements IFrameworkContainer
{
  FrameworkProperty valueProperty;

  Var(){
    _initVarProperties();

    //meta data for binding system
    stateBag[FrameworkResource.RESOURCE_PROPERTY] = valueProperty;
    stateBag[FrameworkObject.CONTAINER_CONTEXT] = valueProperty;
  }

  get content() => value;

  void _initVarProperties(){
    valueProperty = new FrameworkProperty(this, "value", (Dynamic v){}, null);
  }

  Dynamic get value() => getValue(valueProperty);
  set value(Dynamic c) => setValue(valueProperty, c);
}
