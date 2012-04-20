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


class XmlTokenizer {
  static final int TAB = 9;
  static final int NEW_LINE = 10;
  static final int CARRIAGE_RETURN = 13; 
  static final int SPACE = 32;
  static final int QUOTE = 34;
  static final int SQUOTE = 39;
  static final int SLASH = 47;
  static final int COLON = 58;
  static final int LT = 60; //<
  static final int GT = 62; //>
  static final int EQ = 61; //=
  static final int Q = 63;  //?
  static final int B = 33;  //!
  
  final Queue<_XmlToken> _tq;
  final String _xml;
  int _length;
  int _i = 0;
  
  XmlTokenizer(this._xml) 
  :
    _i = 0,
    _tq = new Queue<_XmlToken>()
  {
    _length = _xml.length;
  }
  
    
  _XmlToken next()
  {
    void addToQueue(_XmlToken token) => _tq.addLast(token);
    
    _XmlToken getNextToken() =>  _tq.isEmpty() ? null : _tq.removeFirst();
    
    
    //returns the first char in the list that appears ahead
    int peekUntil(List chars){
      int z = _i;
      
      while (z < _length && chars.indexOf(_xml.charCodeAt(z)) == -1){
        z++;
      }
      
      return _xml.charCodeAt(z);
    }
    
    if (!_tq.isEmpty()) return getNextToken();
        
    while(_i < _length && isWhitespace(_xml.charCodeAt(_i)))
      {
        _i++;
      }
    
    if (_i == _length) return null;
    //print('char: $_i code: ${_xml.charCodeAt(_i)} ' + _xml.substring(_i, _i+1));
    final int char = _xml.charCodeAt(_i);
    
    switch(char){
      case Q:
        _i++;
        addToQueue(new _XmlToken(_XmlToken.QUESTION));
        break;
      case B:
        _i++;
        addToQueue(new _XmlToken(_XmlToken.BANG));
        break;
      case COLON:
        _i++;
        addToQueue(new _XmlToken(_XmlToken.COLON));
        break;
      case SLASH:
        _i++;
        addToQueue(new _XmlToken(_XmlToken.SLASH));
        break;
      case LT:
        _i++;
        addToQueue(new _XmlToken(_XmlToken.LT));
        int c = peekUntil([SPACE, GT]);
        if (c == SPACE){
          var _ii = _i;
          _i = _xml.indexOf(' ', _ii) + 1;
          addToQueue(new _XmlToken.string(_xml.substring(_ii, _i - 1)));
        }
        break;
      case GT:
        _i++;
        addToQueue(new _XmlToken(_XmlToken.GT));
        break;
      case EQ:
        _i++;
        addToQueue(new _XmlToken(_XmlToken.EQ));
        break;
      case QUOTE:
      case SQUOTE:
        _i++;
        addToQueue(new _XmlToken(_XmlToken.QUOTE));
        break;
      default:
        StringBuffer s = new StringBuffer();
        
        while(_i < _length && !isReserved(_xml.charCodeAt(_i))){
          s.add(_xml.substring(_i, _i + 1));
          _i++;
        }
        
        addToQueue(new _XmlToken.string(s.toString()));
        break;
    }
    return getNextToken();
  }

  static bool isReserved(int c){
    return c == LT || c == GT || c == Q || c == B || c == COLON || c == SLASH || c == QUOTE || c == SQUOTE || c == EQ;
  }
  
  static bool isWhitespace(int c) {
    return c == SPACE || c == TAB || c == NEW_LINE || c == CARRIAGE_RETURN;
  }
  
}

class _XmlToken {
  static final int LT = 1;
  static final int GT = 2;
  static final int QUESTION = 3;
  static final int STRING = 4;
  static final int BANG = 5;
  static final int COLON = 6;
  static final int SLASH = 7;
  static final int EQ = 8;
  static final int QUOTE = 9;
  static final int IGNORE = 10;
  
  final int kind;
  final String _str;
  
  const _XmlToken._internal(this.kind, this._str);
 
  
  factory _XmlToken.string(String s) {
    return new _XmlToken._internal(STRING, s);
  }

  factory _XmlToken(int kind) {
    return new _XmlToken._internal(kind, '');
  }

  
  String toString() {
    switch(kind){
      case LT:
        return "(<)";
      case GT:
        return "(>)";
      case QUESTION:
        return "(?)";
      case STRING:
        return 'STRING($_str)';
      case BANG:
        return "(!)";
      case COLON:
        return "(:)";
      case SLASH:
        return "(/)";
      case EQ:
        return "(=)";
      case QUOTE:
        return '(")';
      case IGNORE:
        return 'INVALID()';
            
    }
  }
}