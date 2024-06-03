class CasosDengue {
  final int id;
  final double casosPrevistos;
  final double casos;
  final int nivel;
  final double temperaturaMinima;
  final double temperaturaMaxima;

  CasosDengue({required this.id, required this.casosPrevistos, required this.casos, required this.nivel, required this.temperaturaMinima, required this.temperaturaMaxima});

  factory CasosDengue.fromJson(Map<String, dynamic> json) {
    return CasosDengue(
      id: json['id'],
      casosPrevistos: json['casos_est'], 
      casos: json['casos'], 
      nivel: json['nivel'], 
      temperaturaMinima: json['tempmin'], 
      temperaturaMaxima: json['tempmax']);
  }

}