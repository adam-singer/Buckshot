// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

class StringToColorConverter implements IValueConverter{
  
  const StringToColorConverter();
  
  Dynamic convert(Dynamic value, [Dynamic parameter]){
    
    if (value.startsWith("#")){
      return new Color.hex(value);
    }else{

      //reflection... please get here soon...
      switch(value){
        case "AliceBlue":
          return new Color.hex(Colors.AliceBlue.toString());
        case "AntiqueWhite":
          return new Color.hex(Colors.AntiqueWhite.toString());
        case "Aqua":
          return new Color.hex(Colors.Aqua.toString());
        case "Aquamarine":
          return new Color.hex(Colors.Aquamarine.toString());
        case "Azure":
          return new Color.hex(Colors.Azure.toString());
        case "Beige":
          return new Color.hex(Colors.Beige.toString());
        case "Bisque":
          return new Color.hex(Colors.Bisque.toString());
        case "Black":
          return new Color.hex(Colors.Black.toString());
        case "BlanchedAlmond":
          return new Color.hex(Colors.BlanchedAlmond.toString());
        case "Blue":
          return new Color.hex(Colors.Blue.toString());
        case "BlueViolet":
          return new Color.hex(Colors.BlueViolet.toString());
        case "Brown":
          return new Color.hex(Colors.Brown.toString());
        case "BurlyWood":
          return new Color.hex(Colors.BurlyWood.toString());
        case "CadetBlue":
          return new Color.hex(Colors.CadetBlue.toString());
        case "Chartreuse":
          return new Color.hex(Colors.Chartreuse.toString());
        case "Chocolate":
          return new Color.hex(Colors.Chocolate.toString());
        case "Coral":
          return new Color.hex(Colors.Coral.toString());
        case "ConflowerBlue":
          return new Color.hex(Colors.ConflowerBlue.toString());
        case "Cornsilk":
          return new Color.hex(Colors.Cornsilk.toString());
        case "Crimson":
          return new Color.hex(Colors.Crimson.toString());
        case "Cyan":
          return new Color.hex(Colors.Cyan.toString());
        case "DarkBlue":
          return new Color.hex(Colors.DarkBlue.toString());
        case "DarkCyan":
          return new Color.hex(Colors.DarkCyan.toString());
        case "DarkGoldenrod":
          return new Color.hex(Colors.DarkGoldenrod.toString());
        case "DarkGray":
          return new Color.hex(Colors.DarkGray.toString());
        case "DarkGreen":
          return new Color.hex(Colors.DarkGreen.toString());
        case "DarkKhaki":
          return new Color.hex(Colors.DarkKhaki.toString());
        case "DarkMagenta":
          return new Color.hex(Colors.DarkMagenta.toString());
        case "DarkOliveGreen":
          return new Color.hex(Colors.DarkOliveGreen.toString());
        case "DarkOrange":
          return new Color.hex(Colors.DarkOrange.toString());
        case "DarkOrchid":
          return new Color.hex(Colors.DarkOrchid.toString());
        case "DarkRed":
          return new Color.hex(Colors.DarkRed.toString());
        case "DarkSalmon":
          return new Color.hex(Colors.DarkSalmon.toString());
        case "DarkSeaGreen":
          return new Color.hex(Colors.DarkSeaGreen.toString());
        case "DarkSlateBlue":
          return new Color.hex(Colors.DarkSlateBlue.toString());
        case "DarkSlateGray":
          return new Color.hex(Colors.DarkSlateGray.toString());
        case "DarkTurquoise":
          return new Color.hex(Colors.DarkTurquoise.toString());
        case "DarkViolet":
          return new Color.hex(Colors.DarkViolet.toString());
        case "DeepPink":
          return new Color.hex(Colors.DeepPink.toString());
        case "DeepSkyBlue":
          return new Color.hex(Colors.DeepSkyBlue.toString());
        case "DimGray":
          return new Color.hex(Colors.DimGray.toString());
        case "DodgerBlue":
          return new Color.hex(Colors.DodgerBlue.toString());
        case "Firebrick":
          return new Color.hex(Colors.Firebrick.toString());
        case "FloralWhite":
          return new Color.hex(Colors.FloralWhite.toString());
        case "ForestGreen":
          return new Color.hex(Colors.ForestGreen.toString());
        case "Fuchsia":
          return new Color.hex(Colors.Fuchsia.toString());
        case "Gainsboro":
          return new Color.hex(Colors.Gainsboro.toString());
        case "GhostWhite":
          return new Color.hex(Colors.GhostWhite.toString());
        case "Gold":
          return new Color.hex(Colors.Gold.toString());
        case "Goldenrod":
          return new Color.hex(Colors.Goldenrod.toString());
        case "Gray":
          return new Color.hex(Colors.Gray.toString());
        case "Green":
          return new Color.hex(Colors.Green.toString());
        case "GreenYellow":
          return new Color.hex(Colors.GreenYellow.toString());
        case "Honeydew":
          return new Color.hex(Colors.Honeydew.toString());
        case "HotPink":
          return new Color.hex(Colors.HotPink.toString());
        case "IndianRed":
          return new Color.hex(Colors.IndianRed.toString());
        case "Indigo":
          return new Color.hex(Colors.Indigo.toString());
        case "Ivory":
          return new Color.hex(Colors.Ivory.toString());
        case "Khaki":
          return new Color.hex(Colors.Khaki.toString());
        case "Lavender":
          return new Color.hex(Colors.Lavender.toString());
        case "LavenderBlush":
          return new Color.hex(Colors.LavenderBlush.toString());
        case "LawnGreen":
          return new Color.hex(Colors.LawnGreen.toString());
        case "LemonChiffon":
          return new Color.hex(Colors.LemonChiffon.toString());
        case "LightBlue":
          return new Color.hex(Colors.LightBlue.toString());
        case "LightCoral":
          return new Color.hex(Colors.LightCoral.toString());
        case "LightCyan":
          return new Color.hex(Colors.LightCyan.toString());
        case "LightGoldenrod":
          return new Color.hex(Colors.LightGoldenrod.toString());
        case "LightGray":
          return new Color.hex(Colors.LightGray.toString());
        case "LightGreen":
          return new Color.hex(Colors.LightGreen.toString());
        case "LightPink":
          return new Color.hex(Colors.LightPink.toString());
        case "LightSalmon":
          return new Color.hex(Colors.LightSalmon.toString());
        case "LightSeaGreen":
          return new Color.hex(Colors.LightSeaGreen.toString());
        case "LightSkyBlue":
          return new Color.hex(Colors.LightSkyBlue.toString());
        case "LightSlateGray":
          return new Color.hex(Colors.LightSlateGray.toString());
        case "LightSteelBlue":
          return new Color.hex(Colors.LightSteelBlue.toString());
        case "LightYellow":
          return new Color.hex(Colors.LightYellow.toString());
        case "Lime":
          return new Color.hex(Colors.Lime.toString());
        case "LimeGreen":
          return new Color.hex(Colors.LimeGreen.toString());
        case "Linen":
          return new Color.hex(Colors.Linen.toString());
        case "Magenta":
          return new Color.hex(Colors.Magenta.toString());
        case "Maroon":
          return new Color.hex(Colors.Maroon.toString());
        case "MediumAquamarine":
          return new Color.hex(Colors.MediumAquamarine.toString());
        case "MediumBlue":
          return new Color.hex(Colors.MediumBlue.toString());
        case "MediumOrchid":
          return new Color.hex(Colors.MediumOrchid.toString());
        case "MediumPurple":
          return new Color.hex(Colors.MediumPurple.toString());
        case "MediumSeaGreen":
          return new Color.hex(Colors.MediumSeaGreen.toString());
        case "MediumSlateBlue":
          return new Color.hex(Colors.MediumSlateBlue.toString());
        case "MediumSpringGreen":
          return new Color.hex(Colors.MediumSpringGreen.toString());
        case "MediumTurquoise":
          return new Color.hex(Colors.MediumTurquoise.toString());
        case "MediumVioletRed":
          return new Color.hex(Colors.MediumVioletRed.toString());
        case "MidnightBlue":
          return new Color.hex(Colors.MidnightBlue.toString());
        case "MintCream":
          return new Color.hex(Colors.MintCream.toString());
        case "MistyRose":
          return new Color.hex(Colors.MistyRose.toString());
        case "Moccasin":
          return new Color.hex(Colors.Moccasin.toString());
        case "NavajoWhite":
          return new Color.hex(Colors.NavajoWhite.toString());
        case "Navy":
          return new Color.hex(Colors.Navy.toString());
        case "OldLace":
          return new Color.hex(Colors.OldLace.toString());
        case "Olive":
          return new Color.hex(Colors.Olive.toString());
        case "OliveDrab":
          return new Color.hex(Colors.OliveDrab.toString());
        case "Orange":
          return new Color.hex(Colors.Orange.toString());
        case "OrangeRed":
          return new Color.hex(Colors.OrangeRed.toString());
        case "Orchid":
          return new Color.hex(Colors.Orchid.toString());
        case "PaleGoldenrod":
          return new Color.hex(Colors.PaleGoldenrod.toString());
        case "PaleGreen":
          return new Color.hex(Colors.PaleGreen.toString());
        case "PaleTurquoise":
          return new Color.hex(Colors.PaleTurquoise.toString());
        case "PaleVioletRed":
          return new Color.hex(Colors.PaleVioletRed.toString());
        case "PapayaWhip":
          return new Color.hex(Colors.PapayaWhip.toString());
        case "PeachPuff":
          return new Color.hex(Colors.PeachPuff.toString());
        case "Peru":
          return new Color.hex(Colors.Peru.toString());
        case "Pink":
          return new Color.hex(Colors.Pink.toString());
        case "Plum":
          return new Color.hex(Colors.Plum.toString());
        case "PowderBlue":
          return new Color.hex(Colors.PowderBlue.toString());
        case "Purple":
          return new Color.hex(Colors.Purple.toString());
        case "Red":
          return new Color.hex(Colors.Red.toString());
        case "RosyBrown":
          return new Color.hex(Colors.RosyBrown.toString());
        case "RoyalBlue":
          return new Color.hex(Colors.RoyalBlue.toString());
        case "SaddleBrown":
          return new Color.hex(Colors.SaddleBrown.toString());
        case "Salmon":
          return new Color.hex(Colors.Salmon.toString());
        case "SandyBrown":
          return new Color.hex(Colors.SandyBrown.toString());
        case "SeaGreen":
          return new Color.hex(Colors.SeaGreen.toString());
        case "SeaShell":
          return new Color.hex(Colors.SeaShell.toString());
        case "Sienna":
          return new Color.hex(Colors.Sienna.toString());
        case "Silver":
          return new Color.hex(Colors.Silver.toString());
        case "SkyBlue":
          return new Color.hex(Colors.SkyBlue.toString());
        case "SlateBlue":
          return new Color.hex(Colors.SlateBlue.toString());
        case "SlateGray":
          return new Color.hex(Colors.SlateGray.toString());
        case "Snow":
          return new Color.hex(Colors.Snow.toString());
        case "SpringGreen":
          return new Color.hex(Colors.SpringGreen.toString());
        case "SteelBlue":
          return new Color.hex(Colors.SteelBlue.toString());
        case "Tan":
          return new Color.hex(Colors.Tan.toString());
        case "Teal":
          return new Color.hex(Colors.Teal.toString());
        case "Thistle":
          return new Color.hex(Colors.Thistle.toString());
        case "Tomato":
          return new Color.hex(Colors.Tomato.toString());
        case "Turquoise":
          return new Color.hex(Colors.Turquoise.toString());
        case "Violet":
          return new Color.hex(Colors.Violet.toString());
        case "Wheat":
          return new Color.hex(Colors.Wheat.toString());
        case "White":
          return new Color.hex(Colors.White.toString());
        case "WhiteSmoke":
          return new Color.hex(Colors.WhiteSmoke.toString());
        case "Yellow":
          return new Color.hex(Colors.Yellow.toString());
        case "YellowGreen":
          return new Color.hex(Colors.YellowGreen.toString());
        default:
          return value;
      } 
    }
  }  
}
