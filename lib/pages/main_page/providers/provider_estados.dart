import 'package:alerta_dengue/data/model_estados.dart';
import 'package:alerta_dengue/pages/main_page/service/service_estados.dart';
import 'package:flutter/material.dart';

class EstadoProvider with ChangeNotifier {
  List<Estado> _estados = [];
  bool _isLoading = true;

  List<Estado> get estados => _estados;
  bool get isLoading => _isLoading;

  Future<void> carregarEstados() async {
    try {
      _estados = await ApiEstadosService.fetchEstados();
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
