Pod::Spec.new do |s|
  s.name         = "LoginHelper"
  s.version      = "0.0.1"
  s.summary      = "A short description of LoginHelper."
s.description  =  s.description      = <<-DESC
LoginHelper handles Signup & Login, via Facebook, Google & Email. It takes care of the UI, the forms, validation, and Facebook SDK access.
All you need to do is start LoginKit, and then make the necessary calls to your own backend API to login or signup.
DESC
  s.homepage     = "https://github.com/macro-dadt/LoginHelper"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "macro.dat" => "macro.dat@trim-inc.com" }
  s.source       = { :git => "https://github.com/macro-dadt/LoginHelper.git", :tag => "#{s.version}" }
  s.source_files  = "Classes/**/*"
  s.exclude_files = "Assets/*.{xib,xcassets,png,jpg,otf,ttf}"
  s.dependency 'Validator'
  s.dependency 'FBSDKLoginKit'
  s.dependency 'Google/SignIn'
end
