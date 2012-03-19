//   Copyright (c) 2012, John Evans & LUCA Studios LLC
//
//   http://www.lucastudios.com/contact
//   John: https://plus.google.com/u/0/115427174005651655317/about
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

class TestView implements IView {
  FrameworkElement _rootElement;
  final ITestViewModel _vm;
  
  TestView.with(ITestViewModel this._vm){
    _rootElement = _mainView();
  }
  
  FrameworkElement get rootVisual() => _rootElement;
  
  Border _mainView(){
    Border b = new Border();
    b._component.style.position = "absolute";
    b._component.style.zIndex = "9999";
    b._component.style.left = "0";
    b._component.style.top = "0";
    b.background = new SolidColorBrush(new Color.hex("#555555"));
    b.borderColor = new SolidColorBrush(new Color.predefined(Colors.Black));
    b.borderThickness = new Thickness(2);
    b.padding = new Thickness(10);
//    b.height = 500;
//    b.width = 500;

    var wrapperPanel = new StackPanel();
    
    _vm.rootPanel = new StackPanel();
    
    b.content = wrapperPanel;
    
    TextBlock t = new TextBlock();
    t.text = "Unit Test Results";
    t.foreground = new SolidColorBrush(new Color.predefined(Colors.Yellow));
    t.fontSize = 16;
    t.fontFamily = "Consolas";
    
    _vm.rootPanel.children.add(t);

    var btnCollapseToggle = new Button();
    
    btnCollapseToggle.content = "Hide";
    
    btnCollapseToggle.click + (_, __) {
      if (_vm.rootPanel.visibility == Visibility.visible){
        _vm.rootPanel.visibility = Visibility.collapsed;
        b.opacity = .5;  
        btnCollapseToggle.content = "Show";
        
      }else{
        _vm.rootPanel.visibility = Visibility.visible;
        b.opacity = 1.0;
        btnCollapseToggle.content = "Hide";
      }
    };
    
    wrapperPanel.children.add(btnCollapseToggle);
    wrapperPanel.children.add(_vm.rootPanel);
    
    return b;
  }
}
