---
name: Clinical Soft Light
colors:
  surface: '#f8f9ff'
  surface-dim: '#cbdbf5'
  surface-bright: '#f8f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#eff4ff'
  surface-container: '#e5eeff'
  surface-container-high: '#dce9ff'
  surface-container-highest: '#d3e4fe'
  on-surface: '#0b1c30'
  on-surface-variant: '#434655'
  inverse-surface: '#213145'
  inverse-on-surface: '#eaf1ff'
  outline: '#737686'
  outline-variant: '#c3c6d7'
  surface-tint: '#0053db'
  primary: '#004ac6'
  on-primary: '#ffffff'
  primary-container: '#2563eb'
  on-primary-container: '#eeefff'
  inverse-primary: '#b4c5ff'
  secondary: '#006c49'
  on-secondary: '#ffffff'
  secondary-container: '#6cf8bb'
  on-secondary-container: '#00714d'
  tertiary: '#3e3fcc'
  on-tertiary: '#ffffff'
  tertiary-container: '#585be6'
  on-tertiary-container: '#f1eeff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#dbe1ff'
  primary-fixed-dim: '#b4c5ff'
  on-primary-fixed: '#00174b'
  on-primary-fixed-variant: '#003ea8'
  secondary-fixed: '#6ffbbe'
  secondary-fixed-dim: '#4edea3'
  on-secondary-fixed: '#002113'
  on-secondary-fixed-variant: '#005236'
  tertiary-fixed: '#e1e0ff'
  tertiary-fixed-dim: '#c0c1ff'
  on-tertiary-fixed: '#07006c'
  on-tertiary-fixed-variant: '#2f2ebe'
  background: '#f8f9ff'
  on-background: '#0b1c30'
  surface-variant: '#d3e4fe'
typography:
  headline-xl:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-xl-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 26px
    fontWeight: '700'
    lineHeight: 34px
    letterSpacing: -0.015em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
    letterSpacing: -0.015em
  headline-lg-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 26px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 18px
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.01em
  label-sm:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 14px
    letterSpacing: 0.02em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1.5rem
  gutter-sm: 1rem
  margin: 2rem
  margin-sm: 1rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2.5rem
---

## Brand & Style

This design system is engineered for professional clinical scheduling, telemedicine, and healthcare practice management. The brand ethos prioritizes emotional reassurance, high operational clarity, and reduced cognitive load for both medical practitioners and patients managing critical health appointments.

The design movement combines **Minimalism** with **Tonal Layering and Soft Tactile Surfaces**. It avoids sterile, stark clinical whites in favor of calming pastel washes, soft rounded enclosures, and subtle tactile boundaries. The visual tone must evoke serene professionalism, trust, and frictionless efficiency, deliberately avoiding aggressive alerts or hyper-saturated accents that induce anxiety in clinical contexts.

## Colors

The palette balances clean clinical blues with restorative mint tones and soft functional pastels.

### Primary Palette
- **Primary Brand / Interactive**: `#2563EB` (Deep Clinical Blue) for primary actions, selected states, and focused navigation.
- **Primary Tint / Soft Wash**: `#E0F2FE` (Pastel Sky) for active sidebar items, selection backdrops, and calendar booking blocks.
- **Primary Subtle / Hover**: `#3B82F6` and `#60A5FA` for interaction feedback and focal points.

### Semantic & Status Accents
- **Success / Confirmed**: `#10B981` (Mint Primary) paired with `#D1FAE5` (Mint Pastel Soft Fill) and `#065F46` (Text contrast).
- **Warning / Pending**: `#F59E0B` (Warm Amber) paired with `#FEF3C7` (Soft Amber Fill) and `#92400E` (Text contrast).
- **In-Consultation / Active Session**: `#3B82F6` (Focused Azure) paired with `#DBEAFE` (Soft Blue Fill) and `#1E40AF` (Text contrast).
- **Canceled / Critical**: `#F43F5E` (Muted Rose) paired with `#FFE4E6` (Soft Rose Fill) and `#9F1239` (Text contrast).

### Neutrals & Surfaces
- **Canvas Base Background**: `#F8FAFC` (Slate Tinted Soft Off-White).
- **Surface Level 1 (Cards, Overlays)**: `#FFFFFF` (Pure Crisp White).
- **Surface Level 2 (Dividers, Inactive Fields)**: `#F1F5F9`.
- **Borders & Inactive Dividers**: `#E2E8F0`.
- **Text Headings / Emphasized**: `#0F172A` (Deep Slate).
- **Text Body / Secondary**: `#475569`.
- **Text Muted / Caption**: `#94A3B8`.

## Typography

The type system blends the welcoming curves of `Plus Jakarta Sans` for headers with the high utility of `Inter` for data density and clinical clarity.

### Numerical Data & Schedules
All time indicators, dates, duration counters, and medical IDs must enforce tabular figures (`font-variant-numeric: tabular-nums;` or `font-feature-settings: "tnum" 1`). This prevents vertical alignment jitter across calendar views, patient queues, and slot pickers.

## Layout & Spacing

The layout is structured around an 8-point base grid inside a fluid desktop and responsive mobile system:

- **Desktop (1024px and above)**: 12-column grid, `margin` of `2rem` (32px), `gutter` of `1.5rem` (24px). Sidebar panel remains fixed at 260px; the calendar or appointment table expands fluidly.
- **Tablet (768px – 1023px)**: 8-column layout, `gutter` of `1rem` (16px), `margin` of `1.5rem` (24px). Dual-pane layouts collapse into stacked tabs or responsive drawers.
- **Mobile (below 768px)**: 4-column layout, `margin-sm` of `1rem` (16px), `gutter-sm` of `1rem` (16px). Appointment slots and metrics transition into single-column vertical cards.

## Elevation & Depth

Visual hierarchy uses ambient tinted shadows paired with low-contrast boundaries to preserve a lightweight clinical appearance.

- **Base Surface**: `#F8FAFC` flat canvas without shadow.
- **Card / Surface Level 1**: Pure white `#FFFFFF` with a hairline stroke `1px solid #E2E8F0` and an ambient tinted shadow: `0px 4px 20px -2px rgba(37, 99, 235, 0.04), 0px 2px 6px -1px rgba(15, 23, 42, 0.03)`.
- **Card / Hover**: Elevation increases with `0px 8px 24px -4px rgba(37, 99, 235, 0.08), 0px 4px 8px -2px rgba(15, 23, 42, 0.04)`.
- **Popover / Dropdown / Modal**: Floating surface with `0px 16px 36px -6px rgba(15, 23, 42, 0.10), 0px 6px 12px -2px rgba(15, 23, 42, 0.04)`.
- **Glassmorphic Floating Bars**: Used for fixed bottom mobile navigation bars: `rgba(255, 255, 255, 0.85)` with a backdrop blur of `12px` and `border-top: 1px solid #E2E8F0`.

## Shapes

The interface utilizes generous, friendly curvatures (`roundedness: 2`, equivalent to 16px / `rounded-2xl` on primary container surfaces).

- **Cards & Modal Dialogs**: `1rem` (16px) border radius (`rounded-2xl`).
- **Input Fields & Appointment Blocks**: `0.75rem` (12px) border radius (`rounded-xl`).
- **Status Badges, Chips & Avatars**: Full pill radius (`9999px` / `rounded-full`) to differentiate metadata from structural surfaces.
- **Primary Buttons**: `0.75rem` (12px) border radius for ergonomic tap targets.

## Components

### Buttons
- **Primary**: Solid `#2563EB` fill, white `#FFFFFF` text, `0.75rem` radius, subtle focus ring `3px rgba(37, 99, 235, 0.25)`.
- **Secondary / Soft**: `#E0F2FE` soft background, `#1D4ED8` text, hover transition to `#BAE6FD`.
- **Ghost**: Transparent fill, `#475569` text, `#F1F5F9` on hover.

### Status Badges
Pill-shaped with a 4px internal circular dot indicator and bold label text:
- **Confirmada**: Background `#D1FAE5`, dot & text `#065F46`.
- **Pendiente**: Background `#FEF3C7`, dot & text `#92400E`.
- **En Consulta**: Background `#DBEAFE`, dot & text `#1E40AF`.
- **Cancelada**: Background `#FFE4E6`, dot & text `#9F1239`.

### Input Fields & Selectors
- Height: 44px on desktop, 48px on mobile for touch accessibility.
- Border: `1px solid #E2E8F0`, surface `#FFFFFF`.
- Focus state: `1px solid #2563EB` outline offset with `0 0 0 3px rgba(37, 99, 235, 0.15)`.
- Error state: `1px solid #F43F5E` with `0 0 0 3px rgba(244, 63, 94, 0.15)`.

### Appointment Cards
- Background: `#FFFFFF` with `1px solid #E2E8F0` and `16px` border-radius.
- Time Slot Indicator: Prominently displayed using `tabular-nums` alongside a subtle 3px vertical accent border matching the status color on the card's leading edge.

### Time Slot Picker Chips
- Inactive: Background `#FFFFFF`, border `1px solid #E2E8F0`, text `#475569`.
- Selected: Background `#2563EB`, text `#FFFFFF`, shadow `0 2px 8px rgba(37, 99, 235, 0.25)`.
- Disabled / Booked: Background `#F1F5F9`, border `1px dashed #CBD5E1`, text `#94A3B8`.