#import('generator.dart');
#import('dart:io');

// waiting for the Dart Edit to start picking this up.
void main(){
  
  print('Don\'t worry, this is supposed to fail right now: ${new Options().arguments}');
  
  exit(1);
  
  //generateCode();  
}