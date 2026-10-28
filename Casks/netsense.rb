cask "netsense" do
  version "1.8.7"
  arch arm: "aarch64", intel: "x64"
  sha256 arm: "a5a5362288cdcf1060e53f59630428738ce0bb55718d0fa4e630d5b59ce6d098",
         intel: "2c753b4c130cdb8480486af75d806b9b2f6e45f799ccd4fc3370ba9897f5990e"

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
