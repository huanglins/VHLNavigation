
Pod::Spec.new do |s|

  s.name         = "VHLNavigation"
  s.version      = "0.0.1"
  s.summary      = "navigationbar color / background image/ alpha / hidden"
  s.homepage     = "https://github.com/huanglins/VHLNavigation"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "vincent" => "gvincent@163.com" }
  s.social_media_url   = "https://github.com/huanglins"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/huanglins/VHLNavigation.git", :tag => s.version }
  s.source_files  = "VHLNavigation/*.{h,m}"
  s.requires_arc         = true

end