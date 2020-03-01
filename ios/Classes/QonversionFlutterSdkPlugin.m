#import "QonversionFlutterSdkPlugin.h"
#if __has_include(<qonversion_flutter_sdk/qonversion_flutter_sdk-Swift.h>)
#import <qonversion_flutter_sdk/qonversion_flutter_sdk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "qonversion_flutter_sdk-Swift.h"
#endif

@implementation QonversionFlutterSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftQonversionFlutterSdkPlugin registerWithRegistrar:registrar];
}
@end
