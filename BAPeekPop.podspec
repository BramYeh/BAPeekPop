#
# Be sure to run `pod lib lint BAPeekPop.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BAPeekPop'
  s.version          = '1.1.1'
  s.summary          = 'Peek & Pop Compat for Long Press on non 3D touch Device of iOS 9+'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                       A compat library to support Peek & Pop on iOS 9+ device.
                       If device supports 3D touch, it will work directly as original 3D touch behavior.
                       If device doesn't supports 3D touch, it will still work and display peek previewing viewcontroller via long press.
                       DESC

  s.homepage         = 'https://github.com/BramYeh/BAPeekPop'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Bram Yeh' => 'hanru.yeh@gmail.com' }
  s.source           = { :git => 'https://github.com/BramYeh/BAPeekPop.git', :tag => s.version.to_s }

  s.requires_arc = true
  s.platform = :ios, '8.0'
  s.ios.deployment_target = '8.0'

  s.source_files = 'BAPeekPop/Classes/**/*'
  s.public_header_files = 'BAPeekPop/Classes/BAPeekPop.h', "BAPeekPop/Classes/BAPreviewingViewController.h"
  s.resources = 'BAPeekPop/Assets/BAPeekPopAssets.xcassets'
  # s.resource_bundles = {
  #   'BAPeekPop' => ['BAPeekPop/Assets/*.png']
  # }

  s.frameworks = 'UIKit', 'Accelerate', 'Foundation'
end
