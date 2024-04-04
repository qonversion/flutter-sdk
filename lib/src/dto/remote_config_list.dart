import 'package:json_annotation/json_annotation.dart';
import 'remote_config.dart';

part 'remote_config_list.g.dart';

@JsonSerializable(createToJson: false)
class QRemoteConfigList {
  @JsonKey(name: 'remoteConfigs')
  final List<QRemoteConfig> remoteConfigs;

  const QRemoteConfigList(
      this.remoteConfigs,
  );

  QRemoteConfig? remoteConfigForContextKey(String contextKey) {
    return _findRemoteConfig(contextKey);
  }

  QRemoteConfig? remoteConfigForEmptyContextKey() {
    return _findRemoteConfig(null);
  }

  QRemoteConfig? _findRemoteConfig(String? contextKey) {
    for (QRemoteConfig config in remoteConfigs) {
      if (config.source.contextKey == contextKey) {
        return config;
      }
    }
    return null;
  }

  factory QRemoteConfigList.fromJson(Map<String, dynamic> json) =>
      _$QRemoteConfigListFromJson(json);
}
