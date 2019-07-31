
Pod::Spec.new do |s|
  s.name         = "RNMyLibrary"
  s.version      = "1.0.0"
  s.summary      = "RNMyLibrary"
  s.description  = <<-DESC
                  RNMyLibrary
                   DESC
  s.homepage     = "https://github.com/zzhoouxin/react-native-share"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "JillZsy" => "zsy0530@163.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/zzhoouxin/react-native-share.git", :tag => "#{s.version}" }
  s.vendored_frameworks = ['QQSDK/TencentOpenAPI.framework']
  s.source_files  = "*.{h,m}", "src/*.{h,m}"
  s.resource = 'AJShareSDK.bundle'
  s.requires_arc = true


  s.dependency "React"
  #s.dependency "others"

end

  