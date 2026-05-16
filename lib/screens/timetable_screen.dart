import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/timetable_provider.dart';
import '../widgets/app_drawer.dart';

class TimetableScreen extends ConsumerWidget {
  const TimetableScreen({super.key});

  static const _dayNames = ['', '周一', '周二', '周三', '周四', '周五', '周六', '周日'];
  static const _weekTypeNames = {'all': '全周', 'odd': '单周', 'even': '双周'};

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(timetableListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('课表管理')),
      drawer: const AppDrawer(currentRoute: '/timetable'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
      body: events.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('错误: $e')),
        data: (list) {
          if (list.isEmpty) {
            return const Center(child: Text('还没有课程\n点击右下角添加', textAlign: TextAlign.center));
          }
          // 按星期分组
          final grouped = <int, List<dynamic>>{};
          for (final e in list) {
            grouped.putIfAbsent(e.dayOfWeek, () => []).add(e);
          }
          return ListView(
            children: List.generate(7, (i) {
              final day = i + 1;
              final dayEvents = grouped[day] ?? [];
              if (dayEvents.isEmpty) return const SizedBox.shrink();
              return ExpansionTile(
                title: Text(_dayNames[day], style: const TextStyle(fontWeight: FontWeight.bold)),
                initiallyExpanded: true,
                children: dayEvents.map((e) => ListTile(
                  leading: const Icon(Icons.class_),
                  title: Text(e.courseName),
                  subtitle: Text(
                    '${_fmt(e.startHour, e.startMinute)}-${_fmt(e.endHour, e.endMinute)} '
                    '${_weekTypeNames[e.weekType] ?? ''} '
                    '第${e.startWeek}-${e.endWeek}周',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => ref.read(timetableActionsProvider).deleteEvent(e.id),
                  ),
                )).toList(),
              );
            }),
          );
        },
      ),
    );
  }

  String _fmt(int h, int m) => '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    int dayOfWeek = 1;
    TimeOfDay start = const TimeOfDay(hour: 8, minute: 0);
    TimeOfDay end = const TimeOfDay(hour: 9, minute: 40);
    String weekType = 'all';
    int startWeek = 1;
    int endWeek = 20;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('添加课程'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: '课程名称'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  value: dayOfWeek,
                  decoration: const InputDecoration(labelText: '星期'),
                  items: List.generate(7, (i) => DropdownMenuItem(
                    value: i + 1,
                    child: Text(_dayNames[i + 1]),
                  )),
                  onChanged: (v) => setDialogState(() => dayOfWeek = v!),
                ),
                const SizedBox(height: 12),
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
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: weekType,
                  decoration: const InputDecoration(labelText: '重复'),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('全周')),
                    DropdownMenuItem(value: 'odd', child: Text('单周')),
                    DropdownMenuItem(value: 'even', child: Text('双周')),
                  ],
                  onChanged: (v) => setDialogState(() => weekType = v!),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: '$startWeek',
                        decoration: const InputDecoration(labelText: '起始周'),
                        keyboardType: TextInputType.number,
                        onChanged: (v) => startWeek = int.tryParse(v) ?? 1,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        initialValue: '$endWeek',
                        decoration: const InputDecoration(labelText: '结束周'),
                        keyboardType: TextInputType.number,
                        onChanged: (v) => endWeek = int.tryParse(v) ?? 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
            FilledButton(
              onPressed: () {
                final name = nameCtrl.text.trim();
                if (name.isEmpty) return;
                ref.read(timetableActionsProvider).addEvent(
                  courseName: name,
                  dayOfWeek: dayOfWeek,
                  startHour: start.hour,
                  startMinute: start.minute,
                  endHour: end.hour,
                  endMinute: end.minute,
                  weekType: weekType,
                  startWeek: startWeek,
                  endWeek: endWeek,
                );
                Navigator.pop(ctx);
              },
              child: const Text('添加'),
            ),
          ],
        ),
      ),
    );
  }
}
