#
#  Be sure to run `pod spec lint passcode-auth.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "passcode-auth"
  s.version      = "1.0.0"
  s.summary      = "A passcode auth control."
  s.description  = "A simple programatically passcode controll."
  s.license      = "MIT"
  s.author       = { "Alex Ilies" => "alex.ilies@zoho.com" }
  s.source       = { :git => "https://github.com/hackmajoris/passcode-auth.git" }
  s.source_files  = "Project/AuthenticationView/Sources", "Project/AuthenticationView/Sources/**/*.{h,m,swift}"
  s.resource_bundles = {
    'passcode-auth' => ['Project/AuthenticationView/Sources/**/*.{storyboard,xib,xcassets,json,imageset,png}']
  }

  s.resources     = 'Project/AuthenticationView/Sources/**/*.{storyboard,xib,xcassets,json,imageset,png}'
  s.exclude_files = "Classes/Exclude"
  s.swift_version = "4.2" 
  s.platform      = :ios, "11.0"

end
