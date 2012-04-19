#library('extensions_actions_actionpack');
#import('../../lib/Buckshot.dart');
#import('SetPropertyAction.dart');
#import('TogglePropertyAction.dart');
#import('AnimationAction.dart');

void initializeActionPackExtensions(){
  buckshot.registerElement(new AnimationAction());
  buckshot.registerElement(new SetPropertyAction());
  buckshot.registerElement(new TogglePropertyAction());
}