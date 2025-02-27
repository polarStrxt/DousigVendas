import 'package:flutter/material.dart';
import 'package:flutter_docig_venda/home/produto_model.dart'; // ✅ Modelo correto
import 'package:flutter_docig_venda/home/apiProduto.dart'; // ✅ API correta
import 'package:flutter_docig_venda/home/cardProdutos.dart'; // ✅ Componente de produto
import 'package:flutter_docig_venda/home/carrinho.dart';
import 'package:flutter_docig_venda/home/carrinhoScreen.dart';
import 'package:flutter_docig_venda/home/carrinhoWidget.dart';

class ProdutoScreen extends StatefulWidget {
  @override
  _ProdutoScreenState createState() => _ProdutoScreenState();
}

class _ProdutoScreenState extends State<ProdutoScreen> {
  TextEditingController searchController = TextEditingController();
  List<Produto> produtos = []; // ✅ Lista de produtos carregados da API
  List<Produto> produtosFiltrados = [];
  final Carrinho carrinho = Carrinho(); // ✅ Criando o carrinho
  bool isLoading = true; // ✅ Controle de carregamento
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    carregarProdutos(); // ✅ Busca os produtos da API ao iniciar a tela
  }

  // 🔹 Corrigindo chamada da API para buscar produtos corretamente
  Future<void> carregarProdutos() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    
    try {
      List<Produto> lista = await ProdutoService.buscarProdutos(); // ✅ Usando método correto
      setState(() {
        produtos = lista;
        produtosFiltrados = lista; // ✅ Inicializa os filtrados com todos os produtos
        isLoading = false;
      });
    } catch (e) {
      print("❌ Erro ao buscar produtos: $e");
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
      
      // Mostrar diálogo de erro
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erro ao carregar produtos'),
          content: Text('Não foi possível carregar os produtos. Verifique sua conexão e tente novamente.\n\nDetalhes: ${e.toString()}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                carregarProdutos(); // Tenta carregar novamente
              },
              child: Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }
  }

  void filtrarProdutos(String query) {
    setState(() {
      produtosFiltrados = produtos.where((produto) {
        return produto.dcrprd.toLowerCase().contains(query.toLowerCase()); // ✅ Usa `dcrprd`
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Docig Venda"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: filtrarProdutos,
              decoration: InputDecoration(
                hintText: "Pesquisar produto...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // ✅ Mostra carregamento
          : errorMessage != null 
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Erro ao carregar produtos",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          errorMessage!,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: carregarProdutos,
                        icon: Icon(Icons.refresh),
                        label: Text("Tentar novamente"),
                      ),
                    ],
                  ),
                )
              : produtosFiltrados.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Nenhum produto encontrado",
                            style: TextStyle(fontSize: 18),
                          ),
                          if (searchController.text.isNotEmpty)
                            TextButton(
                              onPressed: () {
                                searchController.clear();
                                setState(() {
                                  produtosFiltrados = produtos;
                                });
                              },
                              child: Text("Limpar pesquisa"),
                            ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: produtosFiltrados.length,
                      itemBuilder: (context, index) {
                        Produto produto = produtosFiltrados[index];
                        return ProdutoDetalhe(
                          produto: produto,
                          carrinho: carrinho, // ✅ Passando o carrinho corretamente
                          onAddToCart: () {
                            setState(() {}); // Atualiza a UI quando adicionar ao carrinho
                          },
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // ✅ Criando o CarrinhoWidget corretamente
          final CarrinhoWidget carrinhoWidget = CarrinhoWidget(
            itens: carrinho.itens, // ✅ Passando Map<Produto, int>
            descontos: carrinho.descontos, // ✅ Passando Map<Produto, double>
          );

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CarrinhoScreen(carrinho: carrinhoWidget)),
          ).then((_) {
            // Atualiza a UI quando retornar do carrinho
            setState(() {});
          });
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.shopping_cart),
            if (carrinho.itens.isNotEmpty)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: Text(
                    '${carrinho.itens.length}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}