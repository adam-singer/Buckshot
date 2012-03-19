#import('../../core/LUCA_UI_Framework.dart');
#import('../DemoStyles/DemoStyles.dart');
#import('dart:html');
#source('InHalfValueConverter.dart');


// To compile:
// minfrog --out=Colors.dart.app.js --compile-only Colors.dart

/**
* Demonstrates LUCA UI pre-defined colors.
*
* Since the LUCA UI library is not yet optimized for performance, it may take a few seconds for the layout to render.
*/
class ColorsDemo {
  //instantiate style resources
  StyleResources resources;
  
  void run() {
    //init Luca UI
    new LucaSystem();

    resources = new StyleResources();
    
    List<Colors> colors = getColorList();
    
    num columns = 14;
    num rows = (colors.length / 14).ceil();
        
    //since we know this app owns the entire browser window space...
    //bind LucaSystem.visualRoot to window dimensions
    new Binding(LucaSystem.windowWidthProperty, LucaSystem.visualRoot.widthProperty);
    new Binding(LucaSystem.windowHeightProperty, LucaSystem.visualRoot.heightProperty);
    
    Grid mainGrid = new Grid();
    mainGrid.style = resources.mainGridStyle;

    Border outerContentBorder = new Border();
    outerContentBorder.style = resources.contentBorderStyle;
    Grid.setRow(outerContentBorder, 2);
    mainGrid.children.add(outerContentBorder);
    
    Border innerContentBorder = new Border();
    innerContentBorder.style = resources.innerBorderStyle;
    outerContentBorder.content = innerContentBorder;
    
    TextBlock title = new TextBlock();
    title.style = resources.titleTextBlockStyle;
    title.text = "LUCA UI Framework Pre-Defined Colors";
    mainGrid.children.add(title);
    
    TextBlock subTitle = new TextBlock();
    subTitle.style = resources.subTitleTextBlockStyle;
    subTitle.text = "These standard colors are available for use in the framework. You can also specify your own RGB values when creating colors.";
    Grid.setRow(subTitle, 1);
    mainGrid.children.add(subTitle);
      
    Grid colorGrid = buildColorGrid(columns, rows);
    colorGrid.name = "colorGrid";
    innerContentBorder.content = colorGrid;
    
    for (int r = 0; r < rows; r++){
      for (int c = 0; c < columns; c++){
        int index = (r * columns) + c;
        Color nextColor = new Color.predefined(colors[index]);
        
        Border b = new Border();
        b.style = resources.stretchedStyle;
        b.background = new SolidColorBrush(nextColor);
        Grid.setColumn(b, c);
        Grid.setRow(b, r);
        
        TextBlock tb = new TextBlock();
        tb.text = colors[index].name;
        tb.fontSize = 10;
        tb.style = resources.centeredStyle;
        
        //set the text to white for darker colors
        if ((nextColor.R + nextColor.G + nextColor.B) / 3 < 86)
          tb.foreground = new SolidColorBrush(new Color.predefined(Colors.White));
        
        b.content = tb;
        
        colorGrid.children.add(b);
      }
    }
    
    LucaSystem.renderRaw(mainGrid);
  }

  Grid buildColorGrid(int columns, int rows)
  {
    if (columns < 1 || rows < 1) throw const Exception("Invalid column or row value.");
    
    Grid colorGrid = new Grid();
    colorGrid.background = new SolidColorBrush(new Color.predefined(Colors.Red));
    colorGrid.style = resources.stretchedStyle;
    
    //build columns
    for(int i = 0; i < columns; i++){
      colorGrid.columnDefinitions.add(new ColumnDefinition.with(new GridLength.star(1)));
    }
    
    //build rows
    for(int i = 0; i < rows; i++){
      colorGrid.rowDefinitions.add(new RowDefinition.with(new GridLength.star(1)));
    }
    
    return colorGrid;
  }
  
}


List<Colors> getColorList(){
  return const [Colors.AliceBlue,
                 Colors.AntiqueWhite,
                 Colors.Aqua,
                 Colors.Aquamarine,
                 Colors.Azure,
                 Colors.Beige,
                 Colors.Bisque,
                 Colors.Black,
                 Colors.BlanchedAlmond,
                 Colors.Blue,
                 Colors.BlueViolet,
                 Colors.Brown,
                 Colors.BurlyWood,
                 Colors.CadetBlue,
                 Colors.Chartreuse,
                 Colors.Chocolate,
                 Colors.Coral,
                 Colors.ConflowerBlue,
                 Colors.Cornsilk,
                 Colors.Crimson,
                 Colors.Cyan,
                 Colors.DarkBlue,
                 Colors.DarkCyan,
                 Colors.DarkGoldenrod,
                 Colors.DarkGray,
                 Colors.DarkGreen,
                 Colors.DarkKhaki,
                 Colors.DarkMagenta,
                 Colors.DarkOliveGreen,
                 Colors.DarkOrange,
                 Colors.DarkOrchid,
                 Colors.DarkRed,
                 Colors.DarkSalmon,
                 Colors.DarkSeaGreen,
                 Colors.DarkSlateBlue,
                 Colors.DarkSlateGray,
                 Colors.DarkTurquoise,
                 Colors.DarkViolet,
                 Colors.DeepPink,
                 Colors.DeepSkyBlue,
                 Colors.DimGray,
                 Colors.DodgerBlue,
                 Colors.Firebrick,
                 Colors.FloralWhite,
                 Colors.ForestGreen,
                 Colors.Fuchsia,
                 Colors.Gainsboro,
                 Colors.GhostWhite,
                 Colors.Gold,
                 Colors.Goldenrod,
                 Colors.Gray,
                 Colors.Green,
                 Colors.GreenYellow,
                 Colors.Honeydew,
                 Colors.HotPink,
                 Colors.IndianRed,
                 Colors.Indigo,
                 Colors.Ivory,
                 Colors.Khaki,
                 Colors.Lavender,
                 Colors.LavenderBlush,
                 Colors.LawnGreen,
                 Colors.LemonChiffon,
                 Colors.LightBlue,
                 Colors.LightCoral,
                 Colors.LightCyan,
                 Colors.LightGoldenrod,
                 Colors.LightGray,
                 Colors.LightGreen,
                 Colors.LightPink,
                 Colors.LightSalmon,
                 Colors.LightSeaGreen,
                 Colors.LightSkyBlue,
                 Colors.LightSlateGray,
                 Colors.LightSteelBlue,
                 Colors.LightYellow,
                 Colors.Lime,
                 Colors.LimeGreen,
                 Colors.Linen,
                 Colors.Magenta,
                 Colors.Maroon,
                 Colors.MediumAquamarine,
                 Colors.MediumBlue,
                 Colors.MediumOrchid,
                 Colors.MediumPurple,
                 Colors.MediumSeaGreen,
                 Colors.MediumSlateBlue,
                 Colors.MediumSpringGreen,
                 Colors.MediumTurquoise,
                 Colors.MediumVioletRed,
                 Colors.MidnightBlue,
                 Colors.MintCream,
                 Colors.MistyRose,
                 Colors.Moccasin,
                 Colors.NavajoWhite,
                 Colors.Navy,
                 Colors.OldLace,
                 Colors.Olive,
                 Colors.OliveDrab,
                 Colors.Orange,
                 Colors.OrangeRed,
                 Colors.Orchid,
                 Colors.PaleGoldenrod,
                 Colors.PaleGreen,
                 Colors.PaleTurquoise,
                 Colors.PaleVioletRed,
                 Colors.PapayaWhip,
                 Colors.PeachPuff,
                 Colors.Peru,
                 Colors.Pink,
                 Colors.Plum,
                 Colors.PowderBlue,
                 Colors.Purple,
                 Colors.Red,
                 Colors.RosyBrown,
                 Colors.RoyalBlue,
                 Colors.SaddleBrown,
                 Colors.Salmon,
                 Colors.SandyBrown,
                 Colors.SeaGreen,
                 Colors.SeaShell,
                 Colors.Sienna,
                 Colors.Silver,
                 Colors.SkyBlue,
                 Colors.SlateBlue,
                 Colors.SlateGray,
                 Colors.Snow,
                 Colors.SpringGreen,
                 Colors.SteelBlue,
                 Colors.Tan,
                 Colors.Teal,
                 Colors.Thistle,
                 Colors.Tomato,
                 Colors.Turquoise,
                 Colors.Violet,
                 Colors.Wheat,
                 Colors.White,
                 Colors.WhiteSmoke,
                 Colors.Yellow,
                 Colors.YellowGreen];
}

void main() {
  new ColorsDemo().run();
}
