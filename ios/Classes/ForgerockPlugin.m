#import "ForgerockPlugin.h"
#if __has_include(<forgerock_plugin/forgerock_plugin-Swift.h>)
#import <forgerock_plugin/forgerock_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "forgerock_plugin-Swift.h"
#endif

@implementation ForgerockPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftForgerockPlugin registerWithRegistrar:registrar];
}
@end
