Pod::Spec.new do |s|
  s.name         = "WebAPIKit"
  s.version      = "0.1"
  s.summary      = "A network abstraction layer to build web API clients Edit"
  s.description  = <<-DESC
    Build web API clients with extension methods instead of enums. 
  DESC
  s.homepage     = "https://github.com/WebAPIKit/WebAPIKit"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Evan Liu" => "evancoding@gmail.com" }
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/WebAPIKit/WebAPIKit.git", :tag => s.version.to_s }
  s.source_files  = "Sources/**/*"
  s.frameworks  = "Foundation"
end
