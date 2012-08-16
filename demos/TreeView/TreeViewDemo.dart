#import('../../lib/Buckshot.dart');
#import('../../extensions/controls/TreeView/TreeView.dart');


void main() {

  //TODO: Doesn't work yet because reflection isn't handling control templates
  // yet.


  final view = new View.fromTemplate('#main');

  view.ready.then((_){
    view.setAsRootView();

    final tv = buckshot.namedElements['tvDemo'] as TreeView;

    tv.treeNodeSelected + (_, TreeNodeSelectedEventArgs args){
      print('Node Selected: ${args.node.header}');
    };
  });

}
