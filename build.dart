#import('package:buckshot/generator.dart');
#import('dart:io');

void main(){
  final args = new Options()
                    .arguments
                    .filter((arg) => 
                        arg.startsWith('--changed') &&
                        (arg.endsWith('.buckshot') || arg.endsWith('.html')))
                    .map((arg) => arg.replaceFirst('--changed=', ''));
  
  if (args.isEmpty()) return;
  
  generateCode(args);
  
//  exit(1);
}