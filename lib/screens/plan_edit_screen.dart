import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../main.dart';
import '../providers/plan_provider.dart';

class PlanEditScreen extends ConsumerStatefulWidget {
  final PlanItem item;
  final Subject? subject;

  const PlanEditScreen({super.key, required this.item, this.subject});

  @override
  ConsumerState<PlanEditScreen> createState() => _PlanEditScreenState();
}

class _PlanEditScreenState extends ConsumerState<PlanEditScreen> {
  late int _startMinutes;
  late int _duration;
  late final int _maxDuration;

  @override
  void initState() {
    super.initState();
    _startMinutes = widget.item.startMinutes;
    _duration = widget.item.durationMinutes;
    _maxDuration = _duration > 120 ? _duration : 120;
  }

  @override
  Widget build(BuildContext context) {
    final startH = _startMinutes ~/ 60;
    final startM = _startMinutes % 60;
    final endMinutes = _startMinutes + _duration;
    final endH = endMinutes ~/ 60;
    final endM = endMinutes % 60;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.isRest
            ? '编辑休息'
            : '编辑 ${widget.subject?.name ?? widget.item.customName ?? "学习"}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: _delete,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${startH.toString().padLeft(2, '0')}:${startM.toString().padLeft(2, '0')} - '
              '${endH.toString().padLeft(2, '0')}:${endM.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Text('时长: $_duration 分钟'),
            Slider(
              value: _duration.toDouble(),
              min: 10,
              max: _maxDuration.toDouble(),
              divisions: (_maxDuration - 10) ~/ 5,
              label: '$_duration 分钟',
              onChanged: (v) => setState(() => _duration = v.round()),
            ),
            const SizedBox(height: 24),
            const Text('调整开始时间'),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: _startMinutes >= 30
                      ? () => setState(() => _startMinutes -= 30)
                      : null,
                ),
                Text(
                  '${startH.toString().padLeft(2, '0')}:${startM.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 18),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _startMinutes < 23 * 60
                      ? () => setState(() => _startMinutes += 30)
                      : null,
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: _save,
                child: const Text('保存'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    final db = ref.read(databaseProvider);
    db.updatePlanItem(PlanItemsCompanion(
      id: Value(widget.item.id),
      date: Value(widget.item.date),
      subjectId: Value(widget.item.subjectId),
      customName: Value(widget.item.customName),
      startMinutes: Value(_startMinutes),
      durationMinutes: Value(_duration),
      isRest: Value(widget.item.isRest),
      isManual: const Value(true),
      orderIndex: Value(widget.item.orderIndex),
    ));
    ref.invalidate(planItemsProvider);
    Navigator.pop(context);
  }

  void _delete() {
    final db = ref.read(databaseProvider);
    db.deletePlanItem(widget.item.id);
    ref.invalidate(planItemsProvider);
    Navigator.pop(context);
  }
}
