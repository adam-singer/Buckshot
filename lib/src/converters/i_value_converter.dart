part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn
// See LICENSE file for Apache 2.0 licensing information.

/**
* Represents a contract for an object that converts value to another value (and back).
*
* Bi-directional conversion not yet supported. */
abstract class IValueConverter
{

  /// Returns a converted value from a given [Dynamic] value and optional [Dynamic]
  /// parameter.
  abstract dynamic convert(dynamic value, {dynamic parameter});

  //TODO implement two-way conversion support
}
