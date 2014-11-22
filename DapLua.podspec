#
# Be sure to run `pod lib lint DapCore.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "DapLua"
  s.version          = "0.1.0"
  s.summary          = "DAP - Distributed Application Platform, Lua Support (Swift Implementation)"
  s.description      = <<-DESC
                       DAP - Distributed Application Platform, Lua Support

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/angeldnd/dap.lua.swift"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "YJ Park" => "yjpark@gmail.com" }
  s.source           = { :git => "https://github.com/angeldnd/dap.lua.swift.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.1'
  s.requires_arc = true

  s.source_files = 'DAP.Lua/*.{h,m,swift}', 'Lib/**/*.{h,c}'
  s.resource_bundles = {
    #'DapCore' => ['Assets/*.png']
  }

  s.public_header_files = 'DAP.Lua/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'DapCore', '~> 0.1.0'
end
