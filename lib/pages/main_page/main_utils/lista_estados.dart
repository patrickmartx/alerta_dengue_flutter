import 'package:alerta_dengue/data/model_estados.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListaEstados extends StatefulWidget {
  const ListaEstados({super.key, required this.estados, required this.onTap});
  
  final List<Estado> estados;
  final void Function(Estado) onTap;

  @override
  State<ListaEstados> createState() => _ListaEstadosState();
}

class _ListaEstadosState extends State<ListaEstados> {
  late List<Estado> sortedEstados;

  @override
  void initState() {
    super.initState();
    sortedEstados = List.from(widget.estados)
      ..sort((a, b) => a.sigla.compareTo(b.sigla));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final estado = sortedEstados[index];
        return ListTile(
          title: Text("${index+1}: ${estado.sigla} - ${estado.nome}"),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => widget.onTap(estado),
        );
      },
      separatorBuilder: (context, index) => Divider(),
      itemCount: widget.estados.length,
    );
  }
}
