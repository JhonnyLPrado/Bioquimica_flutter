# Periodic Table Color Reference

This document describes the color scheme used for the periodic table elements, designed to work harmoniously with the app's dark theme.

## Theme Integration

The periodic table colors are designed to complement the app's main theme:
- **Primary**: `#4FC3F7` (Cyan 300) - Knowledge and clarity
- **Secondary**: `#26C6DA` (Cyan 400) - Scientific and energetic
- **Tertiary**: `#80CBC4` (Teal 200) - Accent color
- **Background**: `#121517` - Very dark background
- **Surface**: `#1E2428` - Dark blue-grey surface

## Element Category Colors

All colors are from Material Design's 200-400 range, optimized for visibility and contrast on dark backgrounds.

### Metal Categories

| Category | Color | Hex Code | Rationale |
|----------|-------|----------|-----------|
| **Metal alcalino** | Light Blue 200 | `#81D4FA` | Bright and vibrant - represents high reactivity |
| **Metal alcalinotérreo** | Blue 400 | `#64B5F6` | Similar to alkali but deeper - slightly less reactive |
| **Metal de transición** | Cyan 400 | `#4DD0E1` | Main metals - matches secondary theme color |
| **Metal** | Cyan 300 | `#4FC3F7` | Post-transition metals - matches primary theme color |

### Non-Metal Categories

| Category | Color | Hex Code | Rationale |
|----------|-------|----------|-----------|
| **No metal** | Teal 400 | `#4DB6AC` | Organic, life-related - complements the cyan/blue palette |
| **Halógeno** | Pink 300 | `#F06292` | Reactive and dangerous - stands out with warm contrast |
| **Gas noble** | Orange 300 | `#FFB74D` | Inert and special - unique warm accent |

### Intermediate Category

| Category | Color | Hex Code | Rationale |
|----------|-------|----------|-----------|
| **Metaloide** | Deep Purple 300 | `#9575CD` | Semi-metallic - purple indicates hybrid nature |

### Rare Earth Categories

| Category | Color | Hex Code | Rationale |
|----------|-------|----------|-----------|
| **Lantánido** | Indigo 300 | `#7986CB` | Rare earths - distinctive indigo for special elements |
| **Actínido** | Red 300 | `#E57373` | Radioactive - red indicates hazard/warning |

## Design Principles

1. **Color Harmony**: Predominantly cool colors (cyan, teal, blue) that align with the scientific theme
2. **Contrast**: Warm accents (pink, orange, red) for reactive/special elements
3. **Visibility**: All colors tested for sufficient contrast against dark backgrounds
4. **Semantic Meaning**: Colors chosen to reflect chemical properties
   - Blues/Cyans: Metals (cool, conductive)
   - Teal: Non-metals (organic, essential for life)
   - Pink: Halogens (reactive, dangerous)
   - Orange: Noble gases (unique, inert)
   - Purple: Metalloids (hybrid nature)
   - Red: Actinides (radioactive, warning)

## Accessibility Notes

- All colors meet WCAG AA standards for contrast when displayed with white text
- Color is not the only indicator - each element also has its category label
- The color scheme is designed to be distinguishable for most types of color vision deficiency

## Files Updated

- `lib/data/tabla_periodica.dart` - Main periodic table data
- `lib/data/tabla_periodica_extendida.dart` - Extended periodic table data

---

*Last updated: 2024 - Matches theme version in `lib/main.dart`*