import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'regScreenUser.dart';
import 'camFunction.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int itemSelecionado = 0;
  CameraController? _cameraController;
  bool _isRecognizing = false;
  String recognitionResult = "Aguarde o reconhecimento";

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Index 0: Home'),
    RegScreenUser(),
    CamFunction(),
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
      setState(() {});
    }
  }

  Future<void> iniciarReconhecimentoFacial() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      print("Câmera não inicializada.");
      return;
    }

    if (_isRecognizing) return;  // Evita iniciar reconhecimento se já está em andamento

    setState(() {
      _isRecognizing = true;
      recognitionResult = "Aguarde o reconhecimento";
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
              ? "Acesso liberado"
              : "Usuário não cadastrado";
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

  void refazerReconhecimento() {
    setState(() {
      recognitionResult = "Aguarde o reconhecimento";
    });
    iniciarReconhecimentoFacial();
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
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 203, 6, 45),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      recognitionResult,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.5,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CameraPreview(_cameraController!),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: refazerReconhecimento,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 203, 6, 45),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: const Text(
                      "Refazer Reconhecimento",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (_isRecognizing)
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
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
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "Cad. Usuário"),
          BottomNavigationBarItem(icon: Icon(Icons.camera), label: "Câmera"),
          BottomNavigationBarItem(icon: Icon(Icons.fingerprint), label: "Reconhecimento"),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: "Sair"),
        ],
        onTap: (valor) {
          setState(() {
            itemSelecionado = valor;
          });
          if (valor == 3 && !_isRecognizing) {
            iniciarReconhecimentoFacial();  // Inicia o reconhecimento quando o usuário seleciona a opção
          }
        },
        selectedItemColor: const Color.fromARGB(255, 203, 6, 45),
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
