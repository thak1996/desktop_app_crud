import 'package:desktop_app_crud/app/modules/json/accounts_json.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  final databaseName = 'appDatabase.db';

  String accountTbl = '''
  CREATE TABLE IF NOT EXISTS accounts (
  accId INTEGER PRIMARY KEY AUTOINCREMENT,
  accHolder TEXT NOT NULL,
  accName TEXT NOT NULL,
  accStatus INTEGER,
  createdAt TEXT
  )''';

  /// Database connection
  Future<Database> init() async {
    final databasePath = await getApplicationCacheDirectory();
    final path = "${databasePath.path}/$databaseName";
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        /// Tables
        await db.execute(accountTbl);
      },
    );
  }

  /// CRUD Methods
  /// Get
  Future<List<AccountsJson>> getAccounts() async {
    final Database db = await init();
    List<Map<String, Object?>> result = await db.query(
      "accounts",
      where: "accStatus = 1",
    );
    return result.map((e) => AccountsJson.fromMap(e)).toList();
  }

  /// Insert
  Future<int> insertAccount(AccountsJson account) async {
    final Database db = await init();
    return await db.insert("accounts", account.toMap());
  }

  /// Update
  Future<int> updateAccount(String accHolder, String accName, int accId) async {
    final Database db = await init();
    return await db.rawUpdate(
      "UPDATE accounts SET accHolder = ?, accName = ? WHERE accId = ?",
      [accHolder, accName, accId],
    );
  }

  /// Delete
  Future<int> deleteAccount(int accId) async {
    final Database db = await init();
    return await db.delete("accounts", where: "accId = ?", whereArgs: [accId]);
  }

  Future<List<AccountsJson>> filterAccounts(String keyword) async {
    final Database db = await init();
    List<Map<String, Object?>> result = await db.rawQuery(
      "select * from accounts where accHolder LIKE ? OR accName LIKE ?",
      ["%$keyword%", "%$keyword%"],
    );
    return result.map((e) => AccountsJson.fromMap(e)).toList();
  }
}
