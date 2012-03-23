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

#import('../../lib/Buckshot.dart');
#import('../../extensions/media/lucaui_extension_media.dart');
#import('../../extensions/social/lucaui_extension_social.dart');
#import('dart:html');
#source('Views.dart');
#source('DemoViewModel.dart');
#source('DemoModel.dart');

void main() { 
  aTest();
  
  new BuckshotSystem();
  
  Views views = new Views();
  
  //register extensions
  BuckshotSystem.registerElement(new YouTube());
  BuckshotSystem.registerElement(new Hulu());
  BuckshotSystem.registerElement(new Vimeo());
  BuckshotSystem.registerElement(new FunnyOrDie());
  BuckshotSystem.registerElement(new PlusOne());
  
  // initialize the presentation provider.  this will eventually be done by the framework
  IPresentationFormatProvider p = BuckshotSystem.defaultPresentationProvider;
    
  // create our main view and error view
  FrameworkObject o = p.deserialize(views.ui);
  FrameworkObject errorUI = p.deserialize(views.errorUI);
  
  // get references to all the ui interactives that we need    
  TextBlock tbError = BuckshotSystem.namedElements["tbErrorMessage"];  
  Border borderContent = BuckshotSystem.namedElements["borderContent"];
  Button btnRefresh = BuckshotSystem.namedElements["btnRefresh"];
  Button btnClear = BuckshotSystem.namedElements["btnClear"];
  TextArea tbUserInput = BuckshotSystem.namedElements["tbUserInput"];
  DropDownList ddlElements = BuckshotSystem.namedElements["ddlElements"];
  DropDownList ddlControls = BuckshotSystem.namedElements["ddlControls"];
  DropDownList ddlBinding = BuckshotSystem.namedElements["ddlBinding"];
  DropDownList ddlMediaExtensions = BuckshotSystem.namedElements["ddlMediaExtensions"];  

  // set a demo view model into the borderContent's datacontext
  borderContent.dataContext = new DemoViewModel();
  
  // this event actually renders the chosen content, or provides and error
  // message if something went wrong
  btnRefresh.click + (_, __){
    try{
      if (tbUserInput.text.trim() == "") return;
      FrameworkObject userContent = p.deserialize(tbUserInput.text.trim());
      borderContent.content = userContent;
    }
    catch(PresentationProviderException pe){
      tbError.text = "We were unable to parse your input into content for display: ${pe.message}";
      borderContent.content = errorUI;
    }
    catch(FrameworkPropertyResolutionException pre){
      tbError.text = "A framework error occured while attempting to resolve a property binding: ${pre.message}";
      borderContent.content = errorUI;
    }
    catch(FrameworkException fe){
      tbError.text = "A framework error occured while attempting to render the content: ${fe.message}";
      borderContent.content = errorUI;
    }
    catch(Exception e){
      tbError.text = "A general exception occured while attempting to render the content.  Please bear with us as we (and Dart) are still in the early stages of development.  Thanks!";
      borderContent.content = errorUI;
    }
  };
    
  btnClear.click + (_,__){
    tbUserInput.text = "";
    
    //TODO this should support '= null' but does not
    borderContent.content = new TextBlock();
  };
    
  void handleSelection(_, SelectedItemChangedEventArgs<DropDownListItem> args){
    
    switch(args.selectedItem.value){
      case "helloworld":
        tbUserInput.text = views.helloWorldView;
        borderContent.content = p.deserialize(views.helloWorldView);
        break;
      case "stackpanel":
        tbUserInput.text = views.stackPanelView;
        borderContent.content = p.deserialize(views.stackPanelView);
        break;
      case "button":
        tbUserInput.text = views.buttonView;
        borderContent.content = p.deserialize(views.buttonView);
        break;
      case "grid":
        tbUserInput.text = views.gridView;
        borderContent.content = p.deserialize(views.gridView);
        break;
      case "layoutcanvas":
        tbUserInput.text = views.layoutCanvasView;
        borderContent.content = p.deserialize(views.layoutCanvasView);
        break;
      case "slider":
        tbUserInput.text = views.sliderView;
        borderContent.content = p.deserialize(views.sliderView);
        break;
      case "thispage":
        tbUserInput.text = views.ui;
        borderContent.content = p.deserialize(views.ui);
        break;
      case "border":
        tbUserInput.text = views.borderView;
        borderContent.content = p.deserialize(views.borderView);
        break;
      case "radiobuttons":
        tbUserInput.text = views.radioButtonView;
        borderContent.content = p.deserialize(views.radioButtonView);
        break;
      case "checkboxes":
        tbUserInput.text = views.checkBoxView;
        borderContent.content = p.deserialize(views.checkBoxView);
        break;
      case "hyperlink":
        tbUserInput.text = views.hyperlinkView;
        borderContent.content = p.deserialize(views.hyperlinkView);
        break;
      case "image":
        tbUserInput.text = views.imageView;
        borderContent.content = p.deserialize(views.imageView);
        break;
      case "resourcebinding":
        tbUserInput.text = views.resourcesView;
        borderContent.content = p.deserialize(views.resourcesView);
        break;
      case "elementbinding":
        tbUserInput.text = views.interactiveView;
        borderContent.content = p.deserialize(views.interactiveView);
        break;
      case "databinding":
        tbUserInput.text = views.dataBindingView;
        borderContent.content = p.deserialize(views.dataBindingView);
        break;
      case "collections":
        tbUserInput.text = views.collectionsView;
        borderContent.content = p.deserialize(views.collectionsView);
        break;
      case "youtube":
        tbUserInput.text = views.youtubeView;
        borderContent.content = p.deserialize(views.youtubeView);
        break;
      case "hulu":
        tbUserInput.text = views.huluView;
        borderContent.content = p.deserialize(views.huluView);
        break;
      case "vimeo":
        tbUserInput.text = views.vimeoView;
        borderContent.content = p.deserialize(views.vimeoView);
        break;
      case "funnyordie":
        tbUserInput.text = views.funnyOrDieView;
        borderContent.content = p.deserialize(views.funnyOrDieView);
        break;
      case "dropdownlist":
        tbUserInput.text = views.dropDownListView;
        borderContent.content = p.deserialize(views.dropDownListView);
        break;
      case "listbox":
        tbUserInput.text = views.listBoxView;
        borderContent.content = p.deserialize(views.listBoxView);
        break;
    }  
  }
  
  ddlElements.selectionChanged + handleSelection;
  ddlBinding.selectionChanged + handleSelection;
  ddlMediaExtensions.selectionChanged + handleSelection;
  ddlControls.selectionChanged + handleSelection;
    
  // render the main view
  BuckshotSystem.renderRaw(o);
}



