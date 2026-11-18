cask "netsense" do
  version "2.0.0"
  arch arm: "aarch64", intel: "x64"
  sha256 arm: "c5b1e95dbffdadad3e9931aea75fc2fe689d502c6e2aa21eeb8d7bd0f1d0b462",
         intel: "44e619eb8af2a0224d911f28b46a5b702d6303a1367742b962242348c34f443f"

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
