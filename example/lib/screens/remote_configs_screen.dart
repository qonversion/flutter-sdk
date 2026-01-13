import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

import '../app_state.dart';
import '../theme.dart';

class RemoteConfigsScreen extends StatefulWidget {
  const RemoteConfigsScreen({super.key});

  @override
  State<RemoteConfigsScreen> createState() => _RemoteConfigsScreenState();
}

class _RemoteConfigsScreenState extends State<RemoteConfigsScreen> {
  final _contextKeysController = TextEditingController();
  final _singleContextKeyController = TextEditingController();
  final _experimentIdController = TextEditingController();
  final _groupIdController = TextEditingController();

  @override
  void dispose() {
    _contextKeysController.dispose();
    _singleContextKeyController.dispose();
    _experimentIdController.dispose();
    _groupIdController.dispose();
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
              title: const Text('Remote Configs'),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildLoadConfigsSection(),
                  const SizedBox(height: 16),
                  _buildSingleConfigSection(),
                  const SizedBox(height: 16),
                  _buildExperimentSection(),
                  const SizedBox(height: 16),
                  _buildResultsSection(appState),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadConfigsSection() {
    return SectionCard(
      title: 'Load Remote Config List',
      child: Column(
        children: [
          TextField(
            controller: _contextKeysController,
            decoration: const InputDecoration(
              hintText: 'key1, key2, key3 (optional)',
              labelText: 'Context Keys (comma-separated)',
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _loadRemoteConfigList,
              child: const Text('Load Config List'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleConfigSection() {
    return SectionCard(
      title: 'Load Single Remote Config',
      child: Column(
        children: [
          TextField(
            controller: _singleContextKeyController,
            decoration: const InputDecoration(
              hintText: 'Enter context key (optional)',
              labelText: 'Context Key',
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _loadSingleRemoteConfig,
              child: const Text('Load Config'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperimentSection() {
    return SectionCard(
      title: 'Experiment Attachment',
      child: Column(
        children: [
          TextField(
            controller: _experimentIdController,
            decoration: const InputDecoration(
              hintText: 'Enter experiment ID',
              labelText: 'Experiment ID',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _groupIdController,
            decoration: const InputDecoration(
              hintText: 'Enter group ID',
              labelText: 'Group ID',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _attachToExperiment,
                  child: const Text('Attach'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: _detachFromExperiment,
                  child: const Text('Detach'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultsSection(AppState appState) {
    final configs = appState.remoteConfigs;
    
    if (configs == null) {
      return SectionCard(
        title: 'Results',
        child: Center(
          child: Text(
            'No configs loaded yet',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      );
    }

    return SectionCard(
      title: 'Results (${configs.remoteConfigs.length})',
      child: Column(
        children: configs.remoteConfigs.map((config) => _buildConfigCard(config)).toList(),
      ),
    );
  }

  Widget _buildConfigCard(QRemoteConfig config) {
    String payloadStr = 'null';
    if (config.payload != null) {
      try {
        payloadStr = const JsonEncoder.withIndent('  ').convert(config.payload);
      } catch (e) {
        payloadStr = config.payload.toString();
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.cloud, size: 18, color: Colors.purple.shade400),
              const SizedBox(width: 8),
              Text(
                config.source.contextKey ?? 'Empty context',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildInfoRow('Source', config.source.name),
          _buildInfoRow('Type', config.source.type.name),
          const SizedBox(height: 8),
          Text(
            'Payload:',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              payloadStr,
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadRemoteConfigList() async {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.setLoading(true);
    
    try {
      QRemoteConfigList configs;
      final keysText = _contextKeysController.text.trim();
      
      if (keysText.isNotEmpty) {
        final keys = keysText.split(',').map((k) => k.trim()).toList();
        debugPrint('🔄 [Qonversion] Loading remote config list for keys: $keys');
        configs = await Qonversion.getSharedInstance().remoteConfigListForContextKeys(keys, true);
      } else {
        debugPrint('🔄 [Qonversion] Loading remote config list...');
        configs = await Qonversion.getSharedInstance().remoteConfigList();
      }
      
      debugPrint('✅ [Qonversion] Remote configs loaded: ${configs.remoteConfigs.length}');
      appState.setRemoteConfigs(configs);
    } catch (e) {
      debugPrint('❌ [Qonversion] Failed to load remote configs: $e');
      _showError('Failed to load: $e');
    } finally {
      appState.setLoading(false);
    }
  }

  Future<void> _loadSingleRemoteConfig() async {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.setLoading(true);
    
    try {
      final contextKey = _singleContextKeyController.text.trim();
      debugPrint('🔄 [Qonversion] Loading remote config for key: $contextKey');
      
      final config = await Qonversion.getSharedInstance().remoteConfig(
        contextKey: contextKey.isEmpty ? null : contextKey,
      );
      
      debugPrint('✅ [Qonversion] Remote config loaded');
      appState.setRemoteConfigs(QRemoteConfigList([config]));
    } catch (e) {
      debugPrint('❌ [Qonversion] Failed to load remote config: $e');
      _showError('Failed to load: $e');
    } finally {
      appState.setLoading(false);
    }
  }

  Future<void> _attachToExperiment() async {
    final experimentId = _experimentIdController.text.trim();
    final groupId = _groupIdController.text.trim();
    
    if (experimentId.isEmpty || groupId.isEmpty) {
      _showError('Please enter both experiment ID and group ID');
      return;
    }
    
    try {
      debugPrint('🔄 [Qonversion] Attaching to experiment: $experimentId, group: $groupId');
      await Qonversion.getSharedInstance().attachUserToExperiment(experimentId, groupId);
      debugPrint('✅ [Qonversion] Attached to experiment');
      _showSuccess('Attached to experiment!');
    } catch (e) {
      debugPrint('❌ [Qonversion] Failed to attach: $e');
      _showError('Failed to attach: $e');
    }
  }

  Future<void> _detachFromExperiment() async {
    final experimentId = _experimentIdController.text.trim();
    
    if (experimentId.isEmpty) {
      _showError('Please enter experiment ID');
      return;
    }
    
    try {
      debugPrint('🔄 [Qonversion] Detaching from experiment: $experimentId');
      await Qonversion.getSharedInstance().detachUserFromExperiment(experimentId);
      debugPrint('✅ [Qonversion] Detached from experiment');
      _showSuccess('Detached from experiment!');
    } catch (e) {
      debugPrint('❌ [Qonversion] Failed to detach: $e');
      _showError('Failed to detach: $e');
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
