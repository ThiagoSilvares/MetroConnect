import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int itemSelecionado = 0;
  CameraController? _cameraController;
  bool _isRecognizing = false;
  String recognitionResult = "Desconhecido";

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Index 0: Home'),
    Text('Index 1: Chat'),
    Text('Index 2: Camera'),
    Text('Index 3: Biometria'),
    Text('Index 4: Sair'),
  ];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
      await _cameraController?.initialize();
      setState(() {}); // Atualiza a tela quando a câmera é inicializada
    }
  }

  Future<void> iniciarReconhecimentoFacial() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      print("Câmera não inicializada.");
      return;
    }

    setState(() {
      _isRecognizing = true;
    });

    try {
      final image = await _cameraController!.takePicture();
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse("http://192.168.15.168:5000/recognize"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'image': base64Image}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final recognizedFaces = data["recognized_faces"];
        setState(() {
          recognitionResult = recognizedFaces.isNotEmpty
              ? recognizedFaces.join(", ")
              : "Desconhecido";
        });
      } else {
        print("Erro ao conectar ao servidor.");
        setState(() {
          recognitionResult = "Erro ao conectar";
        });
      }
    } catch (e) {
      print("Erro: $e");
      setState(() {
        recognitionResult = "Erro: $e";
      });
    } finally {
      setState(() {
        _isRecognizing = false;
      });
    }
  }

  // Função para refazer o reconhecimento facial
  void refazerReconhecimento() {
    setState(() {
      recognitionResult = "Desconhecido"; // Resetando o nome exibido
    });
    iniciarReconhecimentoFacial(); // Reiniciando o processo de reconhecimento
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: itemSelecionado == 3 && _cameraController != null && _cameraController!.value.isInitialized
            ? Stack(
                alignment: Alignment.center,
                children: [
                  // CameraPreview dentro do Container
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.5,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CameraPreview(_cameraController!),
                  ),
                  // Caixa com o nome do reconhecimento facial (fora da câmera, em cima dela)
                  Positioned(
                    top: 10, // Distância do topo da câmera
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 203, 6, 45), // Cor de fundo da caixa
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        recognitionResult,
                        style: const TextStyle(
                          color: Colors.white, // Cor da letra
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Botão "Refazer Reconhecimento" (fora da câmera, abaixo dela)
                  Positioned(
                    bottom: 20, // Distância da parte inferior
                    child: ElevatedButton(
                      onPressed: refazerReconhecimento,
                      child: Text("Refazer Reconhecimento"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 203, 6, 45), // Cor do botão
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Cor do texto do botão
                        ),
                      ),
                    ),
                  ),
                  // Indicador de progresso abaixo da câmera, se o reconhecimento estiver em andamento
                  if (_isRecognizing)
                    Positioned(
                      bottom: 16,
                      child: CircularProgressIndicator(),
                    ),
                ],
              )
            : Center(
                child: _widgetOptions.elementAt(itemSelecionado),
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: itemSelecionado,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.camera), label: "Camera"),
          BottomNavigationBarItem(icon: Icon(Icons.fingerprint), label: "Biometria"),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: "Sair"),
        ],
        onTap: (valor) {
          setState(() {
            itemSelecionado = valor;
          });
          if (valor == 3 && !_isRecognizing) {
            iniciarReconhecimentoFacial();
          }
        },
        selectedItemColor: Color.fromARGB(255, 203, 6, 45),
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
