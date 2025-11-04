---
name: ui-inspiration-finder
description: Use when building or refactoring UI components, especially landing pages, dashboards, or feature sections - searches premium UI library at /mnt/c/Users/Dominik/Documents/UI for matching components, patterns, and inspirations before implementing from scratch
---

# UI Inspiration Finder

## Overview

**Always check the premium UI library before implementing UI components.**

You have access to a curated collection of high-quality React components and real-world design inspirations at `/mnt/c/Users/Dominik/Documents/UI`. This library contains production-ready implementations and screenshots from premium websites (Clay, Doist, Firefox, etc.) indexed by pattern, use case, and visual style.

**Core principle:** Don't build basic UI when premium implementations already exist. Check first, implement second.

## When to Use

Use this skill when:
- **Building new UI features** - Hero sections, pricing tables, testimonials, forms, navigation
- **Refactoring existing UI** - User says UI looks "basic," "needs polish," or "unprofessional"
- **Starting landing page sections** - Any time you're adding a new section to a landing page
- **Implementing common patterns** - Cards, grids, carousels, modals, dashboards
- **Time pressure situations** - "Need this done quickly" = use library, don't reinvent

**Symptoms that trigger this skill:**
- User mentions "professional," "premium," "polished," "modern" UI
- User references competitor sites or design examples
- You're about to implement a testimonial, pricing, hero, or feature section
- User has basic implementation and wants it elevated

## Library Structure

```
/mnt/c/Users/Dominik/Documents/UI/
├── components/              # React/TypeScript implementations
│   ├── animated_tabs/
│   ├── animated_testimonials/
│   ├── calendar/
│   └── ... (48 components)
├── inspirations/            # Screenshots from premium sites
│   ├── clay/
│   ├── doist/
│   └── ... (14 websites)
└── ui-inspiration-index.json  # Master index (108KB)
```

**The index is your starting point.** It cross-references 51 screenshots with 100+ components.

## Quick Reference: Search Workflow

| Step | Action | Example |
|------|--------|---------|
| 1. Read index | `Read /mnt/c/Users/Dominik/Documents/UI/ui-inspiration-index.json` | Get full index structure |
| 2. Search by use case | Look in `"use_cases"` array | `"building credibility"`, `"displaying customer testimonials"` |
| 3. Search by pattern | Look in `"ui_patterns"` array | `"masonry-grid"`, `"horizontal-scroll"`, `"badge-grid"` |
| 4. Search by category | Look in `"category"` field | `"testimonials/social-proof"`, `"hero"`, `"pricing"` |
| 5. Check related components | Look in `"related_components"` array | Points to actual component directories |
| 6. Read component | `Read /mnt/c/Users/Dominik/Documents/UI/components/{name}/` | Get implementation code |

## Implementation Workflow

### Step 1: Identify What You're Building

Before touching code, categorize the UI element:
- **Pattern**: Hero, testimonials, pricing, features, navigation, forms, dashboards
- **Purpose**: Social proof, conversion, information display, data entry
- **Visual Style**: Minimal, bold, animated, static, cards, grids

### Step 2: Query the Index

**Read the full index:**
```typescript
const index = Read("/mnt/c/Users/Dominik/Documents/UI/ui-inspiration-index.json");
```

**Search strategies:**

**By UI Pattern:**
- Search `screenshots[].ui_patterns[]` for: `"testimonial-cards"`, `"hero"`, `"pricing-table"`, `"feature-grid"`, `"masonry-grid"`, `"bento-grid"`

**By Use Case:**
- Search `screenshots[].use_cases[]` for: `"building credibility"`, `"displaying customer testimonials"`, `"pricing display"`, `"showcasing achievements"`

**By Category:**
- Search `screenshots[].category` for: `"testimonials/social-proof"`, `"awards/social-proof"`, `"hero"`, `"features"`

**By Component Name:**
- Search `screenshots[].related_components[]` for: `"animated_testimonials"`, `"banner"`, `"social_card"`

### Step 3: Review Options

For each match:
1. Read the screenshot description and quality indicators
2. Check `related_components` to see available implementations
3. Read the actual component code in `components/{component_name}/`
4. Assess fit for current project

### Step 4: Implement or Adapt

**Option A - Direct use:**
```typescript
// If component matches perfectly
import { AnimatedTestimonials } from 'path/to/ui-library/components/animated_testimonials';
```

**Option B - Adaptation:**
- Copy component to project
- Adjust styling to match design system
- Modify data structure to fit project needs
- Keep core interaction patterns

**Option C - Inspiration-driven:**
- No perfect component exists
- Use screenshot for visual reference
- Build similar structure following their patterns
- Reference `quality_indicators` from index

### Step 5: Present Options to User (When Multiple Matches)

Don't decide alone when there are 2+ good matches:

```markdown
I found 3 testimonial patterns in the UI library:

1. **Masonry Grid** (Clay inspiration) - Asymmetric card heights, organic Pinterest-like layout
2. **Animated Carousel** (existing component) - Auto-rotating testimonials with fade transitions
3. **Featured Single** (Doist inspiration) - One large testimonial with rotating background

Which style fits your landing page best?
```

## Common Mistakes

| Mistake | Why It's Wrong | Fix |
|---------|---------------|-----|
| "I'll just add some styling to make it look better" | Wastes time recreating what exists | Check library first, always |
| "This is too simple to check the library" | Simple patterns often have polished versions | Check anyway, takes 30 seconds |
| "I'll check after I build the basic version" | Sunk cost fallacy - you'll keep the basic version | Check before writing any code |
| Searching Google/shadcn before library | Library is curated for this project | Library first, external resources second |
| Reading component without seeing inspiration | Miss the visual context and intent | Read both screenshot and component |

## Index Schema Reference

Quick reference for JSON structure:

```typescript
interface Screenshot {
  id: string;                        // Unique identifier
  source: string;                    // Website name (Clay, Doist, etc.)
  path: string;                      // Path to screenshot image
  category: string;                  // "testimonials/social-proof", "hero", etc.
  title: string;                     // Human-readable title
  description: string;               // Detailed description
  ui_patterns: string[];             // ["masonry-grid", "testimonial-cards"]
  visual_elements: string[];         // ["profile photos", "quotes", "badges"]
  layout_type: string;               // "multi-column masonry grid"
  color_scheme: string;              // Color description
  typography: string;                // Font usage notes
  interactions: string[];            // ["scrollable", "hover states"]
  use_cases: string[];               // ["building credibility", "social proof"]
  tags: string[];                    // Searchable keywords
  related_components: string[];      // Component directory names
  quality_indicators: string[];      // What makes this high-quality
}
```

## Real-World Impact

**Before this skill:**
- Agents build basic UI from scratch
- Miss existing premium implementations
- Waste time on problems already solved
- Deliver lower quality than available

**After this skill:**
- Check library automatically (30 seconds)
- Discover production-ready components
- Deliver premium UI consistently
- Save hours of implementation time

**Example:** Building testimonials section
- Without skill: 45 minutes to design + implement basic cards
- With skill: 5 minutes to find + adapt masonry grid component
- Quality: Professional vs basic
- Maintenance: Tested component vs new code

## Red Flags - Stop and Check Library

If you catch yourself thinking:
- "I'll just make a simple card grid"
- "This won't take long to build"
- "I'll add some CSS to make it look better"
- "Let me try a basic implementation first"

**All of these mean: Stop. Read the index. Check library first.**
