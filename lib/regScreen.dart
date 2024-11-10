import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'loginScreen.dart';

class RegScreen extends StatelessWidget {
  RegScreen({Key? key}) : super(key: key);

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _fullNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();

  Future<void> registerUser(BuildContext context) async {
    if (_fullNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showError(context, "Por favor, preencha todos os campos.");
      return;
    }

    if (!_emailController.text.contains("@metro.com")) {
      _showError(context, "O email deve conter '@metro.com'.");
      return;
    }

    if (_passwordController.text.length < 6) {
      _showError(context, "A senha deve conter pelo menos 6 caracteres.");
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showError(context, "Senha e Confirme sua Senha devem ser idênticas.");
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
        'fullName': _fullNameController.text,
        'email': _emailController.text,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      _showError(context, "Erro ao cadastrar. Tente novamente.");
      print("Erro ao cadastrar: $e");
    }
  }

  void _showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Erro"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
          LayoutBuilder(
            builder: (context, constraints) {
              final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
              return Center(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: isKeyboardVisible
                          ? constraints.maxHeight
                          : constraints.maxHeight - MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 163.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 70),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  FocusScope.of(context).requestFocus(_fullNameFocusNode);
                                },
                                child: TextField(
                                  focusNode: _fullNameFocusNode,
                                  controller: _fullNameController,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    suffixIcon: Icon(Icons.person, color: Colors.grey),
                                    label: Text(
                                      'Nome Completo',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 203, 6, 45),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              GestureDetector(
                                onTap: () {
                                  FocusScope.of(context).requestFocus(_emailFocusNode);
                                },
                                child: TextField(
                                  focusNode: _emailFocusNode,
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    suffixIcon: Icon(Icons.email, color: Colors.grey),
                                    label: Text(
                                      'Email',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 203, 6, 45),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              TextField(
                                controller: _passwordController,
                                obscureText: true,
                                keyboardType: TextInputType.visiblePassword,
                                decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.visibility_off, color: Colors.grey),
                                  label: Text(
                                    'Senha',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 203, 6, 45),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              TextField(
                                controller: _confirmPasswordController,
                                obscureText: true,
                                keyboardType: TextInputType.visiblePassword,
                                decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.visibility_off, color: Colors.grey),
                                  label: Text(
                                    'Confirme sua Senha',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 203, 6, 45),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 50),
                              GestureDetector(
                                onTap: () => registerUser(context),
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
                                        color: Colors.white,
                                      ),
                                    ),
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
                                          MaterialPageRoute(builder: (context) => LoginScreen()),
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
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
