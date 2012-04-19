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

#library('Buckshot Control Generator');

#import('../lib/Buckshot.dart');
#import('dart:json');
#import('dart:html');

/** 
* Takes a string of BuckshotXML and returns a string representing a dart Class of the resulting object.
*/
Future<String> generateClassFromXmlTemplate(String buckshotXml){  
  var c = new Completer();
  
  try{
    c.complete(_generateTemplate(buckshotXml));
  }catch (Exception e){
    c.completeException(e);
  }
  
  return c.future;
}

String _generateTemplate(String xml){
  Buckshot b = new Buckshot('#BuckshotHost');
  var oldContext = buckshot.switchContextTo(b);
  
  var result = b.defaultPresentationProvider.deserialize(xml);
  
  StringBuffer s = new StringBuffer();
  
  s.add(
'''
/**
* ** GENERATED CODE **
*/
class UserView implements IView
{
''');
  
  if (b.namedElements.length > 0){    
    b.namedElements.forEach((name, FrameworkObject el){
      s.add(
'''
  /// Object representation of the named [FrameworkElement]: ${name} ${el.type}
  final ${el.type} ${name};

''');
    });
  }
  
  s.add(
'''

  // Raw template representing the view.
  static final String _viewTemplate = 
\'\'\'
${xml}
\'\'\';

  // Deserialized view.
  final FrameworkElement _view;

  /// Gets the visual root of the view. (IView interface)
  FrameworkElement get rootVisual() => _view;
''');  
  
s.add(
'''

  UserView()
  : 
''');

if (b.namedElements.length > 0){
  b.namedElements.forEach((name, FrameworkObject el){
    s.add(
'''
  ${name} = buckshot.namedElements["${name}"],
''');
  });
}

s.add(
'''
  _view = buckshot.defaultPresentationProvider.deserialize(_viewTemplate)
{}
''');
  
  s.add(
'''
}
''');
  
  buckshot.switchContextTo(oldContext);
  UserView v = new UserView();
  buckshot.rootView = v;
  var r = s.toString();
  
//  var content='data:text/plain, $r';
//  
//  window.location.href = content;
  
  return s.toString();
}


/**
* ** GENERATED CODE **
*/
class UserView implements IView
{
  /// Object representation of the named [FrameworkElement]: tbNextLine TextBlock
  final TextBlock tbNextLine;

  /// Object representation of the named [FrameworkElement]: tbTest TextBlock
  final TextBlock tbTest;


  // Raw template representing the view.
  static final String _viewTemplate = 
'''
<stackpanel>
  <textblock name='tbTest' text='hello world'></textblock>
  <textblock name='tbNextLine' text='This is opportunity knocking.'></textblock>
</stackpanel>

''';

  // Deserialized view.
  final FrameworkElement _view;

  /// Gets the visual root of the view. (IView interface)
  FrameworkElement get rootVisual() => _view;

  UserView()
  : 
  tbNextLine = buckshot.namedElements["tbNextLine"],
  tbTest = buckshot.namedElements["tbTest"],
  _view = buckshot.defaultPresentationProvider.deserialize(_viewTemplate)
{}
}
 
