import 'package:flutter_riverpod/flutter_riverpod.dart';

final clockProvider = StreamProvider<DateTime>((ref) {
  return Stream.periodic(const Duration(seconds: 30), (_) => DateTime.now());
});
