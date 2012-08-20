// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Represents a View definition for the framework.
*
* (in the MVVM context of a "view")
*
*/
class View {
  FrameworkElement _rootElement;
  final Completer _c;

  /**
   * Future completes when view is ready (has an element assigned to
   * rootVisual).
   */
  Future<bool> ready;

  /// Gets the visual root of the view.
  FrameworkElement get rootVisual() => _rootElement;
  set rootVisual(FrameworkElement element) {
    if (_rootElement != null){
      throw const BuckshotException('View already initialized.');
    }

    if (element == null){
      throw const BuckshotException('Expected a FrameworkElement'
          ' that is not null.');
    }

    _rootElement = element;

    _c.complete(true);
  }

  View()
      :
        _c = new Completer()
  {
    ready = _c.future;
  }

  /**
   * Constructs a view from a given template [resourceName].  Depending on
   * what is provided in the string (Uri, or DOM id ['#something']), the
   * constructor will retrieve the resource and deserialize it.
   */
  View.fromTemplate(String resourceName)
        :
        _c = new Completer()
  {
    ready = _c.future;

    Template
      .deserialize(Template.getTemplate(resourceName))
      .then((t) => rootVisual = t);
  }

  /** Constructs a view from a given [element]. */
  View.from(FrameworkElement element)
      :
        _c = new Completer()
  {
        ready = _c.future;
        rootVisual = element;
  }

  /** Sets this [IView] as the rootView of the Buckshot application. */
  void setAsRootView() { buckshot.rootView = this; }

}
