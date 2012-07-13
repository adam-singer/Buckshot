// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
 * A panel element that supports docking of child elements within it.
 */
class DockPanel extends Panel
{
  static AttachedFrameworkProperty dockProperty;
  
  FrameworkProperty fillLastProperty; 
  
  DockPanel()
  {
    Dom.appendBuckshotClass(rawElement, "DockPanel");
    
    _initDockPanelProperties();
  
    loaded + (_, __) => _redraw();
  }
  
  void _initDockPanelProperties(){
    
    fillLastProperty = new FrameworkProperty(this, 'fillLast', (_){}, true,
      converter:const StringToBooleanConverter());
  }
  
  void onChildrenChanging(ListChangedEventArgs args){    
    if (isLoaded){
      _redraw();
    }
  }
  
  bool get fillLast() => getValue(fillLastProperty);
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

    FrameworkObject.setAttachedValue(element, dockProperty, value);

  }

  /**
  * Returns the [DockLocation] value currently assigned to the
  * Dockpanel.dockProperty for the given element. */
  static DockLocation getDock(FrameworkElement element){
    if (element == null) return DockLocation.left;

    final value = FrameworkObject.getAttachedValue(element, dockProperty);

    if (DockPanel.dockProperty == null || value == null)
      DockPanel.setDock(element, DockLocation.left);

    return FrameworkObject.getAttachedValue(element, dockProperty);
  }
  
  
  void _redraw(){
    //TODO .removeLast() instead? 
    rawElement.elements.clear();
    
    var currentContainer = rawElement;
    var lastLocation = DockLocation.left;
    
    //makes a flexbox container
    createContainer(DockLocation loc){
      final c = new DivElement();

      // make a flexbox
      Dom.prefixes.forEach((String p){
        var pre = '${p}box';
        c.style.display = pre;
        pre = '${p}flexbox';
        c.style.display = pre;
        pre = '${p}flex';
        c.style.display = pre;
      });
            
      //set the orientation
      Dom.setXPCSS(c, 'flex-direction', (loc == DockLocation.left 
          || loc == DockLocation.right) ? 'row' : 'column');
      
      //set the stretch
      Dom.setXPCSS(c, 'flex', '1 1 auto');
      
      //make container-level adjustments based on the dock location.
      switch(loc.toString()){
        case 'right':
          Dom.setXPCSS(c, 'justify-content', 'flex-end');
          break;
        case 'top':
          Dom.setXPCSS(c, 'justify-content', 'flex-start');
          Dom.setXPCSS(c, 'align-items', 'stretch');
          break;
        case 'bottom':
          Dom.setXPCSS(c, 'justify-content', 'flex-end');
          Dom.setXPCSS(c, 'align-items', 'stretch');
          break;
      }
            
      return c;
    }
    
    // Adds child to container with correct alignment and ordering.
    void addChild(Element container, FrameworkElement child, DockLocation loc){
      if (loc == DockLocation.top || loc == DockLocation.bottom){
       Dom.setXPCSS(child.rawElement, 'flex', 'none');
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
      
      //stretch the last item to fill the remaining space
      if (fillLast && children.last() == child){
        //stretch the last item to fill the remaining space
        final p = child.rawElement.parent;
        
        assert(p is Element);
        
        Dom.setXPCSS(child.rawElement, 'flex', '1 1 auto');
        
        Dom.setXPCSS(child.rawElement, 'align-self', 'stretch');
      }
    });
    
  }
  
  /// Overridden [FrameworkObject] method.
  void createElement(){
    rawElement = new DivElement();
    rawElement.style.overflow = "hidden";
    Dom.makeFlexBox(this);
    Dom.setVerticalFlexBoxAlignment(this, VerticalAlignment.stretch);
    Dom.setHorizontalFlexBoxAlignment(this, HorizontalAlignment.stretch);
  }
  
  FrameworkObject makeMe() => new DockPanel();
  
  String get type() => 'DockPanel';
}