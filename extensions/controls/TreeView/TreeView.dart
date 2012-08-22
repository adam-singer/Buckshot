// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#library('treeview.controls.buckshotui.org');

#import('dart:html');
#import('../../../lib/Buckshot.dart');
#import('package:DartNet-Event-Model/events.dart');
#import('../../../external/web/web.dart');
#import('../../../external/shared/shared.dart');

#source('TreeNode.dart');

/**
* Displays a heirachical list of [TreeNode] elements.
*/
class TreeView extends Panel
{
  static final String INDICATOR_COLLAPSED = '\u{25b7}';
  static final String INDICATOR_EXPANDED = '\u{25e2}';

  static final String FILE_DEFAULT_TEMPLATE =
      '''
<border width='16' height='16' cornerradius='2' borderthickness='1' bordercolor='Gray' background='#ffff77'>
  <stackpanel halign='stretch' valign='center'>
    <border margin='2,1' borderthickness='1' bordercolor='LightGray' halign='stretch' />
    <border margin='3,1' borderthickness='1' bordercolor='LightGray' halign='stretch' />
    <border margin='2,1' borderthickness='1' bordercolor='LightGray' halign='stretch' />
  </stackpanel>
</border>
''';


  static final String FOLDER_DEFAULT_TEMPLATE =
      '''
<layoutcanvas width='16' height='16'>
  <border width='16' height='14' layoutcanvas.top='1' cornerradius='2' borderthickness='1' bordercolor='Gray' background='#ffff77'>
  </border>
  <border layoutcanvas.left='10' width='6' height='14' cornerradius='2' borderthickness='1' bordercolor='Gray' background='#ffff77'>
  </border>
  <border layoutcanvas.top='5' height='10' width='16' cornerradius='2' borderthickness='1' bordercolor='Gray' background='#ffff77' />
</layoutcanvas>
''';

  StyleTemplate mouseEnterBorderStyle;
  StyleTemplate mouseLeaveBorderStyle;
  StyleTemplate mouseDownBorderStyle;
  StyleTemplate mouseUpBorderStyle;

  FrameworkProperty indentProperty;
  FrameworkProperty openArrowProperty;
  FrameworkProperty borderThicknessProperty;
  FrameworkProperty borderColorProperty;

  /// Event which fires when a node is selected in the TreeView.
  final FrameworkEvent<TreeNodeSelectedEventArgs> treeNodeSelected;

  TreeView()
  :
    treeNodeSelected = new FrameworkEvent<TreeNodeSelectedEventArgs>()
  {
    Browser.appendClass(rawElement, "TreeView");

    _initializeTreeViewProperties();

    initStyleTemplates();

    cursor = Cursors.Arrow;

    background = new SolidColorBrush(new Color.predefined(Colors.White));
  }

  /**
   * Override this method to customize the mouse event styles on [TreeNode]s.
   */
  void initStyleTemplates(){
    Template
      .deserialize('''
<resourcecollection>
  <styletemplate key="__TreeView_mouse_enter_style_template__">
    <setters>
      <stylesetter property="background" value="#eeeeff" />
      <stylesetter property="borderColor" value="#ccccdd" />
    </setters>
  </styletemplate>

  <styletemplate key="__TreeView_mouse_leave_style_template__">
    <setters>
      <stylesetter property="background" value="White" />
      <stylesetter property="borderColor" value="White" />
    </setters>
  </styletemplate>

  <styletemplate key="__TreeView_mouse_down_style_template__">
    <setters>
      <stylesetter property="background" value="#ddddee" />
      <stylesetter property="borderColor" value="#ccccdd" />
    </setters>
  </styletemplate>

  <styletemplate key="__TreeView_mouse_up_style_template__">
    <setters>
      <stylesetter property="background" value="#eeeeff" />
      <stylesetter property="borderColor" value="#ccccdd" />
    </setters>
  </styletemplate>
</resourcecollection>
  ''')
      .then((_){
        mouseEnterBorderStyle = buckshot.retrieveResource('__TreeView_mouse_enter_style_template__');
        mouseLeaveBorderStyle = buckshot.retrieveResource('__TreeView_mouse_leave_style_template__');
        mouseDownBorderStyle = buckshot.retrieveResource('__TreeView_mouse_down_style_template__');
        mouseUpBorderStyle = buckshot.retrieveResource('__TreeView_mouse_up_style_template__');
      });
  }

  void _onTreeNodeSelected(TreeNode node){
    //not working yet, Dart bug with Timer.
    //treeNodeSelected.invokeAsync(this, new TreeNodeSelectedEventArgs(node));

    treeNodeSelected.invoke(this, new TreeNodeSelectedEventArgs(node));
  }

  void _initializeTreeViewProperties(){
    indentProperty = new FrameworkProperty(this, 'indent'
      , (_) => updateLayout(), 10, converter:const StringToNumericConverter());

    borderColorProperty = new AnimatingFrameworkProperty(
      this,
      "borderColor",
      (value){
        rawElement.style.borderColor = value.color.toString();
      }, 'border', converter:const StringToSolidColorBrushConverter());

    borderThicknessProperty = new FrameworkProperty(
      this,
      "borderThickness",
      (value){

        String color = borderColor != null ? rawElement.style.borderColor : Colors.White.toString();

        //TODO support border hatch styles

        rawElement.style.borderTop = 'solid ${value.top}px $color';
        rawElement.style.borderRight = 'solid ${value.right}px $color';
        rawElement.style.borderLeft = 'solid ${value.left}px $color';
        rawElement.style.borderBottom = 'solid ${value.bottom}px $color';

      }, new Thickness(0), converter:const StringToThicknessConverter());

  }

  void onChildrenChanging(ListChangedEventArgs args){
    super.onChildrenChanging(args);

    args.oldItems.forEach((FrameworkElement element){
      element.removeFromLayoutTree();
    });


    args.newItems.forEach((FrameworkElement element){
      if (element is! TreeNode){
        throw const BuckshotException('TreeView children must be of type TreeNode');
      }
      element.dynamic._parentTreeView = this;
      element.addToLayoutTree(this);
    });
  }

  // FrameworkProperty getters/setters
  num get indent() => getValue(indentProperty);
  set indent(num value) => setValue(indentProperty, value);

  /// Sets the [borderColorProperty] value.
  set borderColor(SolidColorBrush value) => setValue(borderColorProperty, value);
  /// Gets the [borderColorProperty] value.
  SolidColorBrush get borderColor() => getValue(borderColorProperty);

  /// Sets the [borderThicknessProperty] value.
  set borderThickness(Thickness value) => setValue(borderThicknessProperty, value);
  /// Gets the [borderThicknessProperty] value.
  Thickness get borderThickness() => getValue(borderThicknessProperty);


  void createElement(){
    rawElement = new DivElement();
    rawElement.style.overflowX = "auto";
    rawElement.style.overflowY = "auto";
  }
}


class TreeNodeSelectedEventArgs extends EventArgs{
  final TreeNode node;

  TreeNodeSelectedEventArgs(this.node);
}

