class Estado {
  final int codigo;
  final String nome;
  final String sigla;

  Estado({required this.codigo, required this.nome, required this.sigla});

  factory Estado.fromJson(Map<String, dynamic> json) {
    return Estado(
      codigo: json['id'],
      nome: json['nome'],
      sigla: json['sigla'],
    );
  }
}
