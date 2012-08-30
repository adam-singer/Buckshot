
#import('dart:io');

// waiting for the Dart Edit to start picking this up.
void main(){
  final out = new File('c:\test.tmp').openOutputStream();
  out.onError = (e){
    print('build.dart error!');
  };
  out.writeString('hello world');
  out.close();
}