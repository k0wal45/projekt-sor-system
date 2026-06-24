class DateTimeUtils {
  static (String, String) formatTicketStatus(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    final totalMinutes = difference.inMinutes;
    final totalHours = difference.inHours;

    // 1. Mniej niż godzina (0 - 59 minut)
    if (totalMinutes < 60) {
      final minutesText = totalMinutes <= 0 ? '1min' : '${totalMinutes}min';
      return (minutesText, 'OCZEKUJE');
    }

    // 2. Między 1 a 12 godzin
    if (totalHours < 12) {
      final remainingMinutes = totalMinutes % 60;
      final timeText = remainingMinutes > 0
          ? '${totalHours}h ${remainingMinutes}min'
          : '${totalHours}h';

      return (timeText, 'OCZEKUJE');
    }

    // 3. Powyżej 12 godzin -> Godzina i Data
    final hourText =
        '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
    final dateText =
        '${createdAt.day.toString().padLeft(2, '0')}.${createdAt.month.toString().padLeft(2, '0')}.${createdAt.year}';

    return (hourText, dateText);
  }
}
