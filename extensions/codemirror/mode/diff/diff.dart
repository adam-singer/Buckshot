// This source code is licensed under the terms described in the LICENSE file.

#library('diff_mode');

#import('../../CodeMirror.dart');

/** A [Mode] for diff. */
class DiffMode extends Mode {
  String token(StringStream stream, State state) {
    String ch = stream.next();
    stream.skipToEnd();
    if (ch == "+") return "plus";
    if (ch == "-") return "minus";
    if (ch == "@") return "rangeinfo";
    return null;
  }
}