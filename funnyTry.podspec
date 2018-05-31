Pod::Spec.new do |s|
  s.name         = "funnyTry"
  s.version      = "1.1.1"
  s.ios.deployment_target = '8.0'
  s.summary      = "A funny place to code"
  s.homepage     = "https://github.com/petyou/funnyTry"
  s.license      = "MIT"
  s.author             = { "petyou" => "812607796@qq.com" }
  s.social_media_url   = "http://weibo.com"
  s.source       = { :git => "https://github.com/petyou/funnyTry.git", :tag => s.version }
  s.source_files  = "funnyTry"
  s.requires_arc = true
endf
