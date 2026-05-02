# Mawqif — مواقف

A native iOS parking reminder app for Riyadh's 147 paid parking zones.

Mawqif runs silently in the background and alerts you at 5 and 10 minutes after you park — before the 15-minute grace period expires. Tap **I Paid** to dismiss, or tap **Pay Now** to go straight to the payment portal.

---

## Screenshots / States

| Idle | In Zone (grace) | Unpaid | Paid |
|---|---|---|---|
| Scanning for zones | Gold timer counting up | Red pulsing ring | Green checkmark |

---

## Features

- **Background location monitoring** — works with the screen off
- **147 paid zones** in Riyadh, each with a 250 m detection radius
- **Reminders at 5 min and 10 min** via local notifications
- **15-minute grace period** shown as a live countdown with a progress bar
- **"I Paid" button** — cancels all reminders instantly
- **"Pay Now"** — deep-links directly to [riyadhparking.sa/Booking](https://riyadhparking.sa/Booking)
- **Silent on Fridays** and Saudi public holidays (hardcoded 2025–2026)
- **Silent outside paid hours** (free between midnight and 8 AM)
- **EN / AR language toggle** in the nav bar with full right-to-left layout
- **Light and dark mode** support via system colors + named color assets

---

## Requirements

- iOS 17.0+
- Xcode 15+
- No third-party dependencies — pure SwiftUI + CoreLocation + UserNotifications

---

## Project Structure

```
Mawqif/
├── MawqifApp.swift               # App entry point (@main)
├── ContentView.swift             # Routes between permission screen and main screen
│
├── Models/
│   ├── ParkingZone.swift         # Codable struct matching parking_zones.json
│   └── ParkingSession.swift      # Active session value type (elapsed, grace, progress)
│
├── Managers/
│   ├── ZoneDatabase.swift        # Loads JSON at launch, Haversine zone lookup
│   ├── NotificationManager.swift # Schedules / cancels UNCalendar notifications
│   └── LocationManager.swift     # CLLocationManager + ParkingAppState machine
│
├── Utilities/
│   └── Strings.swift             # All UI strings in English and Arabic
│
├── Views/
│   ├── PermissionView.swift      # "Allow Always" location permission screen
│   ├── MainView.swift            # Single main screen (all 5 app states)
│   └── Components/
│       ├── StatusRingView.swift  # Animated pulsing ring indicator
│       └── GraceProgressView.swift # Thin progress bar for 15-min grace period
│
├── Assets.xcassets/
│   ├── GoldColor                 # Accent: #C9A84C
│   └── AccentColor
│
├── parking_zones.json            # 147 geocoded zones bundled with the app
└── Info.plist                    # Location permissions + background mode
```

---

## Architecture Decisions

### Single-screen, state-driven UI
The entire app is one screen (`MainView`) that reacts to a `ParkingAppState` enum with five cases: `permissionRequired`, `scanning`, `outsideZone`, `freeHours`, `inZone`, `paid`. No tabs, no navigation stack beyond the root — the state dictates everything rendered on screen. This was intentional: parking is a single, focused task.

### LocationManager as the single source of truth
`LocationManager` owns the `ParkingAppState` and all session logic. Views only read from it and call its public methods (`markPaid()`, `stopSession()`). This keeps views dumb and testable.

### Haversine over CLCircularRegion
Instead of iOS geofences (`CLCircularRegion`), zone detection runs Haversine distance checks on every location update against all 147 zones. Geofences are limited to 20 active regions per app, which wouldn't cover the full zone list. Haversine on 147 points is negligible CPU work.

### UNCalendarNotificationTrigger, not timers
Notifications are scheduled at exact calendar times (`startTime + 5 min`, `startTime + 10 min`) using `UNCalendarNotificationTrigger`. This means they fire even if the app is killed by the OS — no in-process Timer needed.

### Friday + holiday silence
Saudi Arabia observes Friday as the weekend. The app checks `Calendar.weekday == 6` and suppresses all zone detection on Fridays. Saudi public holidays for 2025–2026 are hardcoded (Founding Day Feb 22, National Day Sep 23, approximate Eid dates). This avoids any network call or third-party calendar dependency.

### iOS 17 minimum deployment target
The zero-argument `onChange(of:)` SwiftUI modifier (used for the pulsing ring animation) requires iOS 17. Given this is a new app targeting a specific city's infrastructure, iOS 17 (released Sep 2023) is a reasonable floor.

### Bilingual strings as a static struct
All UI text lives in `Strings.swift` as two static instances (`S.english`, `S.arabic`). The active language is stored in `@AppStorage("appLanguage")` and toggled via a button in the nav bar. RTL layout is applied with `environment(\.layoutDirection, .rightToLeft)` at the root level. This approach avoids `.strings` files and keeps all copy in one place.

### Gold accent (#C9A84C)
The single brand color references Riyadh's architectural palette. It sits well on both light and dark backgrounds and provides sufficient contrast for the timer display.

---

## Running the App

1. Open `Mawqif.xcodeproj` in Xcode
2. Select your iPhone as the run destination
3. In **Signing & Capabilities**, set your Development Team
4. Run — the app will prompt for Always On location permission

> Location permission must be set to **Always** for background detection to work. "While Using" will only detect zones when the app is open.

---

## HTML Reference / Web Demo

The file `riyadh-parking-reminder.html` in the root of this repo is the original browser prototype used as a logic reference during development.

**To open it:** double-click the file — it opens directly in Safari or Chrome as a local webpage, no server needed.

It contains a **Demo / Test** section at the bottom with buttons to simulate arriving, skipping to 5/10/15 minutes, and leaving a zone — useful for understanding the app logic without driving to Riyadh. Note: it uses browser notifications, not iOS notifications.

---

## Generating the Xcode Project File

If you add new Swift files, update `generate_project.py` (in the repo root) and run:

```bash
cd parkingreminder
python3 generate_project.py
```

This regenerates `Mawqif.xcodeproj/project.pbxproj` with all file references wired up.
