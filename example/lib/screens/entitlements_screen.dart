import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

import '../app_state.dart';
import '../theme.dart';

class EntitlementsScreen extends StatefulWidget {
  const EntitlementsScreen({super.key});

  @override
  State<EntitlementsScreen> createState() => _EntitlementsScreenState();
}

class _EntitlementsScreenState extends State<EntitlementsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return LoadingOverlay(
          isLoading: appState.isLoading,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Entitlements'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _checkEntitlements,
                  tooltip: 'Check entitlements',
                ),
              ],
            ),
            body: _buildBody(appState),
          ),
        );
      },
    );
  }

  Widget _buildBody(AppState appState) {
    final entitlements = appState.entitlements;
    
    if (entitlements == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.verified_user_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No entitlements checked',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _checkEntitlements,
              icon: const Icon(Icons.check_circle),
              label: const Text('Check Entitlements'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _restore,
              icon: const Icon(Icons.restore),
              label: const Text('Restore Purchases'),
            ),
          ],
        ),
      );
    }

    if (entitlements.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.do_not_disturb, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No active entitlements',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _checkEntitlements,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _restore,
              icon: const Icon(Icons.restore),
              label: const Text('Restore Purchases'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: entitlements.length + 1, // +1 for restore button
      itemBuilder: (context, index) {
        if (index == entitlements.length) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: OutlinedButton.icon(
              onPressed: _restore,
              icon: const Icon(Icons.restore),
              label: const Text('Restore Purchases'),
            ),
          );
        }
        final entitlement = entitlements.values.elementAt(index);
        return _EntitlementCard(entitlement: entitlement);
      },
    );
  }

  Future<void> _checkEntitlements() async {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.setLoading(true);
    
    try {
      debugPrint('🔄 [Qonversion] Checking entitlements...');
      final entitlements = await Qonversion.getSharedInstance().checkEntitlements();
      debugPrint('✅ [Qonversion] Entitlements checked: ${entitlements.length}');
      appState.setEntitlements(entitlements);
    } catch (e) {
      debugPrint('❌ [Qonversion] Failed to check entitlements: $e');
      _showError('Failed to check entitlements: $e');
    } finally {
      appState.setLoading(false);
    }
  }

  Future<void> _restore() async {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.setLoading(true);
    
    try {
      debugPrint('🔄 [Qonversion] Restoring purchases...');
      final entitlements = await Qonversion.getSharedInstance().restore();
      debugPrint('✅ [Qonversion] Purchases restored: ${entitlements.length}');
      appState.setEntitlements(entitlements);
      _showSuccess('Purchases restored successfully!');
    } catch (e) {
      debugPrint('❌ [Qonversion] Failed to restore: $e');
      _showError('Failed to restore: $e');
    } finally {
      appState.setLoading(false);
    }
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppTheme.successColor),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppTheme.errorColor),
    );
  }
}

class _EntitlementCard extends StatelessWidget {
  final QEntitlement entitlement;

  const _EntitlementCard({required this.entitlement});

  @override
  Widget build(BuildContext context) {
    final isActive = entitlement.isActive;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isActive 
                        ? AppTheme.successColor.withOpacity(0.1)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isActive ? Icons.check_circle : Icons.cancel,
                    color: isActive ? AppTheme.successColor : Colors.grey,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entitlement.id,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        'Product: ${entitlement.productId}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isActive 
                        ? AppTheme.successColor.withOpacity(0.1)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isActive ? 'Active' : 'Inactive',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isActive ? AppTheme.successColor : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),
            _buildInfoRow('Renew State', entitlement.renewState.name),
            _buildInfoRow('Source', entitlement.source.name),
            if (entitlement.startedDate != null)
              _buildInfoRow('Started', _formatDate(entitlement.startedDate!)),
            if (entitlement.expirationDate != null)
              _buildInfoRow('Expires', _formatDate(entitlement.expirationDate!)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textTertiary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
