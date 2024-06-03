import 'dart:convert';
import 'package:alerta_dengue/data/model_estados.dart';
import 'package:alerta_dengue/routes/api_routes/api_locais.dart';
import 'package:http/http.dart' as http;

class ApiEstadosService {

  static Future<List<Estado>> fetchEstados() async {
    final response = await http.get(Uri.parse(LISTAR_ESTADOS_URL));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Estado.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar os estados');
    }
  }
}
