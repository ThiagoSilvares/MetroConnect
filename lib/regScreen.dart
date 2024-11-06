import 'package:flutter/material.dart';
import 'loginScreen.dart';

class RegScreen extends StatelessWidget {
  const RegScreen({Key? key}) : super(key: key);

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
                'Crie sua\nConta',
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
                          suffixIcon: Icon(Icons.person, color: Colors.grey),
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
                    const TextField(
                      decoration: InputDecoration(
                          suffixIcon: Icon(Icons.visibility_off, color: Colors.grey),
                          label: Text(
                            'Senha',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 203, 6, 45),
                            ),
                          )),
                    ),
                    const TextField(
                      decoration: InputDecoration(
                          suffixIcon: Icon(Icons.visibility_off, color: Colors.grey),
                          label: Text(
                            'Confirme sua Senha',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 203, 6, 45),
                            ),
                          )),
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 50),
                    Container(
                      height: 55,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 203, 6, 45),
                            Color.fromARGB(255, 255, 255, 255),
                          ],
                        ),
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
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "Você já tem uma conta?",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                              );
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    )
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
