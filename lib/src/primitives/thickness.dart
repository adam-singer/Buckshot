part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Describes the thickness of a frame around a rectangle. */
class Thickness
{
  final num left, top, right, bottom;

  Thickness(num uniformThickness) :
    left = uniformThickness,
    right = uniformThickness,
    top = uniformThickness,
    bottom = uniformThickness;

  Thickness.specified(this.top, this.right, this.bottom, this.left);

  Thickness.widthheight(num width, num height) :
    left = width,
    right = width,
    top = height,
    bottom = height;

  String toString() => "$top $right $bottom $left";
}

