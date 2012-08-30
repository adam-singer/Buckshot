// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

class Error extends View
{
  Error(){
    Template.deserialize(Template.getTemplate('#error'))
    .then((t){
      rootVisual = t;
    });
  }
}
