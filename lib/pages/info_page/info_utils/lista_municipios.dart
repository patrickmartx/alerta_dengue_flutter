import 'package:flutter/material.dart';
import 'package:alerta_dengue/data/model_municipios.dart';

class MunicipioDropdown extends StatefulWidget {
  final List<Municipio> municipios;
  final Municipio? municipioSelecionado;
  final ValueChanged<Municipio?> onChanged;

  const MunicipioDropdown({
    super.key,
    required this.municipios,
    this.municipioSelecionado,
    required this.onChanged,
  });

  @override
  _MunicipioDropdownState createState() => _MunicipioDropdownState();
}

class _MunicipioDropdownState extends State<MunicipioDropdown> {
  Municipio? selectedMunicipio;

  @override
  void initState() {
    super.initState();
    selectedMunicipio = widget.municipioSelecionado ?? widget.municipios.first;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Municipio>(
      value: selectedMunicipio,
      items: widget.municipios
          .map<DropdownMenuItem<Municipio>>((Municipio value) {
        return DropdownMenuItem<Municipio>(
          value: value,
          child: Text(value.nome),
        );
      }).toList(),
      onChanged: (Municipio? novoValor) {
        setState(() {
          selectedMunicipio = novoValor;
        });
        widget.onChanged(novoValor);
      },
    );
  }
}
