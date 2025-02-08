import 'package:flutter_test/flutter_test.dart';
import 'package:string_calculator/string_calculator.dart';

void main() {
  group('StringCalculator', () {
    test('returns 0 for an empty string', () {
      final calculator = StringCalculator();
      expect(calculator.add(""), equals(0));
    });

    test('returns the number itself if only one number is provided', () {
      final calculator = StringCalculator();
      expect(calculator.add("1"), equals(1));
    });

    test('returns the sum of two numbers', () {
      final calculator = StringCalculator();
      expect(calculator.add("1,2"), equals(3));
    });

    test('ignores extra spaces and handles valid numbers correctly', () {
      final calculator = StringCalculator();
      expect(calculator.add(" 1 , 2 "), equals(3));
    });

    test('handles multiple numbers', () {
      final calculator = StringCalculator();
      expect(calculator.add("1,2,3,4,5"), equals(15));
    });

    test('handles a single number with extra spaces', () {
      final calculator = StringCalculator();
      expect(calculator.add("   1   "), equals(1));
    });

    test('handles numbers with empty values in between', () {
      final calculator = StringCalculator();
      expect(calculator.add("1,,2"), equals(3));
    });

    test('handles new lines as delimiters', () {
      final calculator = StringCalculator();
      expect(calculator.add("1\n2\n3"), equals(6));
    });

    test('handles multiple new lines and commas', () {
      final calculator = StringCalculator();
      expect(calculator.add("\n1\n2\n3\n,\n"), equals(6));
    });

    test('handles custom delimiters', () {
      final calculator = StringCalculator();
      expect(calculator.add("//;\n1;2"), equals(3));
    });

    test('handles another custom delimiter', () {
      final calculator = StringCalculator();
      expect(calculator.add("//#\n1#2#3"), equals(6));
    });

    test('handles custom delimiter with mixed whitespace', () {
      final calculator = StringCalculator();
      expect(calculator.add("//-\n1-2- 3 "), equals(6));
    });

    test('throws exception for negative numbers', () {
      final calculator = StringCalculator();
      expect(() => calculator.add("1,-2,3"), throwsA(isA<Exception>()));
    });

    test('throws exception and lists all negative numbers', () {
      final calculator = StringCalculator();
      expect(
            () => calculator.add("1,-2,-3"),
        throwsA(predicate((e) => e.toString().contains("Negatives not allowed: -2, -3"))),
      );
    });

    test('allows minus as a delimiter when explicitly set', () {
      final calculator = StringCalculator();
      expect(calculator.add("//-\n1-2-3"), equals(6)); // No exception
    });

    test('detects negative numbers only when minus is not a delimiter', () {
      final calculator = StringCalculator();
      expect(() => calculator.add("1,-2,3"), throwsA(isA<Exception>())); // Exception expected
      expect(calculator.add("//-\n1-2-3"), equals(6)); // No exception
    });

    test('GetCalledCount returns the number of times add() was called', () {
      final calculator = StringCalculator();

      expect(calculator.getCalledCount(), equals(0)); // Initially, should be 0

      calculator.add("1,2");
      calculator.add("3,4");

      expect(calculator.getCalledCount(), equals(2)); // Should return 2
    });

    test('Neglect Numbers bigger than 1000 ', () {
      final calculator = StringCalculator();
      expect(calculator.add("1,2,2000,3"), equals(6));
    });

    test('Supports multi-character delimiters', () {
      final calculator = StringCalculator();

      expect(calculator.add("//[***]\n1***2***3"), equals(6));
      expect(calculator.add("//[##]\n4##5##6"), equals(15));
    });

    test('Supports multiple delimiters of any length', () {
      final calculator = StringCalculator();

      expect(calculator.add("//[*][%]\n1*2%3"), equals(6));
      expect(calculator.add("//[**][%%]\n1**2%%3"), equals(6));
      expect(calculator.add("//[###][!!]\n4###5!!6"), equals(15));
    });


  });
}