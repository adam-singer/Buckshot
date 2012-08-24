// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

//TODO event handlers (waiting for reflection)

/**
* Provides serialization/deserialization for XML format templates.
*/
class XmlTemplateProvider extends IPresentationFormatProvider
{

  /* Begin IPresentationFormatProvider Interface */

  bool isFormat(String template) => template.startsWith('<');

  Future<FrameworkElement> deserialize(String templateXML){
    final c = new Completer();

    _getNextElement(XML.parse(templateXML)).then((e) => c.complete(e));

    return c.future;
  }

  String serialize(FrameworkElement elementRoot){
    throw const NotImplementedException();
  }

  /* End IPresentationFormatProvider Interface */

  Future<FrameworkObject> _getNextElement(XmlElement xmlElement){

    final oc = new Completer();

    String lowerTagName = xmlElement.name.toLowerCase();

    void completeElementParse(element){
      if (element is FrameworkResource){
        element.rawData = xmlElement.toString();
        _processResource(element);
        // complete nodes as null; they aren't added to the DOM
        oc.complete(null);
      }else{
        oc.complete(element);
      }
    }

    final interfaceMirrorOf = Miriam.context.getObjectByName(lowerTagName);

    if (interfaceMirrorOf == null){
      throw new PresentationProviderException('Element "${xmlElement.name}"'
      ' not found.');
    }

    interfaceMirrorOf
    .newInstance('',[])
    .then((newElementMirror){
      final newElement = newElementMirror.reflectee;
      final fList = [];

      if (xmlElement.children.length > 0 &&
          xmlElement.children.every((n) => n is! XmlText)){
        //process nodes

        for(final e in xmlElement.children.dynamic){
          String elementLowerTagName = e.name.toLowerCase();

          if(newElement.hasProperty(elementLowerTagName)){
            fList.add(processProperty(newElement, e));
          }else {
            fList.add(processTag(newElement, e));
          }
        }
      }else{
        //no nodes, check for text element
        processTextNode(newElement, xmlElement);
      }

      //add the assign attributes future to the list.
      fList.add(_assignAttributeProperties(newElement, xmlElement));

      // Wait for all the futures to complete before finishing
      Futures
      .wait(fList)
      .then((_){
        completeElementParse(newElement);
      });
    });

    return oc.future;
  }


  Future processProperty(ofElement, ofXMLNode){
    final c = new Completer();
    final String lowered = ofXMLNode.name.toLowerCase();

    //property node

    ofElement.getPropertyByName(lowered)
    .then((p){
      if (p == null) throw new PresentationProviderException("Property node"
          " name '${lowered}' is not a valid"
          " property of ${ofElement.type}.");

      if (lowered == "itemstemplate"){
        //accomodation for controls that use itemstemplates...
        if (ofXMLNode.children.length != 1){
          throw const PresentationProviderException('ItemsTemplate'
          ' can only have a single child.');
        }
        // defer parsing of the template xml, the template
        // iterator should handle later.
        setValue(p, ofXMLNode.children[0].toString());
        c.complete(true);
      }else{

        var testValue = getValue(p);

        if (testValue != null && testValue is List){
          //complex property (list)

          var fList = [];

          for (final se in ofXMLNode.children){
            fList.add(_getNextElement(se));
          }

          Futures
          .wait(fList)
          .then((results){
            results.forEach((r){
              testValue.add(r);
            });
            c.complete(true);
          });

        }else if (ofXMLNode.text.trim().startsWith("{")){

          //binding or resource
          _resolveBinding(p, ofXMLNode.text.trim());
          c.complete(true);
        }else{
          //property node

          if (ofXMLNode.children.isEmpty()){
            //assume text assignment
            setValue(p, ofXMLNode.text.trim());
            c.complete(true);
          }else{
            if (ofXMLNode.children.every((n) => n is XmlText)){
              // text assignment to property
              setValue(p, ofXMLNode.text.trim());
              c.complete(true);
            }else if (ofXMLNode.children.length == 1 &&
                ofXMLNode.children[0] is! XmlText){

              // node assignment to property

              _getNextElement(ofXMLNode.children[0]).then((ne){
                setValue(p, ne);
                c.complete(true);
              });
            }
          }
        }
      }

    });

    return c.future;
  }

  Future processTag(ofElement, ofXMLNode){
    final c = new Completer();
    final String elementLowerTagName = ofXMLNode.name.toLowerCase();

    if (ofXMLNode.name.contains(".")){
      AttachedFrameworkProperty
        .invokeSetPropertyFunction(ofXMLNode.name,
            ofElement,
            ofXMLNode.text.trim());
      c.complete(true);
    }else{
      //element or resource

      if (!ofElement.isContainer)
        throw const PresentationProviderException("Attempted to add"
        " element to another element which is not a container.");

      var cc = ofElement.stateBag[FrameworkObject.CONTAINER_CONTEXT];

      _getNextElement(ofXMLNode).then((childElement){

        if (childElement == null){
          c.complete(true); // is a resource
          return;
        }

        //CONTAINER_CONTEXT is a FrameworkProperty for single element, List for multiple
        if (cc is List){
          //list content
          cc.add(childElement);
        }else{
          // single child (previous child will be overwritten
          // if multiple are provided)
          //TODO throw on multiple child element nodes
          setValue(cc, childElement);
        }
        c.complete(true);
      });
    }

    return c.future;
  }

  void processTextNode(ofElement, ofXMLNode){
    if (ofXMLNode.text.trim() != ""){
      if (!ofElement.isContainer)
        throw const PresentationProviderException("Text node found in element"
        " which does not have a container context defined.");

      var cc = ofElement.stateBag[FrameworkObject.CONTAINER_CONTEXT];

      if (cc is List) throw const PresentationProviderException("Expected"
      " container context to be property.  Found list.");

      setValue(cc, ofXMLNode.text.trim());
    }
  }

  void _resolveBinding(FrameworkProperty p, String binding){
    if (!binding.startsWith("{") || !binding.endsWith("}"))
      throw const PresentationProviderException('Binding must begin with'
        ' "{" and end with "}"');

    FrameworkProperty placeholder =
        new FrameworkProperty(null, "placeholder",(_){});

    String stripped = binding.substring(1, binding.length - 1);

    BindingMode mode = BindingMode.OneWay;
    IValueConverter vc = null;

    //TODO support converters...
    var params = stripped.split(',');

    var words = params[0].trim().split(' ');

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
          else if (lParam.startsWith('converter=')
              || lParam.startsWith('converter ='))
          {
            var converterSplit = lParam.split('=');

            if (converterSplit.length == 2
                && converterSplit[1].startsWith('{resource ')
                && converterSplit[1].endsWith('}')){
              _resolveBinding(placeholder, converterSplit[1]);
              var testValueConverter = getValue(placeholder);
              if (testValueConverter is IValueConverter)
                vc = testValueConverter;
            } //TODO: else throw?
          }
        });
    }

    switch(words[0]){
      case "resource":
        if (words.length != 2)
          throw const PresentationProviderException('Binding'
            ' syntax incorrect.');

        setValue(p, FrameworkResource.retrieveResource(words[1]));
        break;
      case "template":
        if (words.length != 2)
          throw const BuckshotException('{template} bindings must contain a'
            ' property name parameter: {template [propertyName]}');

          p.sourceObject.dynamic._templateBindings[p] = words[1];
        break;
      case "data":
        if (!(p.sourceObject is FrameworkElement)){
          throw const PresentationProviderException('{data...} binding only'
            ' supported on types that derive from FrameworkElement.');
        }

        switch(words.length){
          case 1:
            //dataContext directly
            p.sourceObject.dynamic.lateBindings[p] =
                new BindingData("", null, mode);
            break;
          case 2:
            //dataContext object via property resolution
            p.sourceObject.dynamic.lateBindings[p] =
                new BindingData(words[1], null, mode);
            break;
          default:
            throw const PresentationProviderException('Binding'
              ' syntax incorrect.');
        }
        break;
      case "element":
        if (words.length != 2)
          throw const PresentationProviderException('Binding'
            ' syntax incorrect.');

        if (words[1].contains(".")){
          var ne = words[1].substring(0, words[1].indexOf('.'));
          var prop = words[1].substring(words[1].indexOf('.') + 1);

          if (!buckshot.namedElements.containsKey(ne))
            throw new PresentationProviderException("Named element '${ne}'"
            " not found.");

          Binding b;

          buckshot
            .namedElements[ne]
            .resolveProperty(prop)
            .then((property){
              if (property != null){
                new Binding(property, p, bindingMode:mode);
              }else{
                buckshot
                .namedElements[ne]
                .resolveFirstProperty(prop)
                .then((firstProperty){
                  firstProperty.propertyChanging + (_, __) {

                    //unregister previous binding if one already exists.
                    if (b != null) b.unregister();

                    buckshot
                    .namedElements[ne]
                    .resolveProperty(prop)
                    .then((lateProperty){
                      b = new Binding(lateProperty, p, bindingMode:mode);
                    });
                  };
                });
              }
            });
        }else{
          throw const PresentationProviderException("Element binding requires"
            " a minimum named element/property"
            " pairing (usage '{element name.property}')");
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
      throw const PresentationProviderException("Resource is missing"
        " a key identifier.");

    //add/replace resource at given key
    FrameworkResource.registerResource(resource);
  }

  Future _assignAttributeProperties(BuckshotObject element,
                                  XmlElement xmlElement){
    final c = new Completer();

    if (xmlElement.attributes.length == 0){
      c.complete(false);
      return c.future;
    }

    final fList = [];

    xmlElement
      .attributes
      .forEach((String k, String v){
        if (k.contains(".")){
          AttachedFrameworkProperty.invokeSetPropertyFunction(k, element, v);
        }else{
          //property
          final f = element.resolveProperty(k);
          fList.add(f);
          f.then((p){
              if (p == null) return; //TODO throw?

              if (v.trim().startsWith("{")){
                //binding or resource
                _resolveBinding(p, v.trim());
              }else{
                //value or enum (enums converted at property level
                //via FrameworkProperty.stringToValueConverter [if assigned])
                setValue(p, v);
            }
          });
        }
    });

    //make sure all the values are set before completing the future.
    Futures
    .wait(fList)
    .then((_) => c.complete(true));

    return c.future;
  }
}
