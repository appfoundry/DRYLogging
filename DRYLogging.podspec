#
# Be sure to run `pod lib lint DRYLogging.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "DRYLogging"
  s.version          = "3.0.0"
  s.summary          = "A swift logging framework, inspired on logging frameworks in other languages"
  s.homepage         = "https://github.com/appfoundry/DRYLogging"
  s.license          = 'MIT'
  s.author           = { "Michael Seghers" => "mike.seghers@appfoundry.be" }
  s.source           = { :git => "https://github.com/appfoundry/DRYLogging.git", :tag => s.version.to_s }


  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }
end
