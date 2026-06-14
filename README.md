# Beyond the Sidelines

A warm, non‑clinical recovery companion that pairs **physical therapy** with **journaling**, so people healing from an injury can do their exercises *and* check in with how they feel, all in one place.

Built on the **Rebound design system** (apricot/sage/sky palette, soft shadows, gentle motion). Light theme, sentence‑case, no emoji, "one step at a time."

---

## What it does

Two ways to use it, exactly as you described:

1. **Through a PT center**, the person enters a *center code* during sign‑up. Their **exercise reports** get sent to the PT; the PT can send back **notes of encouragement**. The **journal stays completely private** to the patient.
2. **On their own**, a regular account, no clinic attached. Same experience, minus the reports/notes.

Both paths start with an **onboarding wizard** that asks:
- what injury you're recovering from (+ which side),
- your current **limits/constraints** (e.g. "no weight on that leg yet"),
- a few **short‑term goals** you're working toward,
- and which of the two ways you'll use it.

### The screens
- **Landing page**, marketing site with an interactive product preview. Only shown when signed out (or after sign‑out).
- **Sign up / Sign in / Center code**, the two entry paths.
- **Onboarding**, the setup wizard above.
- **Today (home)**, a calm, welcoming overview, *not* a to‑do list. A warm greeting, a gentle one‑tap mood check‑in, any new note from your care team, and friendly shortcuts into the rest of the app.
- **Exercises**, your PT session on its own tab: each exercise as a card with steps, cues, and tap‑to‑complete sets. Finishing sends a report to your PT (center mode) or saves to your progress (solo).
  - **Guided session player:** tap "Start guided session" to be walked through each exercise, with hold timers, rep pacing, rest countdowns, and a finish celebration. A music button lets you **open Spotify or Apple Music** (plays in your own app alongside), play a track from your device, or pick a built‑in vibe (Calm / Focus / Hype).
  - **Feedback to your PT:** after each exercise you can tap *too easy / just right / tough / it hurt*. It shows up on the therapist's dashboard so they can adjust your plan.
  - The library shows a gentle "Check with your PT" flag on exercises that may clash with a limit you noted in setup.
  - **On your own:** the plan starts **empty**, you build it yourself. "Add exercise" opens a library that defaults to *your* body area (knee, shoulder, ankle, back, hip, wrist, based on what you chose in setup), and you can browse any area and add anything. You can **create your own custom exercise** (name, instructions, video link) and **adjust the reps / hold time / sets / rest** on any exercise before adding it (or change them later). In your plan you can **drag the handle to reorder** exercises and **duplicate** any one (to make a lighter/heavier variant you can then tweak).
  - **With a PT center:** a starter plan matched to your injury is assigned for you (standing in for the PT, until the clinic dashboard exists).
  - Not working with a PT? All PT features (care notes, reports) stay hidden, and you can add a center later from **Profile → Add a center**.
- **Journal**, the daily check‑in: mood + pain faces, "one small win," a writing prompt, an optional **photo of today**, and a private entry. A week strip shows past days colored by mood.
- **Journey**, the payoff: streaks, a mood trend, a calendar of every day you showed up, badges, your goals, **self‑set rewards** ("hit a streak → treat yourself"), "small wins worth remembering," and (center mode) notes from your care team.
- **Profile & settings**, edit your injury, constraints, and goals; set a **daily reminder**; see reports sent to your center; add or turn off a PT center; sign out or delete your data.

### For physical therapists

There's a third sign‑up on the landing page: **"Are you a physical therapist? Set up your clinic."** A therapist account is different:
- You enter your name + clinic and get a **unique clinic code** to share with patients.
- When a patient enters that code (at sign‑up or in their profile), they connect to you.
- You see **only the clinic dashboard**, organized **by patient**. For each patient you can assign exercises from the library, **create custom exercises with your own step‑by‑step instructions and a video link**, and send **notes/tips**. It all shows up on that patient's app (their exercises are marked "From your PT").
- **One therapist, many patients.** You also see each patient's latest session adherence.
- **You can never see a patient's journal, mood, or reflections**, only their exercises and progress. That privacy is enforced in the app.
- A patient who heals can **turn off the PT connection** (Profile) and keep using the app for wellness on their own.

Try it instantly with **"Explore a therapist demo"** on the therapist sign‑up screen. To see the real two‑sided flow on one device: sign up a therapist (copy the code), sign out, sign up a patient and connect with that code, then sign back in as the therapist to assign their plan.

Once you connect Firebase (below), accounts and data are saved to the cloud and sync across devices. Until then it remembers you on the same device.

---

## Project layout

The web app lives in the **`www/`** folder (this is the standard layout for turning it into an App Store app later). Everything you'd edit is in there:

```
beyond-the-sidelines/
├── www/                  ← the actual app (host THIS folder)
│   ├── index.html        ← the whole app
│   ├── styles.css        ← styling
│   ├── firebase-config.js← paste your Firebase keys here
│   ├── manifest.webmanifest, sw.js   ← makes it an installable app
│   ├── vendor/           ← bundled libraries (offline-ready)
│   └── assets/           ← logo + app icons
├── capacitor.config.json, package.json   ← App Store build files
├── assets/logo.png       ← source icon for the app stores
├── APP-STORE-GUIDE.md    ← step-by-step App Store / Play Store guide
└── README.md             ← this file
```

## How to open it

A tiny local server is the most reliable way to view it:

```bash
cd "/Users/ananya/beyond-the-sidelines/www"
python3 -m http.server 4178
```

Then open **http://localhost:4178** in your browser. (Press `Ctrl+C` in the terminal to stop it.)

> The app is fully self‑contained now (libraries are bundled in `www/vendor/`), so it works offline. Only the brand fonts load from the web; offline they fall back to your system font.

### Try it instantly
On any sign‑in screen, click **"Explore a filled‑in demo account"** to jump straight into a fully populated example (Maya, 6 weeks into knee recovery, connected to a PT center). Great for showing a PT clinic what it looks like in use.

**Demo center codes:** `RIVER-2026`, `SUMMIT-PT`, `BAYAREA`, or type any code, it'll connect to a generic "Your PT center."

---

## Install it as an app (PWA)

The site is an **installable app** — it has a home‑screen icon, runs full‑screen (no browser bar), and works offline after the first visit. To install, it must be opened from a real web address (not by double‑clicking the file), so host it first (see "Sending it to PT places" just below), then:

- **iPhone (Safari):** open the link → tap the **Share** button → **Add to Home Screen**.
- **Android (Chrome):** open the link → tap the **⋮** menu → **Install app** (or "Add to Home Screen").
- **Computer (Chrome/Edge):** open the link → click the **install icon** in the address bar.

It then launches like a normal app with the Beyond the Sidelines icon. (This is the foundation for the App Store / Play Store version later — that step wraps this same app with Capacitor.)

---

## Sending it to PT places

To put it online so you can share a link (and so the app is installable):

1. Go to **[app.netlify.com/drop](https://app.netlify.com/drop)** (free, no account needed to start).
2. Drag the **`www`** folder (inside `beyond-the-sidelines`) onto the page.
3. You'll get a public link you can send to anyone.

(GitHub Pages, Vercel, or Cloudflare Pages work the same way, it's just static files.)

---

## Logins & accounts

- **New account = empty.** When someone signs up, they start with a blank slate, onboarding, then an empty journal/journey that fills in as they use it.
- **Returning account = restored.** Logging back in brings their data back.
- Out of the box, the app runs in **device-only mode** (accounts saved on that one device, no Google sign-in) so it works instantly with zero setup. The sign-in screen tells you when it's in this mode.

### Turn on real, secure logins + Google (Firebase), ~10 minutes, free

Do this once to enable genuine **Sign in with Google**, secure email/password, and data that **syncs across devices**.

1. **Create a project**, go to **[console.firebase.google.com](https://console.firebase.google.com)** → *Add project*. Give it a name (e.g. "beyond-the-sidelines"); you can skip Google Analytics.
2. **Register a web app**, on the project home, click the **`</>`** (Web) icon → give it a nickname → *Register app*. Firebase shows a `firebaseConfig` block. Keep that screen open.
3. **Paste the keys**, open **`www/firebase-config.js`** and copy each value (`apiKey`, `authDomain`, `projectId`, `storageBucket`, `messagingSenderId`, `appId`) from Firebase into it, replacing the `PASTE_…` placeholders.
4. **Enable sign-in methods**, in the Firebase console: **Build → Authentication → Get started → Sign-in method**, then enable **Email/Password** and **Google** (for Google, pick a support email and save).
5. **Create the database**, **Build → Firestore Database → Create database** → *Start in production mode* → pick a location.
6. **Lock the database to each user**, in Firestore → **Rules**, paste this and *Publish*:

   ```
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /users/{uid} {
         allow read, write: if request.auth != null && request.auth.uid == uid;
       }
       // Shared therapist↔patient connection docs (keyed by clinic code).
       // Any signed-in user can read/join; tighten later for production.
       match /links/{code} {
         allow read, write: if request.auth != null;
       }
     }
   }
   ```

   (Users can read/write **only their own** account data; the `links` rule lets a therapist and their patients share a connection doc. For a real clinic rollout you'd narrow this so only the owning therapist and connected patients can write.)
7. **Authorize your web address**, **Authentication → Settings → Authorized domains → Add domain**, and add the address where you host the app (your Netlify URL, etc.). `localhost` is already allowed for testing.

Reload the app. The sign-in screen will now show **Continue with Google**, and accounts/data are real and synced. (The "device-only mode" note disappears once the keys are in.)

> Tip: keep `firebase-config.js` filled in *before* you drag the folder to Netlify, so the hosted version has real logins.

---

## Resetting your data

To wipe a logged-in account and start fresh, open **Profile → Delete my data**. (Full file layout is in the "Project layout" section above.)

---

## Honest status

The app is fully clickable and now has **real, secure accounts** once Firebase is connected. Still on the roadmap for a real clinic rollout:
- a clinic-side dashboard so PTs actually receive the exercise reports and send notes back (right now those are simulated on the patient side),
- assigning real exercise plans per patient (the library is a knee/ACL starter set),
- a HIPAA-compliant hosting/storage review before handling real patient health data.

Everything else, the two modes, onboarding, the design, and now secure login with cloud sync, is built and ready to grow into that.
