// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* A demo view model for displaying information in tryit.
*
* Objects that participate in data binding must derive from [LucaObject].
* ([ViewModelBase] does)
*
* Properties that need to be bound to must be of type [FrameworkProperty].
*/
class DemoViewModel extends ViewModelBase
{
  final DemoModel model;

  //declare our framework properties
  FrameworkProperty timeStampProperty;
  FrameworkProperty videosProperty;
  FrameworkProperty colorProperty;
  FrameworkProperty fruitProperty;
  FrameworkProperty iconsProperty;
  FrameworkProperty versionProperty;
  FrameworkProperty renderedOutputProperty;
  FrameworkProperty templateTextProperty;
  FrameworkProperty errorMessageProperty;

  DemoViewModel()
  :
    model = new DemoModel()
  {
    _initDemoViewModelProperties();

    // Update the timeStampProperty every second with a new timestamp.
    // Anything binding to this will get updated.
    window.setInterval(() => setValue(timeStampProperty, new Date.now().toString()), 1000);
  }

  // Initialize the properties that we want to allow binding to.
  void _initDemoViewModelProperties(){
    timeStampProperty = new FrameworkProperty(this, "timeStamp", defaultValue:new Date.now().toString());

    iconsProperty = new FrameworkProperty(this, "icons", defaultValue:model.iconList);

    videosProperty = new FrameworkProperty(this, "videos", defaultValue:model.videoList);

    fruitProperty = new FrameworkProperty(this, "fruit", defaultValue:model.fruitList);

    // Since colorProperty is itself a BuckshotObject, the framework will allow dot-notation
    // resolution to any properties within that object as well.
    // ex. "color.red" or "color.orange"
    colorProperty = new FrameworkProperty(this, "color", defaultValue:model.colorClass);

    versionProperty = new FrameworkProperty(this, 'version', defaultValue:buckshot.version);

    renderedOutputProperty = new FrameworkProperty(this, 'renderedOutput');

    templateTextProperty = new FrameworkProperty(this, 'templateText');

    errorMessageProperty = new FrameworkProperty(this, 'errorMessage');
  }

  /*
   * Event Handlers
   */

  /**
   * Handles click events coming from the 'refresh output' button
   */
  void refresh_handler(sender, args){

    // I had to put this here because the closure wasn't workign
    // correctly in the final{} block.
    void doError(String error){
      var errorView = new Error();

      errorView.ready.then((_){
        setValue(renderedOutputProperty, errorView.rootVisual);
        setValue(errorMessageProperty, error);
      });
    }

    String error = '';

    try{
      final tt = getValue(templateTextProperty).trim();

      if (tt == "") return;

      Template.deserialize(tt)
        .then((t) => setValue(renderedOutputProperty, t));
    }catch(AnimationException ae){
      error = "An error occurred while attempting to process an"
        " animation resource: ${ae}";
    }catch(PresentationProviderException pe){
      error = "We were unable to parse your input into content for"
        " display: ${pe}";
    }catch(FrameworkPropertyResolutionException pre){
      error = "A framework error occured while attempting to resolve"
        " a property binding: ${pre}";
    }catch(BuckshotException fe){
      error = "A framework error occured while attempting to render"
        " the content: ${fe}";
    }catch(Exception e){
      error = "A general exception occured while attempting to"
        " render the content.  Please bear with us as we (and Dart) are"
        " still in the early stages of development.  Thanks! ${e}";
    }finally{
      if (error == '') return;
      doError(error);
    }
  }

  /**
   * Handles click events coming from the 'clear all' button.
   */
  void clearAll_handler(sender, args){
    setValue(templateTextProperty, '');
    setValue(renderedOutputProperty, null);
  }

  /**
   * Handles selection changed events coming from the drop down lists.
   */
  void selection_handler(sender, SelectedItemChangedEventArgs<DropDownItem> args){
    final value = args.selectedItem.value.toString();

    if (value == ''){
      setValue(templateTextProperty, '');
      setValue(renderedOutputProperty, null);
    }else{
      final view = Template.getTemplate('#${value}');

      setValue(templateTextProperty, view);

      Template.deserialize(view).then((c){
        setValue(renderedOutputProperty, c);
      });
    }
  }
}