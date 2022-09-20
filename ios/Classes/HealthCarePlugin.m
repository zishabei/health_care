#import "HealthCarePlugin.h"
#if __has_include(<health_care/health_care-Swift.h>)
#import <health_care/health_care-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "health_care-Swift.h"
#endif

@implementation HealthCarePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftHealthCarePlugin registerWithRegistrar:registrar];
}
@end
