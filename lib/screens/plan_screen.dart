import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../database/app_database.dart';
import '../main.dart';
import '../providers/plan_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/week_calendar_bar.dart';
import '../widgets/day_timeline.dart';
import 'plan_edit_screen.dart';

class PlanScreen extends ConsumerWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final planItems = ref.watch(planItemsProvider);
    final settings = ref.watch(settingsProvider);
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
      body: Column(
        children: [
          WeekCalendarBar(
            selectedDate: selectedDate,
            onDateSelected: (date) => ref.read(selectedDateProvider.notifier).state = date,
          ),
          const Divider(height: 1),
          Expanded(
            child: settings.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('错误: $e')),
              data: (settingsData) => planItems.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('错误: $e')),
                data: (items) => FutureBuilder<List<Subject>>(
                  future: db.getAllSubjects(),
                  builder: (ctx, subjectSnap) {
                    if (!subjectSnap.hasData) return const SizedBox();
                    return FutureBuilder<List<FixedEvent>>(
                      future: db.getAllFixedEvents(),
                      builder: (ctx, eventSnap) {
                        if (!eventSnap.hasData) return const SizedBox();
                        return FutureBuilder<List<TimetableEvent>>(
                          future: db.getAllTimetableEvents(),
                          builder: (ctx, ttSnap) {
                            if (!ttSnap.hasData) return const SizedBox();
                            final dayOfWeek = selectedDate.weekday;
                            final filteredTimetable = ttSnap.data!
                                .where((t) => t.dayOfWeek == dayOfWeek)
                                .toList();
                            return DayTimeline(
                              items: items,
                              subjects: subjectSnap.data!,
                              fixedEvents: eventSnap.data!,
                              timetableEvents: filteredTimetable,
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
                            );
                          },
                        );
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
}
