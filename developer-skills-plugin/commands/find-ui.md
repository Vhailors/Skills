---
description: Search premium UI library for components and inspirations matching a pattern
allowed-tools: Read, Grep
argument-hint: <pattern>
---

# UI Library Search

You are running the `/find-ui` command to search the premium UI library for components and inspirations.

## Your Task

Use the **ui-inspiration-finder** skill to search the UI library:

@developer-skills-plugin/skills/ui-inspiration-finder/SKILL.md

## Search Query

Pattern: **$ARGUMENTS**

If no pattern provided, ask the user: "What UI pattern are you looking for? (e.g., testimonials, hero, pricing, cards, navigation)"

## Search Strategy

### Step 1: Load the Index

Read the UI inspiration index:

```
/mnt/c/Users/Dominik/Documents/UI/ui-inspiration-index.json
```

### Step 2: Multi-Strategy Search

Search the index using ALL these strategies and combine results:

**A) Search by UI Pattern** (in `screenshots[].ui_patterns[]`):
- Look for patterns matching: $ARGUMENTS
- Common patterns: `testimonial-cards`, `hero`, `pricing-table`, `feature-grid`, `masonry-grid`, `bento-grid`, `navigation`, `form`, `card`, `modal`, `carousel`

**B) Search by Category** (in `screenshots[].category`):
- Look for: `"$ARGUMENTS"` in category field
- Common categories: `testimonials/social-proof`, `hero`, `pricing`, `features`, `navigation`, `forms`

**C) Search by Use Case** (in `screenshots[].use_cases[]`):
- Look for use cases containing: $ARGUMENTS
- Examples: `building credibility`, `displaying customer testimonials`, `pricing display`, `showcasing achievements`

**D) Search by Tags** (in `screenshots[].tags[]`):
- Look for tags containing: $ARGUMENTS

**E) Search by Related Components** (in `screenshots[].related_components[]`):
- Look for component names containing: $ARGUMENTS

### Step 3: Present Results

For each match found, display:

```markdown
## Found: [screenshot.title]

**Source:** [screenshot.source] (e.g., Clay, Doist, Firefox)
**Category:** [screenshot.category]
**Visual:** [screenshot.path]

**Description:**
[screenshot.description]

**UI Patterns:**
- [list patterns]

**Use Cases:**
- [list use cases]

**Related Components:**
- [list component names from related_components]
  - Location: /mnt/c/Users/Dominik/Documents/UI/components/[component-name]/

**Quality Indicators:**
- [list quality_indicators]

---
```

### Step 4: Component Details

If related components exist, offer to show their implementation:

```markdown
### Available Implementations

I found [N] components that implement this pattern:

1. **[component-name]** - [brief description from index or file]
   - Location: `/mnt/c/Users/Dominik/Documents/UI/components/[component-name]/`
   - Files: [list files in directory]

Would you like me to:
- Show the component implementation?
- Help adapt it to your project?
- Compare multiple options?
```

### Step 5: No Results Handling

If no exact matches found, suggest alternatives:

```markdown
## No exact matches for "$ARGUMENTS"

**Similar patterns in the library:**
- [list 3-5 closest matches based on similar tags/categories]

**Did you mean:**
- [suggest common patterns that might match]
  - testimonials → testimonial-cards, animated_testimonials
  - buttons → CTA buttons, navigation buttons
  - forms → input fields, form validation
  - pricing → pricing-table, subscription plans

**What's in the library:**
- [Show count by category: X testimonials, Y hero sections, Z pricing examples]
```

## Example Output

```markdown
# UI Library Search Results

## Search: "testimonials"

Found **3 matches**:

---

## 1. Multi-Column Testimonial Card Masonry Grid

**Source:** Clay
**Category:** testimonials/social-proof
**Visual:** ./inspirations/clay/multi_column_testimonial_card_grid.jpeg

**Description:**
A masonry-style testimonial grid featuring user reviews with profile pictures, names, handles, and detailed feedback. The layout uses varying card heights creating an organic, Pinterest-like arrangement.

**UI Patterns:**
- masonry-grid
- testimonial-cards
- user-generated-content
- profile-badges

**Use Cases:**
- displaying customer testimonials
- building social proof
- showing diverse user base

**Related Components:**
- animated_testimonials
  - Location: /mnt/c/Users/Dominik/Documents/UI/components/animated_testimonials/
- social_card
  - Location: /mnt/c/Users/Dominik/Documents/UI/components/social_card/

**Quality Indicators:**
- authentic user content
- varied testimonial lengths
- visual diversity
- professional presentation
- clear attribution

---

## 2. Animated Testimonials Carousel

**Component:** animated_testimonials
**Location:** /mnt/c/Users/Dominik/Documents/UI/components/animated_testimonials/

**Features:**
- Framer Motion animations with stacked card effect
- Smooth transitions between testimonials
- Navigation controls with arrow buttons
- Autoplay support (5-second intervals)
- 3D card stacking with random rotation

---

### What would you like to do next?

1. View implementation of `animated_testimonials`
2. See all testimonial patterns side-by-side
3. Get suggestions for adapting to your project
4. Search for something else
```

## Search Tips for User

Suggest common searches if helpful:
- "hero" - Hero sections and landing page headers
- "testimonials" - Customer reviews and social proof
- "pricing" - Pricing tables and subscription plans
- "navigation" - Menus, navbars, sidebars
- "cards" - Card layouts and grid patterns
- "forms" - Input fields, validation, multi-step forms
- "dashboard" - Data visualizations and admin panels
- "calendar" - Date pickers and scheduling
- "modal" - Dialogs, popups, overlays
- "carousel" - Sliders and image galleries

## Output Guidelines

- Show ALL matches (don't limit to 1-2)
- Include visual paths so user can view screenshots
- Provide exact file paths to components
- Suggest next actions based on results
- If multiple good options, help user compare them
- Always reference the skill for implementation guidance
