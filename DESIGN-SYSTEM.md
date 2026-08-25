# Counsel AI — UI/UX Design System

## Product posture
Counsel AI is a local-first legal copilot. The interface should feel familiar to a word processor, quiet like a professional document-management system, and explicit about privacy and provenance.

## Design tokens

### Colors
| Token | Hex | Use |
|---|---|---|
| Background | `#FFFFFF` | Primary surface |
| Surface | `#F7F7F8` | AI message, cards, secondary surfaces |
| Text | `#1A1A1A` | Primary content |
| Text secondary | `#6B7280` | Supporting text |
| Border | `#E5E7EB` | Dividers, inputs, cards |
| Accent | `#1B4965` | Primary actions, focus, active navigation |
| Accent hover | `#153B52` | Hover/pressed accent |
| Success | `#15803D` | Successful state |
| Warning | `#B45309` | External/API warning, in-progress research |
| Danger | `#B91C1C` | Destructive actions |
| Privacy local | `#047857` | Local/private state |

No gradients, neon, purple, decorative blue, or glass effects.

### Typography
- UI: Inter / system sans.
- Legal document preview: Source Serif Pro / Charter / Georgia fallback.
- Source URLs: JetBrains Mono / monospace.
- H1: 28px / 600.
- H2: 20px / 600.
- H3: 16px / 600.
- Body: 14px / 400 / 1.6.
- Citation: 12px / monospace.
- Small labels: 11px, uppercase, 0.05em tracking, `#6B7280`.

### Spacing
Base unit: 4px.
- 4: micro spacing.
- 8: icon + label, chips.
- 12: compact card padding.
- 16: normal control/card padding.
- 24: section gap.
- 32: major section gap.
- 48: large canvas padding.

### Shape and motion
- Radius: 6px controls, 8–10px cards, full pill only for status indicators.
- Borders: 1px default; 2px focus outline.
- Animation: 120–180ms only. No animation is required to understand a state.
- Streaming text gets a subtle caret; research progress uses a standard linear progress bar.

## Component library

### Buttons
Primary filled navy button for a single clear action. Secondary outlined button for reversible/optional actions. Destructive actions use red text with confirmation, not a red filled button by default.

### Inputs
8px radius, visible label, plain-English helper copy. Keyboard focus uses a 2px navy outline.

### Mode control
Four-segment control: Local / API / Research / Tools. Local is green; API is amber. The dot communicates privacy state without relying on a tooltip.

### Privacy status
Always visible in the chat composer area and sidebar. Copy must explain the consequence: “Local mode · Data stays on this device” or “External API · Review before sending confidential material”.

### Citation card
Every factual research answer keeps citations in view. Each citation includes source name, truncated URL, and relevance. Right-click exposes Copy URL / Open in browser / Copy citation (Bluebook).

### Modal confirmation
External actions require a preview step and a final confirmation. Example: “Send this email to client@lawfirm.com?” with Preview / Cancel / Send.

### Empty states
Empty states are instructional, not decorative:
- “Ask a legal question, research a topic, or draft a document”
- Three example prompts as clickable cards.
- “No legitimate sources found. Try broadening your query.”
- “Start with a template or ask me to draft something”.

### Error states
Every error has exactly three parts: what happened, why, and what to do next. Never show stack traces.

## Screen specifications

### 1. Onboarding
Three-step wizard with a thin top progress bar. Step 1 gives the value proposition in one sentence. Step 2 uses dependent Country → Province/State inputs plus optional City. Step 3 chooses Local / API privacy mode. No signup, account creation, or email.

### 2. Main Chat
252px collapsible sidebar. Main content has dense reading width around 860px. User bubbles are right aligned. Assistant responses sit on the `#F7F7F8` surface. Sources are visible below the answer.

### 3. Research
Progress is linear and inspectable: plan → search → analyze → write. Whitelist is shown explicitly. Cancel is available at every stage.

### 4. Documents
Resizable split pane. MDX editor uses monospace and line numbers. Preview uses a serif page metaphor. Export controls remain visible. Jurisdiction badge stays fixed in the footer bar.

### 5. Settings
Five sections: Model, Privacy, Search filters, Tools, Appearance. Every field gets plain-English helper copy.

### 6. Empty states
Use the same typography and borders as the rest of the app. No illustration is required. The product should stay “boring is beautiful”.

### 7. Errors
Use a compact bordered notice at the point of failure. Show a clear recovery action such as “Continue locally”, “Add API key”, “Retry”, or “Cancel”.

## Keyboard map
- `Ctrl+K` — command palette
- `Ctrl+N` — new chat
- `Ctrl+S` — save document/chat
- `Ctrl+/` — shortcuts help
- `Ctrl+Plus` / `Ctrl+Minus` — font scaling
- Tab / Shift+Tab — every control reachable
- Enter — submit focused action
- Esc — close menus/modals

## High-fidelity screen checklist

The prototype should visually communicate, without onboarding instructions:
1. Privacy state at a glance.
2. Citation provenance inside the response, not on another screen.
3. Familiar legal-document page preview.
4. Clear distinction between local reasoning and external actions.
5. Reversible actions with explicit confirmation.
6. Dense but legible information architecture at 1366×768 and 2560×1440.

## Interaction flow

```text
Onboarding
  ├─ Welcome → Jurisdiction → Privacy → Main Chat
  └─ Skip for demo → Main Chat

Main Chat
  ├─ Local/API → chat response
  ├─ Research → Research View → Report + Sources → Chat
  ├─ Draft request → Document View → Edit / Preview / Split → Export
  └─ Tools → Preview → Confirm → External action → Audit state

Sidebar
  ├─ Chat
  ├─ Research
  ├─ Documents
  └─ Settings → privacy/model/search/tools/appearance
```

## Accessibility acceptance criteria

The implementation targets WCAG 2.1 AA. Body text is intended to maintain at least 4.5:1 contrast. Every interactive control needs an accessible label; icon-only controls require tooltips and semantic labels. Focus is always visible with a 2px accent outline. Layouts must not require a mouse or drag gesture to complete a task.
