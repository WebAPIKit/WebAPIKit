Pod::Spec.new do |s|
  s.name         = "WebAPIKit"
  s.version      = "0.1.0"
  s.summary      = "A network abstraction layer to build web API clients Edit"
  s.description  = <<-DESC
    Build web API clients with extension methods instead of enums. 
  DESC
  s.homepage     = "https://github.com/WebAPIKit/WebAPIKit"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Evan Liu" => "evancoding@gmail.com" }
  s.source       = { :git => "https://github.com/WebAPIKit/WebAPIKit.git", :tag => s.version.to_s }
  
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source_files  = "Sources/**/*"
  
  s.dependency "Alamofire", "~> 4.4"
  s.dependency "Result", "~> 3.2"
end
