source "https://github.com/CocoaPods/Specs.git"
platform :ios, "11.0"

target 'CKB' do
  use_frameworks!
  use_modular_headers!
  inhibit_all_warnings!

  pod "CryptoSwift", "~> 0.15.0"
  pod "Sodium", git: "https://github.com/jedisct1/swift-sodium.git", commit: "adc2c117bedf186cb4cdcd64c5b93b7f1f55e185" # "~> 0.7.0"
  pod "secp256k1.swift", "~> 0.1.4"
  pod "SwiftLint"
end

target "CKBTests" do
  use_frameworks!
end
