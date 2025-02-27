import 'package:flutter/material.dart';
import 'package:flutter_docig_venda/home/infoCliente.dart';
import 'package:flutter_docig_venda/home/cliente_model.dart'; // 🔹 Importa o modelo correto

class ClientePerfil extends StatelessWidget {
  final Cliente cliente; // ✅ Agora recebe um objeto Cliente

  const ClientePerfil({Key? key, required this.cliente}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // 🔹 Garantindo que os campos não sejam nulos
    String nome = cliente.nomcli.isNotEmpty ? cliente.nomcli : "Nome não disponível";
    String telefone = cliente.numtel001.isNotEmpty ? cliente.numtel001 : "Sem telefone";
    String endereco = cliente.endcli.isNotEmpty ? cliente.endcli : "Endereço não informado";

    // 🔹 Exibir os valores no console para debug
    print("📌 Cliente: Nome: $nome | Telefone: $telefone | Endereço: $endereco");

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Infocliente(cliente: cliente), // ✅ Passa o cliente inteiro
            ),
          );
        },
        child: Container(
          width: screenWidth * 0.9,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Nome e Telefone
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      nome, // ✅ Nome do cliente
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    telefone, // ✅ Telefone do cliente
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                  ),
                ],
              ),

              SizedBox(height: 8),

              // 🔹 Endereço formatado corretamente
              Text(
                endereco,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
