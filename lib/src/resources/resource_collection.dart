part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Contains a group of [FrameworkResource]s.  */
class ResourceCollection extends FrameworkResource implements FrameworkContainer
{
  final ObservableList<FrameworkResource> resources;

  ResourceCollection(): resources = new ObservableList<FrameworkResource>()
  {
    stateBag[FrameworkObject.CONTAINER_CONTEXT] = resources;

    resources.listChanged + _onListChanging;
  }

  ResourceCollection.register() : super.register(),
    resources = new ObservableList<FrameworkResource>();
  makeMe() => new ResourceCollection();

  get containerContent => resources;

  void _onListChanging(Object _, ListChangedEventArgs args){

    if (!args.newItems.isEmpty){
      args.newItems.forEach((FrameworkResource r){

        //throw on non-resources in this collection or attempts to nest collections
        if (!(r is FrameworkResource) || r is ResourceCollection) {
          throw const BuckshotException("Invalid resource found in ResourceCollection.");
        }
      });
    }
  }
}
