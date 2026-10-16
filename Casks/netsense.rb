cask "netsense" do
  version "1.7.0"
  arch arm: "aarch64", intel: "x64"
  sha256 arm: "fd23421eaf931ed554b84a7fe7be5c6b409c3df5b2195e09abcae9e840cb3a42",
         intel: "8dde842bd0601ffd904d1f5d1f43d438292a30e6af3c1567d1aa0825b8118cfc"

  url "https://github.com/imonior/netsense/releases/download/v#{version}/NetSense_#{version}_#{arch}.dmg"
  name "NetSense"
  desc "Cross-platform SSID-aware network profile switcher"
  homepage "https://github.com/imonior/netsense"

  # No depends_on macos: here -- NetSense needs 10.15+, which is at or below
  # Homebrew's own floor (Big Sur), so it is redundant and Homebrew 7.0 rejects
  # it outright ("Calling depends_on macos: :catalina is disabled!").
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
