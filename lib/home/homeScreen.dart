import 'package:flutter/material.dart';
import 'package:flutter_docig_venda/home/perfilCriente.dart';
import 'package:flutter_docig_venda/home/cliente_model.dart';
import 'package:flutter_docig_venda/home/apiCliente.dart'; // 🔹 Importa a API correta

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Cliente> clientes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    carregarClientes();
  }

  Future<void> carregarClientes() async {
    try {
      List<Cliente> lista = await ClienteService.buscarClientes(); // 🔹 Chama a API correta
      setState(() {
        clientes = lista;
        isLoading = false;
      });
    } catch (e) {
      print("❌ Erro ao buscar clientes: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Clientes")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : clientes.isEmpty
              ? Center(child: Text("Nenhum cliente encontrado."))
              : ListView.builder(
                  itemCount: clientes.length,
                  itemBuilder: (context, index) {
                    return ClientePerfil(cliente: clientes[index]);
                  },
                ),
    );
  }
}
