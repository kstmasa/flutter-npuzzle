import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_npuzzle/lib.dart';

void main() {
  group('Test start, isFinal & isLessThanFinal', () {
    test('isFinal test case', () {
      MyLibrary myLibrary = MyLibrary();
      expect(myLibrary.isFinal(1, 3), false);
      expect(myLibrary.isFinal(2, 3), false);
      expect(myLibrary.isFinal(8, 3), true);
    });
    test('isLessThanFinal test case', () {
      MyLibrary myLibrary = MyLibrary();
      expect(myLibrary.isLessThanFinal(1, 3), true);
      expect(myLibrary.isLessThanFinal(2, 3), true);
      expect(myLibrary.isLessThanFinal(8, 3), true);
      expect(myLibrary.isLessThanFinal(10, 3), false);
    });
  });
}
