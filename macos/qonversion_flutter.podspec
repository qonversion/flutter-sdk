#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint qonversion.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'qonversion_flutter'
  s.version          = '2.3.0'
  s.summary          = 'Flutter Qonversion SDK'
  s.description      = <<-DESC
  Powerful yet simple subscription analytics
                       DESC
  s.homepage         = 'https://qonversion.io'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Qonversion Inc.' => 'hi@qonversion.io' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'FlutterMacOS'
  s.platform = :osx, '10.12'
  s.dependency 'Qonversion', '2.17.1'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
  s.static_framework = true
end
