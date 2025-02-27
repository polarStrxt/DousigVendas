import 'package:flutter/material.dart';
import 'package:flutter_docig_venda/home/produto_model.dart'; // ✅ Corrigida a importação

class CarrinhoWidget extends StatefulWidget {
  final Map<Produto, int> itens;
  final Map<Produto, double> descontos;

  CarrinhoWidget({Key? key, required this.itens, required this.descontos}) : super(key: key);

  @override
  _CarrinhoWidgetState createState() => _CarrinhoWidgetState();
}

class _CarrinhoWidgetState extends State<CarrinhoWidget> {
  double totalSemDesconto = 0;
  double totalComDesconto = 0;

  @override
  void initState() {
    super.initState();
    _atualizarTotais();
  }

  void _atualizarTotais() {
    double totalSemDesc = 0;
    double totalComDesc = 0;

    widget.itens.forEach((produto, quantidade) {
      double valorTotal = produto.vlrbasvda * quantidade; // ✅ Corrigido para `vlrbasvda`
      double desconto = widget.descontos[produto] ?? 0.0;
      double valorComDesconto = valorTotal * (1 - desconto / 100);

      totalSemDesc += valorTotal;
      totalComDesc += valorComDesconto;
    });

    setState(() {
      totalSemDesconto = totalSemDesc;
      totalComDesconto = totalComDesc;
    });
  }

  void removerItem(Produto produto) {
    setState(() {
      widget.itens.remove(produto);
      widget.descontos.remove(produto);
      _atualizarTotais();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: widget.itens.isEmpty
              ? Center(child: Text("Carrinho vazio"))
              : ListView.builder(
                  itemCount: widget.itens.length,
                  itemBuilder: (context, index) {
                    Produto produto = widget.itens.keys.elementAt(index);
                    int quantidade = widget.itens[produto]!;
                    double desconto = widget.descontos[produto] ?? 0.0;
                    double totalProdutoSemDesc = produto.vlrbasvda * quantidade;
                    double totalProdutoComDesc = totalProdutoSemDesc * (1 - desconto / 100);

                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(produto.dcrprd, // ✅ Corrigido para `dcrprd`
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  Text("Código: ${produto.codprd}", style: TextStyle(color: Colors.grey)),
                                  Text("Quantidade: $quantidade"),
                                  Text(
                                    "Total sem desconto: R\$ ${totalProdutoSemDesc.toStringAsFixed(2)}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.red,
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                  Text(
                                    "Total com desconto: R\$ ${totalProdutoComDesc.toStringAsFixed(2)}",
                                    style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => removerItem(produto),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),

        // 🔹 Exibe os totais atualizados
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                "Total sem desconto: R\$ ${totalSemDesconto.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "Total com desconto: R\$ ${totalComDesconto.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
