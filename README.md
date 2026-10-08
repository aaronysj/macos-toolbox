# macos-toolbox

Small macOS utility scripts I use on my machine.

## Scripts

### `bin/tzapp`

Relaunch a macOS app with its own time zone (default `Asia/Shanghai`), while the
system and other apps keep their normal time zone.

```sh
tzapp DingTalk              # restart DingTalk showing Asia/Shanghai time
tzapp W                     # WeChat
tzapp W Asia/Tokyo          # any IANA time zone
tzapp /Applications/W.app   # absolute path also works
```

How it works:

- `open -n --env TZ=...` starts the app with `TZ` in its environment. GUI apps
  do not inherit the shell's `TZ`, so `open --env` is required.
- `__XPC_TZ=...` is also set: XPC services spawned by the app (e.g. WKWebView's
  `com.apple.WebKit.WebContent`/`Networking`/`GPU` processes) only inherit
  environment variables prefixed with `__XPC_`, stripped of the prefix. Without
  it, natively rendered parts of the app use the new zone while web-rendered
  parts (like DingTalk's calendar) stay on the system zone.
- The app is quit gracefully first (`tell application id ... to quit`, falling
  back to `SIGTERM`), and the script waits for the main process to fully exit —
  `open` on an already-running app only raises windows and never applies env vars.
- After launch it verifies `TZ` is present in the new process's environment.

Caveats:

- Only affects that launch. Dock launches, login items, crash auto-relaunches
  and post-update relaunches all lose `TZ` — rerun `tzapp`.
- Quitting uses Apple Events; on first use macOS may ask to grant your terminal
  Automation permission. Without it the script falls back to `SIGTERM`, which
  may skip unsaved-changes prompts.
- Apps with hardened-runtime checks or server-rendered timestamps may still
  ignore `TZ` entirely.

## Install

```sh
./install.sh            # links bin/* into ~/.local/bin
PREFIX=~/bin ./install.sh
```
