import 'package:alerta_dengue/data/model_municipios.dart';
import 'package:alerta_dengue/main.dart';
import 'package:alerta_dengue/pages/info_page/info_utils/lista_municipios.dart';
import 'package:alerta_dengue/pages/info_page/providers/provider_casos_dengue.dart';
import 'package:alerta_dengue/pages/info_page/service/service_casos_dengue.dart';
import 'package:alerta_dengue/pages/info_page/service/service_municipios.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return (diferencaEmDias / 7).ceil() + 1;
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
      await ApiCasosDengueService.fetchCasosDengue(
          getParametros(data, nomeDoenca, codigoMunicipio));
      setState(() {
        isLoadingCasosDengue = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          padding: EdgeInsets.only(bottom: 100),
          backgroundColor: Colors.red,
          content: Text(
              'Nenhum caso de dengue encontrado para a data selecionada.'),
        ),
      );
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
        title: const Text.rich(
          TextSpan(
            children: [
              TextSpan(
                  text: "Alerta ",
                  style: TextStyle(fontSize: 20.0, color: Colors.white)),
              TextSpan(
                  text: "Dengue",
                  style: TextStyle(fontSize: 20.0, color: Colors.red)),
            ],
          ),
        ),
        backgroundColor: Colors.black,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
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

class CasosDengueCard extends StatelessWidget {
  final String parametros;

  const CasosDengueCard({super.key, required this.parametros});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          CasosDengueProvider()..carregarCasosDengue(parametros),
      child: Consumer<CasosDengueProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.casosDengue == null) {
            return const Center(child: Text('Erro ao carregar dados'));
          } else {
            final casosDengue = provider.casosDengue!;
            return Card(
              margin: const EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ID: ${casosDengue.id}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8.0),
                    Text('Casos Previstos: ${casosDengue.casosPrevistos}'),
                    const SizedBox(height: 8.0),
                    Text('Casos: ${casosDengue.casos}'),
                    const SizedBox(height: 8.0),
                    Text('Nível: ${casosDengue.nivel}'),
                    const SizedBox(height: 8.0),
                    Text(
                        'Temperatura Mínima: ${casosDengue.temperaturaMinima}'),
                    const SizedBox(height: 8.0),
                    Text(
                        'Temperatura Máxima: ${casosDengue.temperaturaMaxima}'),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
