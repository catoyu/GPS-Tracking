import 'package:geolocator/geolocator.dart';
import 'package:sqflite/sqflite.dart' as sql;

class PeticionesDB {
  static Future<void> crearTabla(sql.Database database) async {
    await database.execute(
        """ CREATE TABLE posiciones(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        coordenadas TEXTO, 
        fecha TEXT)  """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase("geotracking.db", version: 1,
        onCreate: (sql.Database database, int version) async {
      await crearTabla(database);
    });
  }

  static Future<List<Map<String, dynamic>>> mostrarUbicaciones() async {
    final base = await PeticionesDB.db(); //Conexión base de datos
    return base.query("posiciones", orderBy: "fecha");
  }

  static Future<void> eliminarUbicacion(int idpo) async {
    final base = await PeticionesDB.db();
    base.delete("posiciones", where: "id=?", whereArgs: [idpo]);
  }

  static Future<void> eliminarTodas() async {
    final base = await PeticionesDB.db();
    base.delete("posiciones");
  }

  static Future<void> guardarUbicacion(coor, fecha) async {
    final base = await PeticionesDB.db();
    final datos = {"coordenadas": coor, "fecha": fecha};
    await base.insert("posiciones", datos,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

/////////////////////// Geolocalización

  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Los servicios de ubicación están deshabilitados.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Los permisos de ubicación están denegados');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Los permisos de ubicación se niegan permanentemente, no podemos solicitar permisos.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
