import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../database/app_database.dart';
import '../main.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('周进度')),
      body: FutureBuilder<List<Subject>>(
        future: db.getAllSubjects(),
        builder: (ctx, subjectSnap) {
          if (!subjectSnap.hasData) return const Center(child: CircularProgressIndicator());
          final subjects = subjectSnap.data!;
          if (subjects.isEmpty) return const Center(child: Text('还没有科目'));

          return FutureBuilder<Map<int, int>>(
            future: _getWeekProgress(db, subjects),
            builder: (ctx, progressSnap) {
              if (!progressSnap.hasData) return const Center(child: CircularProgressIndicator());
              final progress = progressSnap.data!;

              return ListView(
                padding: const EdgeInsets.all(16),
                children: subjects.map((s) {
                  final completed = progress[s.id] ?? 0;
                  final target = s.dailyMinutes * 7; // 周目标
                  final percent = target > 0 ? (completed / target).clamp(0.0, 1.0) : 0.0;
                  final completedHours = completed / 60.0;
                  final targetHours = target / 60.0;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Color(s.color),
                                radius: 8,
                              ),
                              const SizedBox(width: 8),
                              Text(s.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const Spacer(),
                              Text(
                                '${completedHours.toStringAsFixed(1)}h / ${targetHours.toStringAsFixed(1)}h',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          LinearProgressIndicator(
                            value: percent,
                            backgroundColor: Colors.grey.shade200,
                            color: percent >= 0.8 ? Colors.green : percent >= 0.5 ? Colors.orange : Colors.red,
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${(percent * 100).round()}%'
                            '${percent >= 1.0 ? ' - 已完成！' : percent >= 0.8 ? ' - 接近完成' : ' - 还需努力'}',
                            style: TextStyle(
                              color: percent >= 0.8 ? Colors.green : Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }

  Future<Map<int, int>> _getWeekProgress(AppDatabase db, List<Subject> subjects) async {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final result = <int, int>{};

    for (int i = 0; i < 7; i++) {
      final date = monday.add(Duration(days: i));
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      final items = await db.getPlanItemsByDate(dateStr);

      for (final item in items) {
        if (item.subjectId != null && !item.isRest) {
          result[item.subjectId!] = (result[item.subjectId] ?? 0) + item.durationMinutes;
        }
      }
    }

    return result;
  }
}
