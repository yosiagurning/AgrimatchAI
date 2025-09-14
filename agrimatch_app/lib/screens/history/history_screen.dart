import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/history_provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<HistoryProvider>().fetchHistory());
  }

  @override
  Widget build(BuildContext context) {
    final history = context.watch<HistoryProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Analisis')),
      body: history.loading
          ? const Center(child: CircularProgressIndicator())
          : history.histories.isEmpty
              ? const Center(child: Text('Belum ada riwayat'))
              : ListView.builder(
                  itemCount: history.histories.length,
                  itemBuilder: (ctx, i) {
                    final h = history.histories[i];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: h.imageUrl.isNotEmpty
                            ? Image.network(
                                h.imageUrl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.landscape),
                        title: Text(h.landName),
                        subtitle: Text(
                            "${h.predictedSoilType} → ${h.recommendedCrop}\nSkor: ${h.recommendationScore}"),
                        trailing: Text(
                          "${h.createdAt.day}/${h.createdAt.month}/${h.createdAt.year}",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
