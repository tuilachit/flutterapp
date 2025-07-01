import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/config/supabase_config.dart';
import '../providers/auth_provider.dart';

enum ConnectionStatus {
  connected,
  disconnected,
  connecting,
  error
}

final connectionStatusProvider = StreamProvider<ConnectionStatus>((ref) {
  // Check initial connection
  return Stream.periodic(const Duration(seconds: 5), (_) async {
    try {
      // Simple ping to check connection
      await SupabaseConfig.client.from('users').select('count').limit(1);
      return ConnectionStatus.connected;
    } catch (e) {
      return ConnectionStatus.error;
    }
  }).asyncMap((future) async => await future);
});

class ConnectionStatusWidget extends ConsumerWidget {
  final VoidCallback? onTap;
  
  const ConnectionStatusWidget({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionStatus = ref.watch(connectionStatusProvider);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _getStatusColor(connectionStatus).withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _getStatusColor(connectionStatus).withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _getStatusIcon(connectionStatus),
            const SizedBox(width: 6),
            Text(
              _getStatusText(connectionStatus),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _getStatusColor(connectionStatus),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Color _getStatusColor(AsyncValue<ConnectionStatus> status) {
    return status.when(
      data: (status) {
        switch (status) {
          case ConnectionStatus.connected:
            return Colors.green;
          case ConnectionStatus.disconnected:
            return Colors.orange;
          case ConnectionStatus.connecting:
            return Colors.blue;
          case ConnectionStatus.error:
            return Colors.red;
        }
      },
      loading: () => Colors.blue,
      error: (_, __) => Colors.red,
    );
  }
  
  Widget _getStatusIcon(AsyncValue<ConnectionStatus> status) {
    return status.when(
      data: (status) {
        switch (status) {
          case ConnectionStatus.connected:
            return Icon(Icons.cloud_done, size: 14, color: Colors.green);
          case ConnectionStatus.disconnected:
            return Icon(Icons.cloud_off, size: 14, color: Colors.orange);
          case ConnectionStatus.connecting:
            return SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.blue,
              ),
            );
          case ConnectionStatus.error:
            return Icon(Icons.error_outline, size: 14, color: Colors.red);
        }
      },
      loading: () => SizedBox(
        width: 14,
        height: 14,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.blue,
        ),
      ),
      error: (_, __) => Icon(Icons.error_outline, size: 14, color: Colors.red),
    );
  }
  
  String _getStatusText(AsyncValue<ConnectionStatus> status) {
    return status.when(
      data: (status) {
        switch (status) {
          case ConnectionStatus.connected:
            return 'Connected';
          case ConnectionStatus.disconnected:
            return 'Disconnected';
          case ConnectionStatus.connecting:
            return 'Connecting...';
          case ConnectionStatus.error:
            return 'Connection Error';
        }
      },
      loading: () => 'Checking...',
      error: (_, __) => 'Connection Error',
    );
  }
}