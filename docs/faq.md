---
title: "FAQ"
description: "Frequently asked questions about OPAL — pricing, compatibility, privacy, and more."
lastUpdated: "2026-06-08"
---

## Pricing and purchasing

### How much does OPAL cost?

The Free tier is free forever. OPAL Pro is a **one-time payment of $149 USD** — no subscription, no renewal, no seat fees.

### What does the Free tier include?

- Full endpoint catalog — all 59,000+ HCM (Human Capital Management), FSCM (Financials and Supply Chain Management), and BPM (Business Process Management) endpoints, fully searchable
- Visual Q Builder — build `q=` filters without writing syntax
- Finder Builder — select named finders (e.g. `PrimaryKey`, `findByPersonId`) and fill in parameters visually
- Schema viewer — browse request and response models for every endpoint
- Offline use — everything above works without an internet connection

### What does Pro add?

- **Live requests** — send API calls to your Oracle Fusion instance and see real responses
- **Flow Runner** — chain multiple requests into reusable multi-step automations
- **Export and backup** — export flows, environments, and history as portable files
- All future updates at no extra charge

### Is this a subscription?

No. You pay once and own it. There are no monthly charges and no account required for the Free tier.

### How do I buy?

Click **Get Pro · $149** on the homepage. Payment is processed by Gumroad. You receive a license key by email immediately after checkout.

### Can I get a refund?

Yes — within 30 days of purchase, no questions asked. Email [contact@opalapi.dev](mailto:contact@opalapi.dev) with your Gumroad order number.

---

## Compatibility

### Which Oracle Fusion Cloud versions does OPAL support?

All of them. OPAL bundles the official Oracle Fusion Cloud REST API specifications for HCM (Human Capital Management), FSCM (Financials and Supply Chain Management), and BPM (Business Process Management). Any Oracle Fusion Cloud SaaS instance works — there is no minimum version requirement.

### Does it work with on-premise Oracle?

OPAL is designed for Oracle Fusion Cloud (SaaS). On-premise Oracle E-Business Suite and Oracle Database are a different product with a different API structure — OPAL does not support them.

### Which operating systems are supported?

- macOS — Apple Silicon (M1/M2/M3/M4) and Intel, macOS 12 or later
- Windows — 64-bit, Windows 10 or later
- Linux — AppImage (tested on Ubuntu 22.04+)

---

## Privacy and data

### Is my Oracle password stored securely?

Yes. Oracle credentials are encrypted with AES-256-GCM before being written to disk. The key never leaves your machine.

### Does OPAL send any data to external servers?

No. OPAL has no cloud backend. Live requests go directly from your machine to your Oracle Fusion instance. There is no OPAL proxy, no telemetry, and no usage tracking.

### Does OPAL work offline?

Yes. The endpoint catalog, Q Builder, and Schema viewer all work without any internet connection after the initial download. An Oracle Fusion connection is only needed for live requests (Pro feature).

---

## Using OPAL

### What are Q filters?

Oracle Fusion Cloud REST APIs support a `q=` query parameter that filters results on the server side. For example: `q=Workers.PersonNumber='12345' AND Workers.ActiveFlag=true`. The syntax is powerful but error-prone. OPAL's Q Builder lets you construct these filters visually — pick a field, pick an operator, enter a value — and generates the exact expression.

### What are Finders and the Finder Builder?

Finders are named lookup strategies built into Oracle Fusion REST APIs. Instead of writing a `q=` filter, you invoke a named finder like `PrimaryKey`, `findByPersonId`, or `findReports` with specific parameters. Finders map to indexed queries on the Oracle backend and are significantly faster than equivalent `q=` expressions for point lookups.

OPAL's Finder Builder surfaces all available finders for the selected endpoint (read directly from the bundled spec), lets you select one, and fills in the required parameters — without writing `?finder=findByPersonId;PersonId=12345` by hand. Works completely offline.

### How many endpoints are included?

59,000+ endpoints across Oracle HCM (Human Capital Management), FSCM (Financials and Supply Chain Management), and BPM (Business Process Management). This includes GET, POST, PATCH, and DELETE operations across all sub-modules.

### Can I test against my production Oracle instance?

You can configure any Oracle Fusion instance as an environment. OPAL does not restrict which instance you connect to, but any write operation (POST, PATCH, DELETE) sent to a production environment affects real data. Use a test instance for exploratory work.

### Does OPAL support OAuth / token-based auth?

Currently, OPAL supports Basic Auth (username and password). OAuth support is planned for a future update.

---

## Troubleshooting

### The app won't open on macOS

This is usually macOS Gatekeeper. Go to **System Settings → Privacy & Security** and click **Open Anyway** next to the OPAL entry. See the [Installation guide](https://opalapi.dev/install) for details.

### I can't connect to my Oracle instance

Make sure the base URL in your workspace settings matches your Oracle instance exactly and that you can reach it in a browser from the same machine. See [Installation and Troubleshooting](https://opalapi.dev/install) for a full checklist.

### Something else is wrong

Email [contact@opalapi.dev](mailto:contact@opalapi.dev) — we respond within 24 hours on business days.
