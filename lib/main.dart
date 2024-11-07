import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart'; // Importação necessária
import 'WelcomeScreen.dart'; // Substitua pelo nome correto da sua tela de boas-vindas

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Garante que a inicialização ocorra antes de qualquer widget
  await Firebase.initializeApp();  // Inicializa o Firebase corretamente

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: ('inter'),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(), // Sua tela inicial
    );
  }
}
