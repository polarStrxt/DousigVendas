import 'package:flutter/material.dart';
import 'package:flutter_docig_venda/home/dupricata.dart';
import 'package:flutter_docig_venda/home/botao.dart';
import 'package:flutter_docig_venda/home/produtoScreen.dart';
import 'package:flutter_docig_venda/home/listaDupricata.dart';
import 'package:flutter_docig_venda/home/cliente_model.dart';

class Infocliente extends StatelessWidget {
  final Cliente cliente;

  const Infocliente({Key? key, required this.cliente}) : super(key: key);

  Widget customContainer(String? texto, IconData icone) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icone, color: Colors.blueGrey),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              texto ?? "Não informado",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Informações do Cliente")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customContainer(cliente.nomcli, Icons.person), // ✅ Nome correto
            customContainer(
                cliente.numtel001, Icons.phone), // ✅ Telefone correto
            customContainer(
                cliente.endcli, Icons.location_on), // ✅ Endereço correto
            Row(
              children: [
                Expanded(
                    child: customContainer(
                        cliente.baicli, Icons.location_city)), // ✅ Correto
                const SizedBox(width: 8),
                Expanded(
                    child: customContainer(
                        cliente.muncli, Icons.location_city)), // ✅ Correto
                const SizedBox(width: 8),
                Expanded(
                    child: customContainer(
                        cliente.ufdcli, Icons.flag)), // ✅ Correto
              ],
            ),

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: "Duplicata",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DuplicataScreen(dupricata: listaCnpj[0]),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomButton(
                    text: "Produtos",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProdutoScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
