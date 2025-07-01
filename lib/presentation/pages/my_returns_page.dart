import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/return_item.dart';
import '../widgets/enhanced_ui_components.dart';
import 'item_details_page.dart';

class MyReturnsPage extends StatefulWidget {
  const MyReturnsPage({super.key});

  @override
  State<MyReturnsPage> createState() => _MyReturnsPageState();
}

class _MyReturnsPageState extends State<MyReturnsPage> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> _filterOptions = ['All', 'Urgent', 'Pending', 'Completed'];

  // Mock data for demonstration
  final List<ReturnItem> _mockItems = [
    ReturnItem(
      id: '1',
      itemName: 'Pink Hoodie',
      brand: 'Nike',
      store: 'Urban Outfitters',
      price: 45.00,
      purchaseDate: DateTime.now().subtract(const Duration(days: 5)),
      returnDeadline: DateTime.now().add(const Duration(days: 2)),
      size: 'M',
      color: 'Pink',
      category: 'Hoodie',
      condition: 'New with tags',
      isOnlinePurchase: true,
      status: ReturnStatus.pending,
      createdAt: DateTime.now(),
      photos: ['🩷'],
    ),
    ReturnItem(
      id: '2',
      itemName: 'Leather Jacket',
      brand: 'Zara',
      store: 'Zara',
      price: 199.00,
      purchaseDate: DateTime.now().subtract(const Duration(days: 10)),
      returnDeadline: DateTime.now().add(const Duration(days: 5)),
      size: 'L',
      color: 'Black',
      category: 'Jacket',
      condition: 'Excellent',
      isOnlinePurchase: false,
      status: ReturnStatus.pending,
      createdAt: DateTime.now(),
      photos: ['🧥'],
    ),
    ReturnItem(
      id: '3',
      itemName: 'Washed Blue Jeans',
      brand: 'H&M',
      store: 'H&M',
      price: 35.00,
      purchaseDate: DateTime.now().subtract(const Duration(days: 15)),
      returnDeadline: DateTime.now().add(const Duration(days: 7)),
      size: '32',
      color: 'Blue',
      category: 'Jeans',
      condition: 'Good',
      isOnlinePurchase: true,
      status: ReturnStatus.pending,
      createdAt: DateTime.now(),
      photos: ['👖'],
    ),
  ];

  List<ReturnItem> get _filteredItems {
    List<ReturnItem> items = _mockItems;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      items = items.where((item) {
        final query = _searchQuery.toLowerCase();
        return item.itemName.toLowerCase().contains(query) ||
            item.brand.toLowerCase().contains(query) ||
            item.store.toLowerCase().contains(query) ||
            item.category.toLowerCase().contains(query) ||
            item.color.toLowerCase().contains(query);
      }).toList();
    }

    // Apply status filter
    switch (_selectedFilter) {
      case 'Urgent':
        items = items.where((item) => item.isUrgent).toList();
        break;
      case 'Pending':
        items =
            items.where((item) => item.status == ReturnStatus.pending).toList();
        break;
      case 'Completed':
        items = items
            .where((item) => item.status == ReturnStatus.completed)
            .toList();
        break;
      case 'All':
      default:
        break;
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with Search and Filter
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
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
                            'My Returns',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.sort,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Search Bar
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Search items, brands, stores...',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 16,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey[400],
                            ),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      color: Colors.grey[400],
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {
                                        _searchQuery = '';
                                      });
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Filter Chips
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Filter by:',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.secondaryTextColor,
                            ),
                      ),
                      const Spacer(),
                      Text(
                        '${_filteredItems.length} items',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.secondaryTextColor,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _filterOptions.map((filter) {
                        final isSelected = _selectedFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: _CustomFilterChip(
                            selected: isSelected,
                            label: filter,
                            onSelected: (selected) {
                              setState(() {
                                _selectedFilter = filter;
                              });
                            },
                            backgroundColor: Colors.white,
                            selectedColor:
                                AppTheme.primaryPurple.withOpacity(0.1),
                            checkmarkColor: AppTheme.primaryPurple,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? AppTheme.primaryPurple
                                  : AppTheme.secondaryTextColor,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                            side: BorderSide(
                              color: isSelected
                                  ? AppTheme.primaryPurple
                                  : Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Items List
          _filteredItems.isEmpty
              ? SliverFillRemaining(
                  child: _EmptyState(
                    searchQuery: _searchQuery,
                    selectedFilter: _selectedFilter,
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _ProductItemCard(
                            item: _filteredItems[index],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ItemDetailsPage(
                                      item: _filteredItems[index]),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      childCount: _filteredItems.length,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

class _CustomFilterChip extends StatelessWidget {
  final bool selected;
  final String label;
  final ValueChanged<bool> onSelected;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? checkmarkColor;
  final TextStyle? labelStyle;
  final BorderSide? side;

  const _CustomFilterChip({
    required this.selected,
    required this.label,
    required this.onSelected,
    this.backgroundColor,
    this.selectedColor,
    this.checkmarkColor,
    this.labelStyle,
    this.side,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: selected,
      label: Text(label),
      onSelected: onSelected,
      backgroundColor: backgroundColor,
      selectedColor: selectedColor,
      checkmarkColor: checkmarkColor,
      labelStyle: labelStyle,
      side: side,
    );
  }
}

class _ProductItemCard extends StatelessWidget {
  final ReturnItem item;
  final VoidCallback onTap;

  const _ProductItemCard({required this.item, required this.onTap});

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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Item Image/Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      item.photos.isNotEmpty ? item.photos.first : '📦',
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Item Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.itemName,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                          _StatusChip(status: item.status),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item.brand} • ${item.store}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.secondaryTextColor,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            item.formattedPrice,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryPurple,
                                ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '• ${item.size} • ${item.color}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.lightTextColor,
                                    ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Return Status Info
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: item.isUrgent
                      ? AppTheme.errorColor
                      : AppTheme.successColor,
                ),
                const SizedBox(width: 8),
                Text(
                  item.status == ReturnStatus.completed
                      ? 'Returned ${item.returnedAt != null ? '${DateTime.now().difference(item.returnedAt!).inDays} days ago' : ''}'
                      : '${item.daysUntilDeadline} days left to return',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: item.status == ReturnStatus.completed
                            ? AppTheme.successColor
                            : (item.isUrgent
                                ? AppTheme.errorColor
                                : AppTheme.secondaryTextColor),
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: AppTheme.primaryPurple,
                    size: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final ReturnStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;

    switch (status) {
      case ReturnStatus.pending:
        color = AppTheme.warningColor;
        text = 'Pending';
        break;
      case ReturnStatus.inProgress:
        color = AppTheme.infoColor;
        text = 'In Progress';
        break;
      case ReturnStatus.completed:
        color = AppTheme.successColor;
        text = 'Completed';
        break;
      case ReturnStatus.expired:
        color = AppTheme.errorColor;
        text = 'Expired';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String searchQuery;
  final String selectedFilter;

  const _EmptyState({
    required this.searchQuery,
    required this.selectedFilter,
  });

  @override
  Widget build(BuildContext context) {
    String message;
    String subtitle;
    IconData icon;

    if (searchQuery.isNotEmpty) {
      message = 'No items found';
      subtitle = 'Try adjusting your search terms';
      icon = Icons.search_off;
    } else if (selectedFilter != 'All') {
      message = 'No $selectedFilter items';
      subtitle = 'All your $selectedFilter items will appear here';
      icon = Icons.filter_list_off;
    } else {
      message = 'No returns yet';
      subtitle = 'Add your first return to get started';
      icon = Icons.shopping_bag_outlined;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                icon,
                size: 48,
                color: AppTheme.primaryPurple,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryTextColor,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.secondaryTextColor,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
