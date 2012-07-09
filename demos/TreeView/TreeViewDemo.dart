#import('dart:html');
#import('../../lib/Buckshot.dart');

void main() {
       
//  new Timer(0, (_) => print('Hello'));
  
  buckshot.registerElement(new TreeView());
  buckshot.registerElement(new TreeNode());
  
  final view = new IView.from(Template.deserialize(Template.getTemplate('#main')));
  
  buckshot.rootView = view;
  
  final tv = buckshot.namedElements['tvDemo'] as TreeView;
    
  tv.treeNodeSelected + (_, TreeNodeSelectedEventArgs args){
    print('Node Selected: ${args.node.header}');
  };
}
