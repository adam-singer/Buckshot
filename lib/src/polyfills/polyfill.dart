
/** Base class for Polyfills */
abstract class Polyfill
{
  /** Begins the polyfill on the given element. */
  abstract void begin(FrameworkElement element);

  /** Removes the polyfill on the element given in begin() */
  abstract void end();
}