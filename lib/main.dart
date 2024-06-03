import 'package:alerta_dengue/pages/info_page/info_page.dart';
import 'package:alerta_dengue/pages/main_page/main_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class InfoArgs {
  final DateTime data;
  final String nomeDoenca;
  final int codigo;

  const InfoArgs(this.data, this.nomeDoenca, this.codigo);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: MainPage.routeName,
      routes: {
        MainPage.routeName: (context) => const MainPage(),
        InfoPage.routeName: (context) => const InfoPage(),
      },
    );
  }
}