cask "netsense" do
  version "0.2.2"
  arch arm: "aarch64", intel: "x64"
  sha256 arm: "52ed24816a9b7b714f248f21feaa87cf3ad297ad58bd15ee8869a1c5314d7717",
         intel: "b86e266aad1dc7363a052760c33897f7096949443ad5ca4589b71835cd00a012"

  url "https://github.com/imonior/netsense/releases/download/v#{version}/NetSense_#{version}_#{arch}.dmg"
  name "NetSense"
  desc "Cross-platform SSID-aware network profile switcher"
  homepage "https://github.com/imonior/netsense"

  depends_on macos: :catalina

  app "NetSense.app"

  # Unsigned build: strip the Gatekeeper quarantine flag after install
  # (equivalent to the user running `xattr -dr com.apple.quarantine`).
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/NetSense.app"]
  end

  uninstall quit: "com.netsense.app"

  zap trash: [
    "~/Library/Application Support/com.netsense.app",
    "~/Library/Caches/com.netsense.app",
    "~/Library/Preferences/com.netsense.app.plist",
  ]
end
