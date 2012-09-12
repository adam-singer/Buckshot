# Getting Started With Buckshot #

## Your First Project ##
The best way get started with Buckshot is to copy one of the starter projects
located in the example/starter_projects/ folder of the library.  

These projects provide a standarized layout for a Buckshot application that uses
the MVVM pattern.


## Using Pub ##
In your Dart application, make a **pubspec.yaml** file and add this line to it:

    dependencies:
      buckshot:
        git: git://github.com/prujohn/Buckshot.git
        
From the command line, change directory to the root of your Dart project, then run pub install

    pub install
    
pub will go out and retrieve buckshot for you, including any of it's dependencies, then placing it in a **packages** directory in your project.

Next you'll need to point the Dart editor to your package directory.  You can set this in the Dart Editor's preferences dialog (Tools -> Preferences).

Now you can reference buckshot in your application like so:

    #import('package:buckshot/buckshot.dart');
    
This process should get easier over time as the pub utility matures.


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

