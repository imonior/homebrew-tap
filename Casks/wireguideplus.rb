cask "wireguideplus" do
  version "1.6.0"
  sha256 "4f15b545aaee619cba8db25028f2345adc19d2eac219a62f8cfd26bfc00e9de2"

  url "https://github.com/imonior/wireguide-plus/releases/download/v#{version}/WireGuidePlus-darwin-arm64.zip"
  name "WireGuide Plus"
  desc "Multi-tunnel automated WireGuard VPN client"
  homepage "https://github.com/imonior/wireguide-plus"

  depends_on macos: :catalina

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
