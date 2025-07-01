import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';
import 'enhanced_dashboard_page.dart';
import 'auth_page.dart';
import 'connection_test_page.dart';
import '../widgets/connection_status_widget.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  bool _showDebugOptions = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 0.9, curve: Curves.easeOutBack),
    ));

    _startSplashSequence();
  }

  void _startSplashSequence() async {
    await _animationController.forward();
    await Future.delayed(const Duration(milliseconds: 1000));

    if (mounted) {
      // Check authentication status
      final authState = ref.read(authStateProvider);
      
      authState.whenData((state) {
        if (state.session != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const EnhancedDashboardPage()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const AuthPage()),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onLongPress: () {
          setState(() {
            _showDebugOptions = true;
          });
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.primaryGradient,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: [
                  // Top spacing
                  const Spacer(flex: 2),

                  // Main Content
                  Expanded(
                    flex: 6,
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // App Logo/Icon
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: ScaleTransition(
                                scale: _scaleAnimation,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.assignment_return_outlined,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 40),

                            // App Name
                            Transform.translate(
                              offset: Offset(0, _slideAnimation.value),
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: Column(
                                  children: [
                                    Text(
                                      'ReturnPal',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 42,
                                            letterSpacing: -1,
                                          ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Create your return\nin your own way',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            color: Colors.white.withOpacity(0.9),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                            height: 1.4,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Subtitle
                            Transform.translate(
                              offset: Offset(0, _slideAnimation.value),
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: Text(
                                  'Never miss a deadline, track, remind, and return in a snap.',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 16,
                                        height: 1.5,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  // Bottom section
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Loading indicator
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            children: [
                              SizedBox(
                                width: 32,
                                height: 32,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white.withOpacity(0.8),
                                  ),
                                  strokeWidth: 2.5,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Loading...',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Colors.white.withOpacity(0.7),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  const SizedBox(width: 8),
                                  Consumer(
                                    builder: (context, ref, child) {
                                      final connectionStatus = ref.watch(connectionStatusProvider);
                                      return connectionStatus.when(
                                        data: (status) {
                                          if (status == ConnectionStatus.connected) {
                                            return const Icon(
                                              Icons.cloud_done,
                                              color: Colors.white,
                                              size: 16,
                                            );
                                          } else {
                                            return const Icon(
                                              Icons.cloud_off,
                                              color: Colors.white70,
                                              size: 16,
                                            );
                                          }
                                        },
                                        loading: () => const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white70,
                                          ),
                                        ),
                                        error: (_, __) => const Icon(
                                          Icons.error_outline,
                                          color: Colors.white70,
                                          size: 16,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        if (_showDebugOptions) ...[
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ConnectionTestPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppTheme.primaryPurple,
                            ),
                            child: const Text('Test Supabase Connection'),
                          ),
                        ],

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}