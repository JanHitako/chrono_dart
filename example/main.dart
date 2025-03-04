import 'package:chrono_dart/chrono_dart.dart' show Chrono;

void main() {
  final dateOrNull = Chrono.parseDate('An appointment on Sep 12');
  print('Found date: $dateOrNull');

  final results = Chrono.parse('An appointment 2 weeks from now');
  print('Found dates: $results');

  final fork = Chrono.parse('An appointment 2 months from now');
  print('Found dates: $fork');
}
