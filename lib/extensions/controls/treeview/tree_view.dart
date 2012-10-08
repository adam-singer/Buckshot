// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#library('treeview.controls.buckshotui.org');

#import('dart:html');
#import('package:buckshot/buckshot.dart');
#import('package:dartnet_event_model/events.dart');
#import('package:buckshot/web/web.dart');

#source('tree_node.dart');

/**
* Displays a heirachical list of [TreeNode] elements.
*/
class TreeView extends Panel
{
  static const String INDICATOR_COLLAPSED = '\u{25b7}';
  static const String INDICATOR_EXPANDED = '\u{25e2}';

  static const String FILE_DEFAULT_TEMPLATE =
      '''
<border width='16' height='16' cornerradius='2' borderthickness='1' bordercolor='{resource theme_border_color_dark}' background='{resource theme_background_dark}'>
  <stackpanel halign='stretch' valign='center'>
    <border margin='2,1' borderthickness='1' bordercolor='LightGray' halign='stretch' />
    <border margin='3,1' borderthickness='1' bordercolor='LightGray' halign='stretch' />
    <border margin='2,1' borderthickness='1' bordercolor='LightGray' halign='stretch' />
  </stackpanel>
</border>
''';


  static const String FOLDER_DEFAULT_TEMPLATE =
      '''
<layoutcanvas width='16' height='16'>
  <border width='16' height='14' layoutcanvas.top='1' cornerradius='2' borderthickness='1' bordercolor='{resource theme_border_color_dark}' background='{resource theme_background_dark}' />
  <border layoutcanvas.left='10' width='6' height='14' cornerradius='2' borderthickness='1' bordercolor='{resource theme_border_color_dark}' background='{resource theme_background_dark}' />
  <border layoutcanvas.top='5' height='10' width='16' cornerradius='2' borderthickness='1' bordercolor='{resource theme_border_color_dark}' background='{resource theme_background_dark}' />
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
  FrameworkProperty selectedNodeProperty;

  /// Event which fires when a node is selected in the TreeView.
  final FrameworkEvent<TreeNodeSelectedEventArgs> treeNodeSelected =
      new FrameworkEvent<TreeNodeSelectedEventArgs>();

  TreeView()
  {
    Browser.appendClass(rawElement, "TreeView");

    _initializeTreeViewProperties();

    initStyleTemplates();

    cursor = Cursors.Arrow;

    background = new SolidColorBrush(new Color.predefined(Colors.White));

    registerEvent('treenodeselected', treeNodeSelected);
  }

  TreeView.register() : super.register(){
    buckshot.registerElement(new TreeNode.register());
  }
  makeMe() => new TreeView();

  /**
   * Override this method to customize the mouse event styles on [TreeNode]s.
   */
  void initStyleTemplates(){
    Template
      .deserialize('''
<resourcecollection>
  <styletemplate key="__TreeView_mouse_enter_style_template__">
    <setters>
      <setter property="background" value="{resource theme_background_dark}" />
      <setter property="borderColor" value="{resource theme_border_color}" />
    </setters>
  </styletemplate>

  <styletemplate key="__TreeView_mouse_leave_style_template__">
    <setters>
      <setter property="background" value="{resource theme_background_light}" />
      <setter property="borderColor" value="{resource theme_background_light}" />
    </setters>
  </styletemplate>

  <styletemplate key="__TreeView_mouse_down_style_template__">
    <setters>
      <setter property="background" value="{resource theme_background_mouse_down}" />
      <setter property="borderColor" value="{resource theme_border_color}" />
    </setters>
  </styletemplate>

  <styletemplate key="__TreeView_mouse_up_style_template__">
    <setters>
      <setter property="background" value="{resource theme_background_dark}" />
      <setter property="borderColor" value="{resource theme_border_color}" />
    </setters>
  </styletemplate>
</resourcecollection>
  ''')
      .then((_){
        mouseEnterBorderStyle = FrameworkResource.retrieveResource('__TreeView_mouse_enter_style_template__');
        mouseLeaveBorderStyle = FrameworkResource.retrieveResource('__TreeView_mouse_leave_style_template__');
        mouseDownBorderStyle = FrameworkResource.retrieveResource('__TreeView_mouse_down_style_template__');
        mouseUpBorderStyle = FrameworkResource.retrieveResource('__TreeView_mouse_up_style_template__');
      });
  }

  /** Selects a [node] as the active node. */
  void selectNode(TreeNode node) => _onTreeNodeSelected(node);

  /** Clears the selectged node. */
  void clearSelectedNode(){
    if (selectedNode == null) return;

    setValue(selectedNode._mouseEventStylesProperty, mouseLeaveBorderStyle);
    selectedNode == null;
  }


  void _onTreeNodeSelected(TreeNode node){

    if (selectedNode != null){
      setValue(selectedNode._mouseEventStylesProperty, mouseLeaveBorderStyle);
    }

    selectedNode = node;
    setValue(selectedNode._mouseEventStylesProperty, mouseUpBorderStyle);
    treeNodeSelected.invoke(this, new TreeNodeSelectedEventArgs(node));
  }

  void _initializeTreeViewProperties(){
    selectedNodeProperty = new FrameworkProperty(this, 'selectedNode');

    indentProperty = new FrameworkProperty(this, 'indent'
      , (_) => updateLayout(), 10, converter:const StringToNumericConverter());

    borderColorProperty = new AnimatingFrameworkProperty(
      this,
      "borderColor",
      'border',
      propertyChangedCallback: (value){
        rawElement.style.borderColor = value.color.toColorString();
      },
      converter:const StringToSolidColorBrushConverter());

    borderThicknessProperty = new FrameworkProperty(
      this,
      "borderThickness",
      propertyChangedCallback:
        (value){

        String color = borderColor != null ? rawElement.style.borderColor : Colors.White.toString();

        //TODO support border hatch styles

        rawElement.style.borderTop = 'solid ${value.top}px $color';
        rawElement.style.borderRight = 'solid ${value.right}px $color';
        rawElement.style.borderLeft = 'solid ${value.left}px $color';
        rawElement.style.borderBottom = 'solid ${value.bottom}px $color';

      },
      defaultValue:new Thickness(0),
      converter:const StringToThicknessConverter());

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
      element._parentTreeView = this;
      element.addToLayoutTree(this);
    });
  }

  // FrameworkProperty getters/setters
  TreeNode get selectedNode => getValue(selectedNodeProperty);
  set selectedNode(TreeNode node) => setValue(selectedNodeProperty, node);

  num get indent => getValue(indentProperty);
  set indent(num value) => setValue(indentProperty, value);

  /// Sets the [borderColorProperty] value.
  set borderColor(SolidColorBrush value) => setValue(borderColorProperty, value);
  /// Gets the [borderColorProperty] value.
  SolidColorBrush get borderColor => getValue(borderColorProperty);

  /// Sets the [borderThicknessProperty] value.
  set borderThickness(Thickness value) => setValue(borderThicknessProperty, value);
  /// Gets the [borderThicknessProperty] value.
  Thickness get borderThickness => getValue(borderThicknessProperty);


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

