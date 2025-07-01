import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/return_item.dart';
import '../widgets/enhanced_ui_components.dart';
import '../providers/auth_provider.dart';
import '../providers/return_items_provider.dart';
import 'item_details_page.dart';
import 'my_returns_page.dart';
import 'manual_entry_page.dart';
import 'calendar_page.dart';
import 'auth_page.dart';

class EnhancedDashboardPage extends ConsumerStatefulWidget {
  const EnhancedDashboardPage({super.key});

  @override
  ConsumerState<EnhancedDashboardPage> createState() => _EnhancedDashboardPageState();
}

class _EnhancedDashboardPageState extends ConsumerState<EnhancedDashboardPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
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

  Future<void> _handleSignOut() async {
    try {
      final authService = ref.read(authServiceProvider);
      final result = await authService.signOut();
      
      result.fold(
        (failure) {
          _showSnackbar('Error signing out: ${failure.message}');
        },
        (_) {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const AuthPage()),
            );
          }
        },
      );
    } catch (e) {
      _showSnackbar('Error signing out: $e');
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
          Consumer(
            builder: (context, ref, child) {
              final statsAsync = ref.watch(returnItemStatsProvider);
              
              return statsAsync.when(
                data: (stats) => Row(
                  children: [
                    Expanded(
                      child: AnimatedStatCard(
                        title: 'Active Returns',
                        count: '${stats.urgentItems} urgent',
                        subtitle: 'Total: ${stats.pendingItems}',
                        icon: Icons.assignment_outlined,
                        color: Theme.of(context).colorScheme.primary,
                        onTap: () {
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
                        count: '${stats.completedItems}',
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
                loading: () => Row(
                  children: [
                    const Expanded(
                      child: SkeletonLoader(
                        height: 120,
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: SkeletonLoader(
                        height: 120,
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                  ],
                ),
                error: (error, stack) => Text('Error loading stats: $error'),
              );
            },
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
          Consumer(
            builder: (context, ref, child) {
              final returnItemsAsync = ref.watch(returnItemsProvider);
              
              return returnItemsAsync.when(
                data: (items) {
                  if (items.isEmpty) {
                    return const EmptyStateWidget(
                      title: 'No returns yet',
                      description: 'Add your first return to get started',
                      buttonText: 'Add Return',
                      icon: Icons.shopping_bag_outlined,
                    );
                  }
                  
                  // Show only the first 3 items
                  final recentItems = items.take(3).toList();
                  
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recentItems.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = recentItems[index];
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
                  );
                },
                loading: () => Column(
                  children: List.generate(
                    3,
                    (index) => const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: SkeletonLoader(
                        height: 80,
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                  ),
                ),
                error: (error, stack) => Center(
                  child: Column(
                    children: [
                      Text('Error loading returns: $error'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.invalidate(returnItemsProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
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

  @override
  Widget build(BuildContext context) {
    // Watch auth state
    final authState = ref.watch(authStateProvider);
    final currentUser = ref.watch(currentUserProvider);

    return authState.when(
      data: (state) {
        // If not authenticated, redirect to auth page
        if (state.session == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const AuthPage()),
            );
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: Column(
            children: [
              // Enhanced Header
              EnhancedAppHeader(
                userName: currentUser?.userMetadata?['full_name'] ?? 
                         currentUser?.email?.split('@').first ?? 
                         'User',
                hasNotifications: true, // You can make this dynamic based on urgent items
                onNotificationTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Notifications'),
                      content: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(Icons.warning, color: Colors.red),
                            title: Text('Urgent Return Alert'),
                            subtitle: Text('You have items due for return soon'),
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
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(currentUser?.email ?? 'Unknown'),
                            subtitle: const Text('Profile'),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.logout),
                            title: const Text('Sign Out'),
                            onTap: _handleSignOut,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Main Content
              Expanded(
                child: _buildMainContent(),
              ),
            ],
          ),

          // Enhanced Bottom Navigation
          bottomNavigationBar: EnhancedBottomNavigation(
            currentIndex: 0,
            onTap: (index) {
              // Handle navigation
              switch (index) {
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyReturnsPage()),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CalendarPage()),
                  );
                  break;
              }
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
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Authentication Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(authStateProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}