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

class DemoModel {
  // This list of data is build statically using data templates, but image how easy it would be
  // to query some data source and build up a list just like this...
  List videoList;
  List iconList;
  final List fruitList = const ["apple","pear","grape","orange","tomato"];
  final SomeColors colorClass;

  DemoModel()
  :
    colorClass = new SomeColors()
  {
    iconList = [
                new DataTemplate.fromMap({'Name':'Certificate', 'Description':'Image of a certificate document.',         'Uri':'http://www.lucastudios.com/Content/images/Certificate64.png'}),
                new DataTemplate.fromMap({'Name':'Chart',       'Description':'Represents a chart of information.',       'Uri':'http://www.lucastudios.com/Content/images/ChartGantt64.png'}),
                new DataTemplate.fromMap({'Name':'Connected',   'Description':'Represents an active connection.',         'Uri':'http://www.lucastudios.com/Content/images/Connected64.png'}),
                new DataTemplate.fromMap({'Name':'Mail Box',    'Description':'Snail Mail!',                              'Uri':'http://www.lucastudios.com/Content/images/MailBox64.png'}),
                new DataTemplate.fromMap({'Name':'Node',        'Description':'Represents a node object.',                'Uri':'http://www.lucastudios.com/Content/images/Node24.png'}),
                new DataTemplate.fromMap({'Name':'Telephone',   'Description':'Image of an old school telephone.',        'Uri':'http://www.lucastudios.com/Content/images/Telephone64.png'}),
                new DataTemplate.fromMap({'Name':'Windows',     'Description':'Represents windows in a user interface.',  'Uri':'http://www.lucastudios.com/Content/images/WindowTriPaneSearch64.png'})
                ];

    videoList = [
                 new DataTemplate.fromMap({"Title":"Buckshot Templates",  "Description":"The Buckshot Template System.", "Hash":"LOacOkmd9FI"}),
                 new DataTemplate.fromMap({"Title":"Buckshot Resources",          "Description":"An overview of Buckshot Resource Binding.",   "Hash":"cFxf3OBIj8Q"}),
                 new DataTemplate.fromMap({"Title":"Buckshot Element Binding",    "Description":"An overview of Buckshot Element Binding.",    "Hash":"WC25C5AHYAI"}),
                 new DataTemplate.fromMap({"Title":"Buckshot Control Templates",  "Description":"An overview of Buckshot Control Templates and Template Binding","Hash":"KRGvdID4rPE"})
               ];
  }
}


// a demo Buckshot object to demonstrate the dot notation resolver for properties
class SomeColors extends BuckshotObject
{
  FrameworkProperty redProperty, orangeProperty, blueProperty;

  SomeColors(){
    redProperty = new FrameworkProperty(this, "red", defaultValue:"Red");
    orangeProperty = new FrameworkProperty(this, "orange", defaultValue:"Orange");
    blueProperty = new FrameworkProperty(this, "blue", defaultValue:"Blue");
  }
}