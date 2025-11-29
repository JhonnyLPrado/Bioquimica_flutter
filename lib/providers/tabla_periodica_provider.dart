import 'package:flutter/material.dart';
import '../data/tabla_periodica.dart';
import '../models/elemento_quimico.dart';

class TablaPeriodicaProvider extends ChangeNotifier {
  final List<ElementoQuimico> elementos = TablaPeriodicaData.elementos;

  ElementoQuimico? elementoSeleccionado;

  void seleccionarElemento(ElementoQuimico elemento) {
    elementoSeleccionado = elemento;
    notifyListeners();
  }
}
