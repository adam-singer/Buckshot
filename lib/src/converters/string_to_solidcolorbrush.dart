part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.
class StringToSolidColorBrushConverter implements IValueConverter
{

  const StringToSolidColorBrushConverter();

  dynamic convert(dynamic value, [dynamic parameter]){

    if (value is! String) {
      new Logger('buckshot.StringToSolidColorBrushConverter')
        .warning('Expected ($value) to be type String');
      return value;
    }

    if (value.startsWith("#")){
      return new SolidColorBrush(new Color.hex(value));
    }

    //reflection... please get here soon...
    switch(value){
      case "AliceBlue":
        return new SolidColorBrush(new Color.predefined(Colors.AliceBlue));
      case "AntiqueWhite":
        return new SolidColorBrush(new Color.predefined(Colors.AntiqueWhite));
      case "Aqua":
        return new SolidColorBrush(new Color.predefined(Colors.Aqua));
      case "Aquamarine":
        return new SolidColorBrush(new Color.predefined(Colors.Aquamarine));
      case "Azure":
        return new SolidColorBrush(new Color.predefined(Colors.Azure));
      case "Beige":
        return new SolidColorBrush(new Color.predefined(Colors.Beige));
      case "Bisque":
        return new SolidColorBrush(new Color.predefined(Colors.Bisque));
      case "Black":
        return new SolidColorBrush(new Color.predefined(Colors.Black));
      case "BlanchedAlmond":
        return new SolidColorBrush(new Color.predefined(Colors.BlanchedAlmond));
      case "Blue":
        return new SolidColorBrush(new Color.predefined(Colors.Blue));
      case "BlueViolet":
        return new SolidColorBrush(new Color.predefined(Colors.BlueViolet));
      case "Brown":
        return new SolidColorBrush(new Color.predefined(Colors.Brown));
      case "BurlyWood":
        return new SolidColorBrush(new Color.predefined(Colors.BurlyWood));
      case "CadetBlue":
        return new SolidColorBrush(new Color.predefined(Colors.CadetBlue));
      case "Chartreuse":
        return new SolidColorBrush(new Color.predefined(Colors.Chartreuse));
      case "Chocolate":
        return new SolidColorBrush(new Color.predefined(Colors.Chocolate));
      case "Coral":
        return new SolidColorBrush(new Color.predefined(Colors.Coral));
      case "ConflowerBlue":
        return new SolidColorBrush(new Color.predefined(Colors.ConflowerBlue));
      case "Cornsilk":
        return new SolidColorBrush(new Color.predefined(Colors.Cornsilk));
      case "Crimson":
        return new SolidColorBrush(new Color.predefined(Colors.Crimson));
      case "Cyan":
        return new SolidColorBrush(new Color.predefined(Colors.Cyan));
      case "DarkBlue":
        return new SolidColorBrush(new Color.predefined(Colors.DarkBlue));
      case "DarkCyan":
        return new SolidColorBrush(new Color.predefined(Colors.DarkCyan));
      case "DarkGoldenrod":
        return new SolidColorBrush(new Color.predefined(Colors.DarkGoldenrod));
      case "DarkGray":
        return new SolidColorBrush(new Color.predefined(Colors.DarkGray));
      case "DarkGreen":
        return new SolidColorBrush(new Color.predefined(Colors.DarkGreen));
      case "DarkKhaki":
        return new SolidColorBrush(new Color.predefined(Colors.DarkKhaki));
      case "DarkMagenta":
        return new SolidColorBrush(new Color.predefined(Colors.DarkMagenta));
      case "DarkOliveGreen":
        return new SolidColorBrush(new Color.predefined(Colors.DarkOliveGreen));
      case "DarkOrange":
        return new SolidColorBrush(new Color.predefined(Colors.DarkOrange));
      case "DarkOrchid":
        return new SolidColorBrush(new Color.predefined(Colors.DarkOrchid));
      case "DarkRed":
        return new SolidColorBrush(new Color.predefined(Colors.DarkRed));
      case "DarkSalmon":
        return new SolidColorBrush(new Color.predefined(Colors.DarkSalmon));
      case "DarkSeaGreen":
        return new SolidColorBrush(new Color.predefined(Colors.DarkSeaGreen));
      case "DarkSlateBlue":
        return new SolidColorBrush(new Color.predefined(Colors.DarkSlateBlue));
      case "DarkSlateGray":
        return new SolidColorBrush(new Color.predefined(Colors.DarkSlateGray));
      case "DarkTurquoise":
        return new SolidColorBrush(new Color.predefined(Colors.DarkTurquoise));
      case "DarkViolet":
        return new SolidColorBrush(new Color.predefined(Colors.DarkViolet));
      case "DeepPink":
        return new SolidColorBrush(new Color.predefined(Colors.DeepPink));
      case "DeepSkyBlue":
        return new SolidColorBrush(new Color.predefined(Colors.DeepSkyBlue));
      case "DimGray":
        return new SolidColorBrush(new Color.predefined(Colors.DimGray));
      case "DodgerBlue":
        return new SolidColorBrush(new Color.predefined(Colors.DodgerBlue));
      case "Firebrick":
        return new SolidColorBrush(new Color.predefined(Colors.Firebrick));
      case "FloralWhite":
        return new SolidColorBrush(new Color.predefined(Colors.FloralWhite));
      case "ForestGreen":
        return new SolidColorBrush(new Color.predefined(Colors.ForestGreen));
      case "Fuchsia":
        return new SolidColorBrush(new Color.predefined(Colors.Fuchsia));
      case "Gainsboro":
        return new SolidColorBrush(new Color.predefined(Colors.Gainsboro));
      case "GhostWhite":
        return new SolidColorBrush(new Color.predefined(Colors.GhostWhite));
      case "Gold":
        return new SolidColorBrush(new Color.predefined(Colors.Gold));
      case "Goldenrod":
        return new SolidColorBrush(new Color.predefined(Colors.Goldenrod));
      case "Gray":
        return new SolidColorBrush(new Color.predefined(Colors.Gray));
      case "Green":
        return new SolidColorBrush(new Color.predefined(Colors.Green));
      case "GreenYellow":
        return new SolidColorBrush(new Color.predefined(Colors.GreenYellow));
      case "Honeydew":
        return new SolidColorBrush(new Color.predefined(Colors.Honeydew));
      case "HotPink":
        return new SolidColorBrush(new Color.predefined(Colors.HotPink));
      case "IndianRed":
        return new SolidColorBrush(new Color.predefined(Colors.IndianRed));
      case "Indigo":
        return new SolidColorBrush(new Color.predefined(Colors.Indigo));
      case "Ivory":
        return new SolidColorBrush(new Color.predefined(Colors.Ivory));
      case "Khaki":
        return new SolidColorBrush(new Color.predefined(Colors.Khaki));
      case "Lavender":
        return new SolidColorBrush(new Color.predefined(Colors.Lavender));
      case "LavenderBlush":
        return new SolidColorBrush(new Color.predefined(Colors.LavenderBlush));
      case "LawnGreen":
        return new SolidColorBrush(new Color.predefined(Colors.LawnGreen));
      case "LemonChiffon":
        return new SolidColorBrush(new Color.predefined(Colors.LemonChiffon));
      case "LightBlue":
        return new SolidColorBrush(new Color.predefined(Colors.LightBlue));
      case "LightCoral":
        return new SolidColorBrush(new Color.predefined(Colors.LightCoral));
      case "LightCyan":
        return new SolidColorBrush(new Color.predefined(Colors.LightCyan));
      case "LightGoldenrod":
        return new SolidColorBrush(new Color.predefined(Colors.LightGoldenrod));
      case "LightGray":
        return new SolidColorBrush(new Color.predefined(Colors.LightGray));
      case "LightGreen":
        return new SolidColorBrush(new Color.predefined(Colors.LightGreen));
      case "LightPink":
        return new SolidColorBrush(new Color.predefined(Colors.LightPink));
      case "LightSalmon":
        return new SolidColorBrush(new Color.predefined(Colors.LightSalmon));
      case "LightSeaGreen":
        return new SolidColorBrush(new Color.predefined(Colors.LightSeaGreen));
      case "LightSkyBlue":
        return new SolidColorBrush(new Color.predefined(Colors.LightSkyBlue));
      case "LightSlateGray":
        return new SolidColorBrush(new Color.predefined(Colors.LightSlateGray));
      case "LightSteelBlue":
        return new SolidColorBrush(new Color.predefined(Colors.LightSteelBlue));
      case "LightYellow":
        return new SolidColorBrush(new Color.predefined(Colors.LightYellow));
      case "Lime":
        return new SolidColorBrush(new Color.predefined(Colors.Lime));
      case "LimeGreen":
        return new SolidColorBrush(new Color.predefined(Colors.LimeGreen));
      case "Linen":
        return new SolidColorBrush(new Color.predefined(Colors.Linen));
      case "Magenta":
        return new SolidColorBrush(new Color.predefined(Colors.Magenta));
      case "Maroon":
        return new SolidColorBrush(new Color.predefined(Colors.Maroon));
      case "MediumAquamarine":
        return new SolidColorBrush(new Color.predefined(Colors.MediumAquamarine));
      case "MediumBlue":
        return new SolidColorBrush(new Color.predefined(Colors.MediumBlue));
      case "MediumOrchid":
        return new SolidColorBrush(new Color.predefined(Colors.MediumOrchid));
      case "MediumPurple":
        return new SolidColorBrush(new Color.predefined(Colors.MediumPurple));
      case "MediumSeaGreen":
        return new SolidColorBrush(new Color.predefined(Colors.MediumSeaGreen));
      case "MediumSlateBlue":
        return new SolidColorBrush(new Color.predefined(Colors.MediumSlateBlue));
      case "MediumSpringGreen":
        return new SolidColorBrush(new Color.predefined(Colors.MediumSpringGreen));
      case "MediumTurquoise":
        return new SolidColorBrush(new Color.predefined(Colors.MediumTurquoise));
      case "MediumVioletRed":
        return new SolidColorBrush(new Color.predefined(Colors.MediumVioletRed));
      case "MidnightBlue":
        return new SolidColorBrush(new Color.predefined(Colors.MidnightBlue));
      case "MintCream":
        return new SolidColorBrush(new Color.predefined(Colors.MintCream));
      case "MistyRose":
        return new SolidColorBrush(new Color.predefined(Colors.MistyRose));
      case "Moccasin":
        return new SolidColorBrush(new Color.predefined(Colors.Moccasin));
      case "NavajoWhite":
        return new SolidColorBrush(new Color.predefined(Colors.NavajoWhite));
      case "Navy":
        return new SolidColorBrush(new Color.predefined(Colors.Navy));
      case "OldLace":
        return new SolidColorBrush(new Color.predefined(Colors.OldLace));
      case "Olive":
        return new SolidColorBrush(new Color.predefined(Colors.Olive));
      case "OliveDrab":
        return new SolidColorBrush(new Color.predefined(Colors.OliveDrab));
      case "Orange":
        return new SolidColorBrush(new Color.predefined(Colors.Orange));
      case "OrangeRed":
        return new SolidColorBrush(new Color.predefined(Colors.OrangeRed));
      case "Orchid":
        return new SolidColorBrush(new Color.predefined(Colors.Orchid));
      case "PaleGoldenrod":
        return new SolidColorBrush(new Color.predefined(Colors.PaleGoldenrod));
      case "PaleGreen":
        return new SolidColorBrush(new Color.predefined(Colors.PaleGreen));
      case "PaleTurquoise":
        return new SolidColorBrush(new Color.predefined(Colors.PaleTurquoise));
      case "PaleVioletRed":
        return new SolidColorBrush(new Color.predefined(Colors.PaleVioletRed));
      case "PapayaWhip":
        return new SolidColorBrush(new Color.predefined(Colors.PapayaWhip));
      case "PeachPuff":
        return new SolidColorBrush(new Color.predefined(Colors.PeachPuff));
      case "Peru":
        return new SolidColorBrush(new Color.predefined(Colors.Peru));
      case "Pink":
        return new SolidColorBrush(new Color.predefined(Colors.Pink));
      case "Plum":
        return new SolidColorBrush(new Color.predefined(Colors.Plum));
      case "PowderBlue":
        return new SolidColorBrush(new Color.predefined(Colors.PowderBlue));
      case "Purple":
        return new SolidColorBrush(new Color.predefined(Colors.Purple));
      case "Red":
        return new SolidColorBrush(new Color.predefined(Colors.Red));
      case "RosyBrown":
        return new SolidColorBrush(new Color.predefined(Colors.RosyBrown));
      case "RoyalBlue":
        return new SolidColorBrush(new Color.predefined(Colors.RoyalBlue));
      case "SaddleBrown":
        return new SolidColorBrush(new Color.predefined(Colors.SaddleBrown));
      case "Salmon":
        return new SolidColorBrush(new Color.predefined(Colors.Salmon));
      case "SandyBrown":
        return new SolidColorBrush(new Color.predefined(Colors.SandyBrown));
      case "SeaGreen":
        return new SolidColorBrush(new Color.predefined(Colors.SeaGreen));
      case "SeaShell":
        return new SolidColorBrush(new Color.predefined(Colors.SeaShell));
      case "Sienna":
        return new SolidColorBrush(new Color.predefined(Colors.Sienna));
      case "Silver":
        return new SolidColorBrush(new Color.predefined(Colors.Silver));
      case "SkyBlue":
        return new SolidColorBrush(new Color.predefined(Colors.SkyBlue));
      case "SlateBlue":
        return new SolidColorBrush(new Color.predefined(Colors.SlateBlue));
      case "SlateGray":
        return new SolidColorBrush(new Color.predefined(Colors.SlateGray));
      case "Snow":
        return new SolidColorBrush(new Color.predefined(Colors.Snow));
      case "SpringGreen":
        return new SolidColorBrush(new Color.predefined(Colors.SpringGreen));
      case "SteelBlue":
        return new SolidColorBrush(new Color.predefined(Colors.SteelBlue));
      case "Tan":
        return new SolidColorBrush(new Color.predefined(Colors.Tan));
      case "Teal":
        return new SolidColorBrush(new Color.predefined(Colors.Teal));
      case "Thistle":
        return new SolidColorBrush(new Color.predefined(Colors.Thistle));
      case "Tomato":
        return new SolidColorBrush(new Color.predefined(Colors.Tomato));
      case "Turquoise":
        return new SolidColorBrush(new Color.predefined(Colors.Turquoise));
      case "Violet":
        return new SolidColorBrush(new Color.predefined(Colors.Violet));
      case "Wheat":
        return new SolidColorBrush(new Color.predefined(Colors.Wheat));
      case "White":
        return new SolidColorBrush(new Color.predefined(Colors.White));
      case "WhiteSmoke":
        return new SolidColorBrush(new Color.predefined(Colors.WhiteSmoke));
      case "Yellow":
        return new SolidColorBrush(new Color.predefined(Colors.Yellow));
      case "YellowGreen":
        return new SolidColorBrush(new Color.predefined(Colors.YellowGreen));
      default:
        return new SolidColorBrush(new Color.predefined(Colors.White));
    }
  }
}