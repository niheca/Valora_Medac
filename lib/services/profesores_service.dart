import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:convert';  // Para convertir el JSON
import 'package:flutter/services.dart'; // Para rootBundle

 final db = FirebaseFirestore.instance;

Future cargarPersonas() async{

  String jsonString =  await rootBundle.loadString('assets/data/jsonValoraMedac.json');

  JsonDecoder decoder =  JsonDecoder();

  var json = decoder.convert(jsonString);

  db.collection("profesores").add(json);

}


