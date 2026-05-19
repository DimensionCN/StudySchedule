import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WeekCalendarBar extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const WeekCalendarBar({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  static const _dayNames = ['一', '二', '三', '四', '五', '六', '日'];

  @override
  Widget build(BuildContext context) {
    final monday = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLarge, vertical: AppTheme.spacingSmall),
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingMedium, horizontal: AppTheme.spacingXS),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left, size: 20, color: Theme.of(context).colorScheme.primary),
            onPressed: () {
              final prevWeek = selectedDate.subtract(const Duration(days: 7));
              onDateSelected(prevWeek);
            },
          ),
          ...List.generate(7, (i) {
            final date = monday.add(Duration(days: i));
            final dateOnly = DateTime(date.year, date.month, date.day);
            final isSelected = dateOnly == DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
            final isToday = dateOnly == todayDate;

            return Expanded(
              child: GestureDetector(
                onTap: () => onDateSelected(date),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isToday && !isSelected
                        ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3)
                        : null,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ] : null,
                  ),
                  child: Column(
                    children: [
                      Text(
                        _dayNames[i],
                        style: TextStyle(
                          fontSize: AppTheme.fontSmall,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected
                              ? Colors.white
                              : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: isToday && !isSelected
                            ? BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 1.5,
                                ),
                              )
                            : null,
                        child: Text(
                          '${date.day}',
                          style: TextStyle(
                            fontSize: AppTheme.fontLarge,
                            fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : isToday
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          IconButton(
            icon: Icon(Icons.chevron_right, size: 20, color: Theme.of(context).colorScheme.primary),
            onPressed: () {
              final nextWeek = selectedDate.add(const Duration(days: 7));
              onDateSelected(nextWeek);
            },
          ),
        ],
      ),
    );
  }
}
