source "https://github.com/CocoaPods/Specs.git"
platform :osx, "10.13"

target 'CKB' do
  use_frameworks!
  use_modular_headers!
  inhibit_all_warnings!

  pod "CryptoSwift", "~> 1.2.0"
  pod "Sodium", "~> 0.8.0"
  pod "secp256k1.swift", "~> 0.1.4"
  pod "SwiftLint"

  pre_install do |installer|
    installer.analysis_result.specifications.each do |s|
      if s.name == 'CryptoSwift'
        s.swift_version = '5.1'
      end
    end
  end
end

target "CKBTests" do
  use_frameworks!
end

