import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/return_item.dart';

class ItemDetailsPage extends StatelessWidget {
  final ReturnItem item;

  const ItemDetailsPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with Item Image
          SliverAppBar(
            expandedHeight: 250,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    // TODO: Navigate to edit page
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF8B5CF6),
                      Color(0xFF6366F1),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Item Image/Icon
                    Center(
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            item.photos.isNotEmpty ? item.photos.first : '📦',
                            style: const TextStyle(fontSize: 48),
                          ),
                        ),
                      ),
                    ),

                    // Urgency Badge
                    if (item.isUrgent)
                      Positioned(
                        top: 60,
                        right: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppTheme.errorColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.errorColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.warning,
                                  color: Colors.white, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                'URGENT',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Item Information
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Item Title and Status
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.itemName,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${item.brand} • ${item.store}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppTheme.secondaryTextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ),
                    _StatusChip(status: item.status),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  item.formattedPrice,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: AppTheme.primaryPurple,
                        fontWeight: FontWeight.w800,
                      ),
                ),

                const SizedBox(height: 32),

                // Time Remaining Card
                _TimeRemainingCard(item: item),

                const SizedBox(height: 24),

                // Item Details Card
                _DetailsCard(
                  title: 'Item Details',
                  icon: Icons.info_outline,
                  children: [
                    _DetailRow(label: 'Category', value: item.category),
                    _DetailRow(label: 'Size', value: item.size),
                    _DetailRow(label: 'Color', value: item.color),
                    _DetailRow(label: 'Condition', value: item.condition),
                    if (item.receiptNumber != null)
                      _DetailRow(
                          label: 'Receipt #', value: item.receiptNumber!),
                    if (item.orderNumber != null)
                      _DetailRow(label: 'Order #', value: item.orderNumber!),
                  ],
                ),

                const SizedBox(height: 16),

                // Purchase Information Card
                _DetailsCard(
                  title: 'Purchase Information',
                  icon: Icons.receipt_outlined,
                  children: [
                    _DetailRow(
                      label: 'Purchase Date',
                      value:
                          '${item.purchaseDate.day}/${item.purchaseDate.month}/${item.purchaseDate.year}',
                    ),
                    _DetailRow(
                      label: 'Return Deadline',
                      value:
                          '${item.returnDeadline.day}/${item.returnDeadline.month}/${item.returnDeadline.year}',
                    ),
                    _DetailRow(
                      label: 'Purchase Type',
                      value: item.isOnlinePurchase ? 'Online' : 'In-Store',
                    ),
                    if (item.storeLocation != null)
                      _DetailRow(
                          label: 'Store Location', value: item.storeLocation!),
                  ],
                ),

                const SizedBox(height: 16),

                // Return Policy Card
                _ReturnPolicyCard(brand: item.brand),

                if (item.notes != null && item.notes!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _DetailsCard(
                    title: 'Notes',
                    icon: Icons.note_outlined,
                    children: [
                      Text(
                        item.notes!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 32),

                // Action Buttons
                if (item.status == ReturnStatus.pending) ...[
                  _ActionButton(
                    icon: Icons.assignment_return,
                    label: 'Start Return Process',
                    color: AppTheme.primaryPurple,
                    onPressed: () => _startReturnProcess(context),
                  ),
                  const SizedBox(height: 16),
                ],

                Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.schedule,
                        label: 'Set Reminder',
                        color: AppTheme.secondaryPurple,
                        isOutlined: true,
                        onPressed: () => _setReminder(context),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.share,
                        label: 'Share',
                        color: AppTheme.lightPurple,
                        isOutlined: true,
                        onPressed: () => _shareItem(context),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _startReturnProcess(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Start Return Process',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'Choose how you\'d like to return this item',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.secondaryTextColor,
                  ),
            ),
            const SizedBox(height: 24),
            _ActionButton(
              icon: Icons.store,
              label: 'Return to Store',
              color: AppTheme.primaryPurple,
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Store return process started')),
                );
              },
            ),
            const SizedBox(height: 16),
            _ActionButton(
              icon: Icons.local_shipping,
              label: 'Request Pickup',
              color: AppTheme.secondaryPurple,
              isOutlined: true,
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pickup request submitted')),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _setReminder(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reminder set for 3 days before deadline')),
    );
  }

  void _shareItem(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Return details shared')),
    );
  }
}

class _TimeRemainingCard extends StatelessWidget {
  final ReturnItem item;

  const _TimeRemainingCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final daysLeft = item.daysUntilDeadline;
    final isUrgent = item.isUrgent;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isUrgent
              ? [AppTheme.errorColor, const Color(0xFFFF6B6B)]
              : [AppTheme.successColor, const Color(0xFF34D399)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isUrgent ? AppTheme.errorColor : AppTheme.successColor)
                .withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              isUrgent ? Icons.warning : Icons.schedule,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.status == ReturnStatus.completed
                      ? 'Return Completed'
                      : '$daysLeft days left',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.status == ReturnStatus.completed
                      ? 'Successfully returned on ${item.returnedAt != null ? "${item.returnedAt!.day}/${item.returnedAt!.month}/${item.returnedAt!.year}" : "N/A"}'
                      : isUrgent
                          ? 'Return deadline is approaching!'
                          : 'You have time to return this item',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _DetailsCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primaryPurple,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.secondaryTextColor,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReturnPolicyCard extends StatelessWidget {
  final String brand;

  const _ReturnPolicyCard({required this.brand});

  Map<String, Map<String, String>> get returnPolicies => {
        'Kmart': {
          'period': '30 days',
          'receipt': 'Required',
          'condition': 'Unworn with tags',
          'refund': 'Full refund or exchange',
          'notes':
              'Underwear, swimwear, and pierced jewellery cannot be returned for hygiene reasons.',
        },
        'Zara': {
          'period': '30 days',
          'receipt': 'Required',
          'condition': 'Unworn with tags',
          'refund': 'Full refund or exchange',
          'notes':
              'Items must be in original condition. Swimwear, underwear, and personalised items excluded.',
        },
        'H&M': {
          'period': '30 days',
          'receipt': 'Required',
          'condition': 'Unworn with tags',
          'refund': 'Full refund or exchange',
          'notes':
              'Beauty products, underwear, swimwear, and pierced jewelry cannot be returned.',
        },
        'Uniqlo': {
          'period': '90 days',
          'receipt': 'Required',
          'condition': 'Unworn with tags',
          'refund': 'Full refund or exchange',
          'notes':
              'Underwear, innerwear, swimwear, and socks cannot be returned for hygiene reasons.',
        },
        'Cotton On': {
          'period': '30 days',
          'receipt': 'Required',
          'condition': 'Unworn with tags',
          'refund': 'Full refund or exchange',
          'notes': 'Underwear, swimwear, and cosmetics cannot be returned.',
        },
        'Target': {
          'period': '30 days',
          'receipt': 'Required',
          'condition': 'Unworn with tags',
          'refund': 'Full refund or exchange',
          'notes':
              'Some items like underwear, swimwear, and personalised items are excluded.',
        },
        'Myer': {
          'period': '30 days',
          'receipt': 'Required',
          'condition': 'Unworn with tags',
          'refund': 'Full refund or exchange',
          'notes':
              'Beauty products, underwear, swimwear, and food items cannot be returned.',
        },
        'David Jones': {
          'period': '30 days',
          'receipt': 'Required',
          'condition': 'Unworn with tags',
          'refund': 'Full refund or exchange',
          'notes':
              'Beauty products, underwear, swimwear, and personalised items excluded.',
        },
      };

  @override
  Widget build(BuildContext context) {
    final policy = returnPolicies[brand] ??
        {
          'period': '30 days',
          'receipt': 'Required',
          'condition': 'Unworn with tags',
          'refund': 'Store credit or exchange',
          'notes': 'Check store policy for specific conditions.',
        };

    return _DetailsCard(
      title: '$brand Return Policy',
      icon: Icons.policy_outlined,
      children: [
        _DetailRow(label: 'Return Period', value: policy['period']!),
        _DetailRow(label: 'Receipt', value: policy['receipt']!),
        _DetailRow(label: 'Condition', value: policy['condition']!),
        _DetailRow(label: 'Refund Type', value: policy['refund']!),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.warningColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline,
                color: AppTheme.warningColor,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  policy['notes']!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.warningColor,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isOutlined;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    this.isOutlined = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
