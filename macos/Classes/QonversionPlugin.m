#import "QonversionPlugin.h"
#if __has_include(<qonversion_flutter/qonversion_flutter-Swift.h>)
#import <qonversion_flutter/qonversion_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "qonversion_flutter-Swift.h"
#endif

@implementation QonversionPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftQonversionPlugin registerWithRegistrar:registrar];
}
@end
