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
  s.version          = "1.1.0"
  s.summary          = "An Objective-C logging framework, inspired on logging frameworks in other languages"
  s.homepage         = "https://github.com/appfoundry/DRYLogging"
  s.license          = 'MIT'
  s.author           = { "Michael Seghers" => "mike.seghers@appfoundry.be" }
  s.source           = { :git => "https://github.com/appfoundry/DRYLogging.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'DRYLogging' => ['Pod/Assets/*.png']
  }
end
