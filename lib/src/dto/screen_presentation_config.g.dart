// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screen_presentation_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$QScreenPresentationConfigToJson(
        QScreenPresentationConfig instance) =>
    <String, dynamic>{
      'presentationStyle':
          _$QScreenPresentationStyleEnumMap[instance.presentationStyle],
      'animated': animatedToJson(instance.animated),
    };

const _$QScreenPresentationStyleEnumMap = {
  QScreenPresentationStyle.push: 'Push',
  QScreenPresentationStyle.fullScreen: 'FullScreen',
  QScreenPresentationStyle.popover: 'Popover',
  QScreenPresentationStyle.noAnimation: 'NoAnimation',
};
