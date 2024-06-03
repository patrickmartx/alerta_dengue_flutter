import 'package:alerta_dengue/data/model_casos_dengue.dart';
import 'package:alerta_dengue/pages/info_page/service/service_casos_dengue.dart';
import 'package:flutter/material.dart';

class CasosDengueProvider with ChangeNotifier {
  CasosDengue? _casosDengue;
  bool _isLoading = true;

  CasosDengue? get casosDengue => _casosDengue;
  bool get isLoading => _isLoading;

  Future<void> carregarCasosDengue(String parametros) async {
    try {
      _casosDengue = await ApiCasosDengueService.fetchCasosDengue(parametros);
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
