import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/subject_provider.dart';
import 'subject_edit_screen.dart';

class SubjectListScreen extends ConsumerWidget {
  const SubjectListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjects = ref.watch(subjectListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('科目管理')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToEdit(context, null),
        child: const Icon(Icons.add),
      ),
      body: subjects.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('错误: $e')),
        data: (list) {
          if (list.isEmpty) {
            return const Center(
              child: Text('还没有科目，点击右下角添加', style: TextStyle(fontSize: 16, color: Colors.grey)),
            );
          }
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final s = list[index];
              final hours = s.dailyMinutes ~/ 60;
              final mins = s.dailyMinutes % 60;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(s.color),
                  child: Text('${s.priority}★', style: const TextStyle(color: Colors.white, fontSize: 12)),
                ),
                title: Text(s.name),
                subtitle: Text('每天 ${hours}h${mins > 0 ? '${mins}m' : ''}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _confirmDelete(context, ref, s.id, s.name),
                ),
                onTap: () => _navigateToEdit(context, s),
              );
            },
          );
        },
      ),
    );
  }

  void _navigateToEdit(BuildContext context, dynamic subject) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SubjectEditScreen(subject: subject)),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, int id, String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除科目'),
        content: Text('确定要删除"$name"吗？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          TextButton(
            onPressed: () {
              ref.read(subjectActionsProvider).deleteSubject(id);
              Navigator.pop(ctx);
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
