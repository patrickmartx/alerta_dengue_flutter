import 'package:alerta_dengue/pages/info_page/providers/provider_casos_dengue.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CasosDengueCard extends StatelessWidget {
  final String parametros;

  const CasosDengueCard({super.key, required this.parametros});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CasosDengueProvider()..carregarCasosDengue(parametros),
      child: Consumer<CasosDengueProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (provider.casosDengue == null) {
            return Center(child: Text('Erro ao carregar dados'));
          } else {
            final casosDengue = provider.casosDengue!;
            return Card(
              margin: EdgeInsets.all(16.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ID: ${casosDengue.id}', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8.0),
                    Text('Casos Previstos: ${casosDengue.casosPrevistos}'),
                    SizedBox(height: 8.0),
                    Text('Casos: ${casosDengue.casos}'),
                    SizedBox(height: 8.0),
                    Text('Nível: ${casosDengue.nivel}'),
                    SizedBox(height: 8.0),
                    Text('Temperatura Mínima: ${casosDengue.temperaturaMinima}'),
                    SizedBox(height: 8.0),
                    Text('Temperatura Máxima: ${casosDengue.temperaturaMaxima}'),
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
