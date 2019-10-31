Pod::Spec.new do |spec|

  spec.name         = "Monri"
  spec.version      = "0.0.1"
  spec.summary      = "Monri iOS SDK"

  spec.description  = <<-DESC
Monri iOS SDK - simplified card collection & payment
                   DESC

  spec.homepage     = "https://github.com/jasminsuljic/monri-ios"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "jasminsuljic" => "jasmin.suljich@gmail.com" }

  spec.ios.deployment_target = "12.1"
  spec.swift_version = "4.2"

  spec.source        = { :git => "https://github.com/jasminsuljic/monri-ios.git", :tag => "#{spec.version}" }
  spec.source_files  = "Monri/**/*.{h,m,swift}"

end