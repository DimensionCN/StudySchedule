import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../theme/app_theme.dart';

/// 空闲时间段
class FreeTimeSlot {
  final int start;
  final int end;
  const FreeTimeSlot(this.start, this.end);
  int get duration => end - start;
}

class DayTimeline extends StatelessWidget {
  final List<PlanItem> items;
  final List<Subject> subjects;
  final List<FixedEvent> fixedEvents;
  final List<TimetableEvent> timetableEvents;
  final int wakeMinutes;
  final int sleepMinutes;
  final void Function(PlanItem item, Subject? subject)? onItemTap;
  final void Function(FixedEvent event)? onFragmentedEventTap;
  final void Function(FreeTimeSlot slot)? onFreeTimeTap;
  final void Function(PlanItem item, bool completed)? onToggleComplete;

  const DayTimeline({
    super.key,
    required this.items,
    required this.subjects,
    required this.fixedEvents,
    required this.timetableEvents,
    required this.wakeMinutes,
    required this.sleepMinutes,
    this.onItemTap,
    this.onFragmentedEventTap,
    this.onFreeTimeTap,
    this.onToggleComplete,
  });

  @override
  Widget build(BuildContext context) {
    final blocks = <_TimeBlock>[];

    for (final fe in fixedEvents) {
      if (fe.isActive) {
        if (fe.supportsFragmented) {
          blocks.add(_TimeBlock(
            start: fe.startHour * 60 + fe.startMinute,
            end: fe.endHour * 60 + fe.endMinute,
            title: '${fe.name} · 可碎片学习',
            gradient: [Colors.orange.shade100, Colors.orange.shade50],
            darkGradient: [const Color(0xFF3D2E00), const Color(0xFF2A1F00)],
            textColor: Colors.orange.shade800,
            darkTextColor: Colors.orange.shade200,
            icon: Icons.access_time_rounded,
            blockType: _BlockType.fragmented,
            fixedEvent: fe,
          ));
        } else {
          blocks.add(_TimeBlock(
            start: fe.startHour * 60 + fe.startMinute,
            end: fe.endHour * 60 + fe.endMinute,
            title: fe.name,
            gradient: [Colors.grey.shade200, Colors.grey.shade100],
            darkGradient: [const Color(0xFF2D3136), const Color(0xFF25292E)],
            textColor: Colors.grey.shade700,
            darkTextColor: Colors.grey.shade300,
            icon: Icons.lock_rounded,
            fixedEvent: fe,
          ));
        }
      }
    }

    for (final te in timetableEvents) {
      blocks.add(_TimeBlock(
        start: te.startHour * 60 + te.startMinute,
        end: te.endHour * 60 + te.endMinute,
        title: te.courseName,
        gradient: AppTheme.classGradient,
        darkGradient: [const Color(0xFF2D1B4E), const Color(0xFF3D1F3D)],
        textColor: Colors.white,
        darkTextColor: Colors.white,
        icon: Icons.class_rounded,
        blockType: _BlockType.classEvent,
      ));
    }

    final subjectMap = {for (final s in subjects) s.id: s};
    for (final item in items) {
      if (item.isRest) {
        blocks.add(_TimeBlock(
          start: item.startMinutes,
          end: item.startMinutes + item.durationMinutes,
          title: '休息',
          gradient: AppTheme.restGradient,
          darkGradient: [const Color(0xFF0D3320), const Color(0xFF0A2A2F)],
          textColor: Colors.white,
          darkTextColor: Colors.white,
          icon: Icons.coffee_rounded,
          planItem: item,
        ));
      } else if (item.subjectId != null) {
        final subject = subjectMap[item.subjectId];
        if (subject != null) {
          final baseColor = Color(subject.color);
          blocks.add(_TimeBlock(
            start: item.startMinutes,
            end: item.startMinutes + item.durationMinutes,
            title: subject.name,
            gradient: [baseColor.withValues(alpha: 0.85), baseColor],
            darkGradient: [baseColor.withValues(alpha: 0.7), baseColor.withValues(alpha: 0.5)],
            textColor: Colors.white,
            darkTextColor: Colors.white,
            icon: Icons.menu_book_rounded,
            isManual: item.isManual,
            planItem: item,
            subject: subject,
          ));
        }
      } else if (!item.isRest && item.customName != null) {
        blocks.add(_TimeBlock(
          start: item.startMinutes,
          end: item.startMinutes + item.durationMinutes,
          title: item.customName!,
          gradient: [Colors.teal.shade200, Colors.teal.shade100],
          darkGradient: [const Color(0xFF0D3333), const Color(0xFF0A2A2A)],
          textColor: Colors.teal.shade900,
          darkTextColor: Colors.teal.shade200,
          icon: Icons.event_note_rounded,
          isManual: item.isManual,
          planItem: item,
        ));
      }
    }

    blocks.sort((a, b) => a.start.compareTo(b.start));

    final allBlocks = <_TimeBlock>[];

    allBlocks.add(_TimeBlock(
      start: wakeMinutes,
      end: wakeMinutes,
      title: '起床',
      gradient: AppTheme.wakeGradient,
      darkGradient: [const Color(0xFF3D2E00), const Color(0xFF2A1F00)],
      textColor: Colors.white,
      darkTextColor: Colors.white,
      icon: Icons.wb_sunny_rounded,
      blockType: _BlockType.wake,
    ));

    int cursor = wakeMinutes;
    for (final block in blocks) {
      if (block.start > cursor) {
        final freeDur = block.start - cursor;
        final freeTitle = freeDur >= 30 ? '空闲 · $freeDur分钟' : '碎片 · $freeDur分钟';
        allBlocks.add(_TimeBlock(
          start: cursor,
          end: block.start,
          title: freeTitle,
          gradient: AppTheme.freeTimeGradient,
          darkGradient: AppTheme.freeTimeDarkGradient,
          textColor: Colors.grey.shade600,
          darkTextColor: Colors.grey.shade400,
          icon: freeDur >= 30 ? Icons.free_breakfast_rounded : Icons.timer_outlined,
          blockType: _BlockType.freeTime,
          freeSlot: FreeTimeSlot(cursor, block.start),
        ));
      }
      allBlocks.add(block);
      if (block.end > cursor) cursor = block.end;
    }
    if (cursor < sleepMinutes) {
      final freeDur = sleepMinutes - cursor;
      final freeTitle = freeDur >= 30 ? '空闲 · $freeDur分钟' : '碎片 · $freeDur分钟';
      allBlocks.add(_TimeBlock(
        start: cursor,
        end: sleepMinutes,
        title: freeTitle,
        gradient: AppTheme.freeTimeGradient,
        darkGradient: AppTheme.freeTimeDarkGradient,
        textColor: Colors.grey.shade600,
        darkTextColor: Colors.grey.shade400,
        icon: freeDur >= 30 ? Icons.free_breakfast_rounded : Icons.timer_outlined,
        blockType: _BlockType.freeTime,
        freeSlot: FreeTimeSlot(cursor, sleepMinutes),
      ));
    }

    allBlocks.add(_TimeBlock(
      start: sleepMinutes,
      end: sleepMinutes,
      title: '睡觉',
      gradient: AppTheme.sleepGradient,
      darkGradient: [const Color(0xFF1B2D4E), const Color(0xFF1F2A3D)],
      textColor: Colors.white,
      darkTextColor: Colors.white,
      icon: Icons.nights_stay_rounded,
      blockType: _BlockType.sleep,
    ));

    if (allBlocks.length <= 2) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLarge, vertical: AppTheme.spacingSmall),
        itemCount: allBlocks.length,
        itemBuilder: (context, index) => _buildBlock(context, allBlocks[index]),
      );
    }

    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLarge, vertical: AppTheme.spacingSmall),
          itemCount: allBlocks.length,
          itemBuilder: (context, index) {
            final block = allBlocks[index];
            return _buildBlock(context, block);
          },
        ),
        // 当前时间指示线
        _buildCurrentTimeIndicator(context),
      ],
    );
  }

  Widget _buildCurrentTimeIndicator(BuildContext context) {
    final now = DateTime.now();
    final nowMinutes = now.hour * 60 + now.minute;

    if (nowMinutes < wakeMinutes || nowMinutes > sleepMinutes) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: 0,
      right: 0,
      top: _calculatePositionFromMinutes(nowMinutes, wakeMinutes, sleepMinutes),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: AppTheme.errorColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.errorColor.withValues(alpha: 0.4),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                color: AppTheme.errorColor.withValues(alpha: 0.6),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.errorColor.withValues(alpha: 0.2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculatePositionFromMinutes(int minutes, int wakeMin, int sleepMin) {
    final totalMinutes = sleepMin - wakeMin;
    if (totalMinutes <= 0) return 0;

    final progress = (minutes - wakeMin) / totalMinutes;
    final estimatedTotalHeight = 800.0;
    return progress * estimatedTotalHeight;
  }

  Widget _buildBlock(BuildContext context, _TimeBlock block) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final startH = block.start ~/ 60;
    final startM = block.start % 60;
    final duration = block.end - block.start;
    final isTimeless = block.blockType == _BlockType.wake || block.blockType == _BlockType.sleep;

    final now = DateTime.now();
    final nowMinutes = now.hour * 60 + now.minute;
    final isActive = duration > 0 && nowMinutes >= block.start && nowMinutes < block.end;

    final canCheck = block.planItem != null &&
        !block.planItem!.isRest &&
        block.start <= nowMinutes &&
        onToggleComplete != null;
    final isChecked = block.planItem?.isCompleted ?? false;

    final textColor = isDark ? block.darkTextColor : block.textColor;
    final gradientColors = isDark ? block.darkGradient : block.gradient;

    return AnimatedContainer(
      duration: Duration(milliseconds: AppTheme.animMedium),
      margin: EdgeInsets.only(
        bottom: block.blockType == _BlockType.freeTime ? AppTheme.spacingSmall : AppTheme.spacingMedium,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(
          block.blockType == _BlockType.freeTime ? AppTheme.radiusMedium : AppTheme.radiusLarge,
        ),
        border: block.blockType == _BlockType.freeTime
            ? Border.all(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                width: 1,
                strokeAlign: BorderSide.strokeAlignInside,
              )
            : null,
        boxShadow: isActive
            ? AppTheme.activeCardShadow
            : (block.blockType != _BlockType.freeTime ? AppTheme.cardShadow : null),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: block.planItem != null && onItemTap != null
              ? () => onItemTap!(block.planItem!, block.subject)
              : (block.fixedEvent != null && block.fixedEvent!.supportsFragmented && onFragmentedEventTap != null)
                  ? () => onFragmentedEventTap!(block.fixedEvent!)
                  : (block.blockType == _BlockType.freeTime && block.freeSlot != null && onFreeTimeTap != null)
                      ? () => onFreeTimeTap!(block.freeSlot!)
                      : null,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          child: Padding(
            padding: EdgeInsets.all(
              block.blockType == _BlockType.freeTime ? AppTheme.spacingMedium : AppTheme.spacingLarge,
            ),
            child: Row(
              children: [
                if (canCheck)
                  GestureDetector(
                    onTap: () => onToggleComplete!(block.planItem!, !isChecked),
                    child: Padding(
                      padding: const EdgeInsets.only(right: AppTheme.spacingSmall),
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: AppTheme.animShort),
                        child: Icon(
                          isChecked ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                          key: ValueKey(isChecked),
                          color: isChecked ? AppTheme.successColor : textColor.withValues(alpha: 0.5),
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                SizedBox(
                  width: isTimeless ? 48 : 52,
                  child: isTimeless
                      ? Icon(block.icon, color: textColor, size: 32)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${startH.toString().padLeft(2, '0')}:${startM.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: textColor,
                                fontSize: AppTheme.fontLarge,
                              ),
                            ),
                            if (duration > 0)
                              Text(
                                '${block.end ~/ 60}:${(block.end % 60).toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  color: textColor.withValues(alpha: 0.7),
                                  fontSize: AppTheme.fontSmall,
                                ),
                              ),
                          ],
                        ),
                ),
                if (!isTimeless) ...[
                  const SizedBox(width: AppTheme.spacingSmall),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: textColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    ),
                    child: Icon(block.icon, color: textColor, size: 18),
                  ),
                ],
                const SizedBox(width: AppTheme.spacingSmall),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              block.title,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isChecked
                                    ? textColor.withValues(alpha: 0.4)
                                    : textColor,
                                fontSize: AppTheme.fontMedium,
                                decoration: isChecked ? TextDecoration.lineThrough : null,
                              ),
                            ),
                          ),
                          if (isActive)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '进行中',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: AppTheme.fontXS,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      if (duration > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: AppTheme.spacingXS),
                          child: Text(
                            '$duration分钟',
                            style: TextStyle(
                              color: textColor.withValues(alpha: 0.6),
                              fontSize: AppTheme.fontSmall,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (block.blockType == _BlockType.freeTime)
                  Icon(Icons.add_circle_outline_rounded, size: 22, color: textColor.withValues(alpha: 0.5)),
                if (block.isManual)
                  Icon(Icons.edit_rounded, size: 16, color: textColor.withValues(alpha: 0.5)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _BlockType { normal, wake, sleep, freeTime, fragmented, classEvent }

class _TimeBlock {
  final int start;
  final int end;
  final String title;
  final List<Color> gradient;
  final List<Color> darkGradient;
  final Color textColor;
  final Color darkTextColor;
  final IconData icon;
  final bool isManual;
  final PlanItem? planItem;
  final Subject? subject;
  final FixedEvent? fixedEvent;
  final FreeTimeSlot? freeSlot;
  final _BlockType blockType;

  _TimeBlock({
    required this.start,
    required this.end,
    required this.title,
    required this.gradient,
    required this.darkGradient,
    required this.textColor,
    required this.darkTextColor,
    required this.icon,
    this.isManual = false,
    this.planItem,
    this.subject,
    this.fixedEvent,
    this.freeSlot,
    this.blockType = _BlockType.normal,
  });
}
