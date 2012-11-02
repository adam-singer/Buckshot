part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

class StringToColorConverter implements IValueConverter{

  const StringToColorConverter();

  dynamic convert(dynamic value, [dynamic parameter]){
    if (value.startsWith("#")){
      return new Color.hex(value);
    }

    //reflection... please get here soon...
    switch(value){
      case "AliceBlue":
        return new Color.predefined(Colors.AliceBlue);
      case "AntiqueWhite":
        return new Color.predefined(Colors.AntiqueWhite);
      case "Aqua":
        return new Color.predefined(Colors.Aqua);
      case "Aquamarine":
        return new Color.predefined(Colors.Aquamarine);
      case "Azure":
        return new Color.predefined(Colors.Azure);
      case "Beige":
        return new Color.predefined(Colors.Beige);
      case "Bisque":
        return new Color.predefined(Colors.Bisque);
      case "Black":
        return new Color.predefined(Colors.Black);
      case "BlanchedAlmond":
        return new Color.predefined(Colors.BlanchedAlmond);
      case "Blue":
        return new Color.predefined(Colors.Blue);
      case "BlueViolet":
        return new Color.predefined(Colors.BlueViolet);
      case "Brown":
        return new Color.predefined(Colors.Brown);
      case "BurlyWood":
        return new Color.predefined(Colors.BurlyWood);
      case "CadetBlue":
        return new Color.predefined(Colors.CadetBlue);
      case "Chartreuse":
        return new Color.predefined(Colors.Chartreuse);
      case "Chocolate":
        return new Color.predefined(Colors.Chocolate);
      case "Coral":
        return new Color.predefined(Colors.Coral);
      case "ConflowerBlue":
        return new Color.predefined(Colors.ConflowerBlue);
      case "Cornsilk":
        return new Color.predefined(Colors.Cornsilk);
      case "Crimson":
        return new Color.predefined(Colors.Crimson);
      case "Cyan":
        return new Color.predefined(Colors.Cyan);
      case "DarkBlue":
        return new Color.predefined(Colors.DarkBlue);
      case "DarkCyan":
        return new Color.predefined(Colors.DarkCyan);
      case "DarkGoldenrod":
        return new Color.predefined(Colors.DarkGoldenrod);
      case "DarkGray":
        return new Color.predefined(Colors.DarkGray);
      case "DarkGreen":
        return new Color.predefined(Colors.DarkGreen);
      case "DarkKhaki":
        return new Color.predefined(Colors.DarkKhaki);
      case "DarkMagenta":
        return new Color.predefined(Colors.DarkMagenta);
      case "DarkOliveGreen":
        return new Color.predefined(Colors.DarkOliveGreen);
      case "DarkOrange":
        return new Color.predefined(Colors.DarkOrange);
      case "DarkOrchid":
        return new Color.predefined(Colors.DarkOrchid);
      case "DarkRed":
        return new Color.predefined(Colors.DarkRed);
      case "DarkSalmon":
        return new Color.predefined(Colors.DarkSalmon);
      case "DarkSeaGreen":
        return new Color.predefined(Colors.DarkSeaGreen);
      case "DarkSlateBlue":
        return new Color.predefined(Colors.DarkSlateBlue);
      case "DarkSlateGray":
        return new Color.predefined(Colors.DarkSlateGray);
      case "DarkTurquoise":
        return new Color.predefined(Colors.DarkTurquoise);
      case "DarkViolet":
        return new Color.predefined(Colors.DarkViolet);
      case "DeepPink":
        return new Color.predefined(Colors.DeepPink);
      case "DeepSkyBlue":
        return new Color.predefined(Colors.DeepSkyBlue);
      case "DimGray":
        return new Color.predefined(Colors.DimGray);
      case "DodgerBlue":
        return new Color.predefined(Colors.DodgerBlue);
      case "Firebrick":
        return new Color.predefined(Colors.Firebrick);
      case "FloralWhite":
        return new Color.predefined(Colors.FloralWhite);
      case "ForestGreen":
        return new Color.predefined(Colors.ForestGreen);
      case "Fuchsia":
        return new Color.predefined(Colors.Fuchsia);
      case "Gainsboro":
        return new Color.predefined(Colors.Gainsboro);
      case "GhostWhite":
        return new Color.predefined(Colors.GhostWhite);
      case "Gold":
        return new Color.predefined(Colors.Gold);
      case "Goldenrod":
        return new Color.predefined(Colors.Goldenrod);
      case "Gray":
        return new Color.predefined(Colors.Gray);
      case "Green":
        return new Color.predefined(Colors.Green);
      case "GreenYellow":
        return new Color.predefined(Colors.GreenYellow);
      case "Honeydew":
        return new Color.predefined(Colors.Honeydew);
      case "HotPink":
        return new Color.predefined(Colors.HotPink);
      case "IndianRed":
        return new Color.predefined(Colors.IndianRed);
      case "Indigo":
        return new Color.predefined(Colors.Indigo);
      case "Ivory":
        return new Color.predefined(Colors.Ivory);
      case "Khaki":
        return new Color.predefined(Colors.Khaki);
      case "Lavender":
        return new Color.predefined(Colors.Lavender);
      case "LavenderBlush":
        return new Color.predefined(Colors.LavenderBlush);
      case "LawnGreen":
        return new Color.predefined(Colors.LawnGreen);
      case "LemonChiffon":
        return new Color.predefined(Colors.LemonChiffon);
      case "LightBlue":
        return new Color.predefined(Colors.LightBlue);
      case "LightCoral":
        return new Color.predefined(Colors.LightCoral);
      case "LightCyan":
        return new Color.predefined(Colors.LightCyan);
      case "LightGoldenrod":
        return new Color.predefined(Colors.LightGoldenrod);
      case "LightGray":
        return new Color.predefined(Colors.LightGray);
      case "LightGreen":
        return new Color.predefined(Colors.LightGreen);
      case "LightPink":
        return new Color.predefined(Colors.LightPink);
      case "LightSalmon":
        return new Color.predefined(Colors.LightSalmon);
      case "LightSeaGreen":
        return new Color.predefined(Colors.LightSeaGreen);
      case "LightSkyBlue":
        return new Color.predefined(Colors.LightSkyBlue);
      case "LightSlateGray":
        return new Color.predefined(Colors.LightSlateGray);
      case "LightSteelBlue":
        return new Color.predefined(Colors.LightSteelBlue);
      case "LightYellow":
        return new Color.predefined(Colors.LightYellow);
      case "Lime":
        return new Color.predefined(Colors.Lime);
      case "LimeGreen":
        return new Color.predefined(Colors.LimeGreen);
      case "Linen":
        return new Color.predefined(Colors.Linen);
      case "Magenta":
        return new Color.predefined(Colors.Magenta);
      case "Maroon":
        return new Color.predefined(Colors.Maroon);
      case "MediumAquamarine":
        return new Color.predefined(Colors.MediumAquamarine);
      case "MediumBlue":
        return new Color.predefined(Colors.MediumBlue);
      case "MediumOrchid":
        return new Color.predefined(Colors.MediumOrchid);
      case "MediumPurple":
        return new Color.predefined(Colors.MediumPurple);
      case "MediumSeaGreen":
        return new Color.predefined(Colors.MediumSeaGreen);
      case "MediumSlateBlue":
        return new Color.predefined(Colors.MediumSlateBlue);
      case "MediumSpringGreen":
        return new Color.predefined(Colors.MediumSpringGreen);
      case "MediumTurquoise":
        return new Color.predefined(Colors.MediumTurquoise);
      case "MediumVioletRed":
        return new Color.predefined(Colors.MediumVioletRed);
      case "MidnightBlue":
        return new Color.predefined(Colors.MidnightBlue);
      case "MintCream":
        return new Color.predefined(Colors.MintCream);
      case "MistyRose":
        return new Color.predefined(Colors.MistyRose);
      case "Moccasin":
        return new Color.predefined(Colors.Moccasin);
      case "NavajoWhite":
        return new Color.predefined(Colors.NavajoWhite);
      case "Navy":
        return new Color.predefined(Colors.Navy);
      case "OldLace":
        return new Color.predefined(Colors.OldLace);
      case "Olive":
        return new Color.predefined(Colors.Olive);
      case "OliveDrab":
        return new Color.predefined(Colors.OliveDrab);
      case "Orange":
        return new Color.predefined(Colors.Orange);
      case "OrangeRed":
        return new Color.predefined(Colors.OrangeRed);
      case "Orchid":
        return new Color.predefined(Colors.Orchid);
      case "PaleGoldenrod":
        return new Color.predefined(Colors.PaleGoldenrod);
      case "PaleGreen":
        return new Color.predefined(Colors.PaleGreen);
      case "PaleTurquoise":
        return new Color.predefined(Colors.PaleTurquoise);
      case "PaleVioletRed":
        return new Color.predefined(Colors.PaleVioletRed);
      case "PapayaWhip":
        return new Color.predefined(Colors.PapayaWhip);
      case "PeachPuff":
        return new Color.predefined(Colors.PeachPuff);
      case "Peru":
        return new Color.predefined(Colors.Peru);
      case "Pink":
        return new Color.predefined(Colors.Pink);
      case "Plum":
        return new Color.predefined(Colors.Plum);
      case "PowderBlue":
        return new Color.predefined(Colors.PowderBlue);
      case "Purple":
        return new Color.predefined(Colors.Purple);
      case "Red":
        return new Color.predefined(Colors.Red);
      case "RosyBrown":
        return new Color.predefined(Colors.RosyBrown);
      case "RoyalBlue":
        return new Color.predefined(Colors.RoyalBlue);
      case "SaddleBrown":
        return new Color.predefined(Colors.SaddleBrown);
      case "Salmon":
        return new Color.predefined(Colors.Salmon);
      case "SandyBrown":
        return new Color.predefined(Colors.SandyBrown);
      case "SeaGreen":
        return new Color.predefined(Colors.SeaGreen);
      case "SeaShell":
        return new Color.predefined(Colors.SeaShell);
      case "Sienna":
        return new Color.predefined(Colors.Sienna);
      case "Silver":
        return new Color.predefined(Colors.Silver);
      case "SkyBlue":
        return new Color.predefined(Colors.SkyBlue);
      case "SlateBlue":
        return new Color.predefined(Colors.SlateBlue);
      case "SlateGray":
        return new Color.predefined(Colors.SlateGray);
      case "Snow":
        return new Color.predefined(Colors.Snow);
      case "SpringGreen":
        return new Color.predefined(Colors.SpringGreen);
      case "SteelBlue":
        return new Color.predefined(Colors.SteelBlue);
      case "Tan":
        return new Color.predefined(Colors.Tan);
      case "Teal":
        return new Color.predefined(Colors.Teal);
      case "Thistle":
        return new Color.predefined(Colors.Thistle);
      case "Tomato":
        return new Color.predefined(Colors.Tomato);
      case "Turquoise":
        return new Color.predefined(Colors.Turquoise);
      case "Violet":
        return new Color.predefined(Colors.Violet);
      case "Wheat":
        return new Color.predefined(Colors.Wheat);
      case "White":
        return new Color.predefined(Colors.White);
      case "WhiteSmoke":
        return new Color.predefined(Colors.WhiteSmoke);
      case "Yellow":
        return new Color.predefined(Colors.Yellow);
      case "YellowGreen":
        return new Color.predefined(Colors.YellowGreen);
      default:
        return new Color.predefined(Colors.Red);
    }
  }
}
