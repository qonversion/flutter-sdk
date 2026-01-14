import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../theme.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              // Logo and title
              _buildHeader(context),
              const SizedBox(height: 24),
              
              // Initialization status
              _buildStatusCard(context),
              const SizedBox(height: 8),
              
              // User info card
              _buildUserInfoCard(context),
              const SizedBox(height: 16),
              
              // Menu items
              _buildMenuSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor,
                AppTheme.primaryColor.withOpacity(0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'Q',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Qonversion SDK Demo',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Test all SDK features',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.power_settings_new, color: AppTheme.textSecondary),
                const SizedBox(width: 12),
                const Text(
                  'SDK Status',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const Spacer(),
                StatusIndicator(status: appState.initStatus),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserInfoCard(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final user = appState.userInfo;
        if (user == null) return const SizedBox.shrink();
        
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
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
                        color: AppTheme.secondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: AppTheme.secondaryColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Current User',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildCopyableRow(
                  context,
                  'Qonversion ID',
                  user.qonversionId,
                ),
                const Divider(height: 24),
                _buildCopyableRow(
                  context,
                  'Identity ID',
                  user.identityId ?? 'Anonymous',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCopyableRow(BuildContext context, String label, String value) {
    return InkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(text: value));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label copied to clipboard'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.copy, size: 16, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    final menuItems = [
      _MenuItem(
        icon: Icons.shopping_bag,
        title: 'Products',
        subtitle: 'View and purchase products',
        route: '/products',
        color: Colors.blue,
      ),
      _MenuItem(
        icon: Icons.verified_user,
        title: 'Entitlements',
        subtitle: 'Check user entitlements',
        route: '/entitlements',
        color: Colors.green,
      ),
      _MenuItem(
        icon: Icons.local_offer,
        title: 'Offerings',
        subtitle: 'Browse available offerings',
        route: '/offerings',
        color: Colors.orange,
      ),
      _MenuItem(
        icon: Icons.cloud_sync,
        title: 'Remote Configs',
        subtitle: 'Load and view remote configs',
        route: '/remote-configs',
        color: Colors.purple,
      ),
      _MenuItem(
        icon: Icons.person,
        title: 'User',
        subtitle: 'Manage user identity & properties',
        route: '/user',
        color: Colors.teal,
      ),
      _MenuItem(
        icon: Icons.code,
        title: 'No-Codes',
        subtitle: 'Test no-code screens',
        route: '/no-codes',
        color: Colors.pink,
      ),
      _MenuItem(
        icon: Icons.more_horiz,
        title: 'Other',
        subtitle: 'Additional SDK methods',
        route: '/other',
        color: Colors.blueGrey,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Features',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 8),
        ...menuItems.map((item) => MenuCard(
          icon: item.icon,
          title: item.title,
          subtitle: item.subtitle,
          iconColor: item.color,
          onTap: () => Navigator.pushNamed(context, item.route),
        )),
      ],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
  final Color color;

  _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.color,
  });
}
