import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../core/config/supabase_config.dart';
import '../providers/auth_provider.dart';
import '../providers/return_items_provider.dart';

class ConnectionTestPage extends ConsumerStatefulWidget {
  const ConnectionTestPage({super.key});

  @override
  ConsumerState<ConnectionTestPage> createState() => _ConnectionTestPageState();
}

class _ConnectionTestPageState extends ConsumerState<ConnectionTestPage> {
  bool _isLoading = false;
  List<TestResult> _testResults = [];

  @override
  void initState() {
    super.initState();
    _runAllTests();
  }

  Future<void> _runAllTests() async {
    setState(() {
      _isLoading = true;
      _testResults = [];
    });

    await _testBasicConnection();
    await _testAuthentication();
    await _testDatabase();
    await _testRealtime();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _testBasicConnection() async {
    _addTestResult(
      'Basic Connection',
      'Testing connection to Supabase...',
      TestStatus.running,
    );

    try {
      // Test basic connection
      final response = await SupabaseConfig.client.from('users').select('count').count();
      
      _updateTestResult(
        'Basic Connection',
        '✅ Connection successful! Database is accessible.',
        TestStatus.success,
        details: 'Successfully connected to ${AppConstants.supabaseUrl}',
      );
    } catch (e) {
      _updateTestResult(
        'Basic Connection',
        '❌ Connection failed',
        TestStatus.error,
        details: 'Error: $e',
      );
    }
  }

  Future<void> _testAuthentication() async {
    _addTestResult(
      'Authentication',
      'Testing authentication services...',
      TestStatus.running,
    );

    try {
      // Check if auth is working
      final authService = ref.read(authServiceProvider);
      final isAuthenticated = authService.isAuthenticated;
      final currentUser = await SupabaseConfig.client.auth.currentUser;
      
      if (isAuthenticated && currentUser != null) {
        _updateTestResult(
          'Authentication',
          '✅ Authentication working! User is signed in.',
          TestStatus.success,
          details: 'Current user: ${currentUser.email}',
        );
      } else {
        _updateTestResult(
          'Authentication',
          '✓ Authentication service available (not signed in)',
          TestStatus.warning,
          details: 'Auth services are working but no user is currently signed in',
        );
      }
    } catch (e) {
      _updateTestResult(
        'Authentication',
        '❌ Authentication test failed',
        TestStatus.error,
        details: 'Error: $e',
      );
    }
  }

  Future<void> _testDatabase() async {
    _addTestResult(
      'Database',
      'Testing database tables and queries...',
      TestStatus.running,
    );

    try {
      // Test users table
      final usersResult = await SupabaseConfig.client.from('users').select('count').count();
      
      // Test return_items table
      final itemsResult = await SupabaseConfig.client.from('return_items').select('count').count();
      
      _updateTestResult(
        'Database',
        '✅ Database tables accessible!',
        TestStatus.success,
        details: 'Users count: ${usersResult[0]['count']}\nReturn items count: ${itemsResult[0]['count']}',
      );
    } catch (e) {
      _updateTestResult(
        'Database',
        '❌ Database test failed',
        TestStatus.error,
        details: 'Error: $e',
      );
    }
  }

  Future<void> _testRealtime() async {
    _addTestResult(
      'Realtime',
      'Testing realtime subscriptions...',
      TestStatus.running,
    );

    try {
      // Test realtime subscription
      final channel = SupabaseConfig.client.channel('test-channel');
      
      channel.subscribe((status, error) {
        if (status == 'SUBSCRIBED') {
          _updateTestResult(
            'Realtime',
            '✅ Realtime subscriptions working!',
            TestStatus.success,
            details: 'Successfully subscribed to test channel',
          );
        } else if (error != null) {
          _updateTestResult(
            'Realtime',
            '❌ Realtime subscription failed',
            TestStatus.error,
            details: 'Error: $error',
          );
        }
      });
      
      // Cleanup after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        channel.unsubscribe();
      });
    } catch (e) {
      _updateTestResult(
        'Realtime',
        '❌ Realtime test failed',
        TestStatus.error,
        details: 'Error: $e',
      );
    }
  }

  void _addTestResult(String name, String message, TestStatus status, {String? details}) {
    setState(() {
      _testResults.add(TestResult(
        name: name,
        message: message,
        status: status,
        details: details,
      ));
    });
  }

  void _updateTestResult(String name, String message, TestStatus status, {String? details}) {
    setState(() {
      final index = _testResults.indexWhere((result) => result.name == name);
      if (index != -1) {
        _testResults[index] = TestResult(
          name: name,
          message: message,
          status: status,
          details: details,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supabase Connection Test'),
        backgroundColor: AppTheme.primaryPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Connection Info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Configuration:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('URL: ${AppConstants.supabaseUrl}'),
                  const SizedBox(height: 4),
                  Text('Key: ${AppConstants.supabaseAnonKey.substring(0, 20)}...'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Test Results
            Expanded(
              child: _isLoading && _testResults.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _testResults.length,
                      itemBuilder: (context, index) {
                        final result = _testResults[index];
                        return _TestResultCard(result: result);
                      },
                    ),
            ),
            
            // Actions
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _runAllTests,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppTheme.primaryPurple,
                  foregroundColor: Colors.white,
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
                          Text('Running Tests...'),
                        ],
                      )
                    : const Text('Run All Tests Again'),
              ),
            ),
            const SizedBox(height: 16),
            
            // Overall Status
            if (!_isLoading && _testResults.isNotEmpty)
              _buildOverallStatus(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallStatus() {
    final hasError = _testResults.any((result) => result.status == TestStatus.error);
    final hasWarning = _testResults.any((result) => result.status == TestStatus.warning);
    final allSuccess = !hasError && !hasWarning;
    
    Color color = allSuccess ? Colors.green : (hasError ? Colors.red : Colors.orange);
    String message = allSuccess 
        ? '✅ All tests passed! Supabase is fully connected.'
        : hasError 
            ? '❌ Some tests failed. Check details above.'
            : '⚠️ Tests completed with warnings.';
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Icon(
            allSuccess ? Icons.check_circle : (hasError ? Icons.error : Icons.warning),
            color: color,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: color,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

enum TestStatus { running, success, warning, error }

class TestResult {
  final String name;
  final String message;
  final TestStatus status;
  final String? details;

  TestResult({
    required this.name,
    required this.message,
    required this.status,
    this.details,
  });
}

class _TestResultCard extends StatefulWidget {
  final TestResult result;

  const _TestResultCard({required this.result});

  @override
  State<_TestResultCard> createState() => _TestResultCardState();
}

class _TestResultCardState extends State<_TestResultCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;

    switch (widget.result.status) {
      case TestStatus.running:
        color = Colors.blue;
        icon = Icons.refresh;
        break;
      case TestStatus.success:
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case TestStatus.warning:
        color = Colors.orange;
        icon = Icons.warning;
        break;
      case TestStatus.error:
        color = Colors.red;
        icon = Icons.error;
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: widget.result.details != null
            ? () {
                setState(() {
                  _expanded = !_expanded;
                });
              }
            : null,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  widget.result.status == TestStatus.running
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: color,
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(icon, color: color, size: 24),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.result.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.result.message,
                          style: TextStyle(
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.result.details != null)
                    Icon(
                      _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                ],
              ),
              if (_expanded && widget.result.details != null) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.result.details!,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}