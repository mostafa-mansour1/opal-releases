---
title: "Installation and Troubleshooting"
description: "How to install OPAL on macOS, Windows, and Linux, and how to fix common problems."
lastUpdated: "2026-06-08"
---

## macOS

1. Download the `.dmg` file from the download link in your Gumroad receipt (or the free download on [opalapi.dev](https://opalapi.dev))
2. Open the `.dmg` and drag **OPAL** to your **Applications** folder
3. Double-click OPAL in Applications to launch

**Apple Silicon (M1/M2/M3/M4)** and **Intel Macs** are both supported as separate downloads. Download the one that matches your Mac.

### "OPAL can't be opened because Apple can't check it for malicious software"

This is macOS Gatekeeper blocking an app from an unnotarized developer. To open it:

1. Open **System Settings → Privacy & Security**
2. Scroll down to the **Security** section
3. You will see a message about OPAL being blocked — click **Open Anyway**
4. Confirm in the dialog that appears

You only need to do this once.

---

## Windows

1. Download the `.exe` installer
2. Run the installer — Windows may show a SmartScreen warning; click **More info → Run anyway**
3. OPAL installs and opens automatically

A desktop shortcut is created during install. OPAL appears in **Add or Remove Programs** for clean uninstallation.

---

## Linux

OPAL is distributed as an **AppImage** for Linux.

1. Download the `.AppImage` file
2. Make it executable: `chmod +x OPAL-*.AppImage`
3. Run it: `./OPAL-*.AppImage`

No installation required. Move the file anywhere you prefer.

**Sandbox error on some distros:** If the AppImage fails with a sandbox error, run with `--no-sandbox`:
```
./OPAL-*.AppImage --no-sandbox
```

---

## Common problems

### The app opens but shows a blank screen

The bundled backend failed to start. Try:

1. Fully quit OPAL (Cmd+Q / Alt+F4)
2. Reopen it
3. If the issue persists, check that no other process is using port 8000 on your machine

### "Connection refused" when sending a live request

Your Oracle Fusion URL may be wrong or your network is blocking the connection. Verify:

- The base URL in your workspace settings matches your Oracle instance exactly (e.g. `https://your-instance.oraclecloud.com`)
- You can reach that URL in a browser from the same machine
- No VPN or firewall is blocking outbound HTTPS

### Login credentials rejected

- Confirm the username and password work by logging in to Oracle Fusion in a browser
- Oracle Fusion uses Basic Auth — enter your Oracle username (not email) in the Accounts section
- If your instance requires MFA, OPAL cannot currently handle MFA prompts

### Slow search results

Search results should appear in under 200ms on any modern machine. If search is slow:

- The index may still be building on first launch — wait 30 seconds and try again
- Restarting the app resets the index if it gets into a bad state

---

## Uninstalling

- **macOS:** Drag OPAL from Applications to Trash. To remove all data, also delete `~/Library/Application Support/opal`
- **Windows:** Use **Add or Remove Programs → OPAL**. Data is in `%APPDATA%\opal`
- **Linux:** Delete the AppImage. Data is in `~/.config/opal`

---

## Still stuck?

Email [contact@opalapi.dev](mailto:contact@opalapi.dev) with a description of the problem and your OS version. We respond within 24 hours on business days.
