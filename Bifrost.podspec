Pod::Spec.new do |s|
  s.name         = "Bifrost"
  s.version      = "0.1"
  s.summary      = "Bifrost"
  s.description  = <<-DESC
    The iOS framework provides an way to handle authentication logic. 
  DESC
  s.homepage     = "https://bitbucket.org/altran-ais/"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Dennis Merli" => "dennis.merli1@gmail.com" }
  s.social_media_url   = ""
  
  s.source = {:http => 'https://github.com/neneds/bifrost.git'}
  s.module_name = "Bifrost"
  s.swift_version = '4.0'
  s.ios.resources = ['Bifrost/*']
  s.platform = :ios, "11.3"
  s.ios.deployment_target = "11.3"
  s.exclude_files = "Bifrost/Resources/*.plist"
  s.ios.public_header_files = "Bifrost/**/*.h"
  s.ios.source_files  = "Bifrost/**/*.{h,m,swift}"
  s.ios.frameworks  = "Foundation" 
  s.dependency  'Moya',       '~> 12.0' 
  s.dependency  'RxSwift',    '~> 4.0'
  s.dependency  'RxCocoa',    '~> 4.0'
end
