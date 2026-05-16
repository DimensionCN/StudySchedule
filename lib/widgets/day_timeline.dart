import 'package:flutter/material.dart';
import '../database/app_database.dart';

class DayTimeline extends StatelessWidget {
  final List<PlanItem> items;
  final List<Subject> subjects;
  final List<FixedEvent> fixedEvents;
  final List<TimetableEvent> timetableEvents;
  final int wakeMinutes;
  final int sleepMinutes;
  final void Function(PlanItem item, Subject? subject)? onItemTap;

  const DayTimeline({
    super.key,
    required this.items,
    required this.subjects,
    required this.fixedEvents,
    required this.timetableEvents,
    required this.wakeMinutes,
    required this.sleepMinutes,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    // 构建所有显示块（固定事件 + 课表 + 计划项）
    final blocks = <_TimeBlock>[];

    // 固定事件
    for (final fe in fixedEvents) {
      if (fe.isActive) {
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
      }
    }

    // 按开始时间排序
    blocks.sort((a, b) => a.start.compareTo(b.start));

    if (blocks.isEmpty) {
      return const Center(
        child: Text('点击"生成计划"开始', style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: blocks.length,
      itemBuilder: (context, index) {
        final block = blocks[index];
        return _buildBlock(context, block);
      },
    );
  }

  Widget _buildBlock(BuildContext context, _TimeBlock block) {
    final startH = block.start ~/ 60;
    final startM = block.start % 60;
    final endH = block.end ~/ 60;
    final endM = block.end % 60;
    final duration = block.end - block.start;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: block.color,
      child: InkWell(
        onTap: block.planItem != null && onItemTap != null
            ? () => onItemTap!(block.planItem!, block.subject)
            : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Column(
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
                Text(
                  '${endH.toString().padLeft(2, '0')}:${endM.toString().padLeft(2, '0')}',
                  style: TextStyle(color: block.textColor.withValues(alpha: 0.7), fontSize: 12),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Icon(block.icon, color: block.textColor, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    block.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: block.textColor,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    '$duration分钟',
                    style: TextStyle(color: block.textColor.withValues(alpha: 0.6), fontSize: 12),
                  ),
                ],
              ),
            ),
            if (block.isManual)
              Icon(Icons.edit, size: 16, color: block.textColor.withValues(alpha: 0.5)),
          ],
        ),
      ),
      ),
    );
  }
}

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
  });
}
