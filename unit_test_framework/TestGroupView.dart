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

class TestGroupView implements IView
{
  FrameworkElement _rootElement;
  final StackPanel _rootPanel;
  
  TestGroupView(this._rootPanel, TestGroupBase group){
    _rootElement = _createGroupUI(group);
  }
  
  FrameworkElement get rootVisual() => _rootElement;
  
  /**
  * Generates UI for a unit test [group] and returns the content stackpanel */
  StackPanel _createGroupUI(TestGroupBase group){
    StackPanel groupPanel = new StackPanel();
    
    StackPanel headerPanel = new StackPanel();
    headerPanel.orientation = Orientation.horizontal;
    
    StackPanel contentPanel = new StackPanel();
    contentPanel.margin = new Thickness.specified(0,0,0,20);
    
    groupPanel.children.add(headerPanel);
    groupPanel.children.add(contentPanel);
    
    var btnCollapse = new Button();
    btnCollapse.content = "-";
    btnCollapse.width = 25;
    btnCollapse.height = 25;
    
    btnCollapse.click + (_, __) {
      if (contentPanel.visibility == Visibility.visible){
        contentPanel.visibility = Visibility.collapsed;
        btnCollapse.content = "+";
        
      }else{
        contentPanel.visibility = Visibility.visible;
        btnCollapse.content = "-";
      }
    };
    
    headerPanel.children.add(btnCollapse);
    
    TextBlock t = new TextBlock();
    t.text = "${group.testGroupName} (${group.testList.length})";
    t.foreground = new SolidColorBrush(new Color.hex("#00FF00"));
    t.fontSize = 14;
    t.fontFamily = "Consolas";
    headerPanel.children.add(t);
    
    _rootPanel.children.add(groupPanel);
    
    return contentPanel;
  }
}
