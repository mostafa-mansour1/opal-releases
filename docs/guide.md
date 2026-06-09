---
title: "User Guide"
description: "How to use OPAL — endpoint search, Q Builder, Finder Builder, Schema viewer, live requests, and flows."
lastUpdated: "2026-06-08"
---

## Overview

OPAL is a desktop application for exploring and testing Oracle Fusion Cloud REST APIs. It ships with 59,000+ endpoints across HCM (Human Capital Management), FSCM (Financials and Supply Chain Management), and BPM (Business Process Management) — indexed locally, no internet connection required for browsing.

**Free tier** gives you the full endpoint catalog, Visual Q Builder, Finder Builder, and Schema viewer.  
**Pro** adds live requests to your Oracle Fusion instance, the Flow Runner, and export/backup.

---

## First launch

On first launch, OPAL opens to the endpoint catalog with no setup required. The bundled HCM, FSCM, and BPM specifications are already indexed.

To send live requests (Pro), add a workspace:

1. Open **Settings → Workspaces**
2. Click **Add workspace**
3. Enter your Oracle Fusion Cloud base URL (e.g. `https://your-instance.oraclecloud.com`)
4. Add an environment (typically your test instance first)
5. Add your Oracle credentials under **Accounts**

---

## Searching endpoints

Type any keyword in the search bar — resource name, HTTP method, description, or parameter name. Results appear in under 200ms.

Filters in the sidebar narrow results by module (HCM, FSCM, BPM), HTTP method (GET, POST, PATCH, DELETE), or resource path prefix.

Click any endpoint to open its detail view.

---

## Q Builder (Free)

Oracle Fusion REST APIs use a `q=` query parameter for server-side filtering. The syntax is powerful but error-prone to write by hand.

The Q Builder lets you:

1. Select a field from the dropdown — only fields valid for this endpoint are shown
2. Choose an operator (`=`, `!=`, `>`, `<`, `LIKE`, etc.)
3. Enter a value
4. Add more conditions with AND / OR logic
5. Copy the generated `q=` expression or use it directly in a live request

The generated expression appears in the URL bar in real time as you build.

---

## Finder Builder (Free)

Oracle Fusion REST APIs support **named finders** — indexed lookup strategies that bypass full-table scanning. Instead of `q=Workers.PersonNumber='12345'`, you call `?finder=findByPersonId;PersonId=12345`. Finders are faster and are the correct tool any time you have a known identifier.

The Finder Builder lets you:

1. Open the **Finder** tab next to Q Builder
2. Select a finder from the dropdown — only finders valid for this endpoint are listed (read from the bundled spec)
3. Fill in the required parameters
4. The `finder=` expression is generated and applied to the URL automatically

Common finders you'll see across HCM endpoints: `PrimaryKey`, `findByPersonId`, `findReports`, `findAbsenceTypesWithQualPlans`, `findByWord`.

---

## Schema viewer (Free)

Every endpoint detail view has a **Schema** tab showing the full request and response models. Expand any nested object to see its fields, types, and descriptions — sourced directly from the Oracle specification.

---

## Live requests (Pro)

With a workspace and credentials configured:

1. Select an endpoint
2. Build your parameters (Q Builder or Finder Builder, headers, path params)
3. Select your environment from the environment switcher
4. Click **Send**

The response body, status code, and timing appear in the response pane. Switch between **Tree** and **Raw** views.

**Copy as cURL** exports the full request as a cURL command you can run in a terminal or share with a colleague.

---

## Flow Runner (Pro)

Flows let you chain multiple API requests in sequence — for example, GET a worker, extract a field from the response, then POST that value to another endpoint.

1. Open **Flows → New flow**
2. Add a step — choose an endpoint, set parameters
3. Reference a previous step's response with `{{steps[0].response.items[0].PersonNumber}}`
4. Add more steps
5. Click **Run flow**

Each step shows its response inline. Failed steps stop the run and highlight the error.

**Export flow** saves the flow definition as a JSON file you can share or restore later.

---

## Export and backup (Pro)

Under **Settings → Export**, you can export:

- All flows as a single JSON backup
- All environments and workspace configuration
- Request history

Import restores from any of these files.
