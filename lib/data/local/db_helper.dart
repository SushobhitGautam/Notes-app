import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{
  ///singleton
  DBHelper._();
  static DBHelper getInstance(){
    return DBHelper._();
  }
  ///table note
  static final String TABLE_NOTE="Note";
  static final String COLUMN_NOTE_SNO="s_no";
  static final String COLUMN_NOTE_TITLE="title";
  static final String COLUMN_NOTE_desc="desc";

  Database? myDB;
  ///db Open( path-> if exists then open else create db )
   Future<Database> getDb()async{
     myDB??=await openDb();
     return myDB!;
   }
  Future<Database> openDb()async{
     Directory appDir= await getApplicationDocumentsDirectory();
     String dbPath=join(appDir.path,"noteDB.db");
    return  await openDatabase(dbPath,onCreate:( db, version)async{
       ///create all your tables here
      await  db.execute("CREATE TABLE $TABLE_NOTE("
          "$COLUMN_NOTE_SNO INTEGER PRIMARY KEY AUTOINCREMENT,"
          "$COLUMN_NOTE_TITLE TEXT,"
          "$COLUMN_NOTE_desc TEXT )");

      ///this is the query for the table and keep on adding this type of query to create more tables
     }, version: 1);
   }
  ///all queries
  ///insertion
   Future<bool> addNote({required String mTitle,required String mDesc})async{
     var db=await getDb();
     int rowEffected=await db.insert(TABLE_NOTE, {
       COLUMN_NOTE_TITLE:mTitle,
       COLUMN_NOTE_desc:mDesc,
     });
     return rowEffected>0;
   }
   ///reading all data
   Future<List<Map<String,dynamic>>> getAllNotes()async{
     var db = await getDb();
    List<Map<String,dynamic>> mData= await  db.query(TABLE_NOTE);
    return mData;
   }
   ///update data
   Future<bool> updateNote({required String title,required String desc,required int sno})async{
     var db = await getDb();
     int rowsEffected =await db.update(TABLE_NOTE,{
       COLUMN_NOTE_TITLE:title,
       COLUMN_NOTE_desc:desc,
     },where:"$COLUMN_NOTE_SNO=$sno");
     return rowsEffected>0;
   }
   ///delete data
 Future<bool> deleteNote({required int sno,})async{
   var db = await getDb();
int rowsEffected=await db.delete(TABLE_NOTE,where: "$COLUMN_NOTE_SNO=?",whereArgs: ['$sno']);
return rowsEffected>0;
 }
}