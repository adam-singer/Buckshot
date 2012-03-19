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

class TestViewModel implements ITestViewModel
{ 
  StackPanel rootPanel;
  
  
  /**
  * Add an output [message] to the given [targetPanel] with optional [indentation] */
  TextBlock addTestMessage(StackPanel targetPanel, String message, [int indentation = 0]){
    TextBlock t = new TextBlock();
    t.text = message;
    t.foreground = new SolidColorBrush(new Color.predefined(Colors.White));
    t.fontSize = 12;
    t.fontFamily = "Consolas";
    if (indentation > 0)
      t.margin = new Thickness.specified(0, 0, 0, indentation);
    targetPanel.children.add(t);
    //LucaSystem.rootView.rootVisual.updateLayout();
    return t;
  }
}
