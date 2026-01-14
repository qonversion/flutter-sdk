import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

import '../app_state.dart';
import '../theme.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return LoadingOverlay(
          isLoading: appState.isLoading,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Products'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _loadProducts,
                  tooltip: 'Reload products',
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
    final products = appState.products;
    
    if (products == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No products loaded',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadProducts,
              icon: const Icon(Icons.download),
              label: const Text('Load Products'),
            ),
          ],
        ),
      );
    }

    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No products available',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products.values.elementAt(index);
        return _ProductCard(
          product: product,
          onPurchase: () => _purchaseProduct(product),
        );
      },
    );
  }

  Future<void> _loadProducts() async {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.setLoading(true);
    
    try {
      debugPrint('🔄 [Qonversion] Loading products...');
      final products = await Qonversion.getSharedInstance().products();
      debugPrint('✅ [Qonversion] Products loaded: ${products.length}');
      appState.setProducts(products);
    } catch (e) {
      debugPrint('❌ [Qonversion] Failed to load products: $e');
      _showError('Failed to load products: $e');
    } finally {
      appState.setLoading(false);
    }
  }

  Future<void> _purchaseProduct(QProduct product) async {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.setLoading(true);
    
    try {
      debugPrint('🔄 [Qonversion] Purchasing product: ${product.qonversionId}...');
      final result = await Qonversion.getSharedInstance().purchaseWithResult(product);
      
      // Show full PurchaseResult details
      _showPurchaseResultDialog(result);
      
      if (result.isSuccess) {
        debugPrint('✅ [Qonversion] Purchase successful!');
        // Update entitlements
        appState.setEntitlements(result.entitlements);
      }
    } catch (e) {
      debugPrint('❌ [Qonversion] Purchase error: $e');
      _showError('Purchase error: $e');
    } finally {
      appState.setLoading(false);
    }
  }

  void _showPurchaseResultDialog(QPurchaseResult result) {
    final tx = result.storeTransaction;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              result.isSuccess ? Icons.check_circle : 
              result.isCanceled ? Icons.cancel : 
              result.isPending ? Icons.pending : Icons.error,
              color: result.isSuccess ? Colors.green : 
                     result.isCanceled ? Colors.orange : 
                     result.isPending ? Colors.blue : Colors.red,
            ),
            const SizedBox(width: 8),
            Text('Purchase Result'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildResultRow('Status', result.status.name),
              _buildResultRow('Source', result.source.name),
              _buildResultRow('Is Fallback', result.isFallbackGenerated.toString()),
              if (result.error != null) ...[
                const Divider(),
                _buildResultRow('Error Code', result.error!.code.toString()),
                _buildResultRow('Error Message', result.error!.message ?? 'N/A'),
              ],
              if (tx != null) ...[
                const Divider(),
                const Text('Store Transaction:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _buildResultRow('Transaction ID', tx.transactionId ?? 'N/A'),
                _buildResultRow('Original TX ID', tx.originalTransactionId ?? 'N/A'),
                _buildResultRow('Product ID', tx.productId ?? 'N/A'),
                _buildResultRow('Quantity', tx.quantity?.toString() ?? 'N/A'),
                _buildResultRow('TX Date', tx.transactionDate?.toIso8601String() ?? 'N/A'),
                _buildResultRow('Promo Offer ID', tx.promoOfferId ?? 'N/A'),
                _buildResultRow('Purchase Token', tx.purchaseToken != null 
                    ? '${tx.purchaseToken!.substring(0, 20)}...' 
                    : 'N/A'),
              ],
              if (result.entitlements != null && result.entitlements!.isNotEmpty) ...[
                const Divider(),
                Text('Entitlements (${result.entitlements!.length}):', 
                     style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...result.entitlements!.values.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('• ${e.id} (active: ${e.isActive})'),
                )),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontFamily: 'monospace'))),
        ],
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
      ),
    );
  }

  void _showInfo(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final QProduct product;
  final VoidCallback onPurchase;

  const _ProductCard({
    required this.product,
    required this.onPurchase,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.storeTitle ?? product.qonversionId,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.storeId ?? 'No store ID',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    product.prettyPrice ?? 'N/A',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            if (product.storeDescription != null) ...[
              const SizedBox(height: 12),
              Text(
                product.storeDescription!,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildChip('ID: ${product.qonversionId}'),
                _buildChip('Type: ${product.type.name}'),
                if (product.subscriptionPeriod != null)
                  _buildChip('${product.subscriptionPeriod!.unitCount} ${product.subscriptionPeriod!.unit.name}'),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPurchase,
                child: const Text('Purchase'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }
}
