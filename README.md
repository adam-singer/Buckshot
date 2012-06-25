![Buckshot Logo](http://www.lucastudios.com/img/lucaui_logo_candidate2.png)

### Buckshot [buhk-shot] *noun* When darts land wildly all over the board. ###

Buckshot is a UI Framework for modern web applications. It is written in Google Dart and attempts to model the best of .net WPF (Silverlight) and Adobe Flex, but without the need for a plug-in. Buckshot renders all output in HTML5/CSS3, and makes use of features available in today's modern web browsers.

If you've worked with .net WPF or Silverlight then this framework will feel very familiar to you.

## Status: Alpha ##
Project is currently in the **alpha** stage of development.  It will likely not move to beta or v1.0 until after Dart ships v1.0. This is to ensure that that library is working correctly with the Dart APIs, which are still in flux.

## Bleeding Edge ##
Buckshot uses the very latest in HTML5/CSS3 standards.  No shims are yet in place to compensate for older or non-compliant browsers.

In particular, the layout model uses the latest draft of the [CSS3 flexbox](http://dev.w3.org/csswg/css3-flexbox/) spec, so it will currently only work with the latest build of Chromium or Dartium.

## Getting Started ##

### Videos ###
* [Setting Up A Buckshot Project](http://www.youtube.com/watch?v=9YXeNalVeGA)
* [Working With UI Templates](http://www.youtube.com/watch?v=LOacOkmd9FI)
* [Template Formats](http://www.youtube.com/watch?v=z5kRiTy0obI)

Many more videos at the [Buckshot playlist on YouTube](http://www.youtube.com/playlist?list=PLE04C8698A5FD2E9E&feature=view_all).

### Buckshot Online Sandbox ###
[Online Interactive Buckshot](http://www.lucastudios.com/trybuckshot)

### Reference Material ###
* [API Reference](http://www.lucastudios.com/trybuckshot/docs/)
* [Wiki Documentation](https://github.com/prujohn/Buckshot/wiki/_pages)
* [Developers: How To Contribute](https://github.com/prujohn/Buckshot/wiki/How-To-Contribute)

## Features
<table>
<tr>
<td>Template-Driven</td>
<td>Similar to Xaml, but more simplified and flexible.  Supports XML, JSON, and YAML formats.</td>
</tr>
<tr>
<td>Actions</td>
<td>Event-driven actions, like playing animations, changing properties, etc, in XML templates instead of code (you can also do it in code too, if desired)</td>
</tr>
<tr>
<td>Controls</td>
<td>Dozens of controls included with the core library, everything from primitive shapes to complex template-supporting controls, like ListBox</td>
</tr>
<tr>
<td>Animation</td>
<td>Declaratively set keyframe animations for your elements, and off you go (still new, has some limitations)</td>
</tr>
<tr>
<td>Data Binding</td>
<td>
Buckshot supports 4 different types of binding from XML templates (or in code):  Resource binding, element-to-element binding, data binding, and template binding</td>
</tr>
<tr>
<td>Events</td>
<td>.net folks will find this model to be very familiar.  We use it to wrap DOM events and for other internal events, but you can use it in your own apps</td>
</tr>
<tr>
<td>Style Templates</td>
<td>Use a common style library among multiple elements.  Individual changes to style property values will automatically update any elements using that style</td>
</tr>
<tr>
<td>Extensibility</td>
<td>Everything in Buckshot is designed to be extensible, so you can create libraries of your own controls, resources, and more</td>
</tr>
</table>

**And Much, Much More** [More Details Here] (https://github.com/prujohn/Buckshot/wiki/What-is-Buckshot%3F)

## Dependencies (git submodules in the 'external' folder)
* [Dart-XML](https://github.com/prujohn/dart-xml)

## License
Apache 2.0. See license.txt for project licensing information.

## Contact

John

Here on github or http://www.lucastudios.com/contact

G+: https://plus.google.com/115427174005651655317/about

Blog: http://phylotic.blogspot.com
