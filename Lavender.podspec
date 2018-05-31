#
# Be sure to run `pod lib lint Lavender.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Lavender'
  s.version          = '0.1.1'
  s.summary          = 'Lavender is a Swift Kit to enhance iOS development.'

  s.description      = <<-DESC
                        Lavender is a Swift Kit to enhance iOS development
                        * A custom ImageView of UIControl
                       DESC

  s.homepage         = 'https://github.com/hyacinthxinxin/Lavender'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'hyacinthxinxin' => 'fanxin0202@163.com' }
  s.source           = { :git => 'https://github.com/hyacinthxinxin/Lavender.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.ios.deployment_target = '9.0'
  s.swift_version = '4.1'

  s.source_files = 'Lavender/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Lavender' => ['Lavender/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Alamofire', '~> 4.7.2'
  s.dependency 'SnapKit', '~> 4.0.0'
  s.dependency 'SwiftyJSON', '~> 4.1.0'
  s.dependency 'Kingfisher', '~> 4.8.0'
  s.dependency 'SVProgressHUD', '~> 2.2.5'

end
