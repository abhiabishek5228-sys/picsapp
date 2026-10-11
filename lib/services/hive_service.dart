
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String favoritesBoxName = 'favorites';
  static const String downloadsBoxName = 'downloads';

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized &&
        Hive.isBoxOpen(favoritesBoxName) &&
        Hive.isBoxOpen(downloadsBoxName)) {
      return;
    }

    await Hive.initFlutter();

    if (!Hive.isBoxOpen(favoritesBoxName)) {
      await Hive.openBox<bool>(favoritesBoxName);
    }

    if (!Hive.isBoxOpen(downloadsBoxName)) {
      await Hive.openBox<dynamic>(downloadsBoxName);
    }

    _initialized = true;

    print('Hive initialized successfully');
    print('Favorites open: ${Hive.isBoxOpen(favoritesBoxName)}');
    print('Downloads open: ${Hive.isBoxOpen(downloadsBoxName)}');
  }

  static Box<bool> get favoritesBox {
    if (!Hive.isBoxOpen(favoritesBoxName)) {
      throw StateError(
        'Favorites box is not open. Call HiveService.init() first.',
      );
    }

    return Hive.box<bool>(favoritesBoxName);
  }

  static Box<dynamic> get downloadsBox {
    if (!Hive.isBoxOpen(downloadsBoxName)) {
      throw StateError(
        'Downloads box is not open. Call HiveService.init() first.',
      );
    }

    return Hive.box<dynamic>(downloadsBoxName);
  }
}
