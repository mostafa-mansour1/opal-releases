---
title: "Privacy Policy"
description: "How OPAL handles your data. Short answer: it doesn't collect any."
lastUpdated: "2026-06-08"
---

OPAL is a desktop application that runs entirely on your machine. It does not collect, transmit, or store your personal data on any external server.

## What OPAL does not do

- Does not collect usage analytics or telemetry
- Does not send any data to OPAL servers — there are no OPAL servers
- Does not sync data to the cloud
- Does not track which endpoints you browse or which requests you send
- Does not share your data with third parties

## Data stored on your machine

All data OPAL creates stays on your device:

- **Workspace configuration** — stored in an encrypted JSON file in your OS application data directory
- **Oracle credentials** — encrypted with AES-256-GCM before being written to disk; the encryption key never leaves your machine
- **Request history** — stored in a local SQLite database
- **Bundled API specifications** — the HCM (Human Capital Management), FSCM (Financials and Supply Chain Management), and BPM (Business Process Management) OpenAPI specs ship inside the app and are never updated over the network

## When you connect to Oracle Fusion

When you use Pro live request features, OPAL makes API calls directly from your machine to your Oracle Fusion Cloud instance. These requests go machine → Oracle. They do not pass through any OPAL proxy or server.

## Contact

Questions about your data: [contact@opalapi.dev](mailto:contact@opalapi.dev)

<!-- REVIEW: Add data retention period for local files and clarify GDPR/CCPA applicability if selling to EU or California users. -->
