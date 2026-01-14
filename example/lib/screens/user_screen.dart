import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

import '../app_state.dart';
import '../theme.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _identityIdController = TextEditingController();
  final _propertyKeyController = TextEditingController();
  final _propertyValueController = TextEditingController();
  final _attributionDataController = TextEditingController();
  
  QUserPropertyKey? _selectedPropertyKey;
  QAttributionProvider _selectedProvider = QAttributionProvider.appsFlyer;

  @override
  void dispose() {
    _identityIdController.dispose();
    _propertyKeyController.dispose();
    _propertyValueController.dispose();
    _attributionDataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return LoadingOverlay(
          isLoading: appState.isLoading,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('User Management'),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildUserInfoSection(appState),
                  const SizedBox(height: 16),
                  _buildIdentitySection(appState),
                  const SizedBox(height: 16),
                  _buildPropertiesSection(appState),
                  const SizedBox(height: 16),
                  _buildAttributionSection(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserInfoSection(AppState appState) {
    final user = appState.userInfo;
    
    return SectionCard(
      title: 'User Info',
      trailing: IconButton(
        icon: const Icon(Icons.refresh, size: 20),
        onPressed: _loadUserInfo,
        tooltip: 'Refresh',
      ),
      child: user == null
          ? Text('No user info', style: TextStyle(color: Colors.grey.shade600))
          : Column(
              children: [
                InfoRow(label: 'Qonversion ID', value: user.qonversionId),
                InfoRow(label: 'Identity ID', value: user.identityId ?? 'Anonymous'),
              ],
            ),
    );
  }

  Widget _buildIdentitySection(AppState appState) {
    final isIdentified = appState.userInfo?.identityId != null;
    
    return SectionCard(
      title: 'Identity',
      child: Column(
        children: [
          TextField(
            controller: _identityIdController,
            enabled: !isIdentified,
            decoration: const InputDecoration(
              hintText: 'Enter user identity ID',
              labelText: 'Identity ID',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: isIdentified ? null : _identify,
                  child: const Text('Identify'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: isIdentified ? _logout : null,
                  child: const Text('Logout'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPropertiesSection(AppState appState) {
    return SectionCard(
      title: 'User Properties',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            onPressed: _loadUserProperties,
            icon: const Icon(Icons.download),
            label: const Text('Load Properties'),
          ),
          
          if (appState.userProperties != null) ...[
            const SizedBox(height: 16),
            _buildPropertiesTable(appState.userProperties!),
          ],
          
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          
          Text(
            'Set Property',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 12),
          
          // Property key dropdown
          DropdownButtonFormField<QUserPropertyKey?>(
            value: _selectedPropertyKey,
            decoration: const InputDecoration(
              labelText: 'Property Key',
            ),
            items: [
              const DropdownMenuItem(value: null, child: Text('Custom (enter below)')),
              ...QUserPropertyKey.values.map((key) => DropdownMenuItem(
                value: key,
                child: Text(key.name),
              )),
            ],
            onChanged: (value) => setState(() => _selectedPropertyKey = value),
          ),
          
          if (_selectedPropertyKey == null) ...[
            const SizedBox(height: 12),
            TextField(
              controller: _propertyKeyController,
              decoration: const InputDecoration(
                hintText: 'Enter custom property key',
                labelText: 'Custom Key',
              ),
            ),
          ],
          
          const SizedBox(height: 12),
          TextField(
            controller: _propertyValueController,
            decoration: const InputDecoration(
              hintText: 'Enter property value',
              labelText: 'Value',
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _setUserProperty,
            child: const Text('Set Property'),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertiesTable(QUserProperties properties) {
    if (properties.properties.isEmpty) {
      return Text('No properties', style: TextStyle(color: Colors.grey.shade600));
    }
    
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text('Key', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade700, fontSize: 12)),
                ),
                Expanded(
                  flex: 3,
                  child: Text('Value', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade700, fontSize: 12)),
                ),
              ],
            ),
          ),
          ...properties.properties.asMap().entries.map((entry) {
            final prop = entry.value;
            final isEven = entry.key % 2 == 0;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: isEven ? Colors.white : Colors.grey.shade50,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(prop.key, style: const TextStyle(fontSize: 12)),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(prop.value, style: const TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAttributionSection() {
    return SectionCard(
      title: 'Attribution',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _attributionDataController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: '{"key": "value"}',
              labelText: 'Attribution Data (JSON)',
            ),
          ),
          const SizedBox(height: 12),
          
          DropdownButtonFormField<QAttributionProvider>(
            value: _selectedProvider,
            decoration: const InputDecoration(
              labelText: 'Provider',
            ),
            items: QAttributionProvider.values.map((provider) => DropdownMenuItem(
              value: provider,
              child: Text(provider.name),
            )).toList(),
            onChanged: (value) {
              if (value != null) setState(() => _selectedProvider = value);
            },
          ),
          const SizedBox(height: 12),
          
          ElevatedButton(
            onPressed: _sendAttribution,
            child: const Text('Send Attribution'),
          ),
          
          if (Platform.isIOS) ...[
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _collectAppleSearchAdsAttribution,
              child: const Text('Collect Apple Search Ads'),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _loadUserInfo() async {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.setLoading(true);
    
    try {
      debugPrint('🔄 [Qonversion] Loading user info...');
      final userInfo = await Qonversion.getSharedInstance().userInfo();
      debugPrint('✅ [Qonversion] User info loaded');
      appState.setUserInfo(userInfo);
    } catch (e) {
      debugPrint('❌ [Qonversion] Failed to load user info: $e');
      _showError('Failed to load: $e');
    } finally {
      appState.setLoading(false);
    }
  }

  Future<void> _identify() async {
    final identityId = _identityIdController.text.trim();
    if (identityId.isEmpty) {
      _showError('Please enter an identity ID');
      return;
    }
    
    final appState = Provider.of<AppState>(context, listen: false);
    appState.setLoading(true);
    
    try {
      debugPrint('🔄 [Qonversion] Identifying user: $identityId');
      final userInfo = await Qonversion.getSharedInstance().identify(identityId);
      debugPrint('✅ [Qonversion] User identified');
      appState.setUserInfo(userInfo);
      _showSuccess('User identified!');
    } catch (e) {
      debugPrint('❌ [Qonversion] Failed to identify: $e');
      _showError('Failed to identify: $e');
    } finally {
      appState.setLoading(false);
    }
  }

  Future<void> _logout() async {
    final appState = Provider.of<AppState>(context, listen: false);
    
    try {
      debugPrint('🔄 [Qonversion] Logging out...');
      Qonversion.getSharedInstance().logout();
      debugPrint('✅ [Qonversion] Logged out');
      
      // Reload user info
      final userInfo = await Qonversion.getSharedInstance().userInfo();
      appState.setUserInfo(userInfo);
      _identityIdController.clear();
      _showSuccess('Logged out!');
    } catch (e) {
      debugPrint('❌ [Qonversion] Failed to logout: $e');
      _showError('Failed to logout: $e');
    }
  }

  Future<void> _loadUserProperties() async {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.setLoading(true);
    
    try {
      debugPrint('🔄 [Qonversion] Loading user properties...');
      final properties = await Qonversion.getSharedInstance().userProperties();
      debugPrint('✅ [Qonversion] User properties loaded: ${properties.properties.length}');
      appState.setUserProperties(properties);
    } catch (e) {
      debugPrint('❌ [Qonversion] Failed to load properties: $e');
      _showError('Failed to load: $e');
    } finally {
      appState.setLoading(false);
    }
  }

  void _setUserProperty() {
    final value = _propertyValueController.text.trim();
    if (value.isEmpty) {
      _showError('Please enter a value');
      return;
    }
    
    try {
      if (_selectedPropertyKey != null) {
        debugPrint('🔄 [Qonversion] Setting property: ${_selectedPropertyKey!.name} = $value');
        Qonversion.getSharedInstance().setUserProperty(_selectedPropertyKey!, value);
      } else {
        final key = _propertyKeyController.text.trim();
        if (key.isEmpty) {
          _showError('Please enter a custom key');
          return;
        }
        debugPrint('🔄 [Qonversion] Setting custom property: $key = $value');
        Qonversion.getSharedInstance().setCustomUserProperty(key, value);
      }
      debugPrint('✅ [Qonversion] Property set');
      _showSuccess('Property set!');
      _propertyValueController.clear();
      _propertyKeyController.clear();
    } catch (e) {
      debugPrint('❌ [Qonversion] Failed to set property: $e');
      _showError('Failed to set: $e');
    }
  }

  void _sendAttribution() {
    final dataText = _attributionDataController.text.trim();
    if (dataText.isEmpty) {
      _showError('Please enter attribution data');
      return;
    }
    
    try {
      final data = json.decode(dataText) as Map<String, dynamic>;
      debugPrint('🔄 [Qonversion] Sending attribution: $_selectedProvider');
      Qonversion.getSharedInstance().attribution(data, _selectedProvider);
      debugPrint('✅ [Qonversion] Attribution sent');
      _showSuccess('Attribution sent!');
    } catch (e) {
      debugPrint('❌ [Qonversion] Failed to send attribution: $e');
      _showError('Invalid JSON or failed to send: $e');
    }
  }

  void _collectAppleSearchAdsAttribution() {
    try {
      debugPrint('🔄 [Qonversion] Collecting Apple Search Ads attribution...');
      Qonversion.getSharedInstance().collectAppleSearchAdsAttribution();
      debugPrint('✅ [Qonversion] Apple Search Ads attribution collected');
      _showSuccess('Apple Search Ads attribution collected!');
    } catch (e) {
      debugPrint('❌ [Qonversion] Failed: $e');
      _showError('Failed: $e');
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
