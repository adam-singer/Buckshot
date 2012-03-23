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
* Represents a property of an element that can be attached loosely to other elements.
* Note that attached properties do not participate in the data binding model (they cannot
* bind or be bound to). */
class AttachedFrameworkProperty extends FrameworkPropertyBase 
{
   
    AttachedFrameworkProperty(String propertyName, Function propertyChangedCallback)
      : super(null, propertyName, propertyChangedCallback)
      { 
        BuckshotSystem._attachedProperties[this] = new HashMap<FrameworkElement, Dynamic>();
      }
    
    String get _type() => "AttachedFrameworkProperty";
}