cask "wireguideplus" do
  version "2.3.1"
  sha256 "a6cedd1af78f1a57c0185569e6d37d93589f0bb0e0a7d6ed9bc295f3b20b7e7c"

  url "https://github.com/imonior/wireguide-plus/releases/download/v#{version}/WireGuidePlus-#{version}-darwin-arm64.zip"
  name "WireGuide Plus"
  desc "Multi-tunnel automated WireGuard VPN client"
  homepage "https://github.com/imonior/wireguide-plus"

  # No depends_on macos: here -- WireGuide Plus needs 10.15+, which is at or
  # below Homebrew's own floor (Big Sur), so it is redundant and Homebrew 7.0
  # rejects it outright ("Calling depends_on macos: :catalina is disabled!").
  app "wireguideplus.app"

  # Symlink the CLI onto PATH (Homebrew's bin), so users get a
  # global `wireguideplus ctl ...` after `brew install` instead of
  # the in-bundle `/Applications/wireguideplus.app/Contents/MacOS/wireguideplus`.
  binary "#{appdir}/wireguideplus.app/Contents/MacOS/wireguideplus"

  # auto_updates true tells `brew upgrade` to defer to the
  # app's own update mechanism, which prevents brew + the
  # in-app scheduler from racing to upgrade the same install
  # (the wireguide RunUpdate path also shells out to brew, so
  # without this flag a user clicking "Update Now" while brew
  # is auto-upgrading hits a lock contention).
  auto_updates true

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/wireguideplus.app"]
    system_command "/usr/bin/killall",
                   args: ["wireguideplus"],
                   must_succeed: false
    system_command "/bin/sleep",
                   args: ["1"],
                   must_succeed: false
    system_command "/usr/bin/open",
                   args: ["#{appdir}/wireguideplus.app"],
                   must_succeed: false
  end

  uninstall quit: "com.imonior.wireguide-plus"

  zap launchctl: "com.wireguideplus.helper",
      delete: [
        "/Library/PrivilegedHelperTools/com.wireguideplus.helper",
        "/Library/LaunchDaemons/com.wireguideplus.helper.plist",
      ],
      trash: [
        "~/Library/Application Support/wireguideplus",
        "~/Library/Preferences/com.imonior.wireguide-plus.plist",
        "/var/run/wireguideplus",
        "/var/log/wireguideplus-helper.log",
      ]
end
