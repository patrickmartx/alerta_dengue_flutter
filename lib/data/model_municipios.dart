class Municipio{
  final int codigo;
  final String nome;

  Municipio({required this.codigo, required this.nome});

  factory Municipio.fromJson(Map<String, dynamic> json) {
    return Municipio(
      codigo: json['id'],
      nome: json['nome'],
    );
  }
}