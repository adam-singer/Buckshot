part of core_buckshotui_org;


/** Base class for Polyfills */
abstract class Polyfill extends HashableObject
{
  final FrameworkElement element;

  /** Constructs a polyfill with the given element. */
  Polyfill(FrameworkElement this.element);

  /** Requires the polyfill to recalcuate. */
  abstract void invalidate();
}