import 'package:alerta_dengue/data/model_estados.dart';
import 'package:alerta_dengue/data/model_municipios.dart';
import 'package:alerta_dengue/pages/main_page/service/service_estados.dart';
import 'package:alerta_dengue/pages/info_page/service/service_municipios.dart';
import 'package:flutter/material.dart';

class MunicipioProvider with ChangeNotifier {
  List<Municipio> _municipios = [];
  bool _isLoading = true;

  List<Municipio> get municipios => _municipios;
  bool get isLoading => _isLoading;

  Future<void> carregarMunicipios(int codigo) async {
    try {
      _municipios = await ApiMunicipiosService.fetchMunicipios(codigo);
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
