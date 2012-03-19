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

/**
* A demo view model for displaying information in tryit.
*
* Objects that participate in data binding must derive from [LucaObject].
* ([ViewModelBase] does)
*
* Properties that need to be bound to must be of type [FrameworkProperty].
*/
class DemoViewModel extends ViewModelBase
{
  final DemoModel model;
  
  //declare our framework properties
  FrameworkProperty timeStampProperty, 
                    videosProperty, 
                    colorProperty,
                    fruitProperty,
                    iconsProperty;
  
  DemoViewModel()
  :
    model = new DemoModel()
  {
    _initDemoViewModelProperties();
    
    // Update the timeStampProperty every second with a new timestamp.
    // Anything binding to this will get updated.
    window.setInterval(() => setValue(timeStampProperty, new Date.now().toString()), 1000);
  }
  
  // Initialize the properties that we want to allow binding to.
  void _initDemoViewModelProperties(){
            
    // initialize the framework properties
    
    timeStampProperty = new FrameworkProperty(this, "timeStamp", (v){}, new Date.now().toString());
    
    iconsProperty = new FrameworkProperty(this, "icons", (_){}, model.iconList);
    
    videosProperty = new FrameworkProperty(this, "videos", (_){}, model.videoList);
       
    fruitProperty = new FrameworkProperty(this, "fruit", (_){}, model.fruitList);
    
    // Since colorProperty is itself a LucaObject, the framework will allow dot-notation
    // resolution to any properties within that object as well. 
    // ex. "color.red" or "color.orange"
    colorProperty = new FrameworkProperty(this, "color", (_){}, model.colorClass);
  }
}