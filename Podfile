source "https://github.com/CocoaPods/Specs.git"
platform :ios, "11.0"

target 'CKB' do
  use_frameworks!
  use_modular_headers!
  inhibit_all_warnings!

  pod "CryptoSwift", "~> 0.14.0"
  pod "secp256k1_swift", modular_headers: true, git: "https://github.com/cryptape/secp256k1_swift.git", branch: "swift-4.2", submodules: true
  pod "SwiftLint"

  target "CKBTests" do
    inherit! :search_paths
  end
end
