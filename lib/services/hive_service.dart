
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String favoritesBoxName = 'favorites';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<bool>(favoritesBoxName);
  }

  static Box<bool> get favoritesBox =>
      Hive.box<bool>(favoritesBoxName);
}
