import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/return_item.dart';

class ManualEntryPage extends StatefulWidget {
  const ManualEntryPage({super.key});

  @override
  State<ManualEntryPage> createState() => _ManualEntryPageState();
}

class _ManualEntryPageState extends State<ManualEntryPage> {
  final _formKey = GlobalKey<FormState>();
  final _itemNameController = TextEditingController();
  final _brandController = TextEditingController();
  final _storeController = TextEditingController();
  final _priceController = TextEditingController();
  final _sizeController = TextEditingController();
  final _colorController = TextEditingController();
  final _receiptNumberController = TextEditingController();
  final _orderNumberController = TextEditingController();
  final _notesController = TextEditingController();

  final supabase = Supabase.instance.client;
  final uuid = const Uuid();
  bool _isLoading = false;

  DateTime? _purchaseDate;
  DateTime? _returnDeadline;
  String _selectedCategory = 'T-Shirt';
  String _selectedCondition = 'New with tags';
  String _selectedBrand = 'Kmart';
  bool _isOnlinePurchase = false;

  final List<String> _categories = [
    'T-Shirt',
    'Hoodie',
    'Jacket',
    'Jeans',
    'Dress',
    'Shoes',
    'Accessories',
    'Other',
  ];

  final List<String> _australianBrands = [
    'Kmart',
    'Zara',
    'H&M',
    'Uniqlo',
    'Cotton On',
    'Target',
    'Myer',
    'David Jones',
    'Country Road',
    'Witchery',
    'Seed Heritage',
    'Sportsgirl',
    'Forever New',
    'Portmans',
    'ASOS',
    'Bonds',
    'Rip Curl',
    'Billabong',
    'Quiksilver',
    'Lorna Jane',
    'Other',
  ];

  final List<String> _conditions = [
    'New with tags',
    'New without tags',
    'Excellent',
    'Good',
    'Fair',
  ];

  @override
  void dispose() {
    _itemNameController.dispose();
    _brandController.dispose();
    _storeController.dispose();
    _priceController.dispose();
    _sizeController.dispose();
    _colorController.dispose();
    _receiptNumberController.dispose();
    _orderNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 100,
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
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Manual Entry',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                                Text(
                                  'Enter your item details',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Form Content
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverToBoxAdapter(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Basic Information Section
                    _SectionHeader(
                      title: 'Basic Information',
                      icon: Icons.info_outline,
                    ),
                    const SizedBox(height: 16),

                    _CustomTextField(
                      controller: _itemNameController,
                      label: 'Item Name',
                      hint: 'e.g., Pink Hoodie',
                      icon: Icons.shopping_bag_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter item name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _CustomDropdown(
                            value: _selectedBrand,
                            label: 'Brand',
                            icon: Icons.label_outline,
                            items: _australianBrands,
                            onChanged: (value) {
                              setState(() {
                                _selectedBrand = value!;
                                // Auto-fill store if brand is selected and store is empty
                                if (_storeController.text.isEmpty &&
                                    value != 'Other') {
                                  _storeController.text = value;
                                }
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _CustomTextField(
                            controller: _storeController,
                            label: 'Store',
                            hint: 'e.g., Zara',
                            icon: Icons.store_outlined,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter store';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),

                    if (_selectedBrand == 'Other') ...[
                      const SizedBox(height: 16),
                      _CustomTextField(
                        controller: _brandController,
                        label: 'Custom Brand',
                        hint: 'Enter brand name',
                        icon: Icons.label_outline,
                        validator: (value) {
                          if (_selectedBrand == 'Other' &&
                              (value == null || value.isEmpty)) {
                            return 'Please enter brand name';
                          }
                          return null;
                        },
                      ),
                    ],

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _CustomTextField(
                            controller: _priceController,
                            label: 'Price',
                            hint: '45.00',
                            icon: Icons.attach_money,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter price';
                              }
                              final price = double.tryParse(value);
                              if (price == null || price <= 0) {
                                return 'Please enter valid price';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _CustomDropdown(
                            value: _selectedCategory,
                            label: 'Category',
                            icon: Icons.category_outlined,
                            items: _categories,
                            onChanged: (value) =>
                                setState(() => _selectedCategory = value!),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Item Details Section
                    _SectionHeader(
                      title: 'Item Details',
                      icon: Icons.details_outlined,
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _CustomTextField(
                            controller: _sizeController,
                            label: 'Size',
                            hint: 'M, L, 32, etc.',
                            icon: Icons.straighten,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter size';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _CustomTextField(
                            controller: _colorController,
                            label: 'Color',
                            hint: 'e.g., Black',
                            icon: Icons.palette_outlined,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter color';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _CustomDropdown(
                      value: _selectedCondition,
                      label: 'Condition',
                      icon: Icons.grade_outlined,
                      items: _conditions,
                      onChanged: (value) =>
                          setState(() => _selectedCondition = value!),
                    ),

                    const SizedBox(height: 32),

                    // Purchase Information Section
                    _SectionHeader(
                      title: 'Purchase Information',
                      icon: Icons.receipt_outlined,
                    ),
                    const SizedBox(height: 16),

                    _DatePicker(
                      label: 'Purchase Date',
                      value: _purchaseDate,
                      onTap: () => _selectPurchaseDate(context),
                      icon: Icons.calendar_today_outlined,
                    ),
                    const SizedBox(height: 16),

                    _DatePicker(
                      label: 'Return Deadline',
                      value: _returnDeadline,
                      onTap: () => _selectReturnDeadline(context),
                      icon: Icons.schedule_outlined,
                    ),
                    const SizedBox(height: 16),

                    _CustomSwitchTile(
                      title: 'Online Purchase',
                      subtitle: 'Was this purchased online?',
                      value: _isOnlinePurchase,
                      onChanged: (value) =>
                          setState(() => _isOnlinePurchase = value),
                    ),

                    const SizedBox(height: 16),

                    if (_isOnlinePurchase) ...[
                      _CustomTextField(
                        controller: _orderNumberController,
                        label: 'Order Number',
                        hint: 'e.g., ORD123456',
                        icon: Icons.confirmation_number_outlined,
                      ),
                      const SizedBox(height: 16),
                    ],

                    _CustomTextField(
                      controller: _receiptNumberController,
                      label: 'Receipt Number (Optional)',
                      hint: 'e.g., RCP789012',
                      icon: Icons.receipt_long_outlined,
                    ),

                    const SizedBox(height: 32),

                    // Additional Notes Section
                    _SectionHeader(
                      title: 'Additional Notes',
                      icon: Icons.note_outlined,
                    ),
                    const SizedBox(height: 16),

                    _CustomTextField(
                      controller: _notesController,
                      label: 'Notes (Optional)',
                      hint: 'Any additional information...',
                      icon: Icons.notes,
                      maxLines: 3,
                    ),

                    const SizedBox(height: 40),

                    // Save Button
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryPurple.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveItem,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                        ),
                        child: _isLoading
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Saving...',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )
                            : const Text(
                                'Save Return Item',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectPurchaseDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _purchaseDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _purchaseDate) {
      setState(() {
        _purchaseDate = picked;
        // Auto-calculate return deadline (30 days from purchase)
        _returnDeadline ??= picked.add(const Duration(days: 30));
      });
    }
  }

  Future<void> _selectReturnDeadline(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _returnDeadline ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _returnDeadline) {
      setState(() {
        _returnDeadline = picked;
      });
    }
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) return;

    if (_purchaseDate == null) {
      _showErrorSnackBar('Please select purchase date');
      return;
    }
    if (_returnDeadline == null) {
      _showErrorSnackBar('Please select return deadline');
      return;
    }

    // Check if user is authenticated
    final user = supabase.auth.currentUser;
    if (user == null) {
      _showErrorSnackBar('Please sign in to save items');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create return item
      final itemId = uuid.v4();
      final item = ReturnItem(
        id: itemId,
        itemName: _itemNameController.text,
        brand:
            _selectedBrand == 'Other' ? _brandController.text : _selectedBrand,
        store: _storeController.text,
        price: double.parse(_priceController.text),
        purchaseDate: _purchaseDate!,
        returnDeadline: _returnDeadline!,
        size: _sizeController.text,
        color: _colorController.text,
        category: _selectedCategory,
        condition: _selectedCondition,
        isOnlinePurchase: _isOnlinePurchase,
        status: ReturnStatus.pending,
        createdAt: DateTime.now(),
        receiptNumber: _receiptNumberController.text.isNotEmpty
            ? _receiptNumberController.text
            : null,
        orderNumber: _orderNumberController.text.isNotEmpty
            ? _orderNumberController.text
            : null,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      // Save to Supabase
      await supabase.from('return_items').insert({
        'id': item.id,
        'user_id': user.id,
        'item_name': item.itemName,
        'brand': item.brand,
        'store': item.store,
        'category': item.category,
        'size': item.size,
        'color': item.color,
        'price': item.price,
        'purchase_date': item.purchaseDate.toIso8601String(),
        'return_deadline': item.returnDeadline.toIso8601String(),
        'status': item.status.toString().split('.').last,
        'condition': item.condition,
        'is_online_purchase': item.isOnlinePurchase,
        'receipt_number': item.receiptNumber,
        'order_number': item.orderNumber,
        'notes': item.notes,
        'created_at': item.createdAt.toIso8601String(),
        'updated_at': item.createdAt.toIso8601String(),
      });

      // Show success and navigate back
      _showSuccessSnackBar('Return item saved successfully!');
      Navigator.pop(context, item);
    } catch (e) {
      _showErrorSnackBar('Error saving item: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int maxLines;

  const _CustomTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryTextColor,
              ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppTheme.primaryPurple),
          ),
        ),
      ],
    );
  }
}

class _CustomDropdown extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final List<String> items;
  final void Function(String?) onChanged;

  const _CustomDropdown({
    required this.value,
    required this.label,
    required this.icon,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryTextColor,
              ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppTheme.primaryPurple),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _DatePicker extends StatelessWidget {
  final String label;
  final DateTime? value;
  final VoidCallback onTap;
  final IconData icon;

  const _DatePicker({
    required this.label,
    required this.value,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryTextColor,
              ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: AppTheme.primaryPurple),
                const SizedBox(width: 16),
                Text(
                  value != null
                      ? '${value!.day}/${value!.month}/${value!.year}'
                      : 'Select date',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: value != null
                            ? AppTheme.primaryTextColor
                            : AppTheme.lightTextColor,
                      ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_drop_down,
                  color: AppTheme.primaryPurple,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CustomSwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final void Function(bool) onChanged;

  const _CustomSwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.secondaryTextColor,
                      ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primaryPurple,
          ),
        ],
      ),
    );
  }
}
