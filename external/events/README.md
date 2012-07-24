## Overview ##
This library provides a way for objects to advertise a triggering mechanism, 
which can be subscribed to and handled elsewhere.  The event model follows 
closely the .net event model, with a few allowances for the Dart language.

## Distinction from DOM Events ##
Framework events are not related to DOM events that many web developers are
familiar with, but the concept is the similar.  Whereas DOM events are
pre-defined for various HTML elements, FrameworkEvent can be
customized for use within any Dart application.

## Defining a FrameworkEvent ##
Defining a framework event is performed with this declaration:

    FrameworkEvent<EventArgs> myEvent = new FrameworkEvent<EventArgs>();

The **EventArgs** type parameter tells the event class what type of object will be passed as arguements when the event is fired.  EventArgs can be sub-classed and customized to fit the needs of the event.

## Subscribing To An Event ##
Now that the event is defined, we want to subscribe to it somewhere else in our application:

    myEvent.subscribe((Dynamic sender, EventArgs args){
        //...do stuff here when the event fires
    };

Or more simply, the event can be subscribed to like this:

    myEvent + ((Dynamic sender, EventArgs args){
        //...do stuff here when the event fires
    };

In the example above, we are using an anonymous method to act as our event handler, but we can formalize this a bit more if we want to:

    void myEventHandler(Dynamic sender, EventArgs args){
        //...do stuff here when the event fires
    }
    
    myEvent + myEventHandler;


## Unsubscribing From An Event ##
Modifying our subscription from above, we can obtain a reference to the event subscription like this:

    EventHandlerReference ref = myEvent + myEventHandler;

And unsubscribe like this:

    myEvent.unsubscribe(ref);

Or more simply, this:

    myEvent - ref;

## Firing Events ##
Firing an event is done like this:

    myEvent.invoke(this, new EventArgs());

Or if you want to be more thorough:

    if (myEvent.hasHandlers)
        myEvent.invoke(this, new EventArgs());

In either case, this simple event only sends a reference to it's parent class as the sender, and a basic **EventArgs** instance, which contains no data.  This is appropriate for many events which just need to notify subscribes that "something" happened.  If we want to pass more meaningful data, we will need to create a custom event arguments class.

## Using Customized Event Arguments ##
Lets say our event wanted to pass something useful to subscribers, such an x/y location of something we are interested in.  We can do this by creating our own event arguments class and passing it when the event fires:

    class LocationEventArgs extends EventArgs{
        final int x, y;
    
        LocationEventArgs(this.x, this.y);
    }

> Note: Custom event argument classes **must** derive from EventArgs

Now we can define an event that uses it:

    FrameworkEvent<LocationEventArgs> myLocationEvent = new FrameworkEvent<LocationEventArgs>();

At the stage where the event fires, it might look more like this:

    myLocationEvent.invoke(this, new LocationEventArgs(5, 10)); //passing x=5, y=10 to any event subscribers
