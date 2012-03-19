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
* Contains a group of [FrameworkResource]s.  */
class ResourceCollection extends FrameworkResource
{
  final ObservableList<FrameworkResource> resources;
  
  LucaObject makeMe() => new ResourceCollection();
  
  ResourceCollection(): resources = new ObservableList<FrameworkResource>()
  {
    this._stateBag[FrameworkObject.CONTAINER_CONTEXT] = resources;
    
    resources.listChanged + _onListChanging;
  }
  
  void _onListChanging(Object _, ListChangedEventArgs args){
    
    if (!args.newItems.isEmpty()){
      args.newItems.forEach((FrameworkResource r){

        //throw on non-resources in this collection or attempts to nest collections
        if (!(r is FrameworkResource) || r is ResourceCollection)
          throw const FrameworkException("Invalid resource found in ResourceCollection.");
      });
    }
  }
  
  String get _type() => "ResourceCollection";
}
