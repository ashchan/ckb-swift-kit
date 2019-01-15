source "https://github.com/CocoaPods/Specs.git"
platform :ios, "11.0"

target 'CKB' do
  use_frameworks!
  use_modular_headers!
  inhibit_all_warnings!

  pod "CryptoSwift", "~> 0.13.1"
  pod "secp256k1_swift", "~> 1.0.3", modular_headers: true

  target "CKBTests" do
    inherit! :search_paths
  end
end
