#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutuate_mixpanel.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutuate_mixpanel'
  s.version          = '1.1.2'
  s.summary          = 'A Flutter plugin for use the Mixpanel API for Android devices.'
  s.description      = <<-DESC
A Flutter plugin for use the Mixpanel API for Android devices.
                       DESC
  s.homepage         = 'https://github.com/flutuate/mixpanel'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Luciano Rodrigues' => 'flutuate.io@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'Mixpanel-swift', '2.6.2'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
