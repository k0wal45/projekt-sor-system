import 'package:flutter/material.dart';
import 'theme.dart';

extension PriorityColorExtension on ThemeData {
  Color getPriorityColor(int priority) {
    final isDark = brightness == Brightness.dark;
    switch (priority) {
      case 1:
        return isDark ? MaterialTheme.priority1.dark.color : MaterialTheme.priority1.light.color;
      case 2:
        return isDark ? MaterialTheme.priority2.dark.color : MaterialTheme.priority2.light.color;
      case 3:
        return isDark ? MaterialTheme.priority3.dark.color : MaterialTheme.priority3.light.color;
      case 4:
        return isDark ? MaterialTheme.priority4.dark.color : MaterialTheme.priority4.light.color;
      case 5:
        return isDark ? MaterialTheme.priority5.dark.color : MaterialTheme.priority5.light.color;
      default:
        return colorScheme.surface;
    }
  }

  Color getPriorityContainerColor(int priority) {
    final isDark = brightness == Brightness.dark;
    switch (priority) {
      case 1:
        return isDark ? MaterialTheme.priority1.dark.colorContainer : MaterialTheme.priority1.light.colorContainer;
      case 2:
        return isDark ? MaterialTheme.priority2.dark.colorContainer : MaterialTheme.priority2.light.colorContainer;
      case 3:
        return isDark ? MaterialTheme.priority3.dark.colorContainer : MaterialTheme.priority3.light.colorContainer;
      case 4:
        return isDark ? MaterialTheme.priority4.dark.colorContainer : MaterialTheme.priority4.light.colorContainer;
      case 5:
        return isDark ? MaterialTheme.priority5.dark.colorContainer : MaterialTheme.priority5.light.colorContainer;
      default:
        return colorScheme.surfaceContainer;
    }
  }
}
