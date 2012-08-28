// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#library('dockpanel.controls.buckshotui.org');

#import('dart:html');
#import('../../lib/Buckshot.dart');
#import('package:DartNet-Event-Model/events.dart');
#import('../../external/shared/shared.dart');
#import('../../external/web/web.dart');

/**
 * A panel element that supports docking of child elements within it.
 */
class DockPanel extends Panel
{
  static AttachedFrameworkProperty dockProperty;

  FrameworkProperty fillLastProperty;

  DockPanel()
  {
    Browser.appendClass(rawElement, "DockPanel");

    _initDockPanelProperties();

    loaded + (_, __) => invalidate();
  }

  void _initDockPanelProperties(){

    fillLastProperty = new FrameworkProperty(this, 'fillLast', defaultValue:true,
      converter:const StringToBooleanConverter());
  }

  void onChildrenChanging(ListChangedEventArgs args){
    if (isLoaded){
      invalidate();
    }
  }

  bool get fillLast => getValue(fillLastProperty);
  set fillLast(bool value) => setValue(fillLastProperty, value);

  /**
  * Sets given [DockLocation] value to the Dockpanel.dockProperty
  * for the given [element]. */
  static void setDock(FrameworkElement element, value){
    assert(value is String || value is DockLocation);

    if (element == null) return;

    value = const StringToLocationConverter().convert(value);

    if (DockPanel.dockProperty == null)
      DockPanel.dockProperty = new AttachedFrameworkProperty("dock",
        (FrameworkElement e, DockLocation l){});

    AttachedFrameworkProperty.setValue(element, dockProperty, value);

  }

  /**
  * Returns the [DockLocation] value currently assigned to the
  * Dockpanel.dockProperty for the given element. */
  static DockLocation getDock(FrameworkElement element){
    if (element == null) return DockLocation.left;

    final value = AttachedFrameworkProperty.getValue(element, dockProperty);

    if (DockPanel.dockProperty == null || value == null)
      DockPanel.setDock(element, DockLocation.left);

    return AttachedFrameworkProperty.getValue(element, dockProperty);
  }


  /** Invalidates the DockPanel layout and causes it to redraw. */
  void invalidate(){
    //TODO .removeLast() instead?
    rawElement.elements.clear();

    var currentContainer = rawElement;
    var lastLocation = DockLocation.left;

    //makes a flexbox container
    Element createContainer(DockLocation loc){
      final c = new RawHtml();

      Polly.makeFlexBox(c.rawElement);

      Polly.setFlexBoxOrientation(c, (loc == DockLocation.left
          || loc == DockLocation.right) ? Orientation.horizontal : Orientation.vertical);

      //set the orientation
//      Polly.setCSS(c, 'flex-direction', (loc == DockLocation.left
//          || loc == DockLocation.right) ? 'row' : 'column');

      //set the stretch
      Polly.setCSS(c.rawElement, 'flex', '1 1 auto');

      //make container-level adjustments based on the dock location.
      switch(loc.toString()){
        case 'right':
          Polly.setCSS(c.rawElement, 'justify-content', 'flex-end');
          break;
        case 'top':
          Polly.setCSS(c.rawElement, 'justify-content', 'flex-start');
          Polly.setCSS(c.rawElement, 'align-items', 'stretch');
          break;
        case 'bottom':
          Polly.setCSS(c.rawElement, 'justify-content', 'flex-end');
          Polly.setCSS(c.rawElement, 'align-items', 'stretch');
          break;
      }

      return c.rawElement;
    }

    // Adds child to container with correct alignment and ordering.
    void addChild(Element container, FrameworkElement child, DockLocation loc){
      if (loc == DockLocation.top || loc == DockLocation.bottom){
        Polly.setCSS(child.rawElement, 'flex', 'none');
      }

      if ((loc == DockLocation.right || loc == DockLocation.bottom)
          && (container.elements.length > 0)){
        container.insertBefore(child.rawElement, container.elements[0]);
      }else{
        container.elements.add(child.rawElement);
      }
    }

    children.forEach((child){
      child.parent = this;

      if (currentContainer == rawElement){
        lastLocation = DockPanel.getDock(child);

        final newContainer = createContainer(lastLocation);

        addChild(newContainer, child, lastLocation);

        currentContainer.elements.add(newContainer);

        currentContainer = newContainer;
      }else{
        final loc = DockPanel.getDock(child);

        if (loc == lastLocation){
          addChild(currentContainer, child, lastLocation);
        }else{

          final newContainer = createContainer(loc);

          addChild(newContainer, child, loc);

          if ((lastLocation == DockLocation.right ||
              lastLocation == DockLocation.bottom)
              && (currentContainer.elements.length > 0)){
            currentContainer.insertBefore(newContainer,
              currentContainer.elements[0]);
          }else{
            currentContainer.elements.add(newContainer);
          }

          currentContainer = newContainer;
          lastLocation = loc;
        }
      }

    });

    //stretch the last item to fill the remaining space
    if (fillLast && !children.isEmpty()){
      final child = children.last();
      //stretch the last item to fill the remaining space
      final p = child.rawElement.parent;

      assert(p is Element);

      Polly.setCSS(child.rawElement, 'flex', '1 1 auto');

      Polly.setCSS(child.rawElement, 'align-self', 'stretch');
    }
  }

  /// Overridden [FrameworkObject] method.
  void createElement(){
    rawElement = new DivElement();
    rawElement.style.overflow = "hidden";
    Polly.makeFlexBox(rawElement);
    Polly.setVerticalFlexBoxAlignment(this, VerticalAlignment.stretch);
    Polly.setHorizontalFlexBoxAlignment(this, HorizontalAlignment.stretch);
  }
}



/*
 * Internal container element for DockPanel cells.
 */
class _DockPanelCell extends FrameworkElement
{
  /// Represents the content inside the border.
  FrameworkProperty contentProperty;
  final DockLocation location;

  _DockPanelCell()
      : location = DockLocation.left
  {
    _initDockPanelCellProperties();

    stateBag[FrameworkObject.CONTAINER_CONTEXT] = contentProperty;
  }

  _DockPanelCell.withLocation(DockLocation this.location){
    _initDockPanelCellProperties();

    stateBag[FrameworkObject.CONTAINER_CONTEXT] = contentProperty;
  }

  void _initDockPanelCellProperties(){
    //register the dependency properties
    contentProperty = new FrameworkProperty(
      this,
      "content", (FrameworkElement c)
      {
        if (contentProperty.previousValue != null){
          contentProperty.previousValue.removeFromLayoutTree();
        }

        if (c != null){
          setContentDockLocation();
          c.addToLayoutTree(this);
        }
      });
  }

  void setContentDockLocation(){
    switch(location){
      case DockLocation.left:
        content.hAlign = HorizontalAlignment.left;
        content.vAlign = VerticalAlignment.stretch;
        break;
      case DockLocation.top:
        content.hAlign = HorizontalAlignment.stretch;
        content.vAlign = VerticalAlignment.top;
        break;
      case DockLocation.right:
        content.hAlign = HorizontalAlignment.right;
        content.vAlign = VerticalAlignment.stretch;
        break;
      case DockLocation.bottom:
        content.hAlign = HorizontalAlignment.stretch;
        content.vAlign = VerticalAlignment.bottom;
        break;
    }
  }

  FrameworkElement get content => getValue(contentProperty);
  set content(FrameworkElement value) => setValue(contentProperty, value);

  /// Overridden [FrameworkObject] method for generating the html representation of the border.
  void createElement(){
    rawElement = new DivElement();
    rawElement.style.overflow = "hidden";
    Polly.makeFlexBox(rawElement);
  }

  /// Overridden [FrameworkObject] method is called when the framework requires elements to recalculate layout.
  void updateLayout(){
    if (content == null) return;

    //spoof the parent during the alignment pass
    content.parent = this;
    Polly.setFlexboxAlignment(content);
    content.parent = parent;
  }
}
