part of switchy;

class MasterViewModel extends ViewModelBase
{
  FrameworkProperty<String> statusMessage;
  FrameworkProperty<FrameworkElement> content;

  final View _calc = new Calculator();
  final View _home = new Home();
  final View _clock = new Clock();
  final View _ticker = new StockTicker();

  MasterViewModel(){
    _initMasterViewModelProperties();

    registerEventHandler('menu_selected', menu_selected);

    setContent(_home);
  }

  void _initMasterViewModelProperties(){
    statusMessage = new FrameworkProperty(this, 'statusMessage',
        defaultValue: 'Home view selected.');

    content = new FrameworkProperty(this, 'content');
  }

  String _viewNameFromInstanceOf(View view){
    return '$view'.replaceFirst("Instance of '",'').replaceFirst("'", "");
  }

  void setContent(View contentView){
    contentView.ready.then((t){
      statusMessage.value = '${_viewNameFromInstanceOf(contentView)} view selected.';
      content.value = t;
    });
  }

  /**
   * Displays a status [message] and then returns to the previous message
   * after a given (optional) [timeInMs].
   *
   * Default value is 4000ms (4 seconds).
   */
  void setTemporaryMessage(String message, {num timeInMs : 4000}){
    //TODO add queuing for overlapping messages

    final oldStatusMessage = statusMessage.value;

    void resetMessage(_){
      statusMessage.value = oldStatusMessage;
    }

    statusMessage.value = message;
    new Timer(timeInMs, resetMessage);
  }

  showAboutDialog(){
    var header = new View.fromResource('web/views/templates/about_header.xml');
    var body = new View.fromResource('web/views/templates/about_body.xml');
    var oldStatusMessage = statusMessage.value;

    statusMessage.value = "Displaying 'About Switchy' dialog.";

    Futures
      .wait([header.ready, body.ready])
      .chain((results){
        final md = new ModalDialog
          .with(results[0], results[1], ModalDialog.Ok);
        return md.show();
      })
      .then((_){
        statusMessage.value = oldStatusMessage;
      });
  }


  void _openTabTo(String uri){
    window.open(uri, '_blank');
    setTemporaryMessage('Opened $uri.');
  }



  // Event handlers

  void menu_selected(sender, MenuItemSelectedEventArgs args){

    final selection =
        args.selectedMenuItem == null ? sender : args.selectedMenuItem;

    final tag = selection.tag.value;

    if (tag == null) return;

    switch(tag){
      case 'buckshot_repo':
        _openTabTo('https://github.com/prujohn/Buckshot');
        break;
      case 'buckshot_discuss':
        _openTabTo('https://groups.google.com/forum/?fromgroups#!forum/buckshot-ui');
        break;
      case 'buckshot_videos':
        _openTabTo('http://www.youtube.com/playlist?list=PLE04C8698A5FD2E9E&feature=view_all');
        break;
      case 'buckshot_sandbox':
        _openTabTo('http://www.buckshotui.org/sandbox/?demo=welcome');
        break;
      case 'buckshot_blog':
        _openTabTo('http://phylotic.blogspot.com/search/label/buckshot');
        break;
      case 'buckshot_gplus':
        _openTabTo('https://plus.google.com/105133271658972815666/posts');
        break;
      case 'buckshot_suggest':
        _openTabTo('http://www.google.com/moderator/#15/e=202f1d&t=202f1d.40');
        break;
      case 'calculator':
        setContent(_calc);
        break;
      case 'home':
        setContent(_home);
        break;
      case 'clock':
        setContent(_clock);
        break;
      case 'stock_ticker':
        setContent(_ticker);
        break;
      case 'about':
        showAboutDialog();
        break;
      default:
        print('$tag');
        break;
    }
  }
}
