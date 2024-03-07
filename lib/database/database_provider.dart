import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static late Database db;
  static late String path;
  static const String tablePackage1 = 'roshan';
  static const String tablePackage2 = 'afghan_bisim';
  static const String tablemukamal = 'mukamal';

  static Future open({String dbName = 'data.db', versionDb = 1}) async {
    var databasesPath = await getDatabasesPath();
    path = join(databasesPath, dbName);

    print('databasesPath: $databasesPath');
    print('_path: $path');

    db = await openDatabase(path, version: versionDb, onCreate: (Database db, int version) async {});
    
  }

  static Future close() async => db.close();
}
