import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sqf_lite/Controladores/controlador.dart';
import 'package:sqf_lite/Proceso/peticiones.dart';
import 'package:iconly/iconly.dart';

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
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                              leading: Icon(
                                IconlyBold.location,
                                color: Color.fromARGB(255, 254, 183, 22),
                              ),
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
                                                color: Color.fromARGB(
                                                    255, 0, 155, 126),
                                                child: Text(
                                                  "Si",
                                                  style: GoogleFonts.openSans(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white),
                                                ),
                                                onPressed: () {
                                                  PeticionesDB.eliminarUbicacion(
                                                      Control.listaUbicaciones![
                                                          index]["id"]);
                                                  Control
                                                      .cargarDB(); //Actualizar tabla
                                                  Navigator.pop(context);
                                                }),
                                            DialogButton(
                                                color: Color.fromARGB(
                                                    255, 176, 0, 32),
                                                child: Text("No",
                                                    style: GoogleFonts.openSans(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white)),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                }),
                                          ],
                                          context: context)
                                      .show();
                                },
                                icon: Icon(
                                  IconlyBold.delete,
                                  color: Color.fromARGB(255, 176, 0, 32),
                                ),
                              ),
                              title: Text(
                                Control.listaUbicaciones![index]["coordenadas"],
                                style: GoogleFonts.openSans(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                Control.listaUbicaciones![index]["fecha"],
                                style: GoogleFonts.openSans(
                                    fontSize: 12, color: Colors.grey),
                              )),
                        ),
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
