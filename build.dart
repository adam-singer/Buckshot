
#import('dart:io');

// waiting for the Dart Edit to start picking this up.
void main(){
  print('build script running...');
  
  final out = new File('test.tmp').openOutputStream();
  out.onError = (e){
    print('build.dart error! $e');
    exit(1);
  };
  out.writeString('hello world');
   
  out.close();
}