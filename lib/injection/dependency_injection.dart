import '../data/practice_item.dart';
import '../data/random_user_repository.dart';
import '../data/mock_practice_repository.dart';

enum Flavor { MOCK, PRO }

class Injector {
  static final Injector _singleton = Injector._internal();
  static Flavor _flavor;

  static void configure(Flavor flavor) {
    _flavor = flavor;
  }

  factory Injector() {
    return _singleton;
  }

  Injector._internal();

  PracticeRepository get contactRepository {
    switch (_flavor) {
      case Flavor.MOCK:
        return MockPracticeRepository();
      default: // Flavor.PRO:
        return MockPracticeRepository();
    }
  }
}
