import 'package:flutter/material.dart';
import 'subject_list_screen.dart';
import 'fixed_event_screen.dart';
import 'timetable_screen.dart';
import 'settings_screen.dart';
import 'plan_screen.dart';
import 'progress_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('考研日程'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(
            context,
            icon: Icons.book,
            title: '科目管理',
            subtitle: '添加/编辑考研科目和学习时长',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SubjectListScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _buildCard(
            context,
            icon: Icons.restaurant,
            title: '固定事件',
            subtitle: '设置吃饭、睡觉、运动时间',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FixedEventScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _buildCard(
            context,
            icon: Icons.schedule,
            title: '课表管理',
            subtitle: '添加课程表',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TimetableScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _buildCard(
            context,
            icon: Icons.auto_awesome,
            title: '今日计划',
            subtitle: '查看自动生成的学习计划',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PlanScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _buildCard(
            context,
            icon: Icons.bar_chart,
            title: '进度追踪',
            subtitle: '查看本周各科完成进度',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProgressScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: onTap,
      ),
    );
  }
}
