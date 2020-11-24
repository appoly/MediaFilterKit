Pod::Spec.new do |spec|

  spec.name         = "MediaFilterKit"
  spec.version      = "0.1"
  spec.license      = "MIT"
  spec.summary      = "A swift library for wrapping and applying core image filters to a image or audiovisual asset."
  spec.homepage     = "https://github.com/appoly/MediaFilterKit"
  spec.authors = "James Wolfe"
  spec.source = { :git => 'https://github.com/appoly/PassportKit.git', :tag => spec.version }

  spec.ios.deployment_target = "9.0"
  spec.framework = "UIKit"
  spec.framework = "AVKit"
  spec.framework = "CoreImage"

  spec.swift_versions = ["5.0", "5.1"]
  
  spec.source_files = "Sources/*.swift"
  

end
