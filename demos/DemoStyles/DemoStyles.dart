#library('Buckshot Demo Style Templates');
#import('../../lib/Buckshot.dart');
#import('dart:html');


/**
* Provides standard StyleTemplate's for Buckshot Demo Projects */
interface StyleResources default _templateResources
{ 
  StyleResources();
  //using the interface gives a cleaner api for the editor's intellisense
  final StyleTemplate contentBorderStyle;
  StyleTemplate innerBorderStyle;
  StyleTemplate mainGridStyle;
  StyleTemplate titleTextBlockStyle;
  StyleTemplate subTitleTextBlockStyle;
  StyleTemplate centeredStyle;
  StyleTemplate stretchedStyle;
}


//internal implementation class is library "private"
class _templateResources implements StyleResources
{
  final StyleTemplate contentBorderStyle;
  final StyleTemplate innerBorderStyle;
  final StyleTemplate mainGridStyle;
  final StyleTemplate titleTextBlockStyle;
  final StyleTemplate subTitleTextBlockStyle;
  final StyleTemplate centeredStyle;
  final StyleTemplate stretchedStyle;
  
  _templateResources():
    contentBorderStyle = new StyleTemplate(),
    innerBorderStyle = new StyleTemplate(),
    mainGridStyle = new StyleTemplate(),
    titleTextBlockStyle = new StyleTemplate(),
    subTitleTextBlockStyle = new StyleTemplate(),
    centeredStyle = new StyleTemplate(),
    stretchedStyle = new StyleTemplate()
  {
    _initCenteredStyle();
    _initStretchedStyle();
    _initContentBorder();
    _initInnerBorder();
    _initMainGrid();
    _initTitleTextBlock();
    _initSubTitleTextBlock();
  }
  
  void _initStretchedStyle(){
    stretchedStyle.setProperty("horizontalAlignment", HorizontalAlignment.stretch);
    stretchedStyle.setProperty("verticalAlignment", VerticalAlignment.stretch);
  }
  
  void _initCenteredStyle(){
    centeredStyle.setProperty("horizontalAlignment", HorizontalAlignment.center);
    centeredStyle.setProperty("verticalAlignment", VerticalAlignment.center);
  }
  
  void _initTitleTextBlock(){
    titleTextBlockStyle.setProperty("fontSize", 32);
    titleTextBlockStyle.setProperty("foreground", new SolidColorBrush(new Color.predefined(Colors.White)));
    titleTextBlockStyle.setProperty("margin", new Thickness(10));
    titleTextBlockStyle.setProperty("horizontalAlignment", HorizontalAlignment.center);
  }
  
  void _initSubTitleTextBlock(){
    subTitleTextBlockStyle.setProperty("fontSize", 16);
    subTitleTextBlockStyle.setProperty("foreground", new SolidColorBrush(new Color.predefined(Colors.White)));
    subTitleTextBlockStyle.setProperty("margin", new Thickness(10));
    subTitleTextBlockStyle.setProperty("horizontalAlignment", HorizontalAlignment.center);
  }
  
  
  void _initMainGrid(){
    
    LinearGradientBrush lgb = new LinearGradientBrush();
    lgb.direction = LinearGradientDirection.vertical;
    lgb.stops.add(new GradientStop.with(new Color.hex("#3333AA"), 65));
    lgb.stops.add(new GradientStop.with(new Color.predefined(Colors.Black)));
  
    ObservableList<RowDefinition> rList = new ObservableList<RowDefinition>();
    rList.add(new RowDefinition.with(new GridLength.auto()));
    rList.add(new RowDefinition.with(new GridLength.auto()));
    rList.add(new RowDefinition.with(new GridLength.star(1)));
    
    mainGridStyle.setProperty("background", lgb);
    mainGridStyle.setProperty("rowDefinitions", rList);
    mainGridStyle.mergeWith([stretchedStyle]);

  } 
  
  void _initContentBorder(){
    contentBorderStyle.setProperty("margin", new Thickness(10));
    contentBorderStyle.setProperty("borderThickness", new Thickness(10));
    contentBorderStyle.setProperty("borderColor", new SolidColorBrush(new Color.hex("#AAAAAA")));
    contentBorderStyle.setProperty("cornerRadius", 10);
    contentBorderStyle.setProperty("background", new SolidColorBrush(new Color.predefined(Colors.WhiteSmoke)));
    contentBorderStyle.mergeWith([stretchedStyle]);
  }

  void _initInnerBorder(){
    innerBorderStyle.setProperty("borderThickness", new Thickness(5));
    innerBorderStyle.setProperty("borderColor", new SolidColorBrush(new Color.hex("#808080")));
    innerBorderStyle.mergeWith([stretchedStyle]);
  }
}
