import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

class CamFunction extends StatefulWidget {
  const CamFunction({super.key});

  @override
  State<CamFunction> createState() => _CamFunctionState();
}

class _CamFunctionState extends State<CamFunction> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  String recognitionResult = "Cadastro de Foto";

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _cameraController = CameraController(
        cameras[0],
        ResolutionPreset.medium,
      );
      await _cameraController?.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } else {
      print("Nenhuma câmera disponível.");
    }
  }

  Future<void> _tirarFoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      print("Câmera não inicializada.");
      return;
    }

    try {
      print("Tentando tirar foto...");
      final image = await _cameraController!.takePicture();
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);

      print("Imagem capturada, enviando ao servidor...");
      final response = await http.post(
        Uri.parse("http://192.168.15.168:5000/take_photo"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'image': base64Image}),
      );

      if (response.statusCode == 200) {
        print("Foto enviada com sucesso.");
        setState(() {
          recognitionResult = "Foto tirada com sucesso";
        });
      } else {
        print("Erro na resposta do servidor: ${response.statusCode}");
        setState(() {
          recognitionResult = "Erro ao tirar foto";
        });
      }
    } catch (e) {
      print("Erro ao tirar foto: $e");
      setState(() {
        recognitionResult = "Erro: $e";
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isCameraInitialized
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 203, 6, 45),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      recognitionResult,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20, // Aumentando o tamanho do texto
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: CameraPreview(_cameraController!),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _tirarFoto,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 203, 6, 45),
                      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20), // Aumentando o tamanho do botão
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      "Tirar Foto",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18, // Aumentando o tamanho do texto do botão
                      ),
                    ),
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
