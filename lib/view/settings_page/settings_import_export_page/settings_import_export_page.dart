import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsImportExportPage extends ConsumerWidget {
  const SettingsImportExportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("設定のインポート・エクスポート"),
      ),
      body: Column(
        children: [
          const Text(
              "Miriaの設定情報をサーバーのドライブ上に保存したり、保存した設定情報を読み込むことができます。\nエクスポートする前にはバックアップを保存しておくことをおすすめします。"),
          Text(
            "インポート",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Text("保存した設定ファイルを読み込みます。"),
          Text(
            "エクスポート",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Text("設定ファイルを保存します。"),
        ],
      ),
    );
  }
}
