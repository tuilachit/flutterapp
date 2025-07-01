import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/return_item.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 12); // Start at current month
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: AppTheme.primaryGradient,
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Calendar',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.today,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.view_agenda,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Track your return deadlines',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Calendar View
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Month Navigation
                  _MonthNavigation(
                    selectedDate: _selectedDate,
                    onPreviousMonth: () {
                      setState(() {
                        _selectedDate = DateTime(
                            _selectedDate.year, _selectedDate.month - 1);
                        _focusedDate = _selectedDate;
                      });
                    },
                    onNextMonth: () {
                      setState(() {
                        _selectedDate = DateTime(
                            _selectedDate.year, _selectedDate.month + 1);
                        _focusedDate = _selectedDate;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // Calendar Grid
                  _CalendarGrid(
                    selectedDate: _selectedDate,
                    focusedDate: _focusedDate,
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDate = date;
                        _focusedDate = date;
                      });
                    },
                  ),
                  const SizedBox(height: 32),

                  // Events for Selected Date
                  _EventsForDate(selectedDate: _selectedDate),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthNavigation extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  const _MonthNavigation({
    required this.selectedDate,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onPreviousMonth,
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.chevron_left,
              color: AppTheme.primaryPurple,
              size: 20,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            '${_getMonthName(selectedDate.month)} ${selectedDate.year}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryTextColor,
                ),
          ),
        ),
        IconButton(
          onPressed: onNextMonth,
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.chevron_right,
              color: AppTheme.primaryPurple,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
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
      'December'
    ];
    return months[month - 1];
  }
}

class _CalendarGrid extends StatelessWidget {
  final DateTime selectedDate;
  final DateTime focusedDate;
  final Function(DateTime) onDateSelected;

  const _CalendarGrid({
    required this.selectedDate,
    required this.focusedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Day headers
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) {
                return Expanded(
                  child: Text(
                    day,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.secondaryTextColor,
                        ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Calendar days
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              children: _buildCalendarWeeks(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCalendarWeeks() {
    final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    final lastDayOfMonth =
        DateTime(selectedDate.year, selectedDate.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday % 7; // Sunday = 0
    final daysInMonth = lastDayOfMonth.day;

    List<Widget> weeks = [];
    List<Widget> currentWeek = [];

    // Add empty cells for days before the first day of the month
    for (int i = 0; i < firstWeekday; i++) {
      currentWeek.add(const Expanded(child: SizedBox()));
    }

    // Add days of the month
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(selectedDate.year, selectedDate.month, day);
      final isSelected = date.year == selectedDate.year &&
          date.month == selectedDate.month &&
          date.day == selectedDate.day;
      final isToday = date.year == DateTime.now().year &&
          date.month == DateTime.now().month &&
          date.day == DateTime.now().day;
      final hasEvents = _hasEventsOnDate(date);

      currentWeek.add(
        Expanded(
          child: _CalendarDay(
            day: day,
            date: date,
            isSelected: isSelected,
            isToday: isToday,
            hasEvents: hasEvents,
            onTap: () => onDateSelected(date),
          ),
        ),
      );

      if (currentWeek.length == 7) {
        weeks.add(Row(children: currentWeek));
        currentWeek = [];
      }
    }

    // Add remaining days to the last week
    if (currentWeek.isNotEmpty) {
      while (currentWeek.length < 7) {
        currentWeek.add(const Expanded(child: SizedBox()));
      }
      weeks.add(Row(children: currentWeek));
    }

    return weeks;
  }

  bool _hasEventsOnDate(DateTime date) {
    // Check if there are any return deadlines on this date
    final mockItems = _getMockItems();
    return mockItems.any((item) {
      final deadline = item.returnDeadline;
      return deadline.year == date.year &&
          deadline.month == date.month &&
          deadline.day == date.day;
    });
  }

  List<ReturnItem> _getMockItems() {
    return [
      ReturnItem(
        id: '1',
        itemName: 'Pink Hoodie',
        brand: 'Urban Outfitters',
        store: 'Urban Outfitters',
        price: 45.00,
        size: 'M',
        color: 'Pink',
        category: 'Hoodie',
        condition: 'New with tags',
        photos: ['🩷'],
        status: ReturnStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        purchaseDate: DateTime.now().subtract(const Duration(days: 25)),
        returnDeadline: DateTime.now().add(const Duration(days: 2)),
        isOnlinePurchase: true,
        orderNumber: 'ORD-123456',
        notes: 'Size too small, need larger size',
      ),
      ReturnItem(
        id: '2',
        itemName: 'Leather Jacket',
        brand: 'Zara',
        store: 'Zara',
        price: 199.00,
        size: 'L',
        color: 'Black',
        category: 'Jacket',
        condition: 'New with tags',
        photos: ['🧥'],
        status: ReturnStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        purchaseDate: DateTime.now().subtract(const Duration(days: 20)),
        returnDeadline: DateTime.now().add(const Duration(days: 5)),
        isOnlinePurchase: false,
        receiptNumber: 'RCP-789012',
        notes: 'Not the right style',
      ),
    ];
  }
}

class _CalendarDay extends StatelessWidget {
  final int day;
  final DateTime date;
  final bool isSelected;
  final bool isToday;
  final bool hasEvents;
  final VoidCallback onTap;

  const _CalendarDay({
    required this.day,
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.hasEvents,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        height: 40,
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryPurple
              : isToday
                  ? AppTheme.primaryPurple.withOpacity(0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isToday && !isSelected
              ? Border.all(color: AppTheme.primaryPurple, width: 2)
              : null,
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                day.toString(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? Colors.white
                          : isToday
                              ? AppTheme.primaryPurple
                              : AppTheme.primaryTextColor,
                      fontWeight: isSelected || isToday
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
              ),
            ),
            if (hasEvents)
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : AppTheme.errorColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EventsForDate extends StatelessWidget {
  final DateTime selectedDate;

  const _EventsForDate({required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    final events = _getEventsForDate(selectedDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Events for ${_formatDate(selectedDate)}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const Spacer(),
            Text(
              '${events.length} events',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.secondaryTextColor,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (events.isEmpty)
          _EmptyEventsState()
        else
          ...events.map((event) => _EventCard(event: event)).toList(),
      ],
    );
  }

  List<ReturnItem> _getEventsForDate(DateTime date) {
    final mockItems = [
      ReturnItem(
        id: '1',
        itemName: 'Pink Hoodie',
        brand: 'Urban Outfitters',
        store: 'Urban Outfitters',
        price: 45.00,
        size: 'M',
        color: 'Pink',
        category: 'Hoodie',
        condition: 'New with tags',
        photos: ['🩷'],
        status: ReturnStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        purchaseDate: DateTime.now().subtract(const Duration(days: 25)),
        returnDeadline: DateTime.now().add(const Duration(days: 2)),
        isOnlinePurchase: true,
        orderNumber: 'ORD-123456',
        notes: 'Size too small, need larger size',
      ),
      ReturnItem(
        id: '2',
        itemName: 'Leather Jacket',
        brand: 'Zara',
        store: 'Zara',
        price: 199.00,
        size: 'L',
        color: 'Black',
        category: 'Jacket',
        condition: 'New with tags',
        photos: ['🧥'],
        status: ReturnStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        purchaseDate: DateTime.now().subtract(const Duration(days: 20)),
        returnDeadline: DateTime.now().add(const Duration(days: 5)),
        isOnlinePurchase: false,
        receiptNumber: 'RCP-789012',
        notes: 'Not the right style',
      ),
    ];

    return mockItems.where((item) {
      final deadline = item.returnDeadline;
      return deadline.year == date.year &&
          deadline.month == date.month &&
          deadline.day == date.day;
    }).toList();
  }

  String _formatDate(DateTime date) {
    const months = [
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
      'December'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}

class _EventCard extends StatelessWidget {
  final ReturnItem event;

  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final daysLeft = event.daysUntilDeadline;
    final isUrgent = event.isUrgent;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isUrgent
                  ? AppTheme.errorColor.withOpacity(0.1)
                  : AppTheme.primaryPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                event.photos.isNotEmpty ? event.photos.first : '📦',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.itemName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${event.brand} • ${event.store}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.secondaryTextColor,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isUrgent
                            ? AppTheme.errorColor.withOpacity(0.1)
                            : AppTheme.successColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isUrgent ? 'URGENT' : '$daysLeft days left',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isUrgent
                                  ? AppTheme.errorColor
                                  : AppTheme.successColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      event.formattedPrice,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryPurple,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyEventsState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.event_available,
                size: 32,
                color: AppTheme.primaryPurple,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No events today',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryTextColor,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'You\'re all caught up!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.secondaryTextColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
