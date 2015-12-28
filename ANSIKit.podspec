Pod::Spec.new do |s|
  s.name         = "ANSIKit"
  s.version      = "0.0.1"
  s.summary      = "iOS/OSX framework for parsing ANSI formatted text to NSAttributedString"
  s.description  = `cat README.md`
  s.homepage     = "https://github.com/mattdelves/ANSIKit"
  s.license      = "MIT"
  s.author       = "Matt Delves"
  s.platform     = :ios, "8.0"
  s.osx.deployment_target = "10.9"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/ngs/ANSIKit.git", :branch => "cocoapods" }
  s.source_files  = "ANSIKit/*.swift"
end
