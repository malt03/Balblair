#
# Be sure to run `pod lib lint Balblair.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Balblair'
  s.version          = '0.4.1'
  s.summary          = 'Api client with ObjectMapper and SwiftTask.'

  s.description      = <<-DESC
This pod is api client.
This is type safe.
This is easy to use with ObjectMapper and SwiftTask.
                       DESC

  s.homepage         = 'https://github.com/malt03/Balblair'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Koji Murata' => 'malt.koji@gmail.com' }
  s.source           = { :git => 'https://github.com/malt03/Balblair.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.subspec 'Core' do |ss|
    ss.source_files = 'Balblair/Core/Classes/**/*'
    ss.dependency 'Alamofire', '~> 4.0'
  end

  s.subspec 'ObjectMapper' do |ss|
    ss.source_files = 'Balblair/ObjectMapper/Classes/**/*'
    ss.dependency 'Balblair/Core'
    ss.dependency 'ObjectMapper', '~> 2.0'
  end

  s.subspec 'SwiftTask' do |ss|
    ss.source_files = 'Balblair/SwiftTask/Classes/**/*'
    ss.dependency 'Balblair/Core'
    ss.dependency 'Balblair/ObjectMapper'
    ss.dependency 'SwiftTask', '>= 5.0'
  end
end
