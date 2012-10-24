part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Enumerates pre-defined color values. */
class Colors{
  const Colors(this._hex, this._name);
  final String _hex;
  final String _name;
  
  //source: http://msdn.microsoft.com/en-us/library/system.windows.media.solidcolorbrush.Color.hex(VS.95).aspx
  
  String toString() => _hex;
  
  String get name => _name;
  
  static const AliceBlue = const Colors("#F0F8FF", "AliceBlue");
  static const AntiqueWhite = const Colors("#FAEBD7", "AntiqueWhite");
  static const Aqua = const Colors("#00FFFF", "Aqua");
  static const Aquamarine = const Colors("#7FFFD4", "Aquamarine");
  static const Azure = const Colors("#F0FFFF", "Azure");
  static const Beige = const Colors("#F5F5DC", "Beige");
  static const Bisque = const Colors("#FFE4C4", "Bisque");
  static const Black = const Colors("#000000", "Black");
  static const BlanchedAlmond = const Colors("#FFEBCD", "BlanchedAlmond");
  static const Blue = const Colors("#0000FF", "Blue");
  static const BlueViolet = const Colors("#8a2be2", "BlueViolet");
  static const Brown = const Colors("#a52a2a", "Brown");
  static const BurlyWood = const Colors("#deb887", "BurlyWood");
  static const CadetBlue = const Colors("#5f9ea0", "CadetBlue");
  static const Chartreuse = const Colors("#7fff00", "Chartreuse");
  static const Chocolate = const Colors("#d2691e", "Chocolate");
  static const Coral = const Colors("#ff7f50", "Coral");
  static const ConflowerBlue = const Colors("#6495ed", "ConflowerBlue");
  static const Cornsilk = const Colors("#fff8dc", "Cornsilk");
  static const Crimson = const Colors("#dc143c", "Crimson");
  static const Cyan = const Colors("#00ffff", "Cyan");
  static const DarkBlue = const Colors("#00008b", "DarkBlue");
  static const DarkCyan = const Colors("#008b8b", "DarkCyan");
  static const DarkGoldenrod = const Colors("#b8860b", "DarkGoldenrod");
  static const DarkGray = const Colors("#A9A9A9", "DarkGray");
  static const DarkGreen = const Colors("#006400", "DarkGreen");
  static const DarkKhaki = const Colors("#000000", "DarkKhaki");
  static const DarkMagenta = const Colors("#8b008b", "DarkMagenta");
  static const DarkOliveGreen = const Colors("#556b2f", "DarkOliveGreen");
  static const DarkOrange = const Colors("#ff8c00", "DarkOrange");
  static const DarkOrchid = const Colors("#9932cc", "DarkOrchid");
  static const DarkRed = const Colors("#8b0000", "DarkRed");
  static const DarkSalmon = const Colors("#e9967a", "DarkSalmon");
  static const DarkSeaGreen = const Colors("#8fbc8f", "DarkSeaGreen");
  static const DarkSlateBlue = const Colors("#483d8b", "DarkSlateBlue");
  static const DarkSlateGray = const Colors("#2f4f4f", "DarkSlateGray");
  static const DarkTurquoise = const Colors("#00ced1", "DarkTurquoise");
  static const DarkViolet = const Colors("#9400d3", "DarkViolet");
  static const DeepPink = const Colors("#ff1493", "DeepPink");
  static const DeepSkyBlue = const Colors("#00bfff", "DeepSkyBlue");
  static const DimGray = const Colors("#696969", "DimGray");
  static const DodgerBlue = const Colors("#1e90ff", "DodgerBlue");
  static const Firebrick = const Colors("#b22222", "Firebrick");
  static const FloralWhite = const Colors("#fffaf0", "FloralWhite");
  static const ForestGreen = const Colors("#228b22", "ForestGreen");
  static const Fuchsia = const Colors("#ff00ff", "Fuchsia");
  static const Gainsboro = const Colors("#dcdcdc", "Gainsboro");
  static const GhostWhite = const Colors("#f8f8ff", "GhostWhite");
  static const Gold = const Colors("#ffd700", "Gold");
  static const Goldenrod = const Colors("#daa520","Goldenrod");
  static const Gray = const Colors("#808080", "Gray");
  static const Green = const Colors("#008000", "Green");
  static const GreenYellow = const Colors("#adff2f", "GreenYellow");
  static const Honeydew = const Colors("#f0fff0", "Honeydew");
  static const HotPink = const Colors("#ff69b4", "HotPink");
  static const IndianRed = const Colors("#cd5c5c", "IndianRed");
  static const Indigo = const Colors("#4b0082", "Indigo");
  static const Ivory = const Colors("#fffff0", "Ivory");
  static const Khaki = const Colors("#f0e68c", "Khaki");
  static const Lavender = const Colors("#e6e6fa", "Lavender");
  static const LavenderBlush = const Colors("#fff0f5", "LavenderBlush");
  static const LawnGreen = const Colors("#7cfc00", "LawnGreen");
  static const LemonChiffon = const Colors("#fffacd","LemonChiffon");
  static const LightBlue = const Colors("#add8e6", "LightBlue");
  static const LightCoral = const Colors("#f08080", "LightCoral");
  static const LightCyan = const Colors("#e0ffff", "LightCyan");
  static const LightGoldenrod = const Colors("#fafad2", "LightGoldenrod");
  static const LightGray = const Colors("#d3d3d3", "LightGray");
  static const LightGreen = const Colors("#90ee90", "LightGreen");
  static const LightPink = const Colors("#ffb6c1", "LightPink");
  static const LightSalmon = const Colors("#ffa07a", "LightSalmon");
  static const LightSeaGreen = const Colors("#20b2aa", "LightSeaGreen");
  static const LightSkyBlue = const Colors("#87cefa", "LightSkyBlue");
  static const LightSlateGray = const Colors("#778899", "LightSlateGray");
  static const LightSteelBlue = const Colors("#b0c4de", "LightSteelBlue");
  static const LightYellow = const Colors("#ffffe0", "LightYellow");
  static const Lime = const Colors("#00ff00", "Lime");
  static const LimeGreen = const Colors("#32cd32", "LimeGreen");
  static const Linen = const Colors("#faf0e6", "Linen");
  static const Magenta = const Colors("#ff00ff", "Magenta");
  static const Maroon = const Colors("#800000", "Maroon");
  static const MediumAquamarine = const Colors("#66cdaa", "MediumAquamarine");
  static const MediumBlue = const Colors("#0000cd", "MediumBlue");
  static const MediumOrchid = const Colors("#ba55d3", "MediumOrchid");
  static const MediumPurple = const Colors("#9370db", "MediumPurple");
  static const MediumSeaGreen = const Colors("#3cb371", "MediumSeaGreen");
  static const MediumSlateBlue = const Colors("#7b68ee", "MediumSlateBlue");
  static const MediumSpringGreen = const Colors("#00fa9a", "MediumSpringGreen");
  static const MediumTurquoise = const Colors("#48d1cc", "MediumTurquoise");
  static const MediumVioletRed = const Colors("#c71585", "MediumVioletRed");
  static const MidnightBlue = const Colors("#191970", "MidnightBlue");
  static const MintCream = const Colors("#f5fffa", "MintCream");
  static const MistyRose = const Colors("#ffe4e1", "MistyRose");
  static const Moccasin = const Colors("#ffe4b5", "Moccasin");
  static const NavajoWhite = const Colors("#ffdead", "NavajoWhite");
  static const Navy = const Colors("#000080", "Navy");
  static const OldLace = const Colors("#fdf5e6", "OldLace");
  static const Olive = const Colors("#808000", "Olive");
  static const OliveDrab = const Colors("#6b8e23", "OliveDrab");
  static const Orange = const Colors("#ffa500", "Orange");
  static const OrangeRed = const Colors("#ff4500", "OrangeRed");
  static const Orchid = const Colors("#da70d6", "Orchid");
  static const PaleGoldenrod = const Colors("#eee8aa", "PaleGoldenrod");
  static const PaleGreen = const Colors("#98fb98", "PaleGreen");
  static const PaleTurquoise = const Colors("#afeeee", "PaleTurquoise");
  static const PaleVioletRed = const Colors("#db7093", "PaleVioletRed");
  static const PapayaWhip = const Colors("#ffefd5", "PapayaWhip");
  static const PeachPuff = const Colors("#ffdab9", "PeachPuff");
  static const Peru = const Colors("#cd853f", "Peru");
  static const Pink = const Colors("#ffc0cb", "Pink");
  static const Plum = const Colors("#dda0dd", "Plum");
  static const PowderBlue = const Colors("#b0e0e6", "PowderBlue");
  static const Purple = const Colors("#800080", "Purple");
  static const Red = const Colors("#ff0000", "Red");
  static const RosyBrown = const Colors("#bc8f8f", "RosyBrown");
  static const RoyalBlue = const Colors("#4169e1", "RoyalBlue");
  static const SaddleBrown = const Colors("#8b4513", "SaddleBrown");
  static const Salmon = const Colors("#fa8072", "Salmon");
  static const SandyBrown = const Colors("#f4a460", "SandyBrown");
  static const SeaGreen = const Colors("#2e8b57", "SeaGreen");
  static const SeaShell = const Colors("#fff5ee", "SeaShell");
  static const Sienna = const Colors("#a0522d", "Sienna");
  static const Silver = const Colors("#c0c0c0", "Silver");
  static const SkyBlue = const Colors("#87ceeb", "SkyBlue");
  static const SlateBlue = const Colors("#6a5acd", "SlateBlue");
  static const SlateGray = const Colors("#708090", "SlateGray");
  static const Snow = const Colors("#fffafa", "Snow");
  static const SpringGreen = const Colors("#00ff7f", "SpringGreen");
  static const SteelBlue = const Colors("#4682b4", "SteelBlue");
  static const Tan = const Colors("#d2b48c", "Tan");
  static const Teal = const Colors("#008080", "Teal");
  static const Thistle = const Colors("#d8bfd8", "Thistle");
  static const Tomato = const Colors("#ff6347", "Tomato");
  static const Turquoise = const Colors("#40e0d0", "Turquoise");
  static const Violet = const Colors("#ee82ee", "Violet");
  static const Wheat = const Colors("#f5deb3", "Wheat");
  static const White = const Colors("#ffffff", "White");
  static const WhiteSmoke = const Colors("#f5f5f5", "WhiteSmoke");
  static const Yellow = const Colors("#ffff00", "Yellow");
  static const YellowGreen = const Colors("#9acd32", "YellowGreen");
}



