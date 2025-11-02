# Design Quality Standards

These standards ensure pixel-perfect, preset-perfect quality when replicating sites.

## Pixel-Perfect Quality Requirements

### Typography Precision
- **Font families must be exact** - Use Chrome DevTools to identify the exact font family, including fallbacks
- **Font weights must match precisely** - Extract computed font-weight values, not just visual approximations
- **Line heights must be identical** - Copy exact line-height values (unitless or pixels)
- **Letter spacing (tracking) must be accurate** - Extract letter-spacing values for headings and body text
- **Font sizes must be exact** - Use computed values from DevTools, considering responsive breakpoints

### Color Accuracy
- **Extract exact hex/rgb values** - No approximations, use computed color values from DevTools
- **Include all color variations** - Hover states, active states, disabled states, focus states
- **Document opacity values** - Separate opacity from color values for accurate reproduction
- **Color gradients must be exact** - Extract gradient angles, stop positions, and colors

### Spacing Precision
- **Measure all margins and padding** - Use DevTools computed values, not visual estimates
- **Document responsive spacing changes** - Track how spacing adapts at breakpoints
- **Gap values for flex/grid** - Extract exact gap values for modern layout systems
- **Negative margins** - Document any negative margin usage

### Layout Accuracy
- **Container widths and max-widths** - Extract exact values and responsive behavior
- **Grid systems** - Document grid column counts, gaps, and breakpoint changes
- **Flexbox properties** - Extract justify-content, align-items, flex-direction for each flex container
- **Position values** - Document absolute/fixed positioning coordinates precisely
- **Z-index values** - Map the complete z-index hierarchy

### Visual Effects
- **Box shadows must be identical** - Extract x-offset, y-offset, blur, spread, color, and inset values
- **Border radii must match** - Document all border-radius values, including per-corner variations
- **Borders** - Extract width, style, color for all borders
- **Opacity and blend modes** - Document transparency and CSS blend modes if used
- **Filters** - Extract blur, brightness, contrast, and other CSS filter values

### Animations and Transitions
- **Transition properties** - Document which properties transition
- **Duration and timing functions** - Extract exact duration (ms) and easing functions
- **Animation keyframes** - If animations exist, document complete @keyframes
- **Transform values** - Extract exact translate, rotate, scale values
- **Use Tailwind classes only** - Never use JavaScript for animations

### Responsive Behavior
- **Breakpoints must be exact** - Document all media query breakpoints used
- **Mobile-first or desktop-first** - Identify the approach used
- **Element visibility changes** - Document display:none toggles at breakpoints
- **Layout shifts** - Document how layouts change (flex-direction, grid columns, etc.)

## Chrome DevTools Extraction Workflow

### Step 1: Inspect Target Site
1. Open Chrome DevTools (F12 or right-click → Inspect)
2. Navigate to the target URL
3. Use the element selector tool to inspect components

### Step 2: Extract Computed Styles
1. Select element in DevTools
2. Switch to "Computed" tab
3. Document all non-default computed values
4. Note: Focus on properties that differ from browser defaults

### Step 3: Take Visual Screenshots
1. Use Chrome DevTools Device Toolbar for responsive screenshots
2. Capture at common breakpoints: 320px, 768px, 1024px, 1440px, 1920px
3. Take full-page screenshots using DevTools command menu (Cmd/Ctrl+Shift+P → "Capture full size screenshot")
4. Save screenshots for visual comparison during implementation

### Step 4: Document Layout Structure
1. Use DevTools Elements panel to understand DOM hierarchy
2. Note semantic HTML elements used (header, nav, main, section, article, etc.)
3. Identify layout systems (flexbox, grid, float, position)
4. Document nesting depth and container relationships

### Step 5: Extract Assets
1. Identify all images, icons, fonts, and media
2. Note image formats, dimensions, and optimization
3. Document icon systems (SVG, icon fonts, etc.)
4. Extract custom fonts if possible (check licensing)

## Quality Assurance

### Visual Comparison Checklist
- [ ] Compare screenshots side-by-side at each breakpoint
- [ ] Verify font rendering matches (weight, spacing, line-height)
- [ ] Check color accuracy (no "close enough" - must be exact)
- [ ] Validate spacing matches at all breakpoints
- [ ] Confirm hover/interaction states match
- [ ] Test responsive behavior at intermediate sizes
- [ ] Verify animations timing and easing

### Code Quality Checklist
- [ ] Use Tailwind utility classes (not custom CSS)
- [ ] Inline styles only when necessary (e.g., dynamic values)
- [ ] Semantic HTML structure
- [ ] Accessible markup (ARIA labels, alt text, etc.)
- [ ] Clean, organized code (not minified inline styles)
- [ ] Comments for complex layout decisions

### Implementation Standards
- **HTML/Tailwind only** - Single code block with all HTML
- **Include html, head, body tags** - Complete valid HTML document
- **Style attributes when needed** - For values not in Tailwind
- **Lucide icons with 1.5 strokeWidth** - For icon systems
- **Chart.js for data viz** - Follow canvas nesting rules
- **Unsplash for placeholder images** - Creative, relevant images
- **Responsive by default** - Mobile-first approach

## Pixel-Perfect Mindset

The goal is not "looks similar" - the goal is "indistinguishable from the original". Every pixel, every font weight, every spacing value must be intentional and measured.

- ❌ "This looks about right"
- ✅ "This matches the computed value of 16.8px line-height"

- ❌ "The spacing feels good"
- ✅ "The margin-bottom is 24px as extracted from DevTools"

- ❌ "It's close enough"
- ✅ "It's pixel-perfect"

When in doubt, measure. When measuring, use DevTools. When using DevTools, extract computed values, not authored styles.

## Extended Thinking for Quality

For complex designs or uncertain measurements, enable extended thinking mode to:
- Carefully analyze visual hierarchy
- Compare extracted values against visual screenshots
- Reason about responsive behavior logic
- Validate accessibility considerations
- Double-check color contrast ratios
- Verify semantic HTML structure

Extended thinking ensures no detail is overlooked in the pursuit of pixel-perfect quality.
