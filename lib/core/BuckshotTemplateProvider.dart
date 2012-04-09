//   Copyright (c) 2012, John Evans & LUCA Studios LLC
//
//   http://www.lucastudios.com/contact
//   John: https://plus.google.com/u/0/115427174005651655317/about
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

//TODO event handlers (waiting for reflection)

/**
* The default presentation format provider for Buckshot.
*/
class BuckshotTemplateProvider extends HashableObject implements IPresentationFormatProvider {
  //a very ugly brute force implementation of an xml <-> object converter
  //but it works..
  
  //TODO MIME as identifier type instead?
  String get fileExtension() => "BuckXml";
  
  FrameworkElement deserialize(String fileData){
    
    //move the file data into an HTML element node tree
    //does much of low-level xml parsing work for us...
    Element e = new Element.html(fileData);
    
    return _getNextElement(e);
  }
  
  BuckshotObject _getNextElement(Element xmlElement){
    String lowerTagName = xmlElement.tagName.toLowerCase();
    
    //html parser converts 'image' to 'img', so convert it back.
    if (lowerTagName == "img") lowerTagName = "image";

    if (!Buckshot._objectRegistry.containsKey(lowerTagName))
      throw new PresentationProviderException('Element "${lowerTagName}" not found in object registry.');
    
    var newElement = Buckshot._objectRegistry[lowerTagName].makeMe();
    
    if (xmlElement.elements.length > 0){
      //process nodes
      
      for(final e in xmlElement.elements){
        String elementLowerTagName = e.tagName.toLowerCase();
        if (elementLowerTagName == "img") elementLowerTagName = "image";
                
        if (Buckshot._objectRegistry.containsKey(elementLowerTagName)){

          if (e.tagName.contains(".")){
            //attached property
            if (Buckshot._objectRegistry.containsKey(elementLowerTagName)){    

              Function setAttachedPropertyFunction = Buckshot._objectRegistry[elementLowerTagName];
              
              //no data binding for attached properties
              setAttachedPropertyFunction(newElement, Math.parseInt(e.text.trim()));
            }
          }else{
            //element or resource

            if (!newElement.isContainer) throw const PresentationProviderException("Attempted to add element to another element which is not a container.");
            
            var cc = newElement._stateBag[FrameworkObject.CONTAINER_CONTEXT];
            
            FrameworkObject childElement = _getNextElement(e);
            
            if (childElement == null) continue; // is a resource
            
            if (cc is List){
              //list content
              cc.add(childElement);
            }else{
              //single child (previous child will be overwritten if multiple are provided)
              //TODO throw on multiple child element nodes
              setValue(cc, childElement);
            }
          }
        }else{
          //property node

          FrameworkProperty p = newElement.resolveProperty(elementLowerTagName);
          if (p == null) throw new PresentationProviderException("Property node name '${elementLowerTagName}' is not a valid property of '${lowerTagName}'.");

          if (elementLowerTagName == "itemstemplate"){
            //accomodation for controls that use  itemstemplates...
            setValue(p, e.innerHTML); // defer parsing of the template xml, the template iterator should handle later.
          }else{
          
            var testValue = getValue(p);
            
            if (testValue != null && testValue is List){
             //complex property (list)
              for (final se in e.elements){
                testValue.add(_getNextElement(se));                
              }
            }else if (e.text.trim().startsWith("{")){
              
              //binding or resource
              _resolveBinding(p, e.text.trim());
            }else{
              //property node
              
              if (e.elements.isEmpty()){
                //assume text assignment
                setValue(p, e.text.trim());  
              }else{
                //assume node assignment to property
                setValue(p, _getNextElement(e.elements[0]));
              }              
            }
          }
        }
      }
    }else{
      //no nodes, check for text element
      if (xmlElement.text.trim() != ""){
        if (!newElement.isContainer) throw const PresentationProviderException("Text node found in element which does not have a container context defined.");
        
        var cc = newElement._stateBag[FrameworkObject.CONTAINER_CONTEXT];
        
        if (cc is List) throw const PresentationProviderException("Expected container context to be property.  Found list.");
        
        setValue(cc, xmlElement.text.trim());
      }
    }
       
    _assignAttributeProperties(newElement, xmlElement);
        
    if (newElement is FrameworkResource){
      newElement.rawData = xmlElement.outerHTML;
      _processResource(newElement);
      // don't return resource nodes; they aren't added to the DOM
      return null;
    }else{
      return newElement;
    }
  }
  
  void _resolveBinding(FrameworkProperty p, String binding){
    if (!binding.startsWith("{") || !binding.endsWith("}"))
      throw const PresentationProviderException('Binding must begin with "{" and end with "}"');
    
    FrameworkProperty placeholder = new FrameworkProperty(null, "placeholder",(_){});
    
    String stripped = binding.substring(1, binding.length - 1);

    BindingMode mode = BindingMode.OneWay;
    IValueConverter vc = null;
        
    //TODO support converters...
    List<String> params = stripped.split(',');
    
    List<String> words = params[0].trim().split(' ');
    
    if (params.length > 1 && words[0] != "template"){
      params
        .getRange(1, params.length - 1)
        .forEach((String param){
          String lParam = param.trim().toLowerCase();
          if (lParam.startsWith('mode=') || lParam.startsWith('mode =')){
            var modeSplit = lParam.split('=');
            if (modeSplit.length == 2){
              switch(modeSplit[1]){
                case "twoway":
                    mode = BindingMode.TwoWay;
                  break;
                case "onetime":
                    mode = BindingMode.OneTime;
                  break;
              }
            } //TODO: else throw?
            
          }
          else if (lParam.startsWith('converter=') || lParam.startsWith('converter ='))
          {
            var converterSplit = lParam.split('=');
            
            if (converterSplit.length == 2 && converterSplit[1].startsWith('{resource ') && converterSplit[1].endsWith('}')){
              _resolveBinding(placeholder, converterSplit[1]);
              var testValueConverter = getValue(placeholder);
              if (testValueConverter is IValueConverter) vc = testValueConverter;
            } //TODO: else throw?
          }  
        });
    }
    
    switch(words[0]){
      case "resource":
        if (words.length != 2)
          throw const PresentationProviderException('Binding syntax incorrect.');
        
        setValue(p, Buckshot.retrieveResource(words[1]));
        break;
      case "template":
        if (words.length != 2)
          throw const FrameworkException('{template} bindings must contain a property name parameter: {template [propertyName]}');
        
          p.sourceObject._templateBindings[p] = words[1];
        break;
      case "data":
        if (!(p.sourceObject is FrameworkElement)){
          throw const PresentationProviderException('{data...} binding only supported on types that derive from FrameworkElement.');
        }
        
        switch(words.length){
          case 1:
            //dataContext directly
            p.sourceObject.lateBindings[p] = new BindingData("", null, mode);
            break;
          case 2:
            //dataContext object via property resolution
            p.sourceObject.lateBindings[p] = new BindingData(words[1], null, mode);
            break;
          default:
            throw const PresentationProviderException('Binding syntax incorrect.');
        }
        break;
      case "element":
        if (words.length != 2)
          throw const PresentationProviderException('Binding syntax incorrect.');
        
        if (words[1].contains(".")){
          var ne = words[1].substring(0, words[1].indexOf('.'));
          var prop = words[1].substring(words[1].indexOf('.') + 1);
          
          if (!Buckshot.namedElements.containsKey(ne))
            throw new PresentationProviderException("Named element '${ne}' not found.");
          
          Binding b;
          try{
            new Binding(Buckshot.namedElements[ne].resolveProperty(prop), p, bindingMode:mode);  
          }catch (Exception err){
            //try to bind late...
            FrameworkProperty theProperty = Buckshot.namedElements[ne].resolveFirstProperty(prop);
            theProperty.propertyChanging + (_, __) {
              
              //unregister previous binding if one already exists.
              if (b != null) b.unregister();
              
              b = new Binding(Buckshot.namedElements[ne].resolveProperty(prop), p, bindingMode:mode);
            }; 
          }        
          
          
        }else{
          throw const PresentationProviderException("Element binding requires a minimum named element/property pairing (usage '{element name.property}')");
        }
        break;
      default:
        throw const PresentationProviderException('Binding syntax incorrect.');
    }
  }
  
  void _processResource(FrameworkResource resource){
    //ignore the collection object, the resources will come here anyway
    //TODO: maybe support merged resource collections in the future...
    if (resource is ResourceCollection) return;

    if (resource.key.isEmpty())
      throw const PresentationProviderException("Resource is missing a key identifier.");
    
    //add/replace resource at given key
    Buckshot.registerResource(resource);
  }
  
  void _assignAttributeProperties(BuckshotObject element, Element xmlElement){

    if (xmlElement.attributes.length == 0) return;
    
    xmlElement.attributes.forEach((String k, String v){

      if (k.contains(".")){
        //attached property    
        if (Buckshot._objectRegistry.containsKey("$k")){    
          
          Function setAttachedPropertyFunction = Buckshot._objectRegistry["$k"];
          
          setAttachedPropertyFunction(element, Math.parseInt(v));
        }
      }else{
        //property
        FrameworkProperty p = element.resolveProperty(k);

        if (p == null) return; //TODO throw?
          
        if (v.trim().startsWith("{")){
          //binding or resource
          _resolveBinding(p, v.trim());
        }else{
          //value or enum (enums converted at property level via FrameworkProperty.stringToValueConverter [if assigned])
            setValue(p, v);
        }
      }
    });
  }
  
  String serialize(FrameworkElement elementRoot){
    throw const NotImplementedException();
  }
  
  String get type() => 'BuckshotTemplateProvider';
}
