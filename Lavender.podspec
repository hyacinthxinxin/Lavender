#
# Be sure to run `pod lib lint Lavender.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |spec|
  spec.name             = 'Lavender'
  spec.version          = '1.0.0'
  spec.summary          = 'Lavender is a Swift Kit to enhance iOS development.'
  spec.description      = <<-DESC
                        Lavender is a Swift Kit to enhance iOS development
                        * extensions for String
                        * extensions for UIView
                       DESC
  spec.homepage         = 'https://github.com/hyacinthxinxin/Lavender'
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.author           = { 'hyacinthxinxin' => 'fanxin0202@163.com' }
  spec.source           = { :git => 'https://git.coding.net/lintao_cn/xc_LocalStarKit_ios.git', :tag => spec.version.to_s }
  spec.ios.deployment_target = '10.0'
  spec.requires_arc = true
  spec.swift_version = '4.1'
  spec.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.1' }
  spec.source_files = 'Lavender/Classes/**/*'
  spec.resource_bundles = {
      'com.ls.lianzai.Lavender' => ['Lavender/Assets/*.{png,jpg,bundle,xib,storyboard,xcassets}']
  }

end
