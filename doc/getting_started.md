# Getting Started With Buckshot #

## Hello World ##
Here is the fully functioning Buckshot Hello World application.

### HTML Page ###
    <!-- Make sure you have a div in your web page like so: -->
    <div id='BuckshotHost'></div>

### Code ###
    #import('package:buckshot/buckshot.dart');
	
	main(){
	   setView(new View.fromTemplate("<textblock text='Hello World!' />"));
	}
	
## Your First Project ##
The best way get started with Buckshot is to copy one of the starter projects
located in the example/starter_projects/ folder of the library. 

These projects provide a standarized layout for a Buckshot application using
the [MVVM](http://en.wikipedia.org/wiki/Model_View_ViewModel) pattern.  They are also full of comments.

## Resources ##
Visit the [Buckshot Discussion Group](https://groups.google.com/forum/#!forum/buckshot-ui) for the latest information.

### Videos ###
* [Setting Up A Buckshot Project](http://www.youtube.com/watch?v=9YXeNalVeGA)
* [Working With UI Templates](http://www.youtube.com/watch?v=LOacOkmd9FI)
* [Template Formats](http://www.youtube.com/watch?v=z5kRiTy0obI)

**Many more videos at the [Buckshot playlist on YouTube](http://www.youtube.com/playlist?list=PLE04C8698A5FD2E9E&feature=view_all).**

### Buckshot Online Sandbox ###
[Online Interactive Buckshot](http://www.buckshotui.org/sandbox/)

### Reference Material ###
* [API Reference](http://www.buckshotui.org/docs/)
* [Wiki Documentation](https://github.com/prujohn/Buckshot/wiki/_pages)
* [Developers: How To Contribute](https://github.com/prujohn/Buckshot/wiki/How-To-Contribute)

