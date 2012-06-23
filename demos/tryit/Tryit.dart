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
#import('../../extensions/media/MediaPack.dart');
#import('../../extensions/actions/ActionPack.dart');
#import('dart:html');
#source('../../extensions/ControlPack1/ModalDialog.dart');
#source('Views.dart');
#source('DemoViewModel.dart');
#source('DemoModel.dart');
#source('../../extensions/social/PlusOne.dart');

void main() { 
    
  Views views = new Views();
    
  buckshot.registerElement(new PlusOne());
  buckshot.registerElement(new ModalDialog());
  
  
  // Register extensions
  // These are exposed by the extension libraries.
  // You could also import individual extensions instead.
  initializeMediaPackExtensions();
  initializeActionPackExtensions();
      
  // create our main view and error view
  FrameworkObject o = Template.deserialize(document.query('#main').text);
  FrameworkObject errorUI = Template.deserialize(views.errorUI);
  
  // get references to all the ui interactives that we need    
  TextBlock tbError = buckshot.namedElements["tbErrorMessage"];  
  Border borderContent = buckshot.namedElements["borderContent"];
  Button btnRefresh = buckshot.namedElements["btnRefresh"];
  Button btnClear = buckshot.namedElements["btnClear"];
  TextArea tbUserInput = buckshot.namedElements["tbUserInput"];
  DropDownList ddlElements = buckshot.namedElements["ddlElements"];
  DropDownList ddlControls = buckshot.namedElements["ddlControls"];
  DropDownList ddlBinding = buckshot.namedElements["ddlBinding"];
  DropDownList ddlMediaExtensions = buckshot.namedElements["ddlMediaExtensions"];  
  StackPanel spRoot = buckshot.namedElements['spRoot'];
  
  // set buckshot to the root's datacontext
  spRoot.dataContext = buckshot;
  
  // set a demo view model into the borderContent's datacontext
  borderContent.dataContext = new DemoViewModel();
  
  // this event actually renders the chosen content, or provides and error
  // message if something went wrong
  btnRefresh.click + (_, __){
    try{
      if (tbUserInput.text.trim() == "") return;
      FrameworkObject userContent = Template.deserialize(tbUserInput.text.trim());
      borderContent.content = userContent;
    }
    catch(AnimationException ae){
      tbError.text = "An error occurred while attempting to process an animation resource: ${ae}";
      borderContent.content = errorUI;
    }
    catch(PresentationProviderException pe){
      tbError.text = "We were unable to parse your input into content for display: ${pe}";
      borderContent.content = errorUI;
    }
    catch(FrameworkPropertyResolutionException pre){
      tbError.text = "A framework error occured while attempting to resolve a property binding: ${pre}";
      borderContent.content = errorUI;
    }
    catch(BuckshotException fe){
      tbError.text = "A framework error occured while attempting to render the content: ${fe}";
      borderContent.content = errorUI;
    }
    catch(Exception e){
      tbError.text = "A general exception occured while attempting to render the content.  Please bear with us as we (and Dart) are still in the early stages of development.  Thanks! ${e}";
      borderContent.content = errorUI;
    }
  };
    
  btnClear.click + (_,__){
    
    tbUserInput.text = "";
    
    //TODO this should support '= null' but does not
    borderContent.content = new TextBlock();
  };
    
  void handleSelection(_, SelectedItemChangedEventArgs<DropDownListItem> args){

    switch(args.selectedItem.value.toString()){
      case "helloworld":
        tbUserInput.text = views.helloWorldView;
        borderContent.content = Template.deserialize(views.helloWorldView);
        break;
      case "stackpanel":
        tbUserInput.text = views.stackPanelView;
        borderContent.content = Template.deserialize(views.stackPanelView);
        break;
      case "button":
        tbUserInput.text = views.buttonView;
        borderContent.content = Template.deserialize(views.buttonView);
        break;
      case "grid":
        tbUserInput.text = views.gridView;
        borderContent.content = Template.deserialize(views.gridView);
        break;
      case "layoutcanvas":
        tbUserInput.text = views.layoutCanvasView;
        borderContent.content = Template.deserialize(views.layoutCanvasView);
        break;
      case "slider":
        tbUserInput.text = views.sliderView;
        borderContent.content = Template.deserialize(views.sliderView);
        break;
      case "thispage":
        tbUserInput.text = document.query('#main').text;
        borderContent.content = Template.deserialize(tbUserInput.text);
        break;
      case "border":
        tbUserInput.text = views.borderView;
        borderContent.content = Template.deserialize(views.borderView);
        break;
      case "radiobuttons":
        tbUserInput.text = views.radioButtonView;
        borderContent.content = Template.deserialize(views.radioButtonView);
        break;
      case "checkboxes":
        tbUserInput.text = views.checkBoxView;
        borderContent.content = Template.deserialize(views.checkBoxView);
        break;
      case "hyperlink":
        tbUserInput.text = views.hyperlinkView;
        borderContent.content = Template.deserialize(views.hyperlinkView);
        break;
      case "image":
        tbUserInput.text = views.imageView;
        borderContent.content = Template.deserialize(views.imageView);
        break;
      case "resourcebinding":
        tbUserInput.text = views.resourcesView;
        borderContent.content = Template.deserialize(views.resourcesView);
        break;
      case "elementbinding":
        tbUserInput.text = views.interactiveView;
        borderContent.content = Template.deserialize(views.interactiveView);
        break;
      case "databinding":
        tbUserInput.text = views.dataBindingView;
        borderContent.content = Template.deserialize(views.dataBindingView);
        break;
      case "collections":
        tbUserInput.text = views.collectionsView;
        borderContent.content = Template.deserialize(views.collectionsView);
        break;
      case "youtube":
        tbUserInput.text = views.youtubeView;
        borderContent.content = Template.deserialize(views.youtubeView);
        break;
      case "hulu":
        tbUserInput.text = views.huluView;
        borderContent.content = Template.deserialize(views.huluView);
        break;
      case "vimeo":
        tbUserInput.text = views.vimeoView;
        borderContent.content = Template.deserialize(views.vimeoView);
        break;
      case "funnyordie":
        tbUserInput.text = views.funnyOrDieView;
        borderContent.content = Template.deserialize(views.funnyOrDieView);
        break;
      case "dropdownlist":
        tbUserInput.text = views.dropDownListView;
        borderContent.content = Template.deserialize(views.dropDownListView);
        break;
      case "listbox":
        tbUserInput.text = views.listBoxView;
        borderContent.content = Template.deserialize(views.listBoxView);
        break;
    }  
  }
  
  ddlElements.selectionChanged + handleSelection;
  ddlBinding.selectionChanged + handleSelection;
  ddlMediaExtensions.selectionChanged + handleSelection;
  ddlControls.selectionChanged + handleSelection;
    
  // render the main view
  buckshot.renderRaw(o);
  
  var x = new ModalDialog();
  x.text = "Hello World this is a test";
  x.title = 'Hello world, this is a title';
  x.show();
}



