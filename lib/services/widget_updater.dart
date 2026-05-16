import 'dart:convert';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import '../database/app_database.dart';

class WidgetUpdater {
  /// 更新桌面小组件数据
  static Future<void> updateWidget(AppDatabase db) async {
    final now = DateTime.now();
    final todayStr = DateFormat('yyyy-MM-dd').format(now);
    final nowMinutes = now.hour * 60 + now.minute;

    // 获取今日计划项
    final items = await db.getPlanItemsByDate(todayStr);

    // 获取科目信息
    final subjects = await db.getAllSubjects();
    final subjectMap = {for (final s in subjects) s.id: s};

    // 计算今日完成进度
    final completedItems = items.where((i) => i.isCompleted && i.subjectId != null && !i.isRest);
    final completedMinutes = completedItems.fold<int>(0, (sum, i) => sum + i.durationMinutes);
    final targetMinutes = subjects.fold<int>(0, (sum, s) => s.dailyMinutes + sum);

    // 构建所有计划项列表（排除休息）
    final planItems = <Map<String, dynamic>>[];
    for (final item in items) {
      if (item.isRest) continue;
      final sh = item.startMinutes ~/ 60;
      final sm = item.startMinutes % 60;
      final em = item.startMinutes + item.durationMinutes;
      final eh = em ~/ 60;
      final esm = em % 60;
      final timeStr = '${_pad(sh)}:${_pad(sm)}-${_pad(eh)}:${_pad(esm)}';

      String name;
      if (item.subjectId != null) {
        name = subjectMap[item.subjectId]?.name ?? '学习';
      } else {
        name = item.customName ?? '学习';
      }

      final isActive = item.startMinutes <= nowMinutes && nowMinutes < item.startMinutes + item.durationMinutes;

      planItems.add({
        'time': timeStr,
        'name': name,
        'done': item.isCompleted,
        'active': isActive,
        'start': item.startMinutes,
      });
    }

    // 写入基础数据
    await HomeWidget.saveWidgetData<String>('date', DateFormat('MM月dd日 EEEE', 'zh_CN').format(now));
    await HomeWidget.saveWidgetData<int>('completedMinutes', completedMinutes);
    await HomeWidget.saveWidgetData<int>('targetMinutes', targetMinutes);
    await HomeWidget.saveWidgetData<int>('itemCount', planItems.length);

    // 写入所有计划项 JSON
    await HomeWidget.saveWidgetData<String>('items', jsonEncode(planItems));

    // 触发 Android 端更新
    await HomeWidget.updateWidget(
      name: 'HomeWidgetProvider',
      iOSName: 'HomeWidgetProvider',
    );
  }

  static String _pad(int n) => n.toString().padLeft(2, '0');
}
