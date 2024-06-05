import 'dart:convert';
import 'package:alerta_dengue/data/model_municipios.dart';
import 'package:alerta_dengue/routes/api_routes/api_locais.dart';
import 'package:http/http.dart' as http;

class ApiMunicipiosService {

  static Future<List<Municipio>> fetchMunicipios(String sigla) async {
    final response = await http.get(Uri.parse(LISTAR_MUNICIPIOS_URL(sigla)));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Municipio.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar os estados');
    }
  }
}
