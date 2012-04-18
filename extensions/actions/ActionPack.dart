#library('extensions_actions_actionpack');
#import('../../lib/Buckshot.dart');
#import('SetPropertyAction.dart');
#import('TogglePropertyAction.dart');
#import('AnimationAction.dart');

void initializeActionPackExtensions(){
  Buckshot.registerElement(new AnimationAction());
  Buckshot.registerElement(new SetPropertyAction());
  Buckshot.registerElement(new TogglePropertyAction());
}