// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#library('social.extensions.buckshotui.org');

#import('../../lib/Buckshot.dart');
#import('../../external/events/events.dart');
#import('../../external/shared/shared.dart');
#import('../../external/web/web.dart');
#import('dart:html');
#source('PlusOne.dart');


void initializeSocialPackExtensions(){
  buckshot.registerElement(new PlusOne());
}