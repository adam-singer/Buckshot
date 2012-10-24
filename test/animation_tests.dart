library animation_tests;

import 'dart:html';
import 'package:buckshot/buckshot_browser.dart';
import 'package:unittest/unittest.dart';

Future run(){
  group('Animation', (){
    test('Set property transition', (){
      Border b = new Border();

      //create a transition entry
      FrameworkAnimation.setPropertyTransition(b.background, new PropertyTransition(1, TransitionTiming.linear));

      Expect.equals('background 1s linear 0s', Polly.getCSS(b.rawElement, 'transition'));


      //add another one
      FrameworkAnimation.setPropertyTransition(b.borderColor, new PropertyTransition(1, TransitionTiming.linear));

      Expect.equals('background 1s linear 0s, border 1s linear 0s', Polly.getCSS(b.rawElement, 'transition'));


      //replace value
      FrameworkAnimation.setPropertyTransition(b.background, new PropertyTransition(3, TransitionTiming.easeIn));

      Expect.equals('background 3s ease-in 0s, border 1s linear 0s', Polly.getCSS(b.rawElement, 'transition'));
    });

    test('Remove property transition', (){
      Border b = new Border();

      //create a transition entry
      FrameworkAnimation.setPropertyTransition(b.background, new PropertyTransition(1, TransitionTiming.linear));

      //add another one
      FrameworkAnimation.setPropertyTransition(b.borderColor, new PropertyTransition(1, TransitionTiming.linear));

      //remove and test
      FrameworkAnimation.clearPropertyTransition(b.background);

      Expect.equals('border 1s linear 0s', Polly.getCSS(b.rawElement, 'transition'));

      FrameworkAnimation.clearPropertyTransition(b.borderColor);

      Expect.isNull(Polly.getCSS(b.rawElement, 'transition'));
    });
  });

  return new Future.immediate(true);
}