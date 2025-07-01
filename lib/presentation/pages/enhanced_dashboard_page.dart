import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/return_item.dart';
import '../widgets/enhanced_ui_components.dart';
import 'item_details_page.dart';
import 'my_returns_page.dart';
import 'manual_entry_page.dart';
import 'calendar_page.dart';

class EnhancedDashboardPage extends StatefulWidget {
  const EnhancedDashboardPage({super.key});

  @override
  State<EnhancedDashboardPage> createState() => _EnhancedDashboardPageState();
}

class _EnhancedDashboardPageState extends State<EnhancedDashboardPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Supabase client
  final supabase = Supabase.instance.client;

  // Data
  List<ReturnItem> _returnItems = [];
  Map<String, int> _statistics = {
    'total': 0,
    'pending': 0,
    'urgent': 0,
    'completed': 0,
  };
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadDashboardData();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadDashboardData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Check if user is authenticated
      final user = supabase.auth.currentUser;
      if (user == null) {
        setState(() {
          _error = 'Please sign in to view your returns';
          _isLoading = false;
        });
        return;
      }

      // Load return items from Supabase
      final response = await supabase
          .from('return_items')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      final List<ReturnItem> items = response
          .map<ReturnItem>((json) => ReturnItem.fromJson(json))
          .toList();

      // Calculate statistics
      final stats = {
        'total': items.length,
        'pending':
            items.where((item) => item.status == ReturnStatus.pending).length,
        'urgent': items
            .where(
                (item) => item.isUrgent && item.status == ReturnStatus.pending)
            .length,
        'completed':
            items.where((item) => item.status == ReturnStatus.completed).length,
      };

      setState(() {
        _returnItems = items;
        _statistics = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error loading data: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _handleSignOut() async {
    try {
      await supabase.auth.signOut();
      // Navigate to sign in page or splash
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/splash');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _onReturnCompleted() {
    _animationController.forward().then((_) {
      _animationController.reset();
    });
    _showSnackbar('🎉 Return completed successfully!');
  }

  Widget _buildQuickStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Stats',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AnimatedStatCard(
                  title: 'Active Returns',
                  count: '${_statistics['urgent']} urgent',
                  subtitle: 'Total: ${_statistics['pending']}',
                  icon: Icons.assignment_outlined,
                  color: Theme.of(context).colorScheme.primary,
                  onTap: () {
                    _showSnackbar('Viewing active returns');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyReturnsPage(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AnimatedStatCard(
                  title: 'Completed',
                  count: '${_statistics['completed']}',
                  subtitle: 'This month',
                  icon: Icons.check_circle_outline,
                  color: AppTheme.successColor,
                  onTap: () {
                    _showSnackbar('Viewing completed returns');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          QuickActionButton(
            icon: Icons.add_shopping_cart,
            label: 'Add New Return',
            color: Theme.of(context).colorScheme.primary,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ManualEntryPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          QuickActionButton(
            icon: Icons.camera_alt_outlined,
            label: 'Scan Receipt',
            color: Theme.of(context).colorScheme.secondary,
            onTap: () {
              _showSnackbar('Opening receipt scanner');
            },
          ),
          const SizedBox(height: 12),
          QuickActionButton(
            icon: Icons.schedule,
            label: 'Set Reminder',
            color: AppTheme.warningColor,
            onTap: () {
              _showSnackbar('Reminder set for urgent returns');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecentReturns() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Returns',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyReturnsPage(),
                    ),
                  );
                },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _returnItems.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = _returnItems[index];
              return EnhancedReturnItemCard(
                item: item,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemDetailsPage(item: item),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SkeletonLoader(
              height: 100, borderRadius: BorderRadius.all(Radius.circular(16))),
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(
                  child: SkeletonLoader(
                      height: 120,
                      borderRadius: BorderRadius.all(Radius.circular(16)))),
              const SizedBox(width: 16),
              const Expanded(
                  child: SkeletonLoader(
                      height: 120,
                      borderRadius: BorderRadius.all(Radius.circular(16)))),
            ],
          ),
          const SizedBox(height: 24),
          ...List.generate(
              3,
              (index) => const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: SkeletonLoader(
                        height: 80,
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                  )),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          _buildQuickStats(),
          const SizedBox(height: 32),
          _buildQuickActions(),
          const SizedBox(height: 32),
          _buildRecentReturns(),
          const SizedBox(height: 100), // Space for bottom navigation
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return Center(child: Text(_error!));
    }

    return _buildMainContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          // Enhanced Header
          EnhancedAppHeader(
            userName: 'Alex',
            hasNotifications: _returnItems.any((item) => item.isUrgent),
            onNotificationTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Notifications'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_returnItems.any((item) => item.isUrgent))
                        ListTile(
                          leading: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          title: const Text('Urgent Return Alert'),
                          subtitle: const Text(
                              'You have items due for return in 2 days'),
                        ),
                      const ListTile(
                        leading: Icon(Icons.info_outline, color: Colors.blue),
                        title: Text('Reminder Set'),
                        subtitle:
                            Text('Return reminder scheduled for tomorrow'),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
            onProfileTap: () {
              _showSnackbar('Profile settings coming soon!');
            },
          ),

          // Main Content
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),

      // Enhanced Bottom Navigation
      bottomNavigationBar: EnhancedBottomNavigation(
        currentIndex: 0,
        onTap: (index) {
          // Simulate loading for navigation
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              // Handle navigation
            }
          });
        },
      ),

      // Floating Action Button for quick add
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Add Return',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ManualEntryPage(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Manual Entry'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _showSnackbar('Receipt scanner opening...');
                          },
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Scan Receipt'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Return'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
