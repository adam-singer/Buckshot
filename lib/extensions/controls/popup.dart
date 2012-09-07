#library('popup.controls.buckshotui.org');

#import('dart:html');
#import('../../../buckshot.dart');
#import('package:DartNet-Event-Model/events.dart');
#import('package:dart_utils/shared.dart');

/**
 * A popup control that hovers over a given element.
 */
class Popup extends Control
{
  FrameworkProperty offsetXProperty;
  FrameworkProperty offsetYProperty;
  FrameworkProperty backgroundProperty;
  FrameworkProperty borderColorProperty;
  FrameworkProperty borderThicknessProperty;
  FrameworkProperty cornerRadiusProperty;
  
  Popup(){
    
  }
  
  void show(FrameworkElement attachedTo){
    
  }
  
  void hide(){
    
  }
  
  Popup.register() : super.register();
  makeMe() => new Popup();
}
