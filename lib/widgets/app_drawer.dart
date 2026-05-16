import 'package:flutter/material.dart';
import '../screens/plan_screen.dart';
import '../screens/subject_list_screen.dart';
import '../screens/fixed_event_screen.dart';
import '../screens/timetable_screen.dart';
import '../screens/progress_screen.dart';
import '../screens/settings_screen.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;

  const AppDrawer({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              '考研日程',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 24,
              ),
            ),
          ),
          _buildItem(context, Icons.auto_awesome, '今日计划', '/plan', const PlanScreen()),
          _buildItem(context, Icons.book, '科目管理', '/subjects', const SubjectListScreen()),
          _buildItem(context, Icons.restaurant, '固定事件', '/events', const FixedEventScreen()),
          _buildItem(context, Icons.schedule, '课表管理', '/timetable', const TimetableScreen()),
          _buildItem(context, Icons.bar_chart, '进度追踪', '/progress', const ProgressScreen()),
          const Divider(),
          _buildItem(context, Icons.settings, '设置', '/settings', const SettingsScreen()),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, IconData icon, String title, String route, Widget page) {
    final isSelected = currentRoute == route;
    return ListTile(
      leading: Icon(icon, color: isSelected ? Theme.of(context).colorScheme.primary : null),
      title: Text(title, style: TextStyle(
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected ? Theme.of(context).colorScheme.primary : null,
      )),
      selected: isSelected,
      onTap: () {
        if (isSelected) {
          Navigator.pop(context);
          return;
        }
        // 移除所有中间路由，直接跳到目标页
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => page),
          (route) => false,
        );
      },
    );
  }
}
