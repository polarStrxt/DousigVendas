import 'package:flutter/material.dart';
import 'package:flutter_docig_venda/home/carrinhoWidget.dart';
import 'package:flutter_docig_venda/home/pdfGenerator.dart';

class CarrinhoScreen extends StatefulWidget {
  final CarrinhoWidget carrinho;

  const CarrinhoScreen({Key? key, required this.carrinho}) : super(key: key);

  @override
  _CarrinhoScreenState createState() => _CarrinhoScreenState();
}

class _CarrinhoScreenState extends State<CarrinhoScreen> {
  @override
  Widget build(BuildContext context) {
    double totalSemDesconto = widget.carrinho.itens.entries.fold(
      0,
      (total, item) => total + (item.key.vlrbasvda * item.value),
    );

    double totalComDesconto = widget.carrinho.itens.entries.fold(0, (total, item) {
      double desconto = widget.carrinho.descontos[item.key] ?? 0.0;
      double precoComDesconto = item.key.vlrbasvda * (1 - desconto / 100);
      return total + (precoComDesconto * item.value);
    });

    return Scaffold(
      appBar: AppBar(title: Text("Carrinho de Compras")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(child: widget.carrinho), // Exibe o CarrinhoWidget diretamente

            // 🔹 Exibição dos Totais (Sem ValueNotifier)
            Text(
              "Total sem desconto: R\$ ${totalSemDesconto.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              "Total com descontos: R\$ ${totalComDesconto.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
            ),

            SizedBox(height: 20),

            // 🔹 Botão para gerar PDF
            ElevatedButton(
              onPressed: () async {
                await PdfGenerator.gerarPdf(widget.carrinho.itens, widget.carrinho.descontos);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("✅ PDF gerado com sucesso!")),
                );
              },
              child: Text("Finalizar Compra e Gerar PDF"),
            ),
          ],
        ),
      ),
    );
  }
}
