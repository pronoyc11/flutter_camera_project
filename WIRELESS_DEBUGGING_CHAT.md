# Wireless Debugging Chat Transcript

## Format: Q&A (verbatim wording)

### User
Hey teach me to run my app on real device while developing instead of an emulator without using any usb

### Assistant
Use **wireless debugging** with your phone on the same Wi-Fi as your PC.

Since your project is Flutter (`.dart`), here’s the fastest setup on **Windows + Android**:

1. On phone, enable developer mode
   - `Settings > About phone > tap Build number 7 times`
2. Enable in Developer options
   - `USB debugging`
   - `Wireless debugging`
3. Pair phone with your PC (no USB)
   - In `Wireless debugging`, tap **Pair device with pairing code**
   - Note the IP:port + pairing code
4. In your terminal, run:
```bash
adb pair <ip>:<pairing_port>
```
Enter the pairing code when prompted.

5. Then connect:
```bash
adb connect <ip>:<debug_port>
```
(Use the connect address shown on the phone’s Wireless debugging screen.)

6. Verify Flutter sees your phone:
```bash
flutter devices
```

7. Run app on device:
```bash
flutter run
```
Or specify explicitly:
```bash
flutter run -d <device_id>
```

If `adb` isn’t recognized, install Android platform-tools (or use Android Studio terminal where adb is already available).

If you want, I can give you a **copy-paste command flow** based on your exact phone screen values.

### User
Ok do that, I don't understand step 5

### Assistant
Step 5 means: after pairing, you must make a normal ADB connection to the phone’s **debug port** (different from pairing port).

Use this exact flow:

```powershell
adb pair 192.168.1.50:37043
# enter 6-digit pairing code shown on phone
adb connect 192.168.1.50:40489
```

Important:
- `37043` = pairing port (from “Pair device with pairing code” screen)
- `40489` = debug/connect port (from main “Wireless debugging” page, usually shown as “IP address & port”)

Then verify:

```powershell
adb devices
flutter devices
flutter run
```

If `adb connect` says failed:
1. Turn Wireless debugging off/on
2. Use the new IP:port shown by phone
3. Run `adb connect <new_ip>:<new_port>` again

If you share your exact two IP:port values from your phone screen, I’ll give you the exact commands to paste.

### User
flutter run -d <device_id>

which is the device id here?

### Assistant
`<device_id>` is the value shown in `flutter devices`.

Run:

```powershell
flutter devices
```

You’ll see something like:

```text
3 connected devices:

SM M325F (mobile) • RZ8N12345AB • android-arm64 • Android 14
Chrome (web)       • chrome      • web-javascript
Windows (desktop)  • windows     • windows-x64
```

Here, for your real phone, the device id is `RZ8N12345AB`.

So run:

```powershell
flutter run -d RZ8N12345AB
```

Tip: if only your phone is connected, plain `flutter run` is enough.

### User
Error: ADB exited with exit code 1
Performing Streamed Install

adb.exe: failed to install E:\VHOR_PREPARATIONS\fav_places\build\app\outputs\flutter-apk\app-debug.apk: Failure
[INSTALL_FAILED_USER_RESTRICTED: Install canceled by user]
Error launching application on M2101K6P.

This is the error message I get after I've followed all your steps and executed flutter run

### Assistant
That error is from the phone side, not Flutter code.
`INSTALL_FAILED_USER_RESTRICTED` means your phone blocked the ADB install.

Do this on the phone (`M2101K6P`, Xiaomi/MIUI likely):

1. Keep phone **unlocked** while running `flutter run`.
2. Go to `Settings > Additional settings > Developer options`.
3. Turn on:
   - `USB debugging`
   - `USB debugging (Security settings)` (if shown)
   - `Install via USB` (if shown)
4. When you run again, watch for a popup like **“Allow install via USB / via ADB”** and tap **Allow**.
5. Also allow install from unknown sources for package installer if prompted.

Then on PC run:

```powershell
adb kill-server
adb start-server
adb devices
flutter run -d <your_device_id>
```

If it still fails, send me:
- output of `adb devices`
- full `flutter run -v` install error block
and I’ll pinpoint the exact setting still blocking it.
