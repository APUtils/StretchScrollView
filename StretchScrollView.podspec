#
# Be sure to run `pod lib lint StretchScrollView.podspec` to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'StretchScrollView'
  s.version          = '2.2.1'
  s.summary          = 'ScrollView that allows to stretch it`s image'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
StretchScrollView provides functionality to enlarge title image and hide overlays when scrolling down. When scrolling up it allows to animate background of navigation bar.
                       DESC

  s.homepage         = 'https://github.com/APUtils/StretchScrollView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Anton Plebanovich' => 'anton.plebanovich@gmail.com' }
  s.source           = { :git => 'https://github.com/APUtils/StretchScrollView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'StretchScrollView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'StretchScrollView' => ['StretchScrollView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'Foundation', 'UIKit'
  s.dependency 'APExtensions/ViewState', '>= 3.4.5'
end
