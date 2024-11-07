import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegScreenUser extends StatefulWidget {
  const RegScreenUser({Key? key}) : super(key: key);

  @override
  State<RegScreenUser> createState() => _RegScreenUserState();
}

class _RegScreenUserState extends State<RegScreenUser> {
  String? _gratuidadeSelecionada;
  final MaskedTextController _dataNascimentoController =
      MaskedTextController(mask: '00/00/0000');

  Future<void> _cadastrarUsuario() async {
    if (_dataNascimentoController.text.isEmpty || _gratuidadeSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos!')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('gratuidade').add({
        'dataNascimento': _dataNascimentoController.text,
        'gratuidade': _gratuidadeSelecionada,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado com sucesso!')),
      );

      _dataNascimentoController.clear();
      setState(() {
        _gratuidadeSelecionada = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 203, 6, 45),
                Color.fromARGB(255, 255, 255, 255),
              ]),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 35.0, left: 22),
              child: Text(
                'Crie Conta\n com Gratuidade',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 140.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _dataNascimentoController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.calendar_today, color: Colors.grey),
                          label: Text(
                            'Data de Nascimento',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 203, 6, 45),
                            ),
                          )),
                    ),
                    const SizedBox(height: 15),
                    RadioListTile<String>(
                      title: const Text(
                        'Gratuidade para Idosos (+60 anos)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 203, 6, 45),
                        ),
                      ),
                      value: 'idosos',
                      groupValue: _gratuidadeSelecionada,
                      onChanged: (value) {
                        setState(() {
                          _gratuidadeSelecionada = value;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text(
                        'Gratuidade para Pessoas com Deficiência (PCD)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 203, 6, 45),
                        ),
                      ),
                      value: 'deficiencia',
                      groupValue: _gratuidadeSelecionada,
                      onChanged: (value) {
                        setState(() {
                          _gratuidadeSelecionada = value;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text(
                        'Gratuidade para Estudantes',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 203, 6, 45),
                        ),
                      ),
                      value: 'estudantes',
                      groupValue: _gratuidadeSelecionada,
                      onChanged: (value) {
                        setState(() {
                          _gratuidadeSelecionada = value;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text(
                        'Gratuidade para Policiais',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 203, 6, 45),
                        ),
                      ),
                      value: 'policiais',
                      groupValue: _gratuidadeSelecionada,
                      onChanged: (value) {
                        setState(() {
                          _gratuidadeSelecionada = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    GestureDetector(
                      onTap: () {
                      },
                      child: Container(
                        height: 55,
                        width: 220,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.black, width: 1),
                          color: Colors.white,
                        ),
                        child: const Center(
                          child: Text(
                            'Foto',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 47),

                    GestureDetector(
                      onTap: _cadastrarUsuario,
                      child: Container(
                        height: 55,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: const Color.fromARGB(255, 203, 6, 45),
                        ),
                        child: const Center(
                          child: Text(
                            'Cadastrar',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30), 
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
