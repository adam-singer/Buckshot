library dart_tests;

import 'dart:html';
import 'package:unittest/unittest.dart';
import 'package:xml/xml.dart';

// Tests against known Dart or other external dependency bugs
run(){
  group('Dart Features And Bugs', (){

    test(': Futures.wait() fails with Collection<T> object in checked mode',
      (){
        final xml = XML.parse('<foo><bar /><bar /><bar /></foo>');

        Future toFuture(_) => new Future.immediate(true);

        Expect.throws(
            () {
              Futures
                .wait(xml.children.map((node) => toFuture(node)))
                .then((results){
                  Expect.fail("It's working now!");
                });
            }
        );
    });

    test(': all objects not hashable', (){
      final o = new Object();

      Expect.throws(
        (){
          Expect.isTrue(o.hashCode is int);
        }
      );
    });

    test(': Type not available', (){
      final o = new Object();

      Expect.throws((){
        Expect.isNotNull(o.runtimeType);
      });
    });

    //fails in JS, OK in Dartium
    test('borderRadiusReturnsNull', (){
      var e = new Element.tag('div');
      e.style.borderRadius = '10px';

      var result = e.style.borderRadius;
      Expect.isNotNull(result);
      Expect.equals('10px', e.style.borderRadius);
    });

    test('SVG elements returning css', (){
      var se = new SVGSVGElement();
      var r = new SVGElement.tag('rect');
      se.elements.add(r);

      r.style.setProperty('fill','Red');

      var result = r.style.getPropertyValue('fill');
      Expect.isNotNull(result);
    });
  });
}