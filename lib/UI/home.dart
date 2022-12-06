import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sqf_lite/Proceso/peticiones.dart';
import 'package:sqf_lite/UI/listado.dart';
import '../Controladores/controlador.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const FlexScheme usedFlexScheme = FlexScheme.aquaBlue;

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
        title: Text(widget.title),
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
                              color: Colors.green[700]!,
                              child: Text("Si"),
                              onPressed: () {
                                PeticionesDB.eliminarTodas();
                                Control.cargarDB();
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
              icon: Icon(Icons.cancel_rounded))
        ],
      ),
      body: listar(),
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
                        color: Colors.green[700]!,
                        child: Text("Si"),
                        onPressed: () {
                          PeticionesDB.guardarUbicacion(
                              Control.unaUbicacion, DateTime.now().toString());
                          Control.cargarDB();
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
        child: Icon(Icons.location_on),
      ),
    );
  }
}
