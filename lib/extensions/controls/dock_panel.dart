// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#library('dockpanel.controls.buckshotui.org');

#import('dart:html');
#import('package:buckshot/buckshot.dart');
#import('package:dartnet_event_model/events.dart');
#import('package:buckshot/web/web.dart');
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

    if (!reflectionEnabled){
      buckshot.registerAttachedProperty('dockpanel.dock', DockPanel.setDock);
    }

    _initDockPanelProperties();
  }

  DockPanel.register() : super.register();
  makeMe() => new DockPanel();

  void _initDockPanelProperties(){

    fillLastProperty = new FrameworkProperty(this, 'fillLast', defaultValue: true,
      converter:const StringToBooleanConverter());
  }

  void onChildrenChanging(ListChangedEventArgs args){
    if (isLoaded){
      invalidate();
    }
  }

  void onFirstLoad() => invalidate();

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
    if (Polly.flexModel != FlexModel.Flex){
      try{
      _invalidatePolyfill();
      }
      catch(e, stack){
        print('>>> ERROR: $e $stack');
      }
      return;
    }

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

  static int _gridCount = 0;
  // Used by DockPanel when display:flex is not available.
  //
  // The polyfill in this case uses nested Grid 2-column or 2-row elements for
  // each child.
  _invalidatePolyfill(){

    //TODO .removeLast() instead?
//    children.forEach((FrameworkObject child){
//      child.removeFromLayoutTree();
//    });

    var currentContainer = this;
    var lastLocation = DockLocation.left;

    //makes a flexbox container
    Grid createContainer(DockLocation loc){
      // set the grid row/column definitions based on position

      final g = new Grid()
                    ..hAlign = HorizontalAlignment.stretch
                    ..vAlign = VerticalAlignment.stretch
                    ..name = 'grid_${_gridCount++}'
                    ..background = new SolidColorBrush(new Color.predefined(Colors.Yellow));

      switch(loc){
        case DockLocation.left:
          g.columnDefinitions.add(new ColumnDefinition.with(new GridLength.auto()));
          g.columnDefinitions.add(new ColumnDefinition.with(new GridLength.star(1)));
          g.rowDefinitions.add(new RowDefinition.with(new GridLength.star(1)));
          return g;
        case DockLocation.right:
          g.columnDefinitions.add(new ColumnDefinition.with(new GridLength.star(1)));
          g.columnDefinitions.add(new ColumnDefinition.with(new GridLength.auto()));
          g.rowDefinitions.add(new RowDefinition.with(new GridLength.star(1)));
          return g;
        case DockLocation.top:
          g.rowDefinitions.add(new RowDefinition.with(new GridLength.auto()));
          g.rowDefinitions.add(new RowDefinition.with(new GridLength.star(1)));
          g.columnDefinitions.add(new ColumnDefinition.with(new GridLength.star(1)));
          return g;
        case DockLocation.bottom:
          g.rowDefinitions.add(new RowDefinition.with(new GridLength.star(1)));
          g.rowDefinitions.add(new RowDefinition.with(new GridLength.auto()));
          g.columnDefinitions.add(new ColumnDefinition.with(new GridLength.star(1)));
          return g;
      }

    }

    // Adds child to container with correct alignment and ordering.
    void addDockedChild(Grid container, FrameworkElement child, DockLocation loc){
      switch(loc){
        case DockLocation.left:
          Grid.setColumn(child, 0);
          Grid.setRow(child, 0);
          child.hAlign = HorizontalAlignment.left;
          child.vAlign = VerticalAlignment.stretch;
          break;
        case DockLocation.right:
          Grid.setColumn(child, 1);
          Grid.setRow(child, 0);
          child.hAlign = HorizontalAlignment.right;
          child.vAlign = VerticalAlignment.stretch;
          break;
        case DockLocation.top:
          Grid.setColumn(child, 0);
          Grid.setRow(child, 0);
          child.hAlign = HorizontalAlignment.stretch;
          child.vAlign = VerticalAlignment.top;
          break;
        case DockLocation.bottom:
          Grid.setColumn(child, 0);
          Grid.setRow(child, 1);
          child.hAlign = HorizontalAlignment.stretch;
          child.vAlign = VerticalAlignment.bottom;
          break;
      }

      container.children.add(child);
    }

    children.forEach((child){
//      child.parent = this;

      if (currentContainer == this){
        lastLocation = DockPanel.getDock(child);

        final newContainer = createContainer(lastLocation);

        addDockedChild(newContainer, child, lastLocation);

//        print('....first container');
//        printTree(newContainer);

        newContainer.addToLayoutTree(currentContainer);

        Polly.setFlexboxAlignment(newContainer);

        currentContainer = newContainer;
      }else{
        final location = DockPanel.getDock(child);

        final newContainer = createContainer(location);

        addDockedChild(newContainer, child, location);
//        print('....new container');
//        printTree(newContainer);


        switch(lastLocation){
          case DockLocation.left:
            Grid.setColumn(newContainer, 1);
            break;
          case DockLocation.right:
            Grid.setColumn(newContainer, 0);
            break;
          case DockLocation.top:
            Grid.setRow(newContainer, 1);
            break;
          case DockLocation.bottom:
            Grid.setRow(newContainer, 0);
            break;
        }

        currentContainer.children.add(newContainer);

//        print('....current container');
//        printTree(currentContainer);


        //print('$currentContainer column defs: ${currentContainer.columnDefinitions} ${Grid.getColumn(newContainer)}');

        lastLocation = location;

        currentContainer = newContainer;
      }
    });

    //stretch the last item to fill the remaining space
//    if (fillLast && !children.isEmpty()){
//      final child = children.last();
//      //stretch the last item to fill the remaining space
//      final p = child.rawElement.parent;
//
//      assert(p is Element);
//
//      Polly.setCSS(child.rawElement, 'flex', '1 1 auto');
//
//      Polly.setCSS(child.rawElement, 'align-self', 'stretch');
//    }
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
