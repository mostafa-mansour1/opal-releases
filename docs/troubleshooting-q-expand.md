---
title: "Troubleshooting q Filters with Expanded Child Resources"
description: "Common Oracle Fusion Workers API mistakes with q and expand: duplicated q values, URL encoding, and child fields not searchable from the parent."
lastUpdated: "2026-07-02"
---

When calling the Oracle Fusion Workers REST API, developers often combine the `q` query parameter with `expand` to filter workers and read nested child data in one request. Two mistakes come up again and again. This note shows both, with the exact fix.

## Mistake 1: Passing q twice

This request looks correct at first glance, but it silently returns wrong results:

```text
Bad:
&q=q=workRelationships.LegalEmployerName like '%Acme%'
```

**The problem:** `q` is duplicated. The value Oracle receives is the literal string `q=workRelationships...` instead of the actual query expression. Depending on the endpoint, this either fails with an Invalid Query error or matches nothing.

This usually happens when copying a full query string (which already starts with `q=`) into a tool field that adds the `q=` prefix for you.

**The fix** — pass the expression only, URL-encoded:

```text
Correct:
&q=workRelationships.LegalEmployerName%20like%20%27%25Acme%25%27
```

Decoded, that is:

```text
q=workRelationships.LegalEmployerName like '%Acme%'
```

## URL encoding reference

When the query expression is placed in a URL, these characters must be encoded:

| Character | Encoded | Used for |
| --------- | ------- | -------- |
| space     | `%20`   | separating field, operator, value |
| `'`       | `%27`   | quoting string values |
| `%`       | `%25`   | the `like` wildcard itself |

So `like '%Acme%'` becomes `like%20%27%25Acme%25%27`. The `%` wildcard inside a `like` pattern must itself be encoded as `%25`, which is why the encoded form looks doubled.

OPAL's Q Builder generates the encoded expression for you, so you never assemble this by hand.

## Mistake 2: Expecting expand to enable child-level filtering

`expand` controls what data is **returned**, not what is **searchable**:

- `expand=workRelationships.assignments.managers` includes the nested child data in the response.
- It does not make every nested field usable inside `q` on the parent `workers` endpoint.
- Some child fields (like `workRelationships.LegalEmployerName`) are queryable from the parent; many others are not.
- A field being visible in the response does not mean it is queryable — those are different metadata attributes.

**How to check before you test:**

1. Open the endpoint in OPAL and check its **q fields** list — this shows exactly which fields (including child paths) are accepted by `q` on that endpoint.
2. Use OPAL's metadata search to find where a field is queryable across all endpoints — a field that is not queryable on `workers` is often queryable on its own child endpoint.
3. When the parent endpoint cannot filter by the field you need, call the child endpoint directly (for example `workers/{id}/child/workRelationships`) or use the dedicated resource where the field lives.

## Quick checklist

```text
1. Never include "q=" inside the q value
2. URL-encode spaces, quotes, and % wildcards
3. expand = what is returned, q = what is filtered — separate lists
4. Verify a field is in the endpoint's q fields before filtering on it
5. If the parent cannot filter it, use the child endpoint directly
```
