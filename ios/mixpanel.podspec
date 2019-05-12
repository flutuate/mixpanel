#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutuate_mixpanel'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter plugin for Mixpanel.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'https://flutuate.io/plugins/mixpanel'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'flutuate.io' => 'luciano@flutuate.io' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.ios.deployment_target = '8.0'
end

