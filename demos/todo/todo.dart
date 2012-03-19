#import('../../core/LUCA_UI_Framework.dart');
#import('dart:html');
#source('View.dart');
#source('ViewModel.dart');


class todo {

  todo() {
  }

  void run() {
    //initialize the framework (I hope to do away with this step eventually)
    new LucaSystem();
    
    LucaSystem.rootView = new View();
    
  }

}

void main() {
  new todo().run();
}
