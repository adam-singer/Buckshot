#import('package:buckshot/buckshot.dart');

void main() {
  // setView() renders a View into the web page at a DIV with the id
  // of 'BuckshotHost'.  You can also specify a different id if you want to.
  setView(
      // The View.fromTemplate() constructor will automatically deserialize
      // a buckshot template and create a View with it.
      new View.fromTemplate('<textblock text="Hello World!" />')
  );
}
