import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: settings.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('错误: $e')),
        data: (s) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionTitle('作息时间'),
            ListTile(
              title: const Text('起床时间'),
              trailing: Text(
                _fmt(s.wakeHour, s.wakeMinute),
                style: const TextStyle(fontSize: 16),
              ),
              onTap: () => _pickTime(context, ref, s.wakeHour, s.wakeMinute, true),
            ),
            ListTile(
              title: const Text('睡觉时间'),
              trailing: Text(
                _fmt(s.sleepHour, s.sleepMinute),
                style: const TextStyle(fontSize: 16),
              ),
              onTap: () => _pickTime(context, ref, s.sleepHour, s.sleepMinute, false),
            ),
            const Divider(),
            _buildSectionTitle('番茄钟'),
            ListTile(
              title: const Text('学习时长'),
              trailing: Text('${s.studyBlockMinutes} 分钟'),
              onTap: () => _pickMinutes(context, ref, s.studyBlockMinutes, true),
            ),
            ListTile(
              title: const Text('休息时长'),
              trailing: Text('${s.restBlockMinutes} 分钟'),
              onTap: () => _pickMinutes(context, ref, s.restBlockMinutes, false),
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(int h, int m) => '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
    );
  }

  void _pickTime(BuildContext context, WidgetRef ref, int hour, int minute, bool isWake) async {
    final t = await showTimePicker(context: context, initialTime: TimeOfDay(hour: hour, minute: minute));
    if (t != null) {
      if (isWake) {
        ref.read(settingsActionsProvider).updateSettings(wakeHour: t.hour, wakeMinute: t.minute);
      } else {
        ref.read(settingsActionsProvider).updateSettings(sleepHour: t.hour, sleepMinute: t.minute);
      }
    }
  }

  void _pickMinutes(BuildContext context, WidgetRef ref, int current, bool isStudy) {
    final options = isStudy ? [30, 40, 45, 50, 60, 90] : [5, 10, 15, 20];
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(isStudy ? '学习时长' : '休息时长'),
        children: options.map((m) => SimpleDialogOption(
          child: Text('$m 分钟', style: TextStyle(fontWeight: m == current ? FontWeight.bold : FontWeight.normal)),
          onPressed: () {
            if (isStudy) {
              ref.read(settingsActionsProvider).updateSettings(studyBlockMinutes: m);
            } else {
              ref.read(settingsActionsProvider).updateSettings(restBlockMinutes: m);
            }
            Navigator.pop(ctx);
          },
        )).toList(),
      ),
    );
  }
}
