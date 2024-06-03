import 'dart:js_interop';

import 'package:alerta_dengue/data/model_municipios.dart';
import 'package:alerta_dengue/main.dart';
import 'package:alerta_dengue/pages/info_page/info_utils/casos_dengue_card.dart';
import 'package:alerta_dengue/pages/info_page/info_utils/lista_municipios.dart';
import 'package:alerta_dengue/pages/info_page/service/service_casos_dengue.dart';
import 'package:alerta_dengue/pages/info_page/service/service_municipios.dart';
import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});
  static const routeName = "/info";

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class CalcularSemanaEpidemiologica {
  static int getSemanaEpidemiologica(DateTime data) {
    DateTime primeiraSegundaFeiraDoAno = DateTime(data.year, 1, 1);
    while (primeiraSegundaFeiraDoAno.weekday != DateTime.monday) {
      primeiraSegundaFeiraDoAno =
          primeiraSegundaFeiraDoAno.add(const Duration(days: 1));
    }
    int diferencaEmDias = data.difference(primeiraSegundaFeiraDoAno).inDays;
    int semanaEpidemiologica = (diferencaEmDias / 7).ceil() + 1;

    return semanaEpidemiologica;
  }
}

String getParametros(DateTime date, String nomeDoenca, int codigoMunicipio) {
  int semanaEpidemiologica =
      CalcularSemanaEpidemiologica.getSemanaEpidemiologica(date);
  int ano = date.year;
  return "geocode=$codigoMunicipio&disease=${nomeDoenca.toLowerCase()}&format=json&ew_start=$semanaEpidemiologica&ey_start=$ano&ew_end=$semanaEpidemiologica&ey_end=$ano";
}

class _InfoPageState extends State<InfoPage> {
  List<Municipio> municipios = [];
  bool isLoadingMunicipios = true;
  bool isLoadingCasosDengue = false;
  int estadoSelecionado = 0;
  bool isInitialized = false;
  Municipio? municipioSelecionado;
  late DateTime data;
  late String nomeDoenca;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitialized) {
      final argumentos = ModalRoute.of(context)?.settings.arguments as InfoArgs;
      estadoSelecionado = argumentos.codigo;
      data = argumentos.data;
      nomeDoenca = argumentos.nomeDoenca;
      fetchMunicipios();
      isInitialized = true;
    }
  }

  Future<void> fetchMunicipios() async {
    try {
      final fetchedMunicipios =
          await ApiMunicipiosService.fetchMunicipios(estadoSelecionado);
      setState(() {
        municipios = fetchedMunicipios;
        isLoadingMunicipios = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchCasosDengue(int codigoMunicipio) async {
    setState(() {
      isLoadingCasosDengue = true;
    });
    try {
      final fetchedCasosDengue = await ApiCasosDengueService.fetchCasosDengue(
          getParametros(data, nomeDoenca, codigoMunicipio));
      setState(() {
        isLoadingCasosDengue = false;
      });
    } catch (e) {
      print("erro aqui ${e.runtimeType} ${e.jsify()} $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: "Alerta ",
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              ),
              TextSpan(
                text: "Dengue",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.black,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: isLoadingMunicipios
                  ? const Center(child: CircularProgressIndicator())
                  : Center(
                      child: MunicipioDropdown(
                        municipios: municipios,
                        municipioSelecionado: municipioSelecionado,
                        onChanged: (Municipio? novoValor) {
                          setState(() {
                            municipioSelecionado = novoValor;
                            if (municipioSelecionado != null) {
                              fetchCasosDengue(municipioSelecionado!.codigo);
                            }
                          });
                        },
                      ),
                    ),
            ),
            Expanded(
              flex: 11,
              child: isLoadingCasosDengue
                  ? const Center(child: CircularProgressIndicator())
                  : municipioSelecionado == null
                      ? const Center(child: Text('Selecione um município'))
                      : CasosDengueCard(
                          parametros: getParametros(
                              data, nomeDoenca, municipioSelecionado!.codigo),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
