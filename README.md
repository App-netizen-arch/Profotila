# Counsel AI

A local-first legal AI copilot designed for lawyers and paralegals. The repository contains the native Flutter desktop UI and a Vercel-hosted static showcase of the same design system.

## UX pillars

- Privacy is visible at all times.
- Citations are always shown with research answers.
- External tool actions require preview and explicit confirmation.
- Dense typography and familiar document surfaces take priority over decorative effects.
- Light mode is the default; dark mode is optional.
- Keyboard navigation is a first-class interaction model.

## Repository structure

```text
lib/main.dart       Native Flutter desktop prototype
index.html          High-fidelity web showcase
styles.css          Shared visual system for the showcase
app.js              Showcase navigation/interactions
DESIGN-SYSTEM.md    Tokens, components, screen specs, accessibility, flow
vercel.json         Static deployment configuration
pubspec.yaml        Flutter project metadata
```

## Flutter desktop

The primary product direction is Flutter/Dart so the UI can target Windows first with macOS and Linux following. The current Dart code is deliberately presentation-focused: production adapters for local GGUF models, API providers, legal search, MDX rendering, OAuth tools, encrypted storage, and document export can be added behind the screens without changing the visual system.

Suggested next packages for the production implementation:

- State: Riverpod.
- Routing: GoRouter.
- Local persistence: Drift + encrypted SQLite.
- Desktop file access: file_selector.
- Markdown/MDX: markdown plus a dedicated MDX rendering adapter.
- DOCX/PDF export: isolated document-export services.
- Local model bridge: llama.cpp / GGUF adapter behind a Dart service boundary.

## Web showcase / Vercel

Vercel serves the static HTML/CSS/JS showcase. It is intentionally separate from the native Flutter product because Vercel is being used here to make the UI reviewable in a browser. The native app remains Flutter.

## Accessibility

The design targets WCAG 2.1 AA: visible 2px focus states, keyboard navigation, semantic labels for interactive controls, minimum body contrast target of 4.5:1, and reduced motion through short transitions only.

## Product disclaimer

This repository is a UI/UX prototype. It does not currently provide legal advice, production legal research, secure client-data storage, model hosting, OAuth tool execution, or document export. Production implementation must add those capabilities with appropriate legal-domain validation, security review, and audit logging.
