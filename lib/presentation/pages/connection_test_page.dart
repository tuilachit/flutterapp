import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

class ConnectionTestPage extends StatefulWidget {
  const ConnectionTestPage({super.key});

  @override
  State<ConnectionTestPage> createState() => _ConnectionTestPageState();
}

class _ConnectionTestPageState extends State<ConnectionTestPage> {
  String _connectionStatus = 'Testing connection...';
  bool _isLoading = true;
  Color _statusColor = Colors.orange;

  @override
  void initState() {
    super.initState();
    _testConnection();
  }

  Future<void> _testConnection() async {
    try {
      setState(() {
        _isLoading = true;
        _connectionStatus = 'Testing connection...';
        _statusColor = Colors.orange;
      });

      final supabase = Supabase.instance.client;

      // Test 1: Basic connection
      await Future.delayed(const Duration(seconds: 1));

      // Test 2: Try to access a simple endpoint
      try {
        final response = await supabase.from('users').select('count').count();

        setState(() {
          _isLoading = false;
          _connectionStatus =
              '✅ Connection successful!\nUsers table accessible\nCount: $response';
          _statusColor = Colors.green;
        });
      } catch (e) {
        // Try return_items table
        try {
          final response =
              await supabase.from('return_items').select('count').count();

          setState(() {
            _isLoading = false;
            _connectionStatus =
                '✅ Connection successful!\nReturn items table accessible\nCount: $response';
            _statusColor = Colors.green;
          });
        } catch (e2) {
          setState(() {
            _isLoading = false;
            _connectionStatus =
                '⚠️ Connection established but tables not accessible\nError: $e2';
            _statusColor = Colors.orange;
          });
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _connectionStatus = '❌ Connection failed\nError: $e';
        _statusColor = Colors.red;
      });
    }
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
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _statusColor.withOpacity(0.1),
                border: Border.all(color: _statusColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else
                    Icon(
                      _statusColor == Colors.green
                          ? Icons.check_circle
                          : _statusColor == Colors.orange
                              ? Icons.warning
                              : Icons.error,
                      color: _statusColor,
                      size: 48,
                    ),
                  const SizedBox(height: 16),
                  Text(
                    _connectionStatus,
                    style: TextStyle(
                      fontSize: 16,
                      color: _statusColor,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
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
                  Text(
                      'Key: ${AppConstants.supabaseAnonKey.substring(0, 20)}...'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _testConnection,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppTheme.primaryPurple,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Test Connection Again'),
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Auth'),
            ),
          ],
        ),
      ),
    );
  }
}
