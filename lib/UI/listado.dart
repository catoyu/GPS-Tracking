import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sqf_lite/Controladores/controlador.dart';
import 'package:sqf_lite/Proceso/peticiones.dart';

class listar extends StatefulWidget {
  const listar({super.key});

  @override
  State<listar> createState() => _listarState();
}

class _listarState extends State<listar> {
  controlador Control = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Control.cargarDB();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          child: Control.listaUbicaciones?.isEmpty == false
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: Control.listaUbicaciones!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                            leading: Icon(Icons.my_location_rounded),
                            trailing: IconButton(
                              onPressed: () {
                                Alert(
                                        title:
                                            "¿Estás seguro de eliminar está ubicación?",
                                        desc:
                                            "Una vez eliminada no podrás restaurarla.",
                                        type: AlertType.warning,
                                        buttons: [
                                          DialogButton(
                                              color: Colors.green[700]!,
                                              child: Text("Si"),
                                              onPressed: () {
                                                PeticionesDB.eliminarUbicacion(
                                                    Control.listaUbicaciones![
                                                        index]["id"]);
                                                Control
                                                    .cargarDB(); //Actualizar tabla
                                                Navigator.pop(context);
                                              }),
                                          DialogButton(
                                              color: Colors.red[800]!,
                                              child: Text("No"),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              }),
                                        ],
                                        context: context)
                                    .show();
                              },
                              icon: Icon(Icons.delete_forever_rounded),
                            ),
                            title: Text(Control.listaUbicaciones![index]
                                ["coordenadas"]),
                            subtitle: Text(
                                Control.listaUbicaciones![index]["fecha"])),
                      );
                    },
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ));
  }
}
