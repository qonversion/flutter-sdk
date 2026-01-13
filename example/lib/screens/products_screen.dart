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
      
      if (result.isSuccess) {
        debugPrint('✅ [Qonversion] Purchase successful!');
        debugPrint('   Transaction ID: ${result.storeTransaction?.transactionId}');
        _showSuccess('Purchase successful!');
        
        // Update entitlements
        appState.setEntitlements(result.entitlements);
      } else if (result.isCanceled) {
        debugPrint('ℹ️ [Qonversion] Purchase canceled by user');
        _showInfo('Purchase canceled');
      } else if (result.isPending) {
        debugPrint('ℹ️ [Qonversion] Purchase pending');
        _showInfo('Purchase is pending');
      } else if (result.isError) {
        debugPrint('❌ [Qonversion] Purchase failed: ${result.error?.message}');
        _showError('Purchase failed: ${result.error?.message}');
      }
    } catch (e) {
      debugPrint('❌ [Qonversion] Purchase error: $e');
      _showError('Purchase error: $e');
    } finally {
      appState.setLoading(false);
    }
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
