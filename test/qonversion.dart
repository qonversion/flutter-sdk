import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qonversion_flutter/src/dto/remote_configuration_assignment_type.dart';
import 'package:qonversion_flutter/src/dto/remote_configuration_source.dart';

void main() {
  const MethodChannel channel = MethodChannel('qonversion_flutter_sdk');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('test', () async {});

  test('frozen remote configuration assignment keeps its provenance', () {
    final source = QRemoteConfigurationSource.fromJson({
      'id': 'rc',
      'name': 'Remote config',
      'type': 'remote_configuration',
      'assignmentType': 'frozen',
      'contextKey': 'main',
    });
    expect(source.assignmentType, QRemoteConfigurationAssignmentType.frozen);
  });
}
