import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sqf_lite/Proceso/peticiones.dart';
import 'package:sqf_lite/UI/listado.dart';
import '../Controladores/controlador.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const FlexScheme usedFlexScheme = FlexScheme.blumineBlue;

    return GetMaterialApp(
      title: 'GPS Tracking',
      theme: FlexColorScheme.light(
        scheme: usedFlexScheme,
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
      ).toTheme,
      darkTheme: FlexColorScheme.dark(
        scheme: usedFlexScheme,
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
      ).toTheme,
      themeMode: ThemeMode.light,
      home: const MyHomePage(title: 'GPS Tracking'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  controlador Control = Get.find();

  void obtenerUbicacion() async {
    Position posicion = await PeticionesDB.determinePosition();
    print(posicion.toString());
    Control.cargaUnaUbicacion(posicion.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style:
              GoogleFonts.openSans(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Alert(
                        title: "¿Estas seguro?",
                        desc:
                            "Una vez que elimines TODAS tus ubicaciones no podrás recuperarlas.",
                        type: AlertType.warning,
                        buttons: [
                          DialogButton(
                              color: Color.fromARGB(255, 0, 155, 126),
                              child: Text("Si",
                                  style: GoogleFonts.openSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                              onPressed: () {
                                PeticionesDB.eliminarTodas();
                                Control.cargarDB();
                                Navigator.pop(context);
                              }),
                          DialogButton(
                              color: Color.fromARGB(255, 176, 0, 32),
                              child: Text("No",
                                  style: GoogleFonts.openSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        ],
                        context: context)
                    .show();
              },
              icon: Icon(
                IconlyBold.close_square,
              ))
        ],
      ),
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Color.fromARGB(255, 143, 186, 201)])),
          child: listar()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          obtenerUbicacion();
          Alert(
                  title: "¡¡¡Atención!!!",
                  desc: "¿Deseas guardar tu ubicación actual?: " +
                      Control.unaUbicacion,
                  type: AlertType.warning,
                  buttons: [
                    DialogButton(
                        color: Color.fromARGB(255, 0, 155, 126),
                        child: Text("Si",
                            style: GoogleFonts.openSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                        onPressed: () {
                          PeticionesDB.guardarUbicacion(
                              Control.unaUbicacion, DateTime.now().toString());
                          Control.cargarDB();
                          Navigator.pop(context);
                        }),
                    DialogButton(
                        color: Color.fromARGB(255, 176, 0, 32),
                        child: Text("No",
                            style: GoogleFonts.openSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ],
                  context: context)
              .show();
        },
        child: Icon(Icons.location_on),
      ),
    );
  }
}
