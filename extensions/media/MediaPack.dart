// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#library('Buckshot_Extensions_Media');

#import('../../lib/Buckshot.dart');
#import('YouTube.dart');
#import('Hulu.dart');
#import('Vimeo.dart');
#import('FunnyOrDie.dart');

/* Video and Audio Extensions for Buckshot Framework */ 

void initializeMediaPackExtensions(){
  buckshot.registerElement(new YouTube());
  buckshot.registerElement(new Hulu());
  buckshot.registerElement(new Vimeo());
  buckshot.registerElement(new FunnyOrDie());
}