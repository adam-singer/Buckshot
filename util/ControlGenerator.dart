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
#import('test_lib.dart');
#import('dart:isolate');
#import('dart:json');
#import('dart:html');


/** 
* Takes a string of BuckshotXML and returns a string representing a dart Class of the resulting object.
*/
Future<String> generateClassFromXmlTemplate(String buckshotXml){
  // run in an isolate so that a completely new Buckshot instance
  // used without crashing into the main one
  //new Buckshot();
  
  SendPort sp = spawnFunction(_generateClassIsolate);
  
  return sp.call(buckshotXml);
  
}

_generateClassIsolate(){
  port.receive((String msg, SendPort reply){
    //any of these yields 'aww snap' from Dartium
    //new Buckshot();
    //var test = new FrameworkElement();
    //FrameworkElement el = Buckshot.defaultPresentationProvider.deserialize(msg);

    
    //just pinging back the message for now
    reply.send(msg, port.toSendPort());
  });
}