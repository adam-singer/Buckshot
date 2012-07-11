// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


/**
* ## Helper class for working with Buckshot templates. ##
*
* ## Supported Formats ##
* * XML
* * JSON
* * YAML (coming soon)
* 
* ## Usage ##
* Both YAML and JSON templates require a certain heirachy in order to 
* deserialize properly:
*
*     [element, 
*       [{property1:value, property2:value}, 
*       [childElement1, 
*         [{property:value}],
*        childElement2,
*         [{property:value}]
*       ]
*     ]
*
* ### XML Example ###
*     <border padding='5' background='Orange'>
*        <stackpanel halign='center' valign='center'>
*          <textblock text='hello' />
*          <textblock text='world' />  
*        </stackpanel>
*     </border>
*
* ### JSON Example ###
*     ["border",
*        [{"background" : "Orange", "padding" : "10"},
*          ["stackpanel", 
*            [{"valign" : "center", "halign" : "center"},
*              ["textblock",
*                [{"text" : "hello"}]
*              ,"textblock",
*                [{"text" : "world"}]
*              ]
*            ]
*          ]
*        ]
*      ]
*
* ### YAML Example ###
*     - border
*     - - {background: Orange, padding: 10}
*       - - stackpanel
*         - - {halign: center, valign: center}
*           - - textblock
*             - - text: hello
*             - textblock
*             - - text: world
*
*/
class Template {
  
  final List<IPresentationFormatProvider> providers;
  
  Template()
  :
    providers = [new XmlTemplateProvider(),
                 new JSONTemplateProvider(),
                 new YAMLTemplateProvider()];

  
  /**
   * Returns the first parent that matches the given [type].  Returns
   * null if parent not found in visual tree.
   */
  static FrameworkElement findParentByType(FrameworkElement element, String type){
    if (element.parent == null) return null;
    
    if (element.parent.type != type){
      return findParentByType(element.parent, type);
    }
    
    return element.parent;
  }
  
  
  /** Performs a search of the element tree starting from the given
   * [FrameworkElement] and returns the first named Element matching
   * the given name.
   *
   * ## Instead use:
   *     Buckshot.namedElements[elementName];
   */
  static FrameworkElement findByName(String name, FrameworkElement startingWith){

    if (startingWith.name != null && startingWith.name == name) return startingWith;

    if (!startingWith.isContainer) return null;

    var cc = startingWith._stateBag[FrameworkObject.CONTAINER_CONTEXT];
    if (cc is List){
      for (final el in cc){
        var result = findByName(name, el);
        if (result != null) return result;
      }
    }else if (cc is FrameworkProperty){
      FrameworkElement obj = getValue(cc);
      if (obj == null || !(obj is FrameworkElement)) return null;
      return findByName(name, obj);
    }else{
      return null;
    }
  }
  
  /**
  * # Usage #
  *     //Retrieves the template from the current web page
  *     //and returns a String containing the template 
  *     //synchronously.
  *     getTemplate('#templateID').then(...);
  *
  *     //Retrieves the template from the URI (same domain)
  *     //and returns a String containing the template
  *     //asynchronously in a Future<String>.
  *     getTemplate('/relative/path/to/templateName.xml').then(...);
  *
  * Use the [deserialize] method to convert a template into an object structure.
  */
  static getTemplate(String from){   
    if (from.startsWith('#')){
      var result = document.query(from);
      return result == null ? null : result.text.trim();
      
    }else{
      //TODO cache...
      
      var c = new Completer();
      var r = new XMLHttpRequest();
      r.on.readyStateChange.add((e){
        if (r.readyState != 4){ 
          c.complete(null);          
        }else{
          c.complete(r.responseText.trim());
        }
      });
      
      try{              
        r.open('GET', from, true);
        r.setRequestHeader('Accept', 'text/xml');
        r.send();
      }catch(Exception e){
        c.complete(null);
      }
      
      return c.future;
    }
  }
  
  /**
  * Takes a buckshot Template and attempts deserialize it into an object
  * structure.
  *
  * This method will attempt to auto-detect the template format and apply
  * the appropriate implementation.
  *
  * ### Supported Formats ###
  * * XML
  * * JSON
  * * YAML
  */
  static FrameworkElement deserialize(String buckshotTemplate){
    final tt = buckshotTemplate.trim();
    final t = new Template();
    
    for(final p in t.providers){
      if(p.isFormat(tt)){
        return p.deserialize(tt);
      }
    }
  }
}
