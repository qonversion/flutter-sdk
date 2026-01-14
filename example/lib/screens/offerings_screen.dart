import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

import '../app_state.dart';
import '../theme.dart';

class OfferingsScreen extends StatefulWidget {
  const OfferingsScreen({super.key});

  @override
  State<OfferingsScreen> createState() => _OfferingsScreenState();
}

class _OfferingsScreenState extends State<OfferingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return LoadingOverlay(
          isLoading: appState.isLoading,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Offerings'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _loadOfferings,
                  tooltip: 'Reload offerings',
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
    final offerings = appState.offerings;
    
    if (offerings == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_offer_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No offerings loaded',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadOfferings,
              icon: const Icon(Icons.download),
              label: const Text('Load Offerings'),
            ),
          ],
        ),
      );
    }

    final allOfferings = <QOffering>[];
    if (offerings.main != null) allOfferings.add(offerings.main!);
    allOfferings.addAll(offerings.availableOfferings);

    if (allOfferings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No offerings available',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: allOfferings.length,
      itemBuilder: (context, index) {
        final offering = allOfferings[index];
        final isMain = offerings.main?.id == offering.id;
        return _OfferingCard(offering: offering, isMain: isMain);
      },
    );
  }

  Future<void> _loadOfferings() async {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.setLoading(true);
    
    try {
      debugPrint('🔄 [Qonversion] Loading offerings...');
      final offerings = await Qonversion.getSharedInstance().offerings();
      debugPrint('✅ [Qonversion] Offerings loaded');
      appState.setOfferings(offerings);
    } catch (e) {
      debugPrint('❌ [Qonversion] Failed to load offerings: $e');
      _showError('Failed to load offerings: $e');
    } finally {
      appState.setLoading(false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppTheme.errorColor),
    );
  }
}

class _OfferingCard extends StatelessWidget {
  final QOffering offering;
  final bool isMain;

  const _OfferingCard({required this.offering, required this.isMain});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isMain 
                  ? AppTheme.primaryColor.withOpacity(0.05)
                  : null,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isMain 
                        ? AppTheme.primaryColor.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isMain ? Icons.star : Icons.local_offer,
                    color: isMain ? AppTheme.primaryColor : Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            offering.id,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          if (isMain) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'MAIN',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tag: ${offering.tag.name}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (offering.products.isNotEmpty) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Products (${offering.products.length})',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...offering.products.map((product) => _buildProductRow(product)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProductRow(QProduct product) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.shopping_bag, size: 18, color: AppTheme.textSecondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.storeTitle ?? product.qonversionId,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  product.storeId ?? 'No store ID',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            product.prettyPrice ?? 'N/A',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
