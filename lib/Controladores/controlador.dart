import 'package:get/get.dart';
import 'package:sqf_lite/Proceso/peticiones.dart';

class controlador extends GetxController {
  final Rxn<List<Map<String, dynamic>>> _listaUbicaciones =
      Rxn<List<Map<String, dynamic>>>();
  final _unaUbicacion = "".obs;

///////////////////////////////////////
  void cargaUnaUbicacion(String x) {
    _unaUbicacion.value = x;
  }

  String get unaUbicacion => _unaUbicacion.value;
//////////////////////////////////////

  void cargaListaUbicaciones(List<Map<String, dynamic>> x) {
    _listaUbicaciones.value = x;
  }

  List<Map<String, dynamic>>? get listaUbicaciones => _listaUbicaciones.value;
//////////////////////////////////////

  Future<void> cargarDB() async {
    final datos = await PeticionesDB.mostrarUbicaciones();
    cargaListaUbicaciones(datos);
  }
}
