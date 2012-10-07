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
  abstract Dynamic convert(Dynamic value, [Dynamic parameter]);

  //TODO implement two-way conversion support
}
