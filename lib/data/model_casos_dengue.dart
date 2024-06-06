class CasosDengue {
  final int id;
  final double casosPrevistos;
  final int casos;
  final int nivel;
  final double temperaturaMinima;
  final double temperaturaMaxima;

  CasosDengue({required this.id, required this.casosPrevistos, required this.casos, required this.nivel, required this.temperaturaMinima, required this.temperaturaMaxima});

  factory CasosDengue.fromJson(List<dynamic> json) {
  final casosDengue = json.map((item) => CasosDengue(
    id: item['id'],
    casosPrevistos: item['casos_est'],
    casos: item['casos'],
    nivel: item['nivel'],
    temperaturaMinima: item['tempmin'],
    temperaturaMaxima: item['tempmax'],
  )).toList();

  return casosDengue[0]; 
}


}