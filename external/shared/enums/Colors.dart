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
  
  static final AliceBlue = const Colors("#F0F8FF", "AliceBlue");
  static final AntiqueWhite = const Colors("#FAEBD7", "AntiqueWhite");
  static final Aqua = const Colors("#00FFFF", "Aqua");
  static final Aquamarine = const Colors("#7FFFD4", "Aquamarine");
  static final Azure = const Colors("#F0FFFF", "Azure");
  static final Beige = const Colors("#F5F5DC", "Beige");
  static final Bisque = const Colors("#FFE4C4", "Bisque");
  static final Black = const Colors("#000000", "Black");
  static final BlanchedAlmond = const Colors("#FFEBCD", "BlanchedAlmond");
  static final Blue = const Colors("#0000FF", "Blue");
  static final BlueViolet = const Colors("#8a2be2", "BlueViolet");
  static final Brown = const Colors("#a52a2a", "Brown");
  static final BurlyWood = const Colors("#deb887", "BurlyWood");
  static final CadetBlue = const Colors("#5f9ea0", "CadetBlue");
  static final Chartreuse = const Colors("#7fff00", "Chartreuse");
  static final Chocolate = const Colors("#d2691e", "Chocolate");
  static final Coral = const Colors("#ff7f50", "Coral");
  static final ConflowerBlue = const Colors("#6495ed", "ConflowerBlue");
  static final Cornsilk = const Colors("#fff8dc", "Cornsilk");
  static final Crimson = const Colors("#dc143c", "Crimson");
  static final Cyan = const Colors("#00ffff", "Cyan");
  static final DarkBlue = const Colors("#00008b", "DarkBlue");
  static final DarkCyan = const Colors("#008b8b", "DarkCyan");
  static final DarkGoldenrod = const Colors("#b8860b", "DarkGoldenrod");
  static final DarkGray = const Colors("#A9A9A9", "DarkGray");
  static final DarkGreen = const Colors("#006400", "DarkGreen");
  static final DarkKhaki = const Colors("#000000", "DarkKhaki");
  static final DarkMagenta = const Colors("#8b008b", "DarkMagenta");
  static final DarkOliveGreen = const Colors("#556b2f", "DarkOliveGreen");
  static final DarkOrange = const Colors("#ff8c00", "DarkOrange");
  static final DarkOrchid = const Colors("#9932cc", "DarkOrchid");
  static final DarkRed = const Colors("#8b0000", "DarkRed");
  static final DarkSalmon = const Colors("#e9967a", "DarkSalmon");
  static final DarkSeaGreen = const Colors("#8fbc8f", "DarkSeaGreen");
  static final DarkSlateBlue = const Colors("#483d8b", "DarkSlateBlue");
  static final DarkSlateGray = const Colors("#2f4f4f", "DarkSlateGray");
  static final DarkTurquoise = const Colors("#00ced1", "DarkTurquoise");
  static final DarkViolet = const Colors("#9400d3", "DarkViolet");
  static final DeepPink = const Colors("#ff1493", "DeepPink");
  static final DeepSkyBlue = const Colors("#00bfff", "DeepSkyBlue");
  static final DimGray = const Colors("#696969", "DimGray");
  static final DodgerBlue = const Colors("#1e90ff", "DodgerBlue");
  static final Firebrick = const Colors("#b22222", "Firebrick");
  static final FloralWhite = const Colors("#fffaf0", "FloralWhite");
  static final ForestGreen = const Colors("#228b22", "ForestGreen");
  static final Fuchsia = const Colors("#ff00ff", "Fuchsia");
  static final Gainsboro = const Colors("#dcdcdc", "Gainsboro");
  static final GhostWhite = const Colors("#f8f8ff", "GhostWhite");
  static final Gold = const Colors("#ffd700", "Gold");
  static final Goldenrod = const Colors("#daa520","Goldenrod");
  static final Gray = const Colors("#808080", "Gray");
  static final Green = const Colors("#008000", "Green");
  static final GreenYellow = const Colors("#adff2f", "GreenYellow");
  static final Honeydew = const Colors("#f0fff0", "Honeydew");
  static final HotPink = const Colors("#ff69b4", "HotPink");
  static final IndianRed = const Colors("#cd5c5c", "IndianRed");
  static final Indigo = const Colors("#4b0082", "Indigo");
  static final Ivory = const Colors("#fffff0", "Ivory");
  static final Khaki = const Colors("#f0e68c", "Khaki");
  static final Lavender = const Colors("#e6e6fa", "Lavender");
  static final LavenderBlush = const Colors("#fff0f5", "LavenderBlush");
  static final LawnGreen = const Colors("#7cfc00", "LawnGreen");
  static final LemonChiffon = const Colors("#fffacd","LemonChiffon");
  static final LightBlue = const Colors("#add8e6", "LightBlue");
  static final LightCoral = const Colors("#f08080", "LightCoral");
  static final LightCyan = const Colors("#e0ffff", "LightCyan");
  static final LightGoldenrod = const Colors("#fafad2", "LightGoldenrod");
  static final LightGray = const Colors("#d3d3d3", "LightGray");
  static final LightGreen = const Colors("#90ee90", "LightGreen");
  static final LightPink = const Colors("#ffb6c1", "LightPink");
  static final LightSalmon = const Colors("#ffa07a", "LightSalmon");
  static final LightSeaGreen = const Colors("#20b2aa", "LightSeaGreen");
  static final LightSkyBlue = const Colors("#87cefa", "LightSkyBlue");
  static final LightSlateGray = const Colors("#778899", "LightSlateGray");
  static final LightSteelBlue = const Colors("#b0c4de", "LightSteelBlue");
  static final LightYellow = const Colors("#ffffe0", "LightYellow");
  static final Lime = const Colors("#00ff00", "Lime");
  static final LimeGreen = const Colors("#32cd32", "LimeGreen");
  static final Linen = const Colors("#faf0e6", "Linen");
  static final Magenta = const Colors("#ff00ff", "Magenta");
  static final Maroon = const Colors("#800000", "Maroon");
  static final MediumAquamarine = const Colors("#66cdaa", "MediumAquamarine");
  static final MediumBlue = const Colors("#0000cd", "MediumBlue");
  static final MediumOrchid = const Colors("#ba55d3", "MediumOrchid");
  static final MediumPurple = const Colors("#9370db", "MediumPurple");
  static final MediumSeaGreen = const Colors("#3cb371", "MediumSeaGreen");
  static final MediumSlateBlue = const Colors("#7b68ee", "MediumSlateBlue");
  static final MediumSpringGreen = const Colors("#00fa9a", "MediumSpringGreen");
  static final MediumTurquoise = const Colors("#48d1cc", "MediumTurquoise");
  static final MediumVioletRed = const Colors("#c71585", "MediumVioletRed");
  static final MidnightBlue = const Colors("#191970", "MidnightBlue");
  static final MintCream = const Colors("#f5fffa", "MintCream");
  static final MistyRose = const Colors("#ffe4e1", "MistyRose");
  static final Moccasin = const Colors("#ffe4b5", "Moccasin");
  static final NavajoWhite = const Colors("#ffdead", "NavajoWhite");
  static final Navy = const Colors("#000080", "Navy");
  static final OldLace = const Colors("#fdf5e6", "OldLace");
  static final Olive = const Colors("#808000", "Olive");
  static final OliveDrab = const Colors("#6b8e23", "OliveDrab");
  static final Orange = const Colors("#ffa500", "Orange");
  static final OrangeRed = const Colors("#ff4500", "OrangeRed");
  static final Orchid = const Colors("#da70d6", "Orchid");
  static final PaleGoldenrod = const Colors("#eee8aa", "PaleGoldenrod");
  static final PaleGreen = const Colors("#98fb98", "PaleGreen");
  static final PaleTurquoise = const Colors("#afeeee", "PaleTurquoise");
  static final PaleVioletRed = const Colors("#db7093", "PaleVioletRed");
  static final PapayaWhip = const Colors("#ffefd5", "PapayaWhip");
  static final PeachPuff = const Colors("#ffdab9", "PeachPuff");
  static final Peru = const Colors("#cd853f", "Peru");
  static final Pink = const Colors("#ffc0cb", "Pink");
  static final Plum = const Colors("#dda0dd", "Plum");
  static final PowderBlue = const Colors("#b0e0e6", "PowderBlue");
  static final Purple = const Colors("#800080", "Purple");
  static final Red = const Colors("#ff0000", "Red");
  static final RosyBrown = const Colors("#bc8f8f", "RosyBrown");
  static final RoyalBlue = const Colors("#4169e1", "RoyalBlue");
  static final SaddleBrown = const Colors("#8b4513", "SaddleBrown");
  static final Salmon = const Colors("#fa8072", "Salmon");
  static final SandyBrown = const Colors("#f4a460", "SandyBrown");
  static final SeaGreen = const Colors("#2e8b57", "SeaGreen");
  static final SeaShell = const Colors("#fff5ee", "SeaShell");
  static final Sienna = const Colors("#a0522d", "Sienna");
  static final Silver = const Colors("#c0c0c0", "Silver");
  static final SkyBlue = const Colors("#87ceeb", "SkyBlue");
  static final SlateBlue = const Colors("#6a5acd", "SlateBlue");
  static final SlateGray = const Colors("#708090", "SlateGray");
  static final Snow = const Colors("#fffafa", "Snow");
  static final SpringGreen = const Colors("#00ff7f", "SpringGreen");
  static final SteelBlue = const Colors("#4682b4", "SteelBlue");
  static final Tan = const Colors("#d2b48c", "Tan");
  static final Teal = const Colors("#008080", "Teal");
  static final Thistle = const Colors("#d8bfd8", "Thistle");
  static final Tomato = const Colors("#ff6347", "Tomato");
  static final Turquoise = const Colors("#40e0d0", "Turquoise");
  static final Violet = const Colors("#ee82ee", "Violet");
  static final Wheat = const Colors("#f5deb3", "Wheat");
  static final White = const Colors("#ffffff", "White");
  static final WhiteSmoke = const Colors("#f5f5f5", "WhiteSmoke");
  static final Yellow = const Colors("#ffff00", "Yellow");
  static final YellowGreen = const Colors("#9acd32", "YellowGreen");
}



