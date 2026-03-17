import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:truecaller/core/database/contact_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('contacts.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,

      //************************
      //If the existing database version < the version you specify, Flutter will call onUpgrade.
      // If the existing database version == the version you specify, onUpgrade is not called.
      // If the database doesn’t exist, onCreate is called instead.
      // */
      /*      
      Without onUpgrade:
      Old users open the app → DB version is old → app tries to read a column that doesn’t exist → crash.
      You can’t safely add new columns after release.
      Release APK crashes on startup if your code expects the new schema.
      */
      onUpgrade: (db, oldVersion, newVersion) =>
          _onUpgrade(db, oldVersion, newVersion),
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE IF NOT EXISTS contacts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  phone TEXT NOT NULL UNIQUE,
  last_follow_up_notes TEXT,
  priority TEXT,
  stage TEXT
)
''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 1) {
      await db.execute('ALTER TABLE contacts ADD COLUMN stage TEXT');
      await db.execute('ALTER TABLE contacts ADD COLUMN priority TEXT');
    }
  }

  Future<int> insertContact(ContactModel contact) async {
    final db = await database;
    return await db.insert(
      'contacts',
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ContactModel>> getAllContacts() async {
    final db = await instance.database;
    final result = await db.query('contacts', orderBy: 'id DESC');
    return result.map((e) => ContactModel.fromMap(e)).toList();
  }

  Future<ContactModel?> getContactByNumber(String number) async {
    final db = await instance.database;
    final res = await db.query(
      'contacts',
      where: 'phone = ?',
      whereArgs: [number],
    );

    if (res.isNotEmpty) {
      return ContactModel.fromMap(res.first);
    } else {
      return null;
    }
  }
}
