import 'dart:core';

class StringCalculator {
  //below variable is to count the no of times add method called
  int _callCount = 0;

  int add(String numbers) {
    _callCount++;

    if (numbers.trim().isEmpty) return 0; // to remove unnecessary spaces

    List<String> delimiters = [','];
    bool isMinusDelimiter = false;

    //below regex is identify multiple delimiters
    RegExp multipleDelimiterPattern = RegExp(r"^//(\[.*?\])+\n");
    Match? match = multipleDelimiterPattern.firstMatch(numbers);

    if (match != null) {
      delimiters = RegExp(r"\[(.*?)\]").allMatches(match.group(0)!)
          .map((m) => m.group(1)!)
          .toList();
      isMinusDelimiter = delimiters.contains("-");
      numbers = numbers.substring(match.end);
    } else if (numbers.startsWith("//")) {
      var parts = numbers.split('\n');
      if (parts.length > 1) {
        delimiters = [parts[0].substring(2)];
        isMinusDelimiter = delimiters.contains("-");
        numbers = parts.sublist(1).join('\n');
      }
    }

    numbers = numbers.replaceAll('\n', delimiters.first);

    String delimiterPattern = delimiters.map(RegExp.escape).join('|');

    if (isMinusDelimiter) {
      return numbers.split(RegExp(delimiterPattern)).map((e) {
        return int.tryParse(e.trim()) ?? 0;
      }).reduce((a, b) => a + b);
    }

    List<int> negatives = []; // to save negative numbers

    int sum = numbers.split(RegExp(delimiterPattern)).fold(0, (total, numStr) {
      if (numStr.trim().isEmpty) return total;

      int? num = int.tryParse(numStr.trim());
      if (num != null && num <= 1000) {
        if (num < 0) {
          negatives.add(num);
        }
        return total + num;
      }
      return total;
    });

    if (negatives.isNotEmpty) {
      throw Exception("Negatives not allowed: ${negatives.join(', ')}");
    }

    return sum;
  }

  int getCalledCount() {
    return _callCount;
  }
}