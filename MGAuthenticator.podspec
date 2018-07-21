#
# Be sure to run `pod lib lint MGAuthenticator.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MGAuthenticator'
  s.version          = '0.1.0'
  s.summary          = 'An iOS authenticator with customized passcode, TouchID and FaceID.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
MGAuthenticator is an iOS authenticator with customized passcode, TouchID and FaceID.
It makes it easy to protect the app with passcode, TouchID and FaceID.
                       DESC

  s.homepage         = 'https://github.com/lm2343635/MGAuthenticator'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lm2343635' => 'lm2343635@126.com' }
  s.source           = { :git => 'https://github.com/lm2343635/MGAuthenticator.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'MGAuthenticator/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MGAuthenticator' => ['MGAuthenticator/Assets/*.png']
  # }

  s.dependency 'SnapKit', '~> 4'
end
