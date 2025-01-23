#
# Be sure to run `pod lib lint PayOrciOS_SDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PayOrciOS_SDK'
  s.version          = '1.0.0'
  s.summary          = 'A short description of PayOrciOS_SDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/ramanocs1145/PayOrciOS_SDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ramanocs1145' => 'p.ramanathan2971@gmail.com' }
  s.source           = { :git => 'https://github.com/ramanocs1145/PayOrciOS_SDK.git', :branch => 'main' } # :tag => s.version.to_s
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'

  s.source_files = 'PayOrciOS_SDK/Classes/**/*'
  
  # s.resource_bundles = {
  #   'PayOrciOS_SDK' => ['PayOrciOS_SDK/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
