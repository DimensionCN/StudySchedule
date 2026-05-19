import 'package:flutter/material.dart';
import '../database/app_database.dart';

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
    // 构建所有显示块（固定事件 + 课表 + 计划项）
    final blocks = <_TimeBlock>[];

    // 固定事件
    for (final fe in fixedEvents) {
      if (fe.isActive) {
        if (fe.supportsFragmented) {
          blocks.add(_TimeBlock(
            start: fe.startHour * 60 + fe.startMinute,
            end: fe.endHour * 60 + fe.endMinute,
            title: '${fe.name} · 可碎片学习',
            color: Colors.orange.shade50,
            textColor: Colors.orange.shade800,
            icon: Icons.access_time,
            fixedEvent: fe,
          ));
        } else {
          blocks.add(_TimeBlock(
            start: fe.startHour * 60 + fe.startMinute,
            end: fe.endHour * 60 + fe.endMinute,
            title: fe.name,
            color: Colors.grey.shade300,
            textColor: Colors.grey.shade700,
            icon: Icons.lock,
          ));
        }
      }
    }

    // 课表事件
    for (final te in timetableEvents) {
      blocks.add(_TimeBlock(
        start: te.startHour * 60 + te.startMinute,
        end: te.endHour * 60 + te.endMinute,
        title: te.courseName,
        color: Colors.blue.shade100,
        textColor: Colors.blue.shade800,
        icon: Icons.class_,
      ));
    }

    // 计划项
    final subjectMap = {for (final s in subjects) s.id: s};
    for (final item in items) {
      if (item.isRest) {
        blocks.add(_TimeBlock(
          start: item.startMinutes,
          end: item.startMinutes + item.durationMinutes,
          title: '休息',
          color: Colors.green.shade50,
          textColor: Colors.green.shade700,
          icon: Icons.coffee,
          planItem: item,
        ));
      } else if (item.subjectId != null) {
        final subject = subjectMap[item.subjectId];
        if (subject != null) {
          blocks.add(_TimeBlock(
            start: item.startMinutes,
            end: item.startMinutes + item.durationMinutes,
            title: subject.name,
            color: Color(subject.color).withValues(alpha: 0.2),
            textColor: Color(subject.color),
            icon: Icons.menu_book,
            isManual: item.isManual,
            planItem: item,
            subject: subject,
          ));
        }
      } else if (!item.isRest && item.customName != null) {
        // 自定义活动（休闲娱乐、作业等）
        blocks.add(_TimeBlock(
          start: item.startMinutes,
          end: item.startMinutes + item.durationMinutes,
          title: item.customName!,
          color: Colors.teal.shade50,
          textColor: Colors.teal.shade700,
          icon: Icons.event_note,
          isManual: item.isManual,
          planItem: item,
        ));
      }
    }

    // 按开始时间排序
    blocks.sort((a, b) => a.start.compareTo(b.start));

    // 计算空闲时间段并插入
    final allBlocks = <_TimeBlock>[];

    // 起床卡片
    allBlocks.add(_TimeBlock(
      start: wakeMinutes,
      end: wakeMinutes,
      title: '起床',
      color: Colors.amber.shade50,
      textColor: Colors.amber.shade800,
      icon: Icons.wb_sunny,
      blockType: _BlockType.wake,
    ));

    // 计算空闲段：起床 → 第一个块
    int cursor = wakeMinutes;
    for (final block in blocks) {
      if (block.start > cursor) {
        final freeDur = block.start - cursor;
        final freeTitle = freeDur >= 30 ? '空闲时间 · 可学习$freeDur分钟' : '碎片时间 · $freeDur分钟';
        allBlocks.add(_TimeBlock(
          start: cursor,
          end: block.start,
          title: freeTitle,
          color: Colors.grey.shade100,
          textColor: Colors.grey.shade600,
          icon: freeDur >= 30 ? Icons.free_breakfast : Icons.timer_outlined,
          blockType: _BlockType.freeTime,
          freeSlot: FreeTimeSlot(cursor, block.start),
        ));
      }
      allBlocks.add(block);
      if (block.end > cursor) cursor = block.end;
    }
    // 空闲段：最后一个块 → 睡觉
    if (cursor < sleepMinutes) {
      final freeDur = sleepMinutes - cursor;
      final freeTitle = freeDur >= 30 ? '空闲时间 · 可学习$freeDur分钟' : '碎片时间 · $freeDur分钟';
      allBlocks.add(_TimeBlock(
        start: cursor,
        end: sleepMinutes,
        title: freeTitle,
        color: Colors.grey.shade100,
        textColor: Colors.grey.shade600,
        icon: freeDur >= 30 ? Icons.free_breakfast : Icons.timer_outlined,
        blockType: _BlockType.freeTime,
        freeSlot: FreeTimeSlot(cursor, sleepMinutes),
      ));
    }

    // 睡觉卡片
    allBlocks.add(_TimeBlock(
      start: sleepMinutes,
      end: sleepMinutes,
      title: '睡觉',
      color: Colors.indigo.shade50,
      textColor: Colors.indigo.shade800,
      icon: Icons.nights_stay,
      blockType: _BlockType.sleep,
    ));

    if (allBlocks.length <= 2) {
      // 只有起床和睡觉
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: allBlocks.length,
        itemBuilder: (context, index) => _buildBlock(context, allBlocks[index]),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: allBlocks.length,
      itemBuilder: (context, index) {
        final block = allBlocks[index];
        return _buildBlock(context, block);
      },
    );
  }

  Widget _buildBlock(BuildContext context, _TimeBlock block) {
    final startH = block.start ~/ 60;
    final startM = block.start % 60;
    final duration = block.end - block.start;
    final isTimeless = block.blockType == _BlockType.wake || block.blockType == _BlockType.sleep;

    // 判断是否为当前正在进行的块
    final now = DateTime.now();
    final nowMinutes = now.hour * 60 + now.minute;
    final isActive = duration > 0 && nowMinutes >= block.start && nowMinutes < block.end;

    // 判断是否为可打勾的计划项（非休息、有计划项、开始时间 <= 当前时间）
    final canCheck = block.planItem != null &&
        !block.planItem!.isRest &&
        block.start <= nowMinutes &&
        onToggleComplete != null;
    final isChecked = block.planItem?.isCompleted ?? false;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: block.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isActive
            ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: block.planItem != null && onItemTap != null
            ? () => onItemTap!(block.planItem!, block.subject)
            : (block.fixedEvent != null && block.fixedEvent!.supportsFragmented && onFragmentedEventTap != null)
                ? () => onFragmentedEventTap!(block.fixedEvent!)
                : (block.blockType == _BlockType.freeTime && block.freeSlot != null && onFreeTimeTap != null)
                    ? () => onFreeTimeTap!(block.freeSlot!)
                    : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // 打勾框
              if (canCheck)
                GestureDetector(
                  onTap: () => onToggleComplete!(block.planItem!, !isChecked),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      isChecked ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: isChecked ? Colors.green : block.textColor.withValues(alpha: 0.4),
                      size: 24,
                    ),
                  ),
                ),
              // 时间列
              SizedBox(
                width: 56,
                child: isTimeless
                    ? Icon(block.icon, color: block.textColor, size: 28)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${startH.toString().padLeft(2, '0')}:${startM.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: block.textColor,
                              fontSize: 16,
                            ),
                          ),
                          if (duration > 0)
                            Text(
                              '${block.end ~/ 60}:${(block.end % 60).toString().padLeft(2, '0')}',
                              style: TextStyle(color: block.textColor.withValues(alpha: 0.7), fontSize: 12),
                            ),
                        ],
                      ),
              ),
              if (!isTimeless) ...[
                const SizedBox(width: 12),
                Icon(block.icon, color: block.textColor, size: 20),
              ],
              const SizedBox(width: 8),
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
                                  ? block.textColor.withValues(alpha: 0.4)
                                  : block.textColor,
                              fontSize: 15,
                              decoration: isChecked ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ),
                        if (isActive)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '进行中',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (duration > 0)
                      Text(
                        '$duration分钟',
                        style: TextStyle(color: block.textColor.withValues(alpha: 0.6), fontSize: 12),
                      ),
                  ],
                ),
              ),
              if (block.blockType == _BlockType.freeTime)
                Icon(Icons.add_circle_outline, size: 20, color: block.textColor.withValues(alpha: 0.5)),
              if (block.isManual)
                Icon(Icons.edit, size: 16, color: block.textColor.withValues(alpha: 0.5)),
            ],
          ),
        ),
      ),
    );
  }
}

enum _BlockType { normal, wake, sleep, freeTime }

class _TimeBlock {
  final int start;
  final int end;
  final String title;
  final Color color;
  final Color textColor;
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
    required this.color,
    required this.textColor,
    required this.icon,
    this.isManual = false,
    this.planItem,
    this.subject,
    this.fixedEvent,
    this.freeSlot,
    this.blockType = _BlockType.normal,
  });
}
