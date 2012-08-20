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
#import('../../extensions/controls/media/YouTube.dart');
#import('../../extensions/controls/media/Hulu.dart');
#import('../../extensions/controls/media/Vimeo.dart');
#import('../../extensions/controls/media/FunnyOrDie.dart');
#import('../../extensions/controls/ListBox.dart');
//#import('../../extensions/controls/ModalDialog.dart');
#import('../../extensions/controls/social/PlusOne.dart');

#source('DemoViewModel.dart');
#source('DemoModel.dart');


void main() {

  // create our main view and error view

  var dummy = buckshot.isContainer;

  Futures
    .wait([
           Template.deserialize(Template.getTemplate('#main')),
           Template.deserialize(Template.getTemplate('#error'))
           ])
    .then((l){
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
      DropDownList ddlMediaExtensions =
          buckshot.namedElements["ddlMediaExtensions"];
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
          Template
            .deserialize(tbUserInput.text.trim())
            .then((t) => borderContent.content = t);
        }
        catch(AnimationException ae){
          tbError.text = "An error occurred while attempting to process an"
              " animation resource: ${ae}";
          borderContent.content = errorUI;
        }
        catch(PresentationProviderException pe){
          tbError.text = "We were unable to parse your input into content for"
              " display: ${pe}";
          borderContent.content = errorUI;
        }
        catch(FrameworkPropertyResolutionException pre){
          tbError.text = "A framework error occured while attempting to resolve"
              " a property binding: ${pre}";
          borderContent.content = errorUI;
        }
        catch(BuckshotException fe){
          tbError.text = "A framework error occured while attempting to render"
              " the content: ${fe}";
          borderContent.content = errorUI;
        }
        catch(Exception e){
          tbError.text = "A general exception occured while attempting to"
              " render the content.  Please bear with us as we (and Dart) are"
              " still in the early stages of development.  Thanks! ${e}";
          borderContent.content = errorUI;
        }
      };

      btnClear.click + (_,__){

        tbUserInput.text = "";

        //TODO this should support '= null' but does not
        borderContent.content = new TextBlock();
      };

      void handleSelection(_, SelectedItemChangedEventArgs<DropDownItem> args){

        final value = args.selectedItem.value.toString();

        if (value == ''){
          tbUserInput.text = '';
          borderContent.content = null;
        }else{
          final view = Template.getTemplate('#${value}');
          tbUserInput.text = view;
          Template.deserialize(view).then((c) => borderContent.content = c);
        }
      }

      ddlElements.selectionChanged + handleSelection;
      ddlBinding.selectionChanged + handleSelection;
      ddlMediaExtensions.selectionChanged + handleSelection;
      ddlControls.selectionChanged + handleSelection;

      // render the main view
      buckshot.renderRaw(o);
    });
}



