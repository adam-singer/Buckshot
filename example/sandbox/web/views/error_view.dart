// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

part of sandbox;

class ErrorView extends View
{
  ErrorView() : super.fromResource('web/views/templates/error.xml')
  {
    ready.then((t){
      rootVisual = t;
    });
  }
}
