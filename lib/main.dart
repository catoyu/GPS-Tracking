import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqf_lite/Controladores/controlador.dart';

import 'UI/home.dart';

void main() {
  Get.put(controlador());
  runApp(const MyApp());
}
