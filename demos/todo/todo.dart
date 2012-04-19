#import('../../lib/Buckshot.dart');
#import('dart:html');
#source('View.dart');
#source('ViewModel.dart');


class todo {

  todo() {
  }

  void run() {
  
    buckshot.rootView = new View();
    
  }

}

void main() {
  new todo().run();
}
