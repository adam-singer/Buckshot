part of genie_buckshot_org;

/**
 * Enumerates options for code generation.
 */
class GenOption
{
  final String _str;

  const GenOption(this._str);

  /// Return only the _g classes.
  static const ONLY_G_FILES = const GenOption('ONLY_G_FILES');
  /// Suppress generation of FrameworkProperty binding stubs.
  static const NO_BINDINGS = const GenOption('NO_BINDINGS');
  /// Suppress generation of event handler stubs.
  static const NO_EVENTS = const GenOption('NO_EVENTS');
  /// Suppress generation of named element fields.
  static const NO_ELEMENTS = const GenOption('NO_ELEMENTS');
  /// Suppress attempts to find matching Type of a named element.
  static const NO_TYPE_LOOKUP = const GenOption('NO_TYPE_LOOKUP');
  /// Puts event handlers into the top-level, instead of in view model.
  static const EVENTS_TO_TOP = const GenOption('EVENTS_TO_TOP');
  /**
   * Put a String of the template into the class and uses it for
   * deserialization.
   */
  static const EMBED_TEMPLATE = const GenOption('EMBED_TEMPLATE');
  /// Suppress comments.
  static const NO_COMMENTS = const GenOption('NO_COMMENTS');

  String toString() => _str;
}