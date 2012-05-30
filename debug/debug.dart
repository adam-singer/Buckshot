#import('../lib/Buckshot.dart');
#import('dart:html');

//#import('dart:json');

#source('ViewModel.dart');
#source('View.dart');
#source('MainUIView.dart');
#source('GridDemoView.dart');
#source('BorderDemoView.dart');
#source('StackPanelDebug.dart');
#source('AlignmentPanelTestingView.dart');

// This project is used for development of the buckshot project.
// Anything here may or may not be working properly, or may look strange.

class Debug {
  ViewModel _vm;

  Debug():
  _vm = new ViewModel(){}

  void run() {
    if (_vm == null) br("is null");

    _vm.title = "Demo Title"; //view can bind to this property

    //passing the view, which triggers rendering on the page.
    //buckshot.rootView = new MainUIView();
    //buckshot.rootView = new GridDemoView.with(_vm);
    //buckshot.rootView = new BorderDemoView();
    buckshot.rootView = new StackPanelDebug();
    //buckshot.rootView = new AlignmentPanelTestingView();
  }
}

void main() {

//  if (DEBUG){
//    try{
//      new Debug().run();
//      db("***end***");
//    }catch(FrameworkException e){
//      print("Unhandled Framework Exception: ${e.message}");
//      //window.alert("Unhandled Framework Exception: ${e.message}");
//    }
//    catch(Exception e){
//      print("Unhandled Exception: ${e.toString()}");
//      //window.alert("Unhandled Exception: ${e.toString()}");
//    }
//  }else{
    new Debug().run();
//  }
}
