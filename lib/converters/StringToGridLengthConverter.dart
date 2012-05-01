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


/** 
* Attempts to convert a given [String] to a [GridLength] object 
*/
class StringToGridLengthConverter implements IValueConverter
{
  const StringToGridLengthConverter();
  
  Dynamic convert(Dynamic value, [Dynamic parameter]){
    if (!(value is String)) return value;
   
    // auto length
    if (value == "auto"){
      return new GridLength.auto();
    }
    
    // star length
    if (value.contains('*')){
      String stripped = value.replaceAll('*', '');
      
      //if only a star, then assume default value 1
      if (stripped == '') return new GridLength.star(1);
      
      //only a numeric should be left
      try{
        num val = Math.parseDouble(stripped);
        return new GridLength.star(val);
      }catch (BadNumberFormatException e){
        throw const BuckshotException("Unable to parse gridlength value.");
      }
    }
   
    // should be pixel
    try{
      num val = Math.parseInt(value);
      return new GridLength.pixel(val);
    }catch (BadNumberFormatException e){
      throw const BuckshotException("Unable to parse gridlength value.");
    }
  }
}
