# Get the latest Download URL
let version = curl https://api.beeper.com/desktop/download/linux/x64/stable/com.automattic.beeper.desktop
| split row "/"
| $in.4
| split row "-"
| $in.1

# Use the version to get the URL
let url = $"https://beeper-desktop.download.beeper.com/builds/Beeper-($version)-x86_64.AppImage"

# Get the SRI Hash
let hash = nix-prefetch-url $url --type sha256
| nix hash convert --hash-algo sha256 $in

# This does a lot of stuff that I don't feel like explaining
cat ./default.nix
| split row "\""
| update 3 $version
| update 7 $hash
| str join "\""
| save default.nix -f
