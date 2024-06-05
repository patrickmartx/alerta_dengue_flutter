import 'dart:convert';
import 'package:alerta_dengue/data/model_estados.dart';
import 'package:alerta_dengue/main.dart';
import 'package:alerta_dengue/pages/info_page/info_page.dart';
import 'package:alerta_dengue/pages/main_page/main_utils/datepicker.dart';
import 'package:alerta_dengue/pages/main_page/main_utils/lista_estados.dart';
import 'package:alerta_dengue/pages/main_page/main_utils/title_component.dart';
import 'package:alerta_dengue/pages/main_page/service/service_estados.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  static const routeName = "/";

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<String> DOENCAS = ["Dengue", "Chikungunya", "Zika"];
  String doencaSelecionada = "";
  DateTime data = DateTime.now();
  List<Estado> estados = [];
  bool isLoading = true;
  String estadoSelecionado = "";

  @override
  void initState() {
    super.initState();
    doencaSelecionada = DOENCAS.first;
    fetchEstados();
  }

  Future<void> fetchEstados() async {
    try {
      final fetchedEstados = await ApiEstadosService.fetchEstados();
      setState(() {
        estados = fetchedEstados;
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
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
                flex: 2,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TitleAndBox(
                      title: "Selecione a doença",
                      child: DropdownButton<String>(
                        value: doencaSelecionada,
                        items: DOENCAS
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? novoValor) {
                          setState(() {
                            if (novoValor != null) {
                              doencaSelecionada = novoValor;
                            }
                          });
                        },
                      ),
                    ),
                    Container(
                      width: 150.0,
                      child: TitleAndBox(
                        title: "Data",
                        child: DatePickerTextField(
                          onDateSelected: (DateTime selectedDate) {
                            setState(() {
                              data = selectedDate;
                            });
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 10,
                child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ListaEstados(
                            estados: estados,
                            onTap: (Estado estado) {
                              estadoSelecionado = estado.sigla;
                              print("$doencaSelecionada - $data - $estadoSelecionado");
                              Navigator.pushNamed(
                                  context, InfoPage.routeName,
                                  arguments: InfoArgs(data, doencaSelecionada, estadoSelecionado));
                            },
                          )),
              )
            ],
          ),
        ));
  }
}
