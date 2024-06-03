import 'dart:convert';
import 'package:alerta_dengue/data/model_casos_dengue.dart';
import 'package:alerta_dengue/routes/api_routes/api_locais.dart'; // Certifique-se de que o URL está aqui
import 'package:http/http.dart' as http;

class ApiCasosDengueService {
  static Future<CasosDengue> fetchCasosDengue(String parametros) async {
    final response = await http.get(Uri.parse('$ALERTADENGUE_BASE_URL$parametros'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return CasosDengue.fromJson(data);
    } else {
      throw Exception('Falha ao carregar os casos de dengue');
    }
  }
}
