class StringUtils {
  static String formatAge(int age) {
    if (age == 1) {
      return '$age rok';
    }

    int lastTwoDigits = age % 100;
    if (lastTwoDigits >= 11 && lastTwoDigits <= 14) {
      return '$age lat';
    }

    int lastDigit = age % 10;
    if (lastDigit >= 2 && lastDigit <= 4) {
      return '$age lata';
    }

    return '$age lat';
  }
}
