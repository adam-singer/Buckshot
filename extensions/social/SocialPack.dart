// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#library('Buckshot_Extensions_Social');

#import('../../lib/Buckshot.dart');
#import('../../external/events/events.dart');
#import('../../external/shared/shared.dart');
#import('dart:html');
#source('PlusOne.dart');


void initializeSocialPackExtensions(){
  buckshot.registerElement(new PlusOne());
}