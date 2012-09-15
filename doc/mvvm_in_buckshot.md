## MVVM in Buckshot ##
Buckshot's API provides support for the [Model-View-ViewModel](http://en.wikipedia.org/wiki/Model_View_ViewModel) (MVVM)
pattern. MVVM provides a good balance of structure and separation of concerns, while at the same time remaining flexible in implementation.

## Components of MVVM ##

## Views ##
Generally speaking, a view is a representation of a buckshot template.  That's all it should do.

Buckshot provides a View class, which helps encapsulate a template for use in applications.

### Constructing Views ###
    // Constructing a view directly from a string template.
    View myView = new View.fromTemplate("<textblock text='Hello world!' />");

Since templates can reside anywhere, the View class provides constructors to retrieve them.

    // Constructing a view residing in an HTML file.
    View myView = new View.fromResource("#myTemplateName");
    
    // Or from a URI
    View myView = new View.fromResource("views/myTemplate.xml");

### View Construction is Asynchronous ###
Before you groan - there are technical reasons for this.  However, the View class handles most of
the heavy lifting work for you, and exposes a **ready** Future so that you can be sure the
view is ready before using it.

    var myView = new View.fromResource("#myTemplate");
	
	myView
	  .ready
	  .then((FrameworkElement rootElement){
	     // The view is ready, do stuff here.
	  })

### Creating View Classes ###
Sometimes, especially in larger applications, you'll want to create dedicated classes to
represent each view.  This is easy using Dart class extensibility:

    // Lets make our own view class
    class MyView extends View
    {
	   MyView() : super.fromResource("#myTemplate");
    }
	
	// now we can use it like so:
    setView(new MyView());
	
### Placing Views in the Web Page ###
Buckshot provies a top-level function called **setView()** to send views to
the web pages.  Buckshot looks for a &lt;DIV&gt; tag with the id of "BuckshotHost"
as a default location for the view.

    <!-- Buckshot looks for a div like this in your web page -->
	<div id='BuckshotHost'></div>

Assuming we have a View object already created called **myView**, we can render
it to the page like so:

    setView(myView);
	
We can also override the default host name to render the view into a different
area of the page:

    // Will set the view into a div with the id of 'someOtherLocation' instead
	// of the default 'BuckshotHost'.
    setView(myView, "someOtherLocation");

**setView()** also returns a Future, in case we want to do something after the view is
loaded:

    setView(myView)
      .then((FrameworkElement rootElement){
	     // View loaded, do some stuff here.
	  });
	 
## View Models ##


## Models ##
