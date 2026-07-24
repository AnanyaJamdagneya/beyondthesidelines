#!/usr/bin/env bash
# Re-applies the Google sign-in fix to the CapacitorFirebaseAuthentication podspec.
#
# WHY: The plugin's podspec normally only enables Google sign-in via a 'Google' subspec.
# But selecting that subspec from a local (:path) Podfile pod under use_frameworks! makes
# CocoaPods silently fail to LINK the plugin into the app — so the WHOLE native
# FirebaseAuthentication plugin never registers and BOTH Google and Apple sign-in fail with
# "no-google" / "no-apple". Fix: bake Google into the podspec's ROOT spec (a real dependency
# + the -DRGCFA_INCLUDE_GOOGLE compile flag), and use the plain `pod` line (no :subspecs) in
# the Podfile — the plain line links correctly.
#
# node_modules is gitignored, so this edit does NOT survive `npm install`. Run this script
# after any fresh `npm install`, then `cd ios/App && pod install`.
set -e
SPEC="$(dirname "$0")/../node_modules/@capacitor-firebase/authentication/CapacitorFirebaseAuthentication.podspec"

if [ ! -f "$SPEC" ]; then
  echo "podspec not found at $SPEC — is the plugin installed?"; exit 1
fi

if grep -q "RGCFA_INCLUDE_GOOGLE" "$SPEC"; then
  echo "✅ Google fix already applied to podspec."
  exit 0
fi

# Insert the Google dependency + compile flag right after the FirebaseAuth dependency line.
python3 - "$SPEC" <<'PY'
import sys
p = sys.argv[1]
s = open(p).read()
anchor = "s.dependency 'FirebaseAuth', '~> 11.0'\n"
add = ("  s.dependency 'GoogleSignIn', '7.1.0'\n"
       "  s.pod_target_xcconfig = { 'OTHER_SWIFT_FLAGS' => '$(inherited) -DRGCFA_INCLUDE_GOOGLE' }\n")
if anchor not in s:
    print("!! could not find FirebaseAuth dependency anchor; edit the podspec manually"); sys.exit(1)
s = s.replace(anchor, anchor + add, 1)
open(p, 'w').write(s)
print("✅ Applied Google fix to podspec.")
PY
echo "Now run:  cd ios/App && LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 pod install"
