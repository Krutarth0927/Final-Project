import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Singleton pattern
 static final DatabaseHelper instance = DatabaseHelper._internal();
  factory DatabaseHelper() => instance;
  DatabaseHelper._internal();

  static const _databaseName = "StayezDatabase.db";
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    // Create Users table
    await db.execute(
      'CREATE TABLE Users( '
          'fullName TEXT,'
          ' dob TEXT, '
          'mobileNo TEXT PRIMARY KEY,'
          ' address TEXT, '
          'collageName TEXT,'
          ' currentCourse TEXT, '
          'yearOfStudy TEXT,'
          ' parentName TEXT,'
          ' parentContactNo TEXT, '
          'roomNo TEXT ,'
          'password TEXT)',
    );

    // Create Register table
    await db.execute('''
      CREATE TABLE register (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        room_no TEXT NOT NULL,
        entry_date_time TEXT NOT NULL,
        exit_date_time TEXT NOT NULL,
        reason TEXT NOT NULL
      )
    ''');

    // Create Complaints table
    await db.execute('''
      CREATE TABLE complaints (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        room_no TEXT,
        complaint_type TEXT,
        complaint_details TEXT
      )
    ''');

    await db.execute('''
        CREATE TABLE data (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          instruction TEXT,
          imagePath TEXT,
          documentPath TEXT
        )
      ''');
  }

  // ------------------ Methods for Users Table -------------------

  Future<int> saveUser(Map<String, dynamic> user) async {
    final dbClient = await database;
    return await dbClient.insert('Users', user);
  }

  Future<Map<String, dynamic>?> getUser(String mobileNo) async {
    final dbClient = await database;
    var result = await dbClient.query('Users', where: 'mobileNo = ?', whereArgs: [mobileNo]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> getUserByPhoneAndPassword(String phone, String password) async {
    final dbClient = await database;
    var result = await dbClient.query('Users', where: 'mobileNo = ? AND password = ?',
        whereArgs: [phone, password]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final dbClient = await database;
    return await dbClient.query('Users');
  }

  Future<void> deleteUser(String mobileNo) async {
    final dbClient = await database;
    await dbClient.delete('Users', where: 'mobileNo = ?', whereArgs: [mobileNo]);
  }

  Future<int> updateUser(String mobileNo, Map<String, dynamic> user) async {
    final dbClient = await database;
    return await dbClient.update('Users', user, where: 'mobileNo = ?', whereArgs: [mobileNo]);
  }

  Future<int> getUserRecordCount() async {
    final dbClient = await database;
    final result = await dbClient.rawQuery('SELECT COUNT(*) FROM Users');
    return Sqflite.firstIntValue(result) ?? 0;
  }
 Future<Map<String, dynamic>> getUserByMobileNo(String mobileNo) async {
   final dbClient = await database;
   final result = await dbClient.query(
     'users',
     where: 'mobileNo = ?',
     whereArgs: [mobileNo],
   );
   return result.isNotEmpty ? result.first : {};
 }

 Future<int> updateUserByMobileNo(String mobileNo,
     Map<String, dynamic> user) async {
   final dbClient = await database;
   return await dbClient!.update(
     'users',
     user,
     where: 'mobileNo = ?',
     whereArgs: [mobileNo],
   );
 }


  // ------------------ Methods for Register Table -------------------

  Future<int> insertRegister(Map<String, dynamic> row) async {
    final dbClient = await database;
    return await dbClient.insert('register', row);
  }

  Future<List<Map<String, dynamic>>> queryAllRegisters() async {
    final dbClient = await database;
    return await dbClient.query('register');
  }

  Future<List<Map<String, dynamic>>> queryRegisterByDate(String date) async {
    final dbClient = await database;
    return await dbClient.query(
      'register',
      where: 'entry_date_time LIKE ?',
      whereArgs: ['$date%'],
    );
  }



  Future<int> getRegisterRecordCount(String date) async {
    final dbClient = await database;
    final result = await dbClient.rawQuery(
        'SELECT COUNT(*) FROM register WHERE entry_date_time LIKE ?', ['$date%']);
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // ------------------ Methods for Complaints Table -------------------

  Future<int> insertComplaint(Map<String, dynamic> row) async {
    final dbClient = await database;
    return await dbClient.insert('complaints', row);
  }

  Future<List<Map<String, dynamic>>> getComplaints() async {
    final dbClient = await database;
    return await dbClient.query('complaints');
  }

  Future<List<Map<String, dynamic>>> getComplaintsByRoom(String roomNo) async {
    final dbClient = await database;
    return await dbClient.query('complaints', where: 'room_no = ?', whereArgs: [roomNo]);
  }

  Future<void> deleteComplaint(int id) async {
    final dbClient = await database;
    await dbClient.delete('complaints', where: 'id = ?', whereArgs: [id]);
  }


  // ------------------------- Method for Daily Update ------------------------

 Future<List<Map<String, dynamic>>> getData() async {
   final db = await database;
   return await db.query('data');
 }

 Future<void> insertData(String instruction, String? imagePath, String? documentPath) async {
   final db = await database;
   await db.insert('data', {
     'instruction': instruction,
     'imagePath': imagePath,
     'documentPath': documentPath,
   });
 }

 Future<void> deleteData(int id) async {
   final db = await database;
   await db.delete('data', where: 'id = ?', whereArgs: [id]);
 }

 Future<List<Map<String, dynamic>>> loadData() async {
   final db = await database;
   return await db.query('data');
 }

 
}

