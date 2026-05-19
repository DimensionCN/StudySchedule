import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../database/app_database.dart';
import '../main.dart';
import '../providers/plan_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/week_calendar_bar.dart';
import '../widgets/day_timeline.dart';
import '../widgets/app_drawer.dart';
import '../services/widget_updater.dart';
import 'plan_edit_screen.dart';

/// 预设的自定义活动
const _presetActivities = ['休闲娱乐', '作业', '运动锻炼', '社团活动', '其他'];

class PlanScreen extends ConsumerWidget {
  const PlanScreen({super.key});

  void _showFreeTimeDialog(
    BuildContext context,
    WidgetRef ref,
    FreeTimeSlot slot,
    List<Subject> allSubjects,
  ) {
    int? selectedSubjectId;
    String? selectedCustomName;
    bool isSubjectMode = true;
    int durationMinutes = slot.duration;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              title: Text('空闲时间 ${slot.duration}分钟'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${slot.start ~/ 60}:${(slot.start % 60).toString().padLeft(2, '0')}'
                      ' - ${slot.end ~/ 60}:${(slot.end % 60).toString().padLeft(2, '0')}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(value: true, label: Text('学习科目')),
                        ButtonSegment(value: false, label: Text('其他活动')),
                      ],
                      selected: {isSubjectMode},
                      onSelectionChanged: (v) => setDialogState(() {
                        isSubjectMode = v.first;
                      }),
                    ),
                    const SizedBox(height: 16),
                    if (isSubjectMode) ...[
                      const Text('选择科目:'),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: allSubjects.map((s) {
                          final selected = s.id == selectedSubjectId;
                          return ChoiceChip(
                            label: Text(s.name),
                            selected: selected,
                            onSelected: (_) => setDialogState(() => selectedSubjectId = s.id),
                          );
                        }).toList(),
                      ),
                    ] else ...[
                      const Text('选择活动:'),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: _presetActivities.map((name) {
                          final selected = name == selectedCustomName;
                          return ChoiceChip(
                            label: Text(name),
                            selected: selected,
                            onSelected: (_) => setDialogState(() => selectedCustomName = name),
                          );
                        }).toList(),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Text('时长: $durationMinutes 分钟'),
                    Slider(
                      value: durationMinutes.toDouble(),
                      min: 5,
                      max: slot.duration.toDouble(),
                      divisions: (slot.duration - 5) ~/ 5,
                      label: '$durationMinutes分钟',
                      onChanged: (v) => setDialogState(() => durationMinutes = v.round()),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('取消'),
                ),
                FilledButton(
                  onPressed: () async {
                    if (isSubjectMode && selectedSubjectId == null) return;
                    if (!isSubjectMode && selectedCustomName == null) return;

                    final db = ref.read(databaseProvider);
                    final dateStr = DateFormat('yyyy-MM-dd')
                        .format(ref.read(selectedDateProvider));
                    final existing = await db.getPlanItemsByDate(dateStr);
                    final maxOrder = existing.isEmpty
                        ? 0
                        : existing.map((i) => i.orderIndex).reduce((a, b) => a > b ? a : b) + 1;
                    await db.insertPlanItem(PlanItemsCompanion.insert(
                      date: dateStr,
                      subjectId: Value(isSubjectMode ? selectedSubjectId : null),
                      customName: Value(isSubjectMode ? null : selectedCustomName),
                      startMinutes: slot.start,
                      durationMinutes: durationMinutes,
                      isRest: const Value(false),
                      isManual: const Value(true),
                      orderIndex: maxOrder,
                    ));
                    ref.invalidate(planItemsProvider);
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                  child: const Text('添加'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddFragmentedStudyDialog(
    BuildContext context,
    WidgetRef ref,
    FixedEvent event,
    List<Subject> allSubjects,
  ) {
    final fragmentedSubjects = allSubjects.where((s) => s.isFragmented).toList();
    if (fragmentedSubjects.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('没有碎片化科目，请先在科目管理中添加')),
      );
      return;
    }

    final eventStart = event.startHour * 60 + event.startMinute;
    final eventEnd = event.endHour * 60 + event.endMinute;
    final eventDuration = eventEnd - eventStart;

    Subject? selectedSubject = fragmentedSubjects.first;
    int durationMinutes = (eventDuration * 0.5).round().clamp(5, eventDuration);

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              title: Text('${event.name} - 碎片学习'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '时间段: ${event.startHour.toString().padLeft(2, '0')}:${event.startMinute.toString().padLeft(2, '0')}'
                    ' - ${event.endHour.toString().padLeft(2, '0')}:${event.endMinute.toString().padLeft(2, '0')}'
                    ' ($eventDuration分钟)',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  const Text('选择科目:'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: fragmentedSubjects.map((s) {
                      final selected = s.id == selectedSubject?.id;
                      return ChoiceChip(
                        label: Text(s.name),
                        selected: selected,
                        onSelected: (_) => setDialogState(() => selectedSubject = s),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Text('学习时长: $durationMinutes 分钟'),
                  Slider(
                    value: durationMinutes.toDouble(),
                    min: 5,
                    max: eventDuration.toDouble(),
                    divisions: (eventDuration - 5) ~/ 5,
                    label: '$durationMinutes分钟',
                    onChanged: (v) => setDialogState(() => durationMinutes = v.round()),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('取消'),
                ),
                FilledButton(
                  onPressed: () async {
                    if (selectedSubject == null) return;
                    final db = ref.read(databaseProvider);
                    final dateStr = DateFormat('yyyy-MM-dd')
                        .format(ref.read(selectedDateProvider));
                    final existing = await db.getPlanItemsByDate(dateStr);
                    final maxOrder = existing.isEmpty
                        ? 0
                        : existing.map((i) => i.orderIndex).reduce((a, b) => a > b ? a : b) + 1;
                    await db.insertPlanItem(PlanItemsCompanion.insert(
                      date: dateStr,
                      subjectId: Value(selectedSubject!.id),
                      customName: const Value(null),
                      startMinutes: eventStart,
                      durationMinutes: durationMinutes,
                      isRest: const Value(false),
                      isManual: const Value(true),
                      orderIndex: maxOrder,
                    ));
                    ref.invalidate(planItemsProvider);
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                  child: const Text('添加'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final planItems = ref.watch(planItemsProvider);
    final settings = ref.watch(settingsProvider);
    final screenData = ref.watch(planScreenDataProvider);
    final db = ref.watch(databaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat('MM月dd日 EEEE', 'zh_CN').format(selectedDate)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: '生成计划',
            onPressed: () => ref.read(generatePlanProvider),
          ),
        ],
      ),
      drawer: const AppDrawer(currentRoute: '/plan'),
      body: Column(
        children: [
          WeekCalendarBar(
            selectedDate: selectedDate,
            onDateSelected: (date) {
              ref.read(selectedDateProvider.notifier).state = date;
              ref.invalidate(planScreenDataProvider);
            },
          ),
          const Divider(height: 1),
          Expanded(
            child: settings.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('错误: $e')),
              data: (settingsData) => planItems.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('错误: $e')),
                data: (items) => screenData.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('错误: $e')),
                  data: (data) => DayTimeline(
                    items: items,
                    subjects: data.subjects,
                    fixedEvents: data.fixedEvents,
                    timetableEvents: data.timetableEvents,
                    wakeMinutes: settingsData.wakeHour * 60 + settingsData.wakeMinute,
                    sleepMinutes: settingsData.sleepHour * 60 + settingsData.sleepMinute,
                    onItemTap: (item, subject) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PlanEditScreen(item: item, subject: subject),
                        ),
                      );
                    },
                    onFragmentedEventTap: (event) {
                      _showAddFragmentedStudyDialog(
                        context, ref, event, data.subjects,
                      );
                    },
                    onFreeTimeTap: (slot) {
                      _showFreeTimeDialog(
                        context, ref, slot, data.subjects,
                      );
                    },
                    onToggleComplete: (item, completed) async {
                      await db.togglePlanItemCompleted(item.id, completed);
                      ref.invalidate(planItemsProvider);
                      WidgetUpdater.updateWidget(db);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
