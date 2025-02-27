import 'package:flutter/material.dart';
import 'package:flutter_docig_venda/login/acesso.dart';
import 'package:flutter_docig_venda/login/textField.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView( // 🔹 Permite rolagem quando necessário
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 250,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Entrar',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Leia(
                texto: 'Digite seu usuário',
                icone: Icons.email,
                dados: usuarioController,
              ),
              Leia(
                texto: 'Digite sua senha',
                icone: Icons.lock,
                dados: senhaController,
                isPassword: true, // 🔹 Agora a senha fica oculta
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String usuario = usuarioController.text;
                  String senha = senhaController.text;
                  FuncVerificacao(context, usuario, senha);
                  print('Acessar pressionado!');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 120),
                ),
                child: Text(
                  'Acessar',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
