import 'package:flutter_docig_venda/home/produto_model.dart';

class Carrinho {
  final Map<Produto, int> _itens = {}; // Produto -> Quantidade
  final Map<Produto, double> _descontos = {}; // Produto -> Desconto %

  void adicionarProduto(Produto produto, {int quantidade = 1, double desconto = 0.0}) {
    if (_itens.containsKey(produto)) {
      _itens[produto] = _itens[produto]! + quantidade;
    } else {
      _itens[produto] = quantidade;
    }
    _descontos[produto] = desconto; // 🔹 Sempre salvar o desconto corretamente
  }

  void removerProduto(Produto produto) {
    _itens.remove(produto);
    _descontos.remove(produto);
  }

  void aplicarDesconto(Produto produto, double desconto) {
    if (_itens.containsKey(produto)) {
      _descontos[produto] = desconto;
    }
  }

  double get totalSemDesconto {
    return _itens.entries.fold(0, (total, item) {
      return total + (item.key.vlrbasvda * item.value);
    });
  }

  double get totalComDesconto {
    return _itens.entries.fold(0, (total, item) {
      double desconto = _descontos[item.key] ?? 0.0;
      double precoComDesconto = item.key.vlrbasvda * (1 - desconto / 100);
      return total + (precoComDesconto * item.value);
    });
  }

  Map<Produto, int> get itens => _itens;
  Map<Produto, double> get descontos => _descontos;
}
