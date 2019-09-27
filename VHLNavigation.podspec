
Pod::Spec.new do |s|

  s.name         = "VHLNavigation"
  s.version      = "1.0"
  s.summary      = "navigationbar color / background image/ alpha / hidden"
  s.homepage     = "https://github.com/huanglins/VHLNavigation"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "vincent" => "gvincent@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/huanglins/VHLNavigation.git", :tag => s.version }
  s.source_files = "VHLNavigation/*.{h,m}"
  s.requires_arc = true
  s.social_media_url = "https://github.com/huanglins"

end