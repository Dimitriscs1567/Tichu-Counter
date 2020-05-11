import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:tichucounter/models/game.dart';

class Storage{

  static final String _dbName = 'games.db';
  static Database db;

  static Future<Database> get database async {
    if(db == null) {
      var dir = await getApplicationDocumentsDirectory();
      await dir.create(recursive: true);
      var dbPath = join(dir.path, _dbName);
      db = await databaseFactoryIo.openDatabase(dbPath);
    }

    return db;
  }

  static Future<void> storeGame(Game game) async {
    var db = await database;
    var store = intMapStoreFactory.store("game");

    await store.drop(db);
    await store.add(db, game.toMap());
  }

  static Future<Game> fetchGame() async{
    var db = await database;
    var store = intMapStoreFactory.store("game");

    var snapshot = await store.findFirst(db);
    if(snapshot != null){
      await store.drop(db);
      return Game.fromMap(snapshot.value);
    }

    return null;
  }

}