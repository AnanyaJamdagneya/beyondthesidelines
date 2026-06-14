# Putting Beyond the Sidelines in the App Store & Google Play

This turns your **existing website into a real App Store / Play Store app** using a tool called **Capacitor**. It wraps the same web app you already have — **you don't write any Swift or Java**, and it stays *one app*: the website and the phone apps share the same code and (through Firebase) the same logins and data.

I've already done the prep:
- Bundled all the libraries locally (`www/vendor/`) so the app is **self‑contained and works offline** — important for App Store approval.
- Organized the web app into the **`www/`** folder (the tool expects this).
- Added the project files: **`capacitor.config.json`**, **`package.json`**, and an icon source (**`assets/logo.png`**).

The rest is run on a **Mac**, in the **Terminal app** and Apple's **Xcode**. Take it one step at a time; copy‑paste the commands exactly.

---

## What you'll need

| Thing | Why | Cost |
|---|---|---|
| A **Mac** | Required to build the iPhone app | — |
| **Node.js** | Runs the Capacitor tool | free |
| **Xcode** (Mac App Store) | Builds + submits the iPhone app | free |
| **Android Studio** | Builds the Android app (optional, only if you want Google Play) | free |
| **Apple Developer Program** | Required to publish to the App Store | **$99 / year** |
| **Google Play Console** | Required to publish to Google Play | **$25 once** |

> ⚠️ **Connect Firebase first.** For the app and website to share one login and sync data, follow the Firebase steps in `README.md` and paste your keys into `www/firebase-config.js` **before** building. Without it, the app works but each device is separate.

> 🩺 **Health‑data note.** Before real patients use it, you'll want a HIPAA review (a Business Associate Agreement with Google for Firebase + proper config). That's a business/legal step, not code. Fine for testing and demos now.

---

## Step 1 — Install the tools (one time)

1. **Node.js:** go to **[nodejs.org](https://nodejs.org)**, download the "LTS" version, install it (just click through).
2. **Xcode:** open the **App Store** on your Mac, search **Xcode**, install (it's big — grab a coffee). Open it once and accept the license.
3. **(Android only) Android Studio:** download from **[developer.android.com/studio](https://developer.android.com/studio)** and install.

To check Node installed, open **Terminal** (press Cmd+Space, type "Terminal") and run:
```bash
node -v
```
You should see a version number like `v20.x`.

---

## Step 2 — Set up the project (one time)

In Terminal, go to the project folder and install everything:
```bash
cd "/Users/ananya/beyond-the-sidelines"
npm install
```

Add the phone platforms:
```bash
npx cap add ios
npx cap add android      # skip this line if you only want the iPhone app
```
This creates `ios/` and `android/` folders (the native wrappers — you won't edit them by hand).

---

## Step 3 — Generate the app icon & splash screen

```bash
npm run icons
```
This reads `assets/logo.png` and creates every icon size + launch screen for both platforms automatically.

---

## Step 4 — Copy your app into the native projects

Any time you change the app (anything in `www/`), run:
```bash
npx cap sync
```
This copies your latest web app into the iPhone/Android projects.

---

## Step 5 — Run it on your iPhone (free, no paid account yet)

```bash
npx cap open ios
```
Xcode opens. Then:
1. Plug in your iPhone (or use a simulator).
2. Click the project name (**App**) in the left sidebar → **Signing & Capabilities** tab.
3. Under **Team**, pick your Apple ID (click "Add an Account" and sign in with your normal Apple ID — this is free and lets you test on your own phone).
4. At the top, choose your iPhone from the device dropdown.
5. Press the **▶ Run** button. The app installs on your phone and launches. 🎉

> On the phone, the first time, go to **Settings → General → VPN & Device Management** and trust your developer certificate if it asks.

### Android version
```bash
npx cap open android
```
Android Studio opens → press the green **▶ Run** button with a device/emulator selected.

---

## Step 6 — When you make changes later

The loop is always:
1. Edit files in **`www/`** (or have me do it).
2. If you changed styling/app files, bump the cache in `www/sw.js` (change `bts-v2` to `bts-v3`).
3. Run `npx cap sync`.
4. Re‑run from Xcode / Android Studio.

---

## Step 7 — Publish to the App Store

1. **Buy the Apple Developer Program** ($99/yr) at **[developer.apple.com/programs](https://developer.apple.com/programs/)**. Approval can take a day or two.
2. In **Xcode → Signing & Capabilities**, make sure **Team** is your paid developer account and the **Bundle Identifier** is `com.beyondthesidelines.app` (change it if you own a different domain — it must be unique and can't be changed after first submit).
3. Set a version + build number (Xcode → the **General** tab).
4. In Xcode top menu: **Product → Destination → Any iOS Device**, then **Product → Archive**. When it finishes, the Organizer opens → **Distribute App → App Store Connect → Upload**.
5. Go to **[appstoreconnect.apple.com](https://appstoreconnect.apple.com)** → **Apps → +** → create the app (name, the bundle id, language).
6. Fill in the listing: **screenshots** (take them from the simulator), **description**, **keywords**, **support URL**, **privacy policy URL**, and the **App Privacy** questionnaire (you collect email + health‑related journal/exercise data — disclose it honestly).
7. Attach your uploaded build → **Submit for Review**. Review usually takes 1–3 days.

---

## Step 8 — Publish to Google Play

1. **Pay the $25** one‑time fee at **[play.google.com/console](https://play.google.com/console)**.
2. In Android Studio: **Build → Generate Signed Bundle / APK → Android App Bundle**. Create a signing key when prompted and **save it safely** (you need it for every future update).
3. In Play Console: **Create app** → upload the `.aab` → fill the store listing + content rating + data‑safety form → roll out to production (or internal testing first).

---

## Native features (already coded in — here's how to switch each on)

The app is written so these light up automatically when it runs as the native app, and stay quiet/graceful on the website. After `npm install` and `npx cap sync`, do the per‑feature setup:

**🎵 Music (works now, no setup):** In the guided session, the music menu lets you paste a **Spotify or Apple Music link** and it plays *inside the app*, plus built‑in vibes and your own audio files. Already live on web and native — nothing to configure.

**🔔 Daily reminders → real phone notifications:** uses `@capacitor/local-notifications` (already in `package.json`). When someone sets a reminder time in Profile, the phone notifies them daily even when the app is closed.
- iOS: permission is requested automatically the first time.
- Android 13+: it asks for notification permission automatically too.
- No server needed — these are scheduled on the device.

**👟 Apple Health / Google Fit steps:** the Home "Today's movement" card reads real steps on the phone. Pick a health plugin and install it:
```bash
npm install capacitor-health   # cross-platform steps; or an iOS-only HealthKit plugin
npx cap sync
```
Then add permissions:
- **iOS (Xcode):** select the project → **Signing & Capabilities → + Capability → HealthKit**. Then in **Info.plist** add `NSHealthShareUsageDescription` = "Shows your daily steps on your home screen."
- **Android:** Health Connect permissions are added by the plugin; review them in `android/app/src/main/AndroidManifest.xml`.
- The reading code is already wired (`readNativeSteps` in `index.html`); if your chosen plugin's method names differ slightly, that one function is the only place to adjust.

**📨 Push from the PT to the patient (future):** "your therapist sent a note" alerts need a tiny server piece (Firebase Cloud Messaging) plus `@capacitor/push-notifications` (already in `package.json`). The local daily reminder above covers the main nudge; ask me when you want to add true PT→patient push and I'll wire the FCM side.

---

## Honest expectations

- **First submissions often get rejected** for small reasons (a missing privacy policy, a screenshot issue, login needed for review). Apple/Google tell you what to fix; you resubmit. It's normal.
- Apple occasionally rejects apps that feel like "just a website." Yours is a full, offline‑capable, interactive app with its own icon and login, which generally passes — and adding a native feature (push notifications or Apple Health) makes it bulletproof. Ask me and I'll wire one in.
- If the Terminal/Xcode steps feel like too much, this prepared project is exactly what a freelance developer would need — you could hand them this folder + this guide and it's a short, cheap job for them to submit.

You've already got the hard part (a real, polished app). This is just packaging and paperwork.
