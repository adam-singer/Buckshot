// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

class DemoModel {
  // This list of data is build statically using data templates, but image how easy it would be
  // to query some data source and build up a list just like this...
  List videoList;
  List iconList;
  final List fruitList = const ["apple","pear","grape","orange","tomato"];
  final SomeColors colorClass;

  Buckshotbin buckshotbin;

  DemoModel()
  :
    colorClass = new SomeColors()
  {
    buckshotbin = new Buckshotbin();
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

class Buckshotbin extends BuckshotObject {
  // XXX: we might not even be sending directly to cloudant
  // Since were just the client at this point. 
  String buckshotbinurl = "http://buckshotbin.cloudant.com/buckshotbin/";
  Uri buckshotbinuri;
  FrameworkProperty templateData;
  FrameworkProperty returnId;
  
  makeMe() => null;
  
  Buckshotbin() {
    buckshotbinuri = new Uri(buckshotbinurl);
    templateData = new FrameworkProperty(this, "templateData", defaultValue:"");
    returnId = new FrameworkProperty(this, "returnId", defaultValue:"");
  }
  
  /**
   * Send template data to store.
   */
  sendData(String data) {
    HttpRequest request = new HttpRequest();
    request.open("POST", "/buckshotbin", true);
    request.on.loadEnd.add((HttpRequestProgressEvent e) {
      print("responseId = ${request.responseText}");
      var responseId = JSON.parse(request.responseText);
    });
    
    request.on.error.add((Event e) {
      print("Error: ${e}");
    });
    
    request.send(JSON.stringify({"code": data}));    
  }
  
  /**
   * Fetch the stored template from the server.
   */
  fetchData(String id) {
    HttpRequest request = new HttpRequest();
    request.open("GET", "/buckshotbin?q=${id}", async : true);
    request.on.error.add((Event e) {
      print("Error: ${e}");
    });
    
    request.on.loadEnd.add((XMLHttpRequestProgressEvent e) { 
      print("responseTemplate = ${request.responseText}");
      var responseTemplate = JSON.parse(request.responseText);
    });
    request.send();
  }
}

// a demo Buckshot object to demonstrate the dot notation resolver for properties
class SomeColors extends BuckshotObject
{
  FrameworkProperty redProperty, orangeProperty, blueProperty;

  makeMe() => null;
  
  SomeColors(){
    redProperty = new FrameworkProperty(this, "red", defaultValue:"Red");
    orangeProperty = new FrameworkProperty(this, "orange", defaultValue:"Orange");
    blueProperty = new FrameworkProperty(this, "blue", defaultValue:"Blue");
  }
}