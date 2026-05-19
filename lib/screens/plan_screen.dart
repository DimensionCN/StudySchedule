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
import '../theme/app_theme.dart';
import 'plan_edit_screen.dart';

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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              ),
              title: Row(
                children: [
                  Icon(Icons.event_available_rounded, color: Theme.of(ctx).colorScheme.primary),
                  const SizedBox(width: AppTheme.spacingSmall),
                  Text('空闲时间 ${slot.duration}分钟'),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacingMedium),
                      decoration: BoxDecoration(
                        color: Theme.of(ctx).colorScheme.primaryContainer.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.access_time_rounded, color: Theme.of(ctx).colorScheme.primary, size: 20),
                          const SizedBox(width: AppTheme.spacingSmall),
                          Text(
                            '${slot.start ~/ 60}:${(slot.start % 60).toString().padLeft(2, '0')}'
                            ' - ${slot.end ~/ 60}:${(slot.end % 60).toString().padLeft(2, '0')}',
                            style: TextStyle(
                              color: Theme.of(ctx).colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingLarge),
                    SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(value: true, label: Text('学习科目'), icon: Icon(Icons.menu_book_rounded, size: 18)),
                        ButtonSegment(value: false, label: Text('其他活动'), icon: Icon(Icons.event_note_rounded, size: 18)),
                      ],
                      selected: {isSubjectMode},
                      onSelectionChanged: (v) => setDialogState(() {
                        isSubjectMode = v.first;
                      }),
                    ),
                    const SizedBox(height: AppTheme.spacingLarge),
                    Text(
                      isSubjectMode ? '选择科目:' : '选择活动:',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: AppTheme.spacingSmall),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (isSubjectMode ? allSubjects.map((s) => _SubjectChip(s)) : _presetActivities.map((name) => _ActivityChip(name)))
                          .map((chip) {
                        return GestureDetector(
                          onTap: () {
                            if (chip is _SubjectChip) {
                              setDialogState(() => selectedSubjectId = chip.subject.id);
                            } else if (chip is _ActivityChip) {
                              setDialogState(() => selectedCustomName = chip.name);
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: AppTheme.animShort),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: (chip is _SubjectChip && chip.subject.id == selectedSubjectId) ||
                                      (chip is _ActivityChip && chip.name == selectedCustomName)
                                  ? Theme.of(ctx).colorScheme.primary
                                  : Theme.of(ctx).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              chip is _SubjectChip ? chip.subject.name : (chip as _ActivityChip).name,
                              style: TextStyle(
                                color: (chip is _SubjectChip && chip.subject.id == selectedSubjectId) ||
                                        (chip is _ActivityChip && chip.name == selectedCustomName)
                                    ? Theme.of(ctx).colorScheme.onPrimary
                                    : Theme.of(ctx).colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppTheme.spacingLarge),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('时长:', style: TextStyle(fontWeight: FontWeight.w600)),
                        Text('$durationMinutes 分钟', style: TextStyle(color: Theme.of(ctx).colorScheme.primary, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 6,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                        activeTrackColor: Theme.of(ctx).colorScheme.primary,
                        inactiveTrackColor: Theme.of(ctx).colorScheme.primaryContainer,
                        thumbColor: Theme.of(ctx).colorScheme.primary,
                      ),
                      child: Slider(
                        value: durationMinutes.toDouble(),
                        min: 5,
                        max: slot.duration.toDouble(),
                        divisions: slot.duration >= 10 ? (slot.duration - 5) ~/ 5 : 1,
                        onChanged: (v) => setDialogState(() => durationMinutes = v.round()),
                      ),
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
                    final dateStr = DateFormat('yyyy-MM-dd').format(ref.read(selectedDateProvider));
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
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                  ),
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
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.info_outline_rounded, color: Colors.white),
              const SizedBox(width: 12),
              const Text('没有碎片化科目，请先在科目管理中添加'),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMedium)),
        ),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              ),
              title: Row(
                children: [
                  Icon(Icons.psychology_rounded, color: Theme.of(ctx).colorScheme.primary),
                  const SizedBox(width: AppTheme.spacingSmall),
                  Text('${event.name} - 碎片学习'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacingMedium),
                    decoration: BoxDecoration(
                      color: Theme.of(ctx).colorScheme.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.access_time_rounded, color: Theme.of(ctx).colorScheme.primary, size: 20),
                        const SizedBox(width: AppTheme.spacingSmall),
                        Text(
                          '${event.startHour.toString().padLeft(2, '0')}:${event.startMinute.toString().padLeft(2, '0')}'
                          ' - ${event.endHour.toString().padLeft(2, '0')}:${event.endMinute.toString().padLeft(2, '0')}'
                          ' ($eventDuration分钟)',
                          style: TextStyle(
                            color: Theme.of(ctx).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingLarge),
                  const Text('选择科目:', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: AppTheme.spacingSmall),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: fragmentedSubjects.map((s) {
                      final selected = s.id == selectedSubject?.id;
                      return ChoiceChip(
                        label: Text(s.name),
                        selected: selected,
                        onSelected: (_) => setDialogState(() => selectedSubject = s),
                        selectedColor: Theme.of(ctx).colorScheme.primary,
                        labelStyle: TextStyle(
                          color: selected ? Theme.of(ctx).colorScheme.onPrimary : Theme.of(ctx).colorScheme.onSurface,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppTheme.spacingLarge),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('学习时长:', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text('$durationMinutes 分钟', style: TextStyle(color: Theme.of(ctx).colorScheme.primary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 6,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                      activeTrackColor: Theme.of(ctx).colorScheme.primary,
                      inactiveTrackColor: Theme.of(ctx).colorScheme.primaryContainer,
                      thumbColor: Theme.of(ctx).colorScheme.primary,
                    ),
                    child: Slider(
                      value: durationMinutes.toDouble(),
                      min: 5,
                      max: eventDuration.toDouble(),
                      divisions: eventDuration >= 10 ? (eventDuration - 5) ~/ 5 : 1,
                      onChanged: (v) => setDialogState(() => durationMinutes = v.round()),
                    ),
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
                    final dateStr = DateFormat('yyyy-MM-dd').format(ref.read(selectedDateProvider));
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
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                  ),
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('MM月dd日', 'zh_CN').format(selectedDate),
              style: const TextStyle(
                fontSize: AppTheme.fontXL,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              DateFormat('EEEE', 'zh_CN').format(selectedDate),
              style: TextStyle(
                fontSize: AppTheme.fontSmall,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: AppTheme.spacingSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: IconButton(
              icon: Icon(Icons.refresh_rounded, color: Theme.of(context).colorScheme.primary),
              tooltip: '生成计划',
              onPressed: () => ref.read(generatePlanProvider),
            ),
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
          Expanded(
            child: settings.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (e, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline_rounded, size: 48, color: AppTheme.errorColor),
                    const SizedBox(height: AppTheme.spacingMedium),
                    Text('错误: $e', style: TextStyle(color: AppTheme.errorColor)),
                  ],
                ),
              ),
              data: (settingsData) => planItems.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('错误: $e')),
                data: (items) => screenData.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('错误: $e')),
                  data: (data) {
                    if (items.isEmpty && data.subjects.isEmpty) {
                      return _buildEmptyState(context, ref);
                    }
                    return DayTimeline(
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
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor.withValues(alpha: 0.1),
                    AppTheme.secondaryColor.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_month_rounded,
                size: 56,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: AppTheme.spacingXXL),
            const Text(
              '开始规划你的考研日程',
              style: TextStyle(
                fontSize: AppTheme.fontXL,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            Text(
              '添加科目和固定事件，\n即可自动生成每日学习计划',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppTheme.fontMedium,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppTheme.spacingXXL),
            FilledButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/subjects');
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text('添加第一个科目'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubjectChip {
  final Subject subject;
  const _SubjectChip(this.subject);
}

class _ActivityChip {
  final String name;
  const _ActivityChip(this.name);
}
