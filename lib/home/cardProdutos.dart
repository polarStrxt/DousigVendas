import 'package:flutter/material.dart';
import 'package:flutter_docig_venda/home/carrinho.dart';
import 'package:flutter_docig_venda/home/produto_model.dart'; // 🔹 Importa o modelo correto


class ProdutoDetalhe extends StatefulWidget {
  final Produto produto;
  final Carrinho carrinho;
  final VoidCallback? onAddToCart;

  const ProdutoDetalhe({
    Key? key, 
    required this.produto, 
    required this.carrinho,
    this.onAddToCart,
  }) : super(key: key);

  @override
  _ProdutoDetalheState createState() => _ProdutoDetalheState();
}

class _ProdutoDetalheState extends State<ProdutoDetalhe> {
  TextEditingController quantidadeController = TextEditingController(text: "1");
  TextEditingController descontoController = TextEditingController(text: "0");

  double calcularTotal() {
    int quantidade = int.tryParse(quantidadeController.text) ?? 1;
    double desconto = double.tryParse(descontoController.text) ?? 0;
    desconto = desconto.clamp(0, 100); // 🔹 Mantém desconto entre 0% e 100%
    
    double totalSemDesconto = widget.produto.vlrbasvda * quantidade;
    double totalComDesconto = totalSemDesconto * (1 - (desconto / 100));
    return totalComDesconto;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: const [
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
          Text(widget.produto.dcrprd, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text("Código: ${widget.produto.codprd}", style: const TextStyle(fontSize: 14, color: Colors.grey)),
          Text("Marca: ${widget.produto.nommrc}", style: const TextStyle(fontSize: 14)),
          Text("Preço base: R\$ ${widget.produto.vlrbasvda.toStringAsFixed(2)}", 
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Quantidade:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(
                width: 80,
                child: TextField(
                  controller: quantidadeController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  ),
                  onChanged: (value) => setState(() {}),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Desconto (%):", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(
                width: 80,
                child: TextField(
                  controller: descontoController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  ),
                  onChanged: (value) => setState(() {}),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Total sem desconto: R\$ ${(widget.produto.vlrbasvda * (int.tryParse(quantidadeController.text) ?? 1)).toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text("Total com desconto: R\$ ${calcularTotal().toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
            ],
          ),

          const SizedBox(height: 8),

          ElevatedButton(
            onPressed: () {
              int quantidade = int.tryParse(quantidadeController.text) ?? 1;
              double desconto = double.tryParse(descontoController.text) ?? 0;
              desconto = desconto.clamp(0, 100); // 🔹 Garante que esteja entre 0% e 100%

              if (quantidade < 1) quantidade = 1;

              widget.carrinho.adicionarProduto(widget.produto, quantidade: quantidade, desconto: desconto);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${widget.produto.dcrprd} adicionado ao carrinho!"),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'Ver Carrinho',
                    onPressed: () {
                      Navigator.pushNamed(context, '/carrinho');
                    },
                  ),
                ),
              );

              // Chama o callback para atualizar a UI da tela principal (contador do carrinho)
              if (widget.onAddToCart != null) {
                widget.onAddToCart!();
              }

              setState(() {}); // 🔹 Atualiza a tela para refletir o desconto
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart, color: Colors.white),
                SizedBox(width: 8),
                Text("Adicionar ao Carrinho", style: TextStyle(fontSize: 16, color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}