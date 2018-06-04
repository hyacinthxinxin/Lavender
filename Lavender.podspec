#
# Be sure to run `pod lib lint Lavender.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |spec|
  spec.name             = 'Lavender'
  spec.version          = '0.1.1'
  spec.summary          = 'Lavender is a Swift Kit to enhance iOS development.'
  spec.description      = <<-DESC
                        Lavender is a Swift Kit to enhance iOS development
                        * extensions for String
                        * extensions for UIView
                       DESC
  spec.homepage         = 'https://github.com/hyacinthxinxin/Lavender'
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.author           = { 'hyacinthxinxin' => 'fanxin0202@163.com' }
  spec.source           = { :git => 'https://github.com/hyacinthxinxin/Lavender.git', :tag => spec.version.to_s }
  spec.ios.deployment_target = '9.0'
  spec.requires_arc = true
  spec.swift_version = '4.1'
  spec.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.1' }
  spec.source_files = 'Lavender/Classes/**/*'
  spec.resource_bundles = {
      'com.xiaoxiangyeyu.haycinth.Lavender' => ['Lavender/Assets/*.{png,jpg,bundle,xib,storyboard,xcassets}']
  }

#spec.dependency 'Alamofire', '~> 4.7.2'
#spec.dependency 'SnapKit', '~> 4.0.0'
#spec.dependency 'SwiftyJSON', '~> 4.1.0'
#spec.dependency 'Kingfisher', '~> 4.8.0'
#spec.dependency 'SVProgressHUD', '~> 2.2.5'

end
