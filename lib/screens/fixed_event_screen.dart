import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../providers/event_provider.dart';
import '../widgets/app_drawer.dart';

class FixedEventScreen extends ConsumerWidget {
  const FixedEventScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(fixedEventListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('固定事件')),
      drawer: const AppDrawer(currentRoute: '/events'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditDialog(context, ref, null),
        child: const Icon(Icons.add),
      ),
      body: events.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('错误: $e')),
        data: (list) {
          if (list.isEmpty) {
            return const Center(child: Text('还没有固定事件\n点击右下角添加吃饭、睡觉等时段', textAlign: TextAlign.center));
          }
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final e = list[index];
              return ListTile(
                leading: Icon(
                  e.supportsFragmented ? Icons.access_time : Icons.lock_outline,
                  color: e.supportsFragmented ? Colors.orange : null,
                ),
                title: Text(e.name),
                subtitle: Text(
                  '${_fmt(e.startHour, e.startMinute)} - ${_fmt(e.endHour, e.endMinute)}'
                  '${e.supportsFragmented ? '  ·  支持碎片学习' : ''}',
                ),
                onTap: () => _showEditDialog(context, ref, e),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _confirmDelete(context, ref, e),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _fmt(int h, int m) => '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';

  void _confirmDelete(BuildContext context, WidgetRef ref, FixedEvent e) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除「${e.name}」吗？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          FilledButton(
            onPressed: () {
              ref.read(fixedEventActionsProvider).deleteEvent(e.id);
              Navigator.pop(ctx);
            },
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, FixedEvent? existing) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    TimeOfDay start = existing != null
        ? TimeOfDay(hour: existing.startHour, minute: existing.startMinute)
        : const TimeOfDay(hour: 12, minute: 0);
    TimeOfDay end = existing != null
        ? TimeOfDay(hour: existing.endHour, minute: existing.endMinute)
        : const TimeOfDay(hour: 13, minute: 0);
    bool supportsFragmented = existing?.supportsFragmented ?? false;
    final isEdit = existing != null;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(isEdit ? '编辑固定事件' : '添加固定事件'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: '事件名称', hintText: '如：午餐、午休'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('开始: '),
                  TextButton(
                    onPressed: () async {
                      final t = await showTimePicker(context: ctx, initialTime: start);
                      if (t != null) setDialogState(() => start = t);
                    },
                    child: Text(_fmt(start.hour, start.minute)),
                  ),
                  const Text('结束: '),
                  TextButton(
                    onPressed: () async {
                      final t = await showTimePicker(context: ctx, initialTime: end);
                      if (t != null) setDialogState(() => end = t);
                    },
                    child: Text(_fmt(end.hour, end.minute)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('支持碎片化学习'),
                subtitle: const Text('如吃饭时可背单词'),
                value: supportsFragmented,
                onChanged: (v) => setDialogState(() => supportsFragmented = v),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
            FilledButton(
              onPressed: () {
                final name = nameCtrl.text.trim();
                if (name.isEmpty) return;
                final actions = ref.read(fixedEventActionsProvider);
                if (isEdit) {
                  actions.updateEvent(
                    id: existing.id,
                    name: name,
                    startHour: start.hour,
                    startMinute: start.minute,
                    endHour: end.hour,
                    endMinute: end.minute,
                    supportsFragmented: supportsFragmented,
                  );
                } else {
                  actions.addEvent(
                    name: name,
                    startHour: start.hour,
                    startMinute: start.minute,
                    endHour: end.hour,
                    endMinute: end.minute,
                    supportsFragmented: supportsFragmented,
                  );
                }
                Navigator.pop(ctx);
              },
              child: Text(isEdit ? '保存' : '添加'),
            ),
          ],
        ),
      ),
    );
  }
}
