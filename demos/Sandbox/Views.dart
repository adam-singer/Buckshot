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
* A container class to hold all the views. */
class Views{
  String buckshotColor = "#165284";
  String errorUI;
  String ui;
  String helloWorldView;
  String stackPanelView;
  String sliderView;
  String layoutCanvasView;
  String borderView;
  String buttonView;
  String radioButtonView;
  String checkBoxView;
  String hyperlinkView;
  String imageView;
  String youtubeView;
  String huluView;
  String vimeoView;
  String funnyOrDieView;
  String gridView;
  String resourcesView;
  String interactiveView;
  String dataBindingView;
  String collectionsView;
  String dropDownListView;
  String listBoxView;

  Views(){

    listBoxView =
''' 
<!--
ListBox Demo

Three ListBoxes are displayed.  The first is a simple textual ListBox.
The second and third demonstration customized item templates and orientation
support.

All of the ListBoxes are binding to collections in a view model, and then
using client-side element binding to display the selected item from
each list. 
 --> 
<stackpanel margin="10">

  <!-- declare resources for common settings -->
  <resourcecollection>
    <lineargradientbrush key="rowbg" direction="vertical" fallbackcolor="Orange">
      <stops>
        <gradientstop color="Yellow"></gradientstop>
        <gradientstop color="Orange"></gradientstop>
      </stops>
    </lineargradientbrush>
    <styletemplate key="title">
      <setters>
        <stylesetter property="fontSize" value="20"></stylesetter>
        <stylesetter property="fontFamily" value="arial"></stylesetter>
        <stylesetter property="margin" value="20,0,0,0"></stylesetter>
      </setters>
    </styletemplate>
    <styletemplate key="rows">
      <setters>
        <stylesetter property="margin" value="1,0"></stylesetter>
        <stylesetter property="padding" value="5"></stylesetter>
        <stylesetter property="background" value="{resource rowbg}"></stylesetter>
      </setters>
    </styletemplate>
  </resourcecollection>

  <textblock style="{resource title}">Basic ListBox</textblock>

  <stackpanel orientation="horizontal">
    <listbox name="lbBasic" width="100" datacontext="{data fruit}">
      <presentationpanel>
        <stackpanel width="100"></stackpanel>
      </presentationpanel>
    </listbox>
    <stackpanel margin="0,0,0,20">
      <textblock text="Your Selection:"></textblock>
      <textblock fontsize="18" foreground="Green" text="{element lbBasic.selectedItem}"></textblock>
    </stackpanel>
  </stackpanel>
  
  <textblock style="{resource title}">Vertical ListBox (Custom Template)</textblock>
  
  <stackpanel orientation="horizontal">
    <listbox name="lbVertical" datacontext="{data icons}" height="150" width="300">
      <itemstemplate>
        <border style="{resource rows}"> 
          <stackpanel orientation="horizontal">
            <border width="64" height="64" margin="5,5">
              <image halign="center" valign="center" sourceuri="{data uri}"></image>
            </border>
            <stackpanel width="200">
              <textblock foreground="Black" fontfamily="arial" text="{data name}"></textblock>
              <textblock foreground="Black" fontsize="12" text="{data description}"></textblock>
            </stackpanel>      
          </stackpanel>
        </border>
      </itemstemplate>
    </listbox>
  
      <stackpanel margin="0,0,0,20">
        <textblock text="Your Selection:"></textblock>
        <border width="64" height="64">
          <image sourceuri="{element lbVertical.selectedItem.Uri}"></image>
        </border>
      </stackpanel>
  </stackpanel>
  <textblock style="{resource title}">Horizontal ListBox</textblock>
  
  <stackpanel orientation="horizontal">
    <listbox name="lbHorizontal" datacontext="{data icons}" width="300" verticalScrollEnabled="false" horizontalScrollEnabled="true">
      <presentationpanel>
        <stackpanel orientation="horizontal"></stackpanel>
      </presentationpanel>
      <itemstemplate>
        <border style="{resource rows}" width="150"> 
          <stackpanel>
            <border width="150" height="64">
              <image halign="center" valign="center" sourceuri="{data uri}"></image>
            </border>
            <textblock foreground="Black" fontfamily="arial" text="{data name}"></textblock>
            <textblock foreground="Black" fontsize="12" text="{data description}"></textblock>
          </stackpanel>
        </border>
      </itemstemplate>
    </listbox>
  
    <stackpanel margin="0,0,0,20">
      <textblock text="Your Selection:"></textblock>
      <border width="64" height="64">
        <image sourceuri="{element lbHorizontal.selectedItem.Uri}"></image>
      </border>
    </stackpanel>
  
  </stackpanel>

  <textblock margin="20,0,0,0">To see the view model that this demo is binding to:</textblock>

  <hyperlink content="View Model Code in Dart" targetname="_blank" navigateto="https://github.com/prujohn/Buckshot/blob/master/demos/tryit/DemoViewModel.dart"></hyperlink>
  
  <textblock margin="20,0,0,0" fontsize="12">Icons used in this demo are licensed to LUCA Studios LLC and may not be redistributed.</textblock>
</stackpanel>

''';

    dropDownListView =
'''
<!--
DropDownList provides an easy way to display a list of choices to the user.
In Buckshot, DropDownList's can be populated statically or dynamically via data binding.

In the example below, both methods are shown.  Element binding is also
used to provide a little interactivity in the demo.  Aside from the
data source 'fruit' the entire demo required no Dart coding in order to work.
-->

<stackpanel margin='5'>

  <textblock text="DropDownList From Data Source:"></textblock>
  
  <!-- This DropDownList is binding to a list of Strings a view model -->
  <dropdownlist name="ddlFruit" itemssource="{data fruit}"></dropdownlist>

  <stackpanel orientation="horizontal">
    <textblock text="Current Choice:" margin="0,5,0,0"></textblock>

    <!-- Element binding is used here to set the text property. -->
    <textblock text="{element ddlFruit.selectedItem.name}"></textblock>
  </stackpanel>
  
  <textblock margin="20,0,0,0" text="Static DropDownList (Select A Color):"></textblock>
  
  <!-- This DropDownList is created statically. -->
  <dropdownlist name="ddlColors">
    <items>
      <DropDownItem name="Red" value="Red" />
      <DropDownItem name="Blue" value="Blue" />
      <DropDownItem name="Green" value="Green" />
      <DropDownItem name="Orange" value="Orange" />
      <DropDownItem name="Tan" value="Tan" />
    </items>
  </dropdownlist>
  
  <!-- Element binding is used here to set the border's background color -->
  <border margin="5,0,0,0" width="75" height="75" background="{element ddlColors.selectedItem.name}"></border>

</stackpanel>
''';

    collectionsView=
'''
<stackpanel margin="10">

  <!-- declare resources for common settings -->
  <resourcecollection>
    <lineargradientbrush key="rowbg" direction="vertical" fallbackcolor="Orange">
      <stops>
        <gradientstop color="#EEEE77"></gradientstop>
        <gradientstop color="Orange"></gradientstop>
      </stops>
    </lineargradientbrush>
    <styletemplate key="header">
      <setters>
        <stylesetter property="margin" value="1"></stylesetter>
        <stylesetter property="padding" value="5"></stylesetter>
        <stylesetter property="background" value="DarkGreen"></stylesetter>
      </setters>
    </styletemplate>
    <styletemplate key="rows">
      <setters>
        <stylesetter property="margin" value="1,0"></stylesetter>
        <stylesetter property="padding" value="5"></stylesetter>
        <stylesetter property="background" value="{resource rowbg}"></stylesetter>
      </setters>
    </styletemplate>
  </resourcecollection>

  <textblock fontsize="20">Binding To Collections</textblock>

  <!-- 
  Display a title for each column of data.
  (note the resource binding for border styles)
  -->
  <stackpanel orientation="horizontal">
    <border width="150" style="{resource header}">
      <textblock foreground="White" text="Title"></textblock>
    </border>
    <border width="150" style="{resource header}">
      <textblock foreground="White" text="Description"></textblock>
    </border>
    <border width="310" style="{resource header}">
      <textblock foreground="White" text="Video"></textblock>
    </border>
  </stackpanel>

  <!--
  CollectionsPresenter is a general-purpose control for rendering
  a list of content.  Notice how it is binding to the 'videos' list
  which is exposed by the higher-up data context (the view model).
  -->
  <collectionpresenter datacontext="{data videos}">
    <!-- 
    The presentationPanel property provides a way to customize
    the container that the list will render inside of.
    -->
    <presentationpanel>
      <stackpanel></stackpanel>
    </presentationpanel>

    <!--
    The itemsTemplate property is where you build up your UI
    for each "row" of data in the list.
    Notice how the textblock's are binding to the fields of the 'videos'
    list.
    -->
    <itemstemplate>
      <stackpanel orientation="horizontal">
        <border valign='stretch' width="150" style="{resource rows}">
          <textblock halign='stretch' foreground="Black" text="{data title}"></textblock>
        </border>
        <border valign='stretch' width="150" style="{resource rows}">
          <textblock halign='stretch' foreground="Black" text="{data description}"></textblock>
        </border>
        <border width="310" style="{resource rows}">
          <youtube margin="10" videoid="{data hash}" width="300" height="200"></youtube>
        </border>
      </stackpanel>
    </itemstemplate>
  </collectionpresenter>
  <textblock margin="10,0,0,0">To see the view model that this demo is binding to:</textblock>
  <hyperlink content="View Model Code in Dart" targetname="_blank" navigateto="https://github.com/prujohn/Buckshot/blob/master/demos/tryit/DemoViewModel.dart"></hyperlink>
</stackpanel>
''';

    dataBindingView =
''' 
<!-- 
Data Binding Demo

This demo shows how Buckshot properties can be bound to data
objects in your code.  This demo is fairly basic, but imagine
that you are dealing with objects such as query returns from
databases, etc.  It works the same.

Each framework element has a property called "dataContext" and
if you assign an object to it, that object or it's properties
can be bound to properties of the element.

When elements declare a data binding (using '{data ...}'), the
Framework looks tries to bind to whatever object is assigned 
to the dataContext of that element.  If dataContext is null, 
then the framework walks up the visual tree until it finds a 
dataContext that has some data, and attempts to bind to that.

This type of binding occurs "late", meaning that it occurs at the
moment that the object is added to the browser visually.  This
is different from resource and element binding, both which occur as
soon as they are declared.
-->


<stackpanel>
  <resourcecollection>
    <!-- 
    Define a resource template for our borders since they share 
    common properties. 
    -->
    <styletemplate key="borderstyle">
      <setters>
        <stylesetter property="width" value="100"></stylesetter>
        <stylesetter property="height" value="100"></stylesetter>
        <stylesetter property="margin" value="5"></stylesetter>
      </setters>
    </styletemplate>
  </resourcecollection>

  <stackpanel margin="5" orientation="horizontal">
    <textblock text="Timestamp:"></textblock>

    <!-- binding to the 'timeStamp' property of the dataContext object -->
    <textblock text="{data timeStamp}" margin="0,0,0,5"></textblock>

  </stackpanel>

  <stackpanel orientation="horizontal">

    <!-- these borders are binding to a sub-property of a property, using 
     Buckshot's dot notation resolver -->
    <border style="{resource borderstyle}" background="{data color.red}"></border>
    <border style="{resource borderstyle}" background="{data color.orange}"></border>
    <border style="{resource borderstyle}" background="{data color.blue}"></border>

  </stackpanel>

  <textblock>To see the view model that this demo is binding to:</textblock>
  <hyperlink content="View Model Code in Dart" targetname="_blank" navigateto="https://github.com/prujohn/Buckshot/blob/master/demos/tryit/DemoViewModel.dart"></hyperlink>
</stackpanel>
''';

    interactiveView =
'''<!--
This demo shows how easy it is to build a simple, but interactive 
UI without having to write any code.

The controls on the left side are adjusting the properties of the
boarder in the display area.  This is accomplished through 
declarative element-to-element binding.
-->

<stackpanel margin="5">
  <textblock fontsize="24" text='This demo is written entirely with Buckshot XML - no code.'></textblock>
  <stackpanel width="650" orientation="horizontal">
  
    <grid margin="5" width="210">
      <columndefinitions>
        <columndefinition width="*1"></columndefinition>
        <columndefinition width="*2"></columndefinition>
        <columndefinition width="*.5"></columndefinition>
      </columndefinitions>
      <rowdefinitions>
        <rowdefinition height="auto"></rowdefinition>
        <rowdefinition height="auto"></rowdefinition>
        <rowdefinition height="auto"></rowdefinition>
        <rowdefinition height="auto"></rowdefinition>
        <rowdefinition height="auto"></rowdefinition>
      </rowdefinitions>
    
      <!-- labels -->
      <textblock text="Color:"></textblock>
      <textblock grid.row="1" text="Width:"></textblock>
      <textblock grid.row="2" text="Height:"></textblock>
      <textblock grid.row="3" text="Corner:"></textblock>
    
      <!-- controls -->

      <dropdownlist name="ddlColors" width="100" grid.column="1">
        <items>
          <DropDownItem name="Red" />
          <DropDownItem name="Green" />
          <DropDownItem name="Blue" />
          <DropDownItem name="LightBlue" />
          <DropDownItem name="Tan" />
          <DropDownItem name="Orange" />
          <DropDownItem name="Purple" />
          <DropDownItem name="Lime" />
          <DropDownItem name="DarkGreen" />
          <DropDownItem name="Yellow" />
        </items>
      </dropdownlist>
      <slider name="slWidth" grid.row="1" grid.column="1" min="20" max="300" value="150" width="100"></slider>
      <slider name="slHeight" grid.row="2" grid.column="1" min="20" max="300" value="150" width="100"></slider>
      <slider name="slCorner" grid.row="3" grid.column="1" min="1" max="20" value="1" width="100"></slider>
    
      <!-- value labels, bound to controls via element binding -->
      <textblock grid.column="2" grid.row="1" text="{element slWidth.value}"></textblock>
      <textblock grid.column="2" grid.row="2" text="{element slHeight.value}"></textblock>
      <textblock grid.column="2" grid.row="3" text="{element slCorner.value}"></textblock>

      <!-- using declarative actions, we reset the values of the controls when the user clicks the button -->
      <button grid.row="4" content='Reset'>
        <actions>
          <setpropertyaction event="click" targetName="slWidth" property="value" value="150"></setpropertyaction>
          <setpropertyaction event="click" targetName="slHeight" property="value" value="150"></setpropertyaction>
          <setpropertyaction event="click" targetName="slCorner" property="value" value="1"></setpropertyaction>
        </actions>
      </button>

    </grid>
   
    <border margin="5" width="400" height="400" borderthickness="1" bordercolor="Black">
      <!-- this border is bound to the controls via element binding -->
      <border halign="center" 
              valign="center" 
              bordercolor="Black" 
              cornerradius="{element slCorner.value}" 
              width="{element slWidth.value}" 
              height="{element slHeight.value}" 
              background="{element ddlColors.selectedItem.name}">
      </border>
    </border>
  </stackpanel>
  <textblock margin="10,0,0,0" text="Video On How Element Binding Works:"></textblock>
  <youtube width="300" height="250" videoid="WC25C5AHYAI"></youtube>
</stackpanel>
''';


    resourcesView =
'''
<!--
Resources Demo
--------------

Resources allow designers to create reusable components for use within their layouts.

Using resources saves time and reduces redundant information.

There are many different types of resources: Brushes, style templates, urls,
numerics, strings, and more...

To apply a resource to a property, use the binding syntax:
property="{resource [nameOfResource]}"

-->

<StackPanel margin="10">
  
  <!-- 
  <resourcecollection> is used to declare a group of resources.
  The framework will parse the collection make the resources available
  to elements.  Resources are application scope, meaning that once declared,
  they are available to all elements within an application.
  --> 
  <resourcecollection>

    <!-- here we are declaring a brush resource -->
    <lineargradientbrush key="lgb" direction="vertical">
      <stops>
        <gradientstop color="Red"></gradientstop>     
        <gradientstop color="White"></gradientstop>
        <gradientstop color="Blue"></gradientstop>
      </stops>
    </lineargradientbrush>

    <!-- here is another brush resource -->
    <radialgradientbrush key="rgb" drawmode="cover">
      <stops>
        <gradientstop color="Red"></gradientstop>
        <gradientstop color="White"></gradientstop>
        <gradientstop color="Blue"></gradientstop>
      </stops>
    </radialgradientbrush>
  
    <!-- 
    This styletemplate resource sets a group of property values
    that can be assigned to an element's 'style' property.  Notice how
    the background property is binding to the lineargradientbrush resource
    from above.
    -->
    <styletemplate key="firstborder">
      <setters>
        <stylesetter property="width" value="150"></stylesetter>
        <stylesetter property="margin" value="5"></stylesetter>
        <stylesetter property="borderThickness" value="2"></stylesetter>
        <stylesetter property="cornerRadius" value="7"></stylesetter>
        <stylesetter property="borderColor" value="Black"></stylesetter>
        <stylesetter property="height" value="75"></stylesetter>
        <stylesetter property="background" value="{resource lgb}"></stylesetter>
      </setters>
    </styletemplate>

    <styletemplate key="secondborder">
      <setters>
        <stylesetter property="margin" value="5"></stylesetter>
        <stylesetter property="width" value="150"></stylesetter>
        <stylesetter property="borderThickness" value="2"></stylesetter>
        <stylesetter property="cornerRadius" value="7"></stylesetter>
        <stylesetter property="borderColor" value="Black"></stylesetter>
        <stylesetter property="height" value="75"></stylesetter>
        <stylesetter property="background" value="{resource rgb}"></stylesetter>
      </setters>
    </styletemplate>

    <styletemplate key="thirdborder">
      <setters>
        <stylesetter property="margin" value="5"></stylesetter>
        <stylesetter property="width" value="150"></stylesetter>
        <stylesetter property="borderThickness" value="1"></stylesetter>
        <stylesetter property="cornerRadius" value="20"></stylesetter>
        <stylesetter property="borderColor" value="Purple"></stylesetter>
        <stylesetter property="height" value="75"></stylesetter>
        <stylesetter property="background" value="Green"></stylesetter>
      </setters>
    </styletemplate>

    <!-- Here we define a style template for our textblocks -->
    <styletemplate key="textstyle">
      <setters>
        <stylesetter property="hAlign" value="center"></stylesetter>
        <stylesetter property="vAlign" value="center"></stylesetter>
        <stylesetter property="fontSize" value="14"></stylesetter>
      </setters>
    </styletemplate>
  
  </resourcecollection>
  <stackpanel orientation="horizontal">

     <!-- 
      notice the binding syntax which tells the framework to look for the
      resource with the key 'firstBorder' and apply it to the 'style' property.
       -->
     <Border style="{resource firstborder}">
        <TextBlock style="{resource textstyle}" text="First Border Style" />
     </Border>
     <Border style="{resource secondborder}">
        <TextBlock style="{resource textstyle}" text="Second Border Style" />
     </Border>
     <Border style="{resource thirdborder}">
        <TextBlock style="{resource textstyle}" foreground="White" text="Third Border Style" />
     </Border>
  </stackpanel>

  <!-- We can apply the same resources to the elements in this grouping -->
  <stackpanel orientation="horizontal">
     <Border style="{resource firstborder}">
        <TextBlock style="{resource textstyle}" text="First Border Style" />
     </Border>
     <Border style="{resource secondborder}">
        <TextBlock style="{resource textstyle}" text="Second Border Style" />
     </Border>
     <Border style="{resource thirdborder}">
        <TextBlock style="{resource textstyle}" foreground="White" text="Third Border Style" />
     </Border>
  </stackpanel>
  <textblock text="Short Video On How Resources Work:"></textblock>
  <youtube width="300" height="250" videoid="cFxf3OBIj8Q"></youtube>
</StackPanel>
''';


    gridView =
'''
<!--
Grid Demo

Grid is a very dynamic layout container.  It supports 3 different column/row
measurement types:
   - Pixel. Row or column is a fixed value in pixels.
   - Star. Takes up a weighted size of available space relative to other
     star-type peers.
   - Auto. Attempts to size to the largest element in the row or column

In this demo, the first row is and "auto" type, and the textblock is using a grid.columnspan attached property to span across all 4 columns.

The remaining rows are laid out equally spaced with "*" (star-type). 

The columns are more interesting.  Notice how the first column is 
automatically the size of the largest text element.

For the next 2 columns, notice how the "*2" column is exactly twice as big as the
"*1" column.  Change the width of the grid to see how this adjusts automatically.

The fourth column is pixel-type of 100, and remains fixed in place.
-->
<stackpanel>
  <lineargradientbrush direction="vertical" key="gridbg" fallbackcolor="PowderBlue">
    <stops>
      <gradientstop color="White"></gradientstop>
      <gradientstop color="#335577"></gradientstop>
    </stops>
  </lineargradientbrush>
  <grid margin='10' width='400' height='400' background="{resource gridbg}">
    <columndefinitions>
      <columndefinition width="auto"></columndefinition>
      <columndefinition width="*1"></columndefinition>
      <columndefinition width="*2"></columndefinition>
      <columndefinition width="100"></columndefinition>
    </columndefinitions>
    <rowdefinitions>
      <rowdefinition height="auto"></rowdefinition>
      <rowdefinition height="*"></rowdefinition>
      <rowdefinition height="*"></rowdefinition>
      <rowdefinition height="*"></rowdefinition>
    </rowdefinitions>
  
    <textblock text="Grid Demo" grid.columnspan="4" halign="center"></textblock>
  
    <border grid.row="1" borderthickness="1" bordercolor="Black" halign="stretch" valign="stretch">
      <textblock>auto</textblock>
    </border>
    <border grid.row="1" grid.column="1" borderthickness="1" bordercolor="Black" halign="stretch" valign="stretch">
      <textblock>*1</textblock>
    </border>
    <border grid.row="1" grid.column="2" borderthickness="1" bordercolor="Black" halign="stretch" valign="stretch">
      <textblock>*2</textblock>
    </border>
    <border grid.row="1" grid.column="3" borderthickness="1" bordercolor="Black" halign="stretch" valign="stretch">
      <textblock>pixel 100</textblock>
    </border>
    
    <border grid.row="2" borderthickness="1" bordercolor="Black" valign='stretch'>
      <textblock>auto column</textblock>
    </border>
    <border grid.row="2" grid.column="1" borderthickness="1" bordercolor="Black" halign="stretch" valign="stretch">
      <textblock>*1</textblock>
    </border>
    <border grid.row="2" grid.column="2" borderthickness="1" bordercolor="Black" halign="stretch" valign="stretch">
      <textblock>*2</textblock>
    </border>
    <border grid.row="2" grid.column="3" borderthickness="1" bordercolor="Black" halign="stretch" valign="stretch">
      <textblock>pixel 100</textblock>
    </border>
    
    <border grid.row="3" borderthickness="1" bordercolor="Black" halign="stretch" valign="stretch">
      <textblock>auto</textblock>
    </border>
    <border grid.row="3" grid.column="1" borderthickness="1" bordercolor="Black" halign="stretch" valign="stretch">
      <textblock>*1</textblock>
    </border>
    <border grid.row="3" grid.column="2" borderthickness="1" bordercolor="Black" halign="stretch" valign="stretch">
      <textblock>*2</textblock>
    </border>
    <border grid.row="3" grid.column="3" borderthickness="1" bordercolor="Black" halign="stretch" valign="stretch">
      <textblock>pixel 100</textblock>
    </border>
  
  </grid>
</stackpanel>
''';

    funnyOrDieView =
'''
<!-- FunnyOrDie element is part of the media extension library for Buckshot. -->
<stackpanel margin="10">

    <textblock fontfamily="arial">Darth Vader Sells Out</textblock>
    
    <funnyordie videoid="1cf04006d2" margin="10" width="400" height="300"></funnyordie>

</stackpanel>
''';

    vimeoView =
'''
<!-- Vimeo element is part of the media extension library for Buckshot. -->
<stackpanel margin="10">

    <textblock fontfamily="arial">Seth Ladd's 'Intro To Box2D'</textblock>
    
    <vimeo videoid="32214850" margin="10" width="400" height="300"></vimeo>

</stackpanel>
''';

    huluView =
'''
<!-- 
Hulu element is part of the media extension library for Buckshot.

Hulu requires Flash and that only works on USA data networks. 
-->

<hulu margin="10" width="400" height="300" videoID="QRNTv9APf02C6J_xFpY0Dg"></hulu>
''';

    youtubeView =
'''
<!-- YouTube element is part of the media extension library for Buckshot. -->
<stackpanel margin="10">

    <textblock fontfamily="arial">David Chandler's 'Getting Started With Dart'</textblock>

    <youtube margin="10" videoid="Gh6SO26SkO8" width="400" height="300"></youtube>

</stackpanel>   
''';

    imageView =
'''
<stackpanel margin="10">
  <textblock>Like this logo for Buckshot?</textblock>
  <image alt="Buckshot Logo Candidate" sourceuri="http://www.lucastudios.com/img/lucaui_logo_candidate2.png"></image>
</stackpanel>
''';

    hyperlinkView =
'''
<stackpanel margin="10">

  <textblock margin="0,10">Hyperlinks can contain text or other elements.</textblock>

  <hyperlink targetname="_blank" navigateto="https://github.com/prujohn/Buckshot/wiki/">Text Hyperlink</hyperlink>

  <hyperlink width="170" margin="10,0,0,0" targetname="_blank" navigateto="https://github.com/prujohn/Buckshot/wiki/">

    <border width="150" height="150" background="Green">
      <textblock foreground="White" halign="center" valign="center">Content hyperlink</textblock>

    </border>

  </hyperlink>

</stackpanel>
''';

    checkBoxView =
'''
<stackpanel margin="10">

  <textblock margin="0,10">Checkboxes</textblock>

  <stackpanel orientation="horizontal">

    <checkbox groupname="1"></checkbox>

    <textblock margin="0,0,0,5">Option 1</textblock>

  </stackpanel>

  <stackpanel orientation="horizontal">

    <checkbox groupname="1"></checkbox>
  
    <textblock margin="0,0,0,5">Option 2</textblock>

  </stackpanel>

  <stackpanel orientation="horizontal">

    <checkbox groupname="1"></checkbox>
  
    <textblock margin="0,0,0,5">Option 3</textblock>

  </stackpanel>

  <stackpanel orientation="horizontal">

    <checkbox groupname="1"></checkbox>
  
    <textblock margin="0,0,0,5">Option 4</textblock>

  </stackpanel>

</stackpanel>
''';


    radioButtonView =
'''
<stackpanel margin="10">

  <textblock margin="0,10">Radio Buttons</textblock>

  <stackpanel orientation="horizontal">

    <radiobutton groupname="1"></radiobutton>

    <textblock margin="0,0,0,5">Option 1</textblock>

  </stackpanel>

  <stackpanel orientation="horizontal">

    <radiobutton groupname="1"></radiobutton>
  
    <textblock margin="0,0,0,5">Option 2</textblock>

  </stackpanel>

  <stackpanel orientation="horizontal">

    <radiobutton groupname="1"></radiobutton>
  
    <textblock margin="0,0,0,5">Option 3</textblock>

  </stackpanel>

  <stackpanel orientation="horizontal">

    <radiobutton groupname="1"></radiobutton>
  
    <textblock margin="0,0,0,5">Option 4</textblock>

  </stackpanel>

</stackpanel>
''';

    buttonView =
'''
<stackpanel margin="10">

  <textblock margin="0,10">Buttons can contain text or other elements.</textblock>

  <button width="80">text button</button>

  <button margin="10,0,0,0">

    <border width="150" height="150" background="Green">
      <textblock foreground="White" halign="center" valign="center">button with content</textblock>

    </border>

  </button>

</stackpanel>
''';

    layoutCanvasView =
'''
<LayoutCanvas width="400" height="400" background="WhiteSmoke">
  <Border layoutcanvas.top="40" layoutcanvas.left="40" width="80" height="80" background="Red">
  </Border>
  <!-- set zorder of next border above the others -->
  <Border layoutcanvas.top="60" layoutcanvas.left="60" width="80" height="80" background="Green" zorder="4">
  </Border>
  <Border layoutcanvas.top="80" layoutcanvas.left="80" width="80" height="80" background="Blue">
  </Border>
</LayoutCanvas>

<!-- LayoutCanvas allows you to position children at explicit locations, with overlap and z-ordering supported.  Notice how the positions of the elements are set using attached properties (LayoutCanvas.left & LayoutCanvas.top)-->
''';

    sliderView =
'''
<!-- 
In this slider demo, we are using element binding to bind 
each slider's 'value' property to the corresponding textblock's
'text' property.  No coding is necessary to achieve this.
-->

<border borderthickness="2" bordercolor="Green" background="WhiteSmoke" cornerradius="9" padding="10" margin="10" width="300">
   <StackPanel halign="center" valign="center">
      <TextBlock>Slide us. We dare you.</TextBlock>

      <stackpanel width="160" orientation="horizontal">
        <Slider name="myslider" value="50"></Slider>      
        <textblock margin="0,0,0,5" text="{element myslider.value}"></textblock>
      </stackpanel>

      <stackpanel width="160" orientation="horizontal">      
        <Slider name="s2" min="1" max="500" value="250"></Slider>
        <textblock margin="0,0,0,5" text="{element s2.value}"></textblock>
      </stackpanel>

      <stackpanel width="160" orientation="horizontal">
        <Slider name="s3" min="0" max="200" step="10" value="100"></Slider>
        <textblock margin="0,0,0,5" text="{element s3.value}"></textblock>
      </stackpanel>
   </StackPanel>
</border>
''';


    borderView =
'''
<border borderthickness="2" bordercolor="Green" background="Yellow" cornerradius="9" padding="10" margin="10" width="400" height="400">
  <border borderthickness="2" bordercolor="Green" background="Pink" cornerradius="9" padding="10" margin="10" halign="stretch" valign="stretch">
    <border borderthickness="2" bordercolor="Green" background="Purple" cornerradius="9" padding="10" margin="10" halign="stretch" valign="stretch">
      <border borderthickness="2" bordercolor="Green" background="Orange" cornerradius="9" padding="10" margin="10" halign="stretch" valign="stretch">
         <TextBlock halign="center" valign="center" text="Borders are cool."></TextBlock>
      </border>
    </border>
  </border>
</border>

<!-- Borders can contain a single content element and are useful in many scenarios -->
''';

    stackPanelView =
'''
<StackPanel margin="10">
  <TextBlock text="Vertical StackPanel" ></TextBlock>
  <StackPanel>
     <Border background="Red" padding="5">
        <TextBlock text="Item 1" />
     </Border>
     <Border background="Green" padding="5">
        <TextBlock text="Item 2" />
     </Border>
     <Border background="Blue" padding="5">
        <TextBlock text="Item 3" />
     </Border>
  </StackPanel>
  <TextBlock margin="10,0,0,0" text="Horizontal StackPanel" ></TextBlock>
  <StackPanel orientation="horizontal">
     <Border background="Red" padding="5">
        <TextBlock text="Item 1" />
     </Border>
     <Border background="Green" padding="5">
        <TextBlock text="Item 2" />
     </Border>
     <Border background="Blue" padding="5">
        <TextBlock text="Item 3" />
     </Border>
  </StackPanel>
</StackPanel>
''';


    helloWorldView =
'''
<TextBlock text="Hello World!" />

<!-- 
This one is about as simple as it gets.

Alternative forms can also be used to set the 'text' property of the TextBlock:

<TextBlock>Hello World!</TextBlock>  //Assigns 'Hello World!' to the TextBlock default content property 'text'.

or an even more verbose form if you like:

<TextBlock>
    <text>Hello World!</text>
</TextBlock>
-->

''';

    errorUI =
'''
<Border borderColor="Red" borderThickness="3" padding="5" background="Yellow">
  <TextBlock name="tbErrorMessage" foreground="Red" text="" />
</Border>
''';

  }
}