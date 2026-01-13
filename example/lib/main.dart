import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

import 'app_state.dart';
import 'theme.dart';
import 'screens/main_screen.dart';
import 'screens/products_screen.dart';
import 'screens/entitlements_screen.dart';
import 'screens/offerings_screen.dart';
import 'screens/remote_configs_screen.dart';
import 'screens/user_screen.dart';
import 'screens/no_codes_screen.dart';
import 'screens/other_screen.dart';

const String projectKey = 'PV77YHL7qnGvsdmpTs7gimsxUvY-Znl2';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const QonversionDemoApp(),
    ),
  );
}

class QonversionDemoApp extends StatefulWidget {
  const QonversionDemoApp({super.key});

  @override
  State<QonversionDemoApp> createState() => _QonversionDemoAppState();
}

class _QonversionDemoAppState extends State<QonversionDemoApp> {
  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to avoid calling notifyListeners during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeQonversion();
    });
  }

  Future<void> _initializeQonversion() async {
    final appState = Provider.of<AppState>(context, listen: false);
    
    try {
      appState.setInitStatus('initializing');
      debugPrint('🔄 [Qonversion] Starting SDK initialization...');
      
      final config = QonversionConfigBuilder(
        projectKey,
        QLaunchMode.subscriptionManagement,
      )
          .setEnvironment(QEnvironment.sandbox)
          .setEntitlementsCacheLifetime(QEntitlementsCacheLifetime.month)
          .build();
      
      Qonversion.initialize(config);
      debugPrint('✅ [Qonversion] SDK initialized successfully');
      
      // Initialize No-Codes
      final noCodesConfig = NoCodesConfigBuilder(projectKey).build();
      final noCodes = NoCodes.initialize(noCodesConfig);
      debugPrint('✅ [NoCodes] SDK initialized successfully');
      
      // Subscribe to No-Codes events
      _subscribeToNoCodesEvents(noCodes, appState);
      
      appState.setInitStatus('success');
      
      // Load initial user info
      _loadUserInfo();
    } catch (e) {
      debugPrint('❌ [Qonversion] SDK initialization failed: $e');
      appState.setInitStatus('error');
    }
  }

  void _subscribeToNoCodesEvents(NoCodes noCodes, AppState appState) {
    noCodes.screenShownStream.listen((event) {
      final screenId = event.payload?['screenId'] ?? 'unknown';
      debugPrint('📡 [NoCodes] Screen shown: $screenId');
      appState.addNoCodesEvent('Screen shown: $screenId');
    });
    
    noCodes.actionStartedStream.listen((event) {
      final actionType = event.payload?['actionType'] ?? event.payload?['type'] ?? 'unknown';
      debugPrint('📡 [NoCodes] Action started: $actionType');
      appState.addNoCodesEvent('Action started: $actionType');
    });
    
    noCodes.actionFinishedStream.listen((event) {
      final actionType = event.payload?['actionType'] ?? event.payload?['type'] ?? 'unknown';
      debugPrint('📡 [NoCodes] Action finished: $actionType');
      appState.addNoCodesEvent('Action finished: $actionType');
    });
    
    noCodes.actionFailedStream.listen((event) {
      final actionType = event.payload?['actionType'] ?? event.payload?['type'] ?? 'unknown';
      final error = event.payload?['error'] ?? 'unknown error';
      debugPrint('📡 [NoCodes] Action failed: $actionType - $error');
      appState.addNoCodesEvent('Action failed: $actionType - $error');
    });
    
    noCodes.finishedStream.listen((event) {
      debugPrint('📡 [NoCodes] Flow finished');
      appState.addNoCodesEvent('Flow finished');
    });
    
    noCodes.screenFailedToLoadStream.listen((event) {
      final error = event.payload?['error'] ?? 'unknown error';
      debugPrint('📡 [NoCodes] Screen failed to load: $error');
      appState.addNoCodesEvent('Screen failed to load: $error');
    });
  }

  Future<void> _loadUserInfo() async {
    try {
      final userInfo = await Qonversion.getSharedInstance().userInfo();
      final appState = Provider.of<AppState>(context, listen: false);
      appState.setUserInfo(userInfo);
      debugPrint('✅ [Qonversion] User info loaded: ${userInfo.qonversionId}');
    } catch (e) {
      debugPrint('❌ [Qonversion] Failed to load user info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qonversion SDK Demo',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (_) => const MainScreen(),
        '/products': (_) => const ProductsScreen(),
        '/entitlements': (_) => const EntitlementsScreen(),
        '/offerings': (_) => const OfferingsScreen(),
        '/remote-configs': (_) => const RemoteConfigsScreen(),
        '/user': (_) => const UserScreen(),
        '/no-codes': (_) => const NoCodesScreen(),
        '/other': (_) => const OtherScreen(),
      },
    );
  }
}
