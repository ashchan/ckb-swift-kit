source "https://github.com/CocoaPods/Specs.git"
platform :ios, "11.0"

target 'CKB' do
  use_frameworks!
  use_modular_headers!
  inhibit_all_warnings!

  pod "CryptoSwift", "~> 1.0.0"
  pod "Sodium", "~> 0.8.0"
  pod "secp256k1.swift", "~> 0.1.4"
  pod "SwiftLint"
end

target "CKBTests" do
  use_frameworks!
end

target "Examples-iOS" do
  use_frameworks!
  use_modular_headers!
  inhibit_all_warnings!

  pod "CKB", git: "https://github.com/nervosnetwork/ckb-sdk-swift.git", branch: "rc/v0.10.0"
end

