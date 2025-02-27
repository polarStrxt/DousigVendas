import 'dart:io';
import 'package:flutter_docig_venda/home/produto_model.dart'; // ✅ Agora usa ProdutoModel correto
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';


class PdfGenerator {
  static Future<String?> gerarPdf(Map<Produto, int> itens, Map<Produto, double> descontos) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Recibo de Compra", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),

              // 🔹 Tabela de produtos
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: pw.FlexColumnWidth(3),
                  1: pw.FlexColumnWidth(1),
                  2: pw.FlexColumnWidth(2),
                  3: pw.FlexColumnWidth(2),
                },
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text("Produto", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                      pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text("Qtd", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                      pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text("Preço Un.", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                      pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text("Total", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                    ],
                  ),
                  ...itens.entries.map((entry) {
                    final produto = entry.key;
                    final quantidade = entry.value;
                    final desconto = descontos[produto] ?? 0.0;
                    final precoComDesconto = produto.vlrbasvda * (1 - desconto / 100);
                    final total = precoComDesconto * quantidade;

                    return pw.TableRow(
                      children: [
                        pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text(produto.dcrprd)),
                        pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text(quantidade.toString())),
                        pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text("R\$ ${produto.vlrbasvda.toStringAsFixed(2)}")),
                        pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text("R\$ ${total.toStringAsFixed(2)}")),
                      ],
                    );
                  }).toList(),
                ],
              ),

              pw.SizedBox(height: 20),

              // 🔹 Totais
              pw.Text("Total sem desconto: R\$ ${itens.entries.fold(0.0, (sum, entry) => sum + (entry.key.vlrbasvda * entry.value)).toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 16)),
              pw.Text("Total com desconto: R\$ ${itens.entries.fold(0.0, (sum, entry) {
                    final desconto = descontos[entry.key] ?? 0.0;
                    final precoComDesconto = entry.key.vlrbasvda * (1 - desconto / 100);
                    return sum + (precoComDesconto * entry.value);
                  }).toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            ],
          );
        },
      ),
    );

    try {
      // 🔹 SOLICITANDO PERMISSÃO PARA ESCRITA NO ARMAZENAMENTO
      if (Platform.isAndroid) {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.storage,
          Permission.manageExternalStorage, // Necessário no Android 11+
        ].request();

        if (!statuses[Permission.storage]!.isGranted) {
          print("❌ Permissão de armazenamento foi negada!");
          return null;
        }
        if (Platform.version.compareTo("30") >= 0 && !statuses[Permission.manageExternalStorage]!.isGranted) {
          print("❌ Permissão de gerenciamento de armazenamento foi negada!");
          return null;
        }
      }

      // 🔹 Obtendo diretório correto
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory("/storage/emulated/0/Documents"); // Padrão Android
      } else if (Platform.isIOS) {
        directory = Directory((await getApplicationDocumentsDirectory()).path); // Padrão iOS
      }

      if (!await directory!.exists()) {
        await directory.create(recursive: true);
      }

      final file = File("${directory.path}/recibo_compra.pdf");
      await file.writeAsBytes(await pdf.save());

      print("✅ PDF gerado e salvo em: ${file.path}");
      return file.path;
    } catch (e) {
      print("❌ Erro ao salvar o PDF: $e");
      return null;
    }
  }
}
