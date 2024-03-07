
import '../database/database_provider.dart';
import 'alphabetkmodel.dart';

class Dictionary {
  static const String _table = DatabaseProvider.tablePackage1;

  static Future<int> deleteById(int id) async {
    await DatabaseProvider.open();
    int count = await DatabaseProvider.db.delete(_table, where: 'id = ?', whereArgs: [id]);
    return count;
  }

  static Future<List<D_arabi>> get({limit = 100, offest = 0, String? where, List<Object?>? whereArgs, String? orderBy, String? groupBy}) async {
    await DatabaseProvider.open();
    List<D_arabi> list = [];

    List<Map> maps = await DatabaseProvider.db.query(_table, where: where, whereArgs: whereArgs, limit: limit, offset: offest, orderBy: orderBy, groupBy: groupBy);

    for (var element in maps) {
      list.add(D_arabi.fromMap(element));
    }
    return list;
  }


  static Future<List<D_arabi>> getAlphabet(String table) async {
    await DatabaseProvider.open();
    List<D_arabi> list = [];

    List<Map> maps = await DatabaseProvider.db.rawQuery("SELECT * FROM $table LIMIT 100");
    // logger.d(maps);

    for (var element in maps) {
      list.add(D_arabi.fromMap(element));
    }
    return list;
  }

  static Future<List<D_arabi>> getMain(String table, int id) async {
    await DatabaseProvider.open();
    List<D_arabi> list = [];

    List<Map> maps = await DatabaseProvider.db.rawQuery("SELECT * FROM $table where id='$id' LIMIT 200 ");
    // logger.d(maps);

    for (var element in maps) {
      list.add(D_arabi.fromMap(element));
    }
    return list;
  }

  static Future<List<D_arabi>> updateFav(String table, int id, int favValue) async {
    await DatabaseProvider.open();
    List<D_arabi> list = [];

    List<Map> maps = await DatabaseProvider.db.rawQuery("update $table set fav=$favValue where id='$id'");
    // logger.d(maps);

    for (var element in maps) {
      list.add(D_arabi.fromMap(element));
    }
    return list;
  }


  static Future<List<D_arabi>> search(String query, String table) async {
    await DatabaseProvider.open();
    List<D_arabi> list = [];

    List<Map<String, dynamic>> maps = await DatabaseProvider.db.rawQuery(
        "SELECT * FROM $table where vag like '$query%' LIMIT 20"
     );

    for (var element in maps) {
      list.add(D_arabi.fromMap(element)); // Assuming FAmids has a fromMap constructor
    }
    return list;
  }


  static Future<List<D_arabi>> search1({limit = 100, offest = 0, String? where, List<Object?>? whereArgs}) async {
    await DatabaseProvider.open();
    List<D_arabi> list = [];

    List<Map> maps = await DatabaseProvider.db.query(_table, where: where, whereArgs: whereArgs, limit: limit, offset: offest);
    for (var element in maps) {
      list.add(D_arabi.fromMap(element));
    }
    return list;
  }



  static Future<int> insert(D_arabi b) async {
    await DatabaseProvider.open();
    int id = await DatabaseProvider.db.insert(_table, b.toMap());
    return id;
  }

  static Future<int> update(D_arabi b) async {
    await DatabaseProvider.open();
    int count = await DatabaseProvider.db.update(_table, b.toMap(), where: 'id = ?', whereArgs: [b.id]);

    return count;
  }
}


