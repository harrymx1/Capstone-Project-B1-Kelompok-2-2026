import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/transfer_schedule.dart';

class ScheduleTransferPage extends StatefulWidget {
  const ScheduleTransferPage({super.key});

  static const String routeName = '/schedule-transfer';

  @override
  State<ScheduleTransferPage> createState() => _ScheduleTransferPageState();
}

class _ScheduleTransferPageState extends State<ScheduleTransferPage> {
  final nameController = TextEditingController();

  int selectedDay = 19;
  int selectedMonth = 5;
  int selectedYear = 2026;

  static const monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 86,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    color: Colors.white,
                  ),
                  const Text(
                    'Set Scheduled Transaction',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Scheduled Name',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'Enter scheduled name',
                        hintStyle: const TextStyle(
                          color: Color(0xFFC4C4C4),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                        ),
                        enabledBorder: _outlineBorder(AppColors.border),
                        focusedBorder: _outlineBorder(AppColors.primary),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Center(
                      child: Text(
                        'Specific date',
                        style: TextStyle(
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Center(
                      child: Text(
                        'Choose date',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 42),
                    _CalendarHeader(
                      month: monthNames[selectedMonth - 1],
                      year: selectedYear,
                      onPreviousMonth: _previousMonth,
                      onNextYear: () => setState(() => selectedYear++),
                    ),
                    const SizedBox(height: 20),
                    const _WeekHeader(),
                    const SizedBox(height: 18),
                    _DateGrid(
                      selectedDay: selectedDay,
                      onSelected: (day) => setState(() => selectedDay = day),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 12, 28, 28),
              child: SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      TransferSchedule(
                        name: nameController.text,
                        day: selectedDay,
                        month: selectedMonth,
                        year: selectedYear,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Save Schedule',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _previousMonth() {
    setState(() {
      if (selectedMonth == 1) {
        selectedMonth = 12;
        selectedYear--;
      } else {
        selectedMonth--;
      }
    });
  }
}

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({
    required this.month,
    required this.year,
    required this.onPreviousMonth,
    required this.onNextYear,
  });

  final String month;
  final int year;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextYear;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: onPreviousMonth,
          child: Row(
            children: [
              Text(
                month,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 18),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text,
                size: 20,
              ),
            ],
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: onNextYear,
          child: Row(
            children: [
              Text(
                '$year',
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 18),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text,
                size: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WeekHeader extends StatelessWidget {
  const _WeekHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _WeekText('SUN'),
        _WeekText('MON'),
        _WeekText('TUE'),
        _WeekText('WED'),
        _WeekText('THU'),
        _WeekText('FRI'),
        _WeekText('SAT'),
      ],
    );
  }
}

class _WeekText extends StatelessWidget {
  const _WeekText(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFFBBC1CA),
        fontSize: 10,
        fontWeight: FontWeight.w800,
        letterSpacing: 1,
      ),
    );
  }
}

class _DateGrid extends StatelessWidget {
  const _DateGrid({required this.selectedDay, required this.onSelected});

  final int selectedDay;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 31,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 12,
        crossAxisSpacing: 4,
      ),
      itemBuilder: (context, index) {
        final day = index + 1;
        final isSelected = day == selectedDay;

        return InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => onSelected(day),
          child: Center(
            child: Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$day',
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.text,
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

OutlineInputBorder _outlineBorder(Color color) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: color),
  );
}
