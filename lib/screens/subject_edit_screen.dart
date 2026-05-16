import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../providers/subject_provider.dart';

class SubjectEditScreen extends ConsumerStatefulWidget {
  final Subject? subject; // null = 新建
  const SubjectEditScreen({super.key, this.subject});

  @override
  ConsumerState<SubjectEditScreen> createState() => _SubjectEditScreenState();
}

class _SubjectEditScreenState extends ConsumerState<SubjectEditScreen> {
  late final TextEditingController _nameController;
  late double _dailyHours;
  late int _priority;
  late int _color;

  static const _colorOptions = [
    0xFF2196F3, // 蓝
    0xFF4CAF50, // 绿
    0xFFFF9800, // 橙
    0xFFF44336, // 红
    0xFF9C27B0, // 紫
    0xFF00BCD4, // 青
    0xFFFF5722, // 深橙
    0xFF795548, // 棕
  ];

  @override
  void initState() {
    super.initState();
    final s = widget.subject;
    _nameController = TextEditingController(text: s?.name ?? '');
    _dailyHours = (s?.dailyMinutes ?? 180) / 60.0;
    _priority = s?.priority ?? 3;
    _color = s?.color ?? _colorOptions[0];
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.subject != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? '编辑科目' : '添加科目')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '科目名称',
                hintText: '如：数学、英语、专业课',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Text('每天学习时长: ${_dailyHours.toStringAsFixed(1)} 小时'),
            Slider(
              value: _dailyHours,
              min: 0.5,
              max: 8,
              divisions: 15,
              label: '${_dailyHours.toStringAsFixed(1)}h',
              onChanged: (v) => setState(() => _dailyHours = v),
            ),
            const SizedBox(height: 20),
            const Text('重要性'),
            Row(
              children: List.generate(5, (i) {
                final star = i + 1;
                return IconButton(
                  icon: Icon(
                    star <= _priority ? Icons.star : Icons.star_border,
                    color: star <= _priority ? Colors.amber : Colors.grey,
                    size: 32,
                  ),
                  onPressed: () => setState(() => _priority = star),
                );
              }),
            ),
            const SizedBox(height: 20),
            const Text('颜色'),
            Wrap(
              spacing: 8,
              children: _colorOptions.map((c) {
                final selected = c == _color;
                return GestureDetector(
                  onTap: () => setState(() => _color = c),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(c),
                      shape: BoxShape.circle,
                      border: selected ? Border.all(color: Colors.black, width: 3) : null,
                    ),
                    child: selected ? const Icon(Icons.check, color: Colors.white) : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: _save,
                child: Text(isEditing ? '保存修改' : '添加科目'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请输入科目名称')));
      return;
    }

    final minutes = (_dailyHours * 60).round();
    final actions = ref.read(subjectActionsProvider);

    if (widget.subject != null) {
      actions.updateSubject(
        id: widget.subject!.id,
        name: name,
        dailyMinutes: minutes,
        priority: _priority,
        color: _color,
      );
    } else {
      actions.addSubject(
        name: name,
        dailyMinutes: minutes,
        priority: _priority,
        color: _color,
      );
    }

    Navigator.pop(context);
  }
}
