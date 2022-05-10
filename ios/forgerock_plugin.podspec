#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint forgerock_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'forgerock_plugin'
  s.version          = '0.2.0'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  # s.source          	= { :git => "https://github.com/ForgeRock/forgerock-ios-sdk.git" }
  s.source_files = '**/Classes/**/*{h,m,swift}'
  s.dependency 'Flutter'
  s.dependency 'FRAuth'
  s.platform = :ios, '15.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
