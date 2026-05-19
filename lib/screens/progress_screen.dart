import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../database/app_database.dart';
import '../main.dart';
import '../widgets/app_drawer.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late DateTime _weekStart; // 当前查看的周的周一
  late DateTime _monthStart; // 当前查看的月 (yyyy-MM-01)

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final now = DateTime.now();
    _weekStart = now.subtract(Duration(days: now.weekday - 1));
    _monthStart = DateTime(now.year, now.month, 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    final now = DateTime.now();
    final todayStr = DateFormat('yyyy-MM-dd').format(now);

    return Scaffold(
      appBar: AppBar(
        title: const Text('进度追踪'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '周进度'),
            Tab(text: '月进度'),
          ],
        ),
      ),
      drawer: const AppDrawer(currentRoute: '/progress'),
      body: FutureBuilder<List<Subject>>(
        future: db.getAllSubjects(),
        builder: (ctx, subjectSnap) {
          if (!subjectSnap.hasData) return const Center(child: CircularProgressIndicator());
          final subjects = subjectSnap.data!;
          if (subjects.isEmpty) return const Center(child: Text('还没有科目，请先添加'));

          return FutureBuilder<_ProgressData>(
            future: _loadAllProgress(db, subjects, todayStr),
            builder: (ctx, dataSnap) {
              if (!dataSnap.hasData) return const Center(child: CircularProgressIndicator());
              final data = dataSnap.data!;

              return Column(
                children: [
                  // 今日摘要
                  _buildTodaySummary(data, subjects),
                  const Divider(height: 1),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildWeekTab(db, subjects, data),
                        _buildMonthTab(db, subjects, data),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTodaySummary(_ProgressData data, List<Subject> subjects) {
    final todayTarget = subjects.fold<int>(0, (s, sub) => s + sub.dailyMinutes);
    final todayPercent = todayTarget > 0 ? (data.todayCompletedMinutes / todayTarget).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Column(
        children: [
          Row(
            children: [
              _buildStatCard('今日已完成', _fmtMinutes(data.todayCompletedMinutes), Colors.green),
              const SizedBox(width: 12),
              _buildStatCard('今日目标', _fmtMinutes(todayTarget), Colors.blue),
              const SizedBox(width: 12),
              _buildStatCard('累计学习', _fmtMinutes(data.cumulativeMinutes), Colors.purple),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: todayPercent,
            backgroundColor: Colors.grey.shade200,
            color: todayPercent >= 0.8 ? Colors.green : todayPercent >= 0.5 ? Colors.orange : Colors.red,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 4),
          Text(
            '今日 ${_fmtMinutes(data.todayCompletedMinutes)} / ${_fmtMinutes(todayTarget)}  '
            '${(todayPercent * 100).round()}%',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            children: [
              Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== 周进度 ====================

  Widget _buildWeekTab(AppDatabase db, List<Subject> subjects, _ProgressData data) {
    final weekEnd = _weekStart.add(const Duration(days: 6));
    final weekLabel = '${DateFormat('MM/dd').format(_weekStart)} - ${DateFormat('MM/dd').format(weekEnd)}';

    return Column(
      children: [
        // 周导航
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => setState(() => _weekStart = _weekStart.subtract(const Duration(days: 7))),
              ),
              Expanded(
                child: Center(
                  child: Text(weekLabel, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => setState(() => _weekStart = _weekStart.add(const Duration(days: 7))),
              ),
              IconButton(
                icon: const Icon(Icons.flag),
                tooltip: '设置周目标',
                onPressed: () => _showGoalDialog(db, 'weekly', DateFormat('yyyy-MM-dd').format(_weekStart)),
              ),
            ],
          ),
        ),
        if (data.weekGoalMinutes != null && data.weekGoalMinutes! > 0)
          _buildGoalSummary(
            data.weekSubjectMinutes.values.fold<int>(0, (a, b) => a + b),
            data.weekGoalMinutes!,
          ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: subjects.map((s) {
              final completed = data.weekSubjectMinutes[s.id] ?? 0;
              final target = s.dailyMinutes * 7;
              final percent = target > 0 ? (completed / target).clamp(0.0, 1.0) : 0.0;

              return _buildSubjectProgress(s, completed, target, percent);
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ==================== 月进度 ====================

  Widget _buildMonthTab(AppDatabase db, List<Subject> subjects, _ProgressData data) {
    final monthLabel = DateFormat('yyyy年MM月').format(_monthStart);
    final daysInMonth = DateTime(_monthStart.year, _monthStart.month + 1, 0).day;

    return Column(
      children: [
        // 月导航
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => setState(() => _monthStart = DateTime(_monthStart.year, _monthStart.month - 1, 1)),
              ),
              Expanded(
                child: Center(
                  child: Text(monthLabel, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => setState(() => _monthStart = DateTime(_monthStart.year, _monthStart.month + 1, 1)),
              ),
              IconButton(
                icon: const Icon(Icons.flag),
                tooltip: '设置月目标',
                onPressed: () => _showGoalDialog(db, 'monthly', DateFormat('yyyy-MM').format(_monthStart)),
              ),
            ],
          ),
        ),
        if (data.monthGoalMinutes != null && data.monthGoalMinutes! > 0)
          _buildGoalSummary(
            data.monthSubjectMinutes.values.fold<int>(0, (a, b) => a + b),
            data.monthGoalMinutes!,
          ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: subjects.map((s) {
              final completed = data.monthSubjectMinutes[s.id] ?? 0;
              final target = s.dailyMinutes * daysInMonth;
              final percent = target > 0 ? (completed / target).clamp(0.0, 1.0) : 0.0;

              return _buildSubjectProgress(s, completed, target, percent);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectProgress(Subject s, int completed, int target, double percent) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(backgroundColor: Color(s.color), radius: 8),
                const SizedBox(width: 8),
                Text(s.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Spacer(),
                Text(
                  '${_fmtMinutes(completed)} / ${_fmtMinutes(target)}',
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
  }

  // ==================== 目标摘要 ====================

  Widget _buildGoalSummary(int completed, int goal) {
    final percent = goal > 0 ? (completed / goal).clamp(0.0, 1.0) : 0.0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.flag, size: 16, color: Colors.orange),
          const SizedBox(width: 8),
          Text(
            '目标: ${_fmtMinutes(completed)} / ${_fmtMinutes(goal)}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: Colors.grey.shade200,
              color: percent >= 0.8 ? Colors.green : percent >= 0.5 ? Colors.orange : Colors.red,
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 8),
          Text('${(percent * 100).round()}%', style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  // ==================== 目标设置对话框 ====================

  void _showGoalDialog(AppDatabase db, String type, String targetDate) async {
    final existing = await db.getGoal(type, targetDate);
    final minutes = existing?.studyMinutes ?? 0;
    final controller = TextEditingController(text: minutes > 0 ? (minutes ~/ 60).toString() : '');

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(type == 'weekly' ? '设置周目标' : '设置月目标'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: '目标学习时长（小时）',
            suffixText: '小时',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          FilledButton(
            onPressed: () async {
              final hours = int.tryParse(controller.text) ?? 0;
              await db.insertOrUpdateGoal(UserGoalsCompanion(
                type: Value(type),
                targetDate: Value(targetDate),
                studyMinutes: Value(hours * 60),
              ));
              if (ctx.mounted) Navigator.pop(ctx);
              setState(() {});
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  // ==================== 数据加载 ====================

  Future<_ProgressData> _loadAllProgress(AppDatabase db, List<Subject> subjects, String todayStr) async {
    final now = DateTime.now();

    // 今日已完成
    final todayItems = await db.getPlanItemsByDate(todayStr);
    final todayCompleted = todayItems
        .where((i) => i.isCompleted && i.subjectId != null && !i.isRest)
        .fold<int>(0, (sum, i) => sum + i.durationMinutes);

    // 累计（最近 90 天）
    final from90 = now.subtract(const Duration(days: 90));
    final from90Str = DateFormat('yyyy-MM-dd').format(from90);
    final cumulative = await db.getCompletedMinutes(from90Str, todayStr);

    // 周进度（聚合查询）
    final weekEnd = _weekStart.add(const Duration(days: 6));
    final weekStartStr = DateFormat('yyyy-MM-dd').format(_weekStart);
    final weekEndStr = DateFormat('yyyy-MM-dd').format(weekEnd);
    final weekSubjectMinutes = await db.getCompletedMinutesBySubject(weekStartStr, weekEndStr);
    final weekGoal = await db.getGoal('weekly', weekStartStr);

    // 月进度（聚合查询）
    final monthEnd = DateTime(_monthStart.year, _monthStart.month + 1, 0);
    final monthStartStr = DateFormat('yyyy-MM-dd').format(_monthStart);
    final monthEndStr = DateFormat('yyyy-MM-dd').format(monthEnd);
    final monthSubjectMinutes = await db.getCompletedMinutesBySubject(monthStartStr, monthEndStr);
    final monthGoal = await db.getGoal('monthly', DateFormat('yyyy-MM').format(_monthStart));

    return _ProgressData(
      todayCompletedMinutes: todayCompleted,
      cumulativeMinutes: cumulative,
      weekSubjectMinutes: weekSubjectMinutes,
      weekGoalMinutes: weekGoal?.studyMinutes,
      monthSubjectMinutes: monthSubjectMinutes,
      monthGoalMinutes: monthGoal?.studyMinutes,
    );
  }

  String _fmtMinutes(int minutes) {
    if (minutes < 60) return '$minutes分钟';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m > 0 ? '${h}h${m}m' : '${h}h';
  }
}

class _ProgressData {
  final int todayCompletedMinutes;
  final int cumulativeMinutes;
  final Map<int, int> weekSubjectMinutes;
  final int? weekGoalMinutes;
  final Map<int, int> monthSubjectMinutes;
  final int? monthGoalMinutes;

  _ProgressData({
    required this.todayCompletedMinutes,
    required this.cumulativeMinutes,
    required this.weekSubjectMinutes,
    this.weekGoalMinutes,
    required this.monthSubjectMinutes,
    this.monthGoalMinutes,
  });
}
