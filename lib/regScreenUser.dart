import 'package:flutter/material.dart';

class RegScreenUser extends StatefulWidget {
  const RegScreenUser({Key? key}) : super(key: key);

  @override
  State<RegScreenUser> createState() => _RegScreenUserState();
}

class _RegScreenUserState extends State<RegScreenUser> {
  String? _gratuidadeSelecionada; 
  final TextEditingController _registroController = TextEditingController();

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
              padding: EdgeInsets.only(top: 60.0, left: 22),
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
            padding: const EdgeInsets.only(top: 170.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0, left: 18.0, right: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const TextField(
                      decoration: InputDecoration(
                          suffixIcon: Icon(Icons.person, color: Colors.grey),
                          label: Text(
                            'Nome Completo',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 203, 6, 45),
                            ),
                          )),
                    ),
                    const TextField(
                      decoration: InputDecoration(
                          suffixIcon: Icon(Icons.email, color: Colors.grey),
                          label: Text(
                            'Email',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 203, 6, 45),
                            ),
                          )),
                    ),
                    const TextField(
                      decoration: InputDecoration(
                          suffixIcon: Icon(Icons.calendar_today, color: Colors.grey),
                          label: Text(
                            'Data de Nascimento',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 203, 6, 45),
                            ),
                          )),
                    ),
                    const SizedBox(height: 0),
                    
                    const TextField(
                      decoration: InputDecoration(
                          suffixIcon: Icon(Icons.numbers, color: Colors.grey),
                          label: Text(
                            'Número de Registro (SP Trans)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 203, 6, 45),
                            ),
                          )),
                    ),
                    const SizedBox(height: 20),

                    RadioListTile<String>(
                      title: const Text(
                        'Gratuidade por Idade',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 203, 6, 45),
                        ),
                      ),
                      value: 'idade',
                      groupValue: _gratuidadeSelecionada,
                      onChanged: (value) {
                        setState(() {
                          _gratuidadeSelecionada = value;
                        });
                      },
                    ),
                    
                    RadioListTile<String>(
                      title: const Text(
                        'Gratuidade por Número de Registro (SP Trans)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 203, 6, 45),
                        ),
                      ),
                      value: 'registro',
                      groupValue: _gratuidadeSelecionada,
                      onChanged: (value) {
                        setState(() {
                          _gratuidadeSelecionada = value;
                        });
                      },
                    ),
                    
                    const SizedBox(height: 30),
                    
                    Container(
                      height: 55,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color.fromARGB(255, 203, 6, 45),
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
                    const SizedBox(height: 50),
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
