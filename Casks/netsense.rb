cask "netsense" do
  version "1.9.5"
  arch arm: "aarch64", intel: "x64"
  sha256 arm: "dad157f38cb9b03aeeb66edaf81862686484c098820c798f26dec9e738855fc2",
         intel: "064b2fc0b1975e2fad5295f1dc4d595f993ce06e8b26fca31ede5740ce509a2f"

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
