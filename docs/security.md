---
title: "Security and Support"
description: "How OPAL protects your credentials and how to get help."
lastUpdated: "2026-06-08"
---

## How OPAL protects your data

**Credential encryption** — Oracle usernames and passwords are encrypted with AES-256-GCM before being written to disk. The encryption key is derived from your machine and never leaves it.

**Local-only architecture** — OPAL has no cloud backend. There is no OPAL server that handles your requests. When you send a live API request, it goes from your machine directly to your Oracle Fusion instance over HTTPS.

**No telemetry** — OPAL does not report usage, errors, or any other data back to OPAL servers.

**No auto-updates** — OPAL does not connect to the internet in the background. Updates are manual downloads from this website.

## What OPAL cannot protect against

- Malware or keyloggers on your own machine
- Oracle-side security issues with your Oracle Fusion instance
- Credentials you enter into an Oracle instance with an invalid or expired TLS certificate (OPAL warns but does not block)

## Responsible disclosure

If you discover a security vulnerability in OPAL, please report it privately before disclosing publicly:

**Email:** [contact@opalapi.dev](mailto:contact@opalapi.dev)  
**Subject line:** `Security: [brief description]`

We aim to respond within 48 hours and to release a fix within 14 days for confirmed vulnerabilities.

## Support

**Email:** [contact@opalapi.dev](mailto:contact@opalapi.dev)  
**Response time:** within 24 hours on business days

For installation issues, see the [Installation and Troubleshooting](https://opalapi.dev/install) guide first — most common problems are covered there.
