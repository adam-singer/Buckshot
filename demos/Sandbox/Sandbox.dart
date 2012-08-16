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

#import('dart:html');
#import('../../lib/Buckshot.dart');
#import('../../external/shared/shared.dart');
#import('package:DartNet-Event-Model/events.dart');
#import('../../extensions/controls/media/MediaPack.dart');
#import('../../extensions/controls/ListBox.dart');
//#import('../../extensions/controls/ModalDialog.dart');
#import('../../extensions/controls/social/PlusOne.dart');

// these 2 imports are needed to support plusone...

#source('Views.dart');
#source('DemoViewModel.dart');
#source('DemoModel.dart');


void main() {
//  buckshot.registerElement(new ListBox());
//  buckshot.registerElement(new PlusOne());
//  buckshot.registerElement(new ModalDialog());

  Views views = new Views();

  // Register extensions
  // These are exposed by the extension libraries.
  // You could also import individual extensions instead.
  //initializeMediaPackExtensions();

  // create our main view and error view

  Futures
    .wait([
           Template.deserialize(Template.getTemplate('#main')),
           Template.deserialize(views.errorUI)
           ])
    .then((l){
      return;
      final o = l[0];
      final errorUI = l[1];

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
          Template.deserialize(tbUserInput.text.trim()).then((t) => borderContent.content = t);
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

      void setView(view){
        tbUserInput.text = view;
        Template.deserialize(view).then((c) => borderContent.content = c);
      }

      void handleSelection(_, SelectedItemChangedEventArgs<DropDownItem> args){

        switch(args.selectedItem.value.toString()){
          case "helloworld":
            setView(views.helloWorldView);
            break;
          case "stackpanel":
            setView(views.stackPanelView);
            break;
          case "button":
            setView(views.buttonView);
            break;
          case "grid":
            setView(views.gridView);
            break;
          case "layoutcanvas":
            setView(views.layoutCanvasView);
            break;
          case "slider":
            setView(views.sliderView);
            break;
          case "thispage":
            setView(document.query('#main').text);
            break;
          case "border":
            setView(views.borderView);
            break;
          case "radiobuttons":
            setView(views.radioButtonView);
            break;
          case "checkboxes":
            setView(views.checkBoxView);
            break;
          case "hyperlink":
            setView(views.hyperlinkView);
            break;
          case "image":
            setView(views.imageView);
            break;
          case "resourcebinding":
            setView(views.resourcesView);
            break;
          case "elementbinding":
            setView(views.interactiveView);
            break;
          case "databinding":
            setView(views.dataBindingView);
            break;
          case "collections":
            setView(views.collectionsView);
            break;
          case "youtube":
            setView(views.youtubeView);
            break;
          case "hulu":
            setView(views.huluView);
            break;
          case "vimeo":
            setView(views.vimeoView);
            break;
          case "funnyordie":
            setView(views.funnyOrDieView);
            break;
          case "dropdownlist":
            setView(views.dropDownListView);
            break;
          case "listbox":
            setView(views.listBoxView);
            break;
        }
      }

      ddlElements.selectionChanged + handleSelection;
      ddlBinding.selectionChanged + handleSelection;
      ddlMediaExtensions.selectionChanged + handleSelection;
      ddlControls.selectionChanged + handleSelection;

      // render the main view
      buckshot.renderRaw(o);

//  var x = new ModalDialog();
//  x.text = "Hello World this is a test";
//  x.title = 'Hello world, this is a title';
//  x.show();
    });
}



