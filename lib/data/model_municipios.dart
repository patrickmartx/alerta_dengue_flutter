class Municipio{
  final int codigoTexto;
  final String nome;

  Municipio({required this.codigoTexto, required this.nome});

  factory Municipio.fromJson(Map<String, dynamic> json) {
    return Municipio(
      codigoTexto: int.parse(json['codigo_ibge']),
      nome: json['nome'],
    );
  }
}