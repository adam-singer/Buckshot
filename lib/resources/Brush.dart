// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.
/**
* A base class for brush objects. */
class Brush extends FrameworkResource
{

  /**
  * Renders the brush output to the given [Element].*/
  abstract void renderBrush(Element component);
}