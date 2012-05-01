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


class StringToThicknessConverter implements IValueConverter{
  
  const StringToThicknessConverter();
  
  Dynamic convert(Dynamic value, [Dynamic parameter]){
    if (!(value is String)) return value;

    List<String> svl = value.split(",");
    switch(svl.length){
      case 1:
        return new Thickness(Math.parseInt(svl[0].trim()));
      case 2:
        return new Thickness.widthheight(Math.parseInt(svl[0].trim()), Math.parseInt(svl[1].trim()));
      case 4:
        return new Thickness.specified(Math.parseInt(svl[0].trim()),Math.parseInt(svl[1].trim()),Math.parseInt(svl[2].trim()),Math.parseInt(svl[3].trim()));
      default:
        throw const BuckshotException("Unable to parse Thickness property string.  Use format '0', '0,0', or '0,0,0,0'");
    }
  }
}
