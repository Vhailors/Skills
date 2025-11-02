# Comprehensive Style Guide Template

Use this template to generate a complete style guide for pixel-perfect site replication.

## Required Sections

### 1. Overview
Provide a high-level description of the design system's purpose, philosophy, and key principles.

### 2. Color Palette
- Primary, secondary, and accent colors with hex codes
- Background and surface colors
- Text colors (primary, secondary, disabled states)
- Semantic colors (success, error, warning, info)
- Color usage guidelines and accessibility considerations
- Hover colors and outline interaction colors

### 3. Typography
- Font families used throughout the project
- Font weights (light, regular, medium, semibold, bold, etc.)
- Font sizes for different text hierarchies (h1-h6, body, small, etc.)
- Line heights for each text size
- Letter spacing where applicable
- How different fonts work together in the project
- Typography scale and usage examples
- **Important font weight rules**: For font-weight 700+, use Inter/Level 2 as example. Bold should be Semibold.
- **Logo typography**: Use letters only with tight tracking
- **Titles above 20px** should use specific weight guidelines

### 4. Spacing System
- Base spacing unit (e.g., 4px, 8px)
- Spacing scale (e.g., xs, sm, md, lg, xl, 2xl, etc.)
- Margin and padding conventions
- Layout spacing guidelines

### 5. Component Styles
- Button variants (primary, secondary, outline, ghost, etc.)
- Input field styles
- Card components
- Navigation elements
- Modal/dialog styles
- Custom UI components: Checkboxes, sliders, dropdowns, toggles (only include if part of the UI)
- Common UI component patterns and their styling
- **Important**: Avoid bottom-right floating DOWNLOAD buttons

### 6. Shadows & Elevation
- Shadow levels (sm, md, lg, xl)
- When to use each elevation level
- Box-shadow values for each level
- Use subtle contrast in shadow application

### 7. Animations & Transitions
- **Do NOT use JavaScript for animations - use Tailwind instead**
- Timing functions (ease, ease-in, ease-out, etc.)
- Duration values for different interaction types
- Common animation patterns
- Transition properties for interactive elements
- Add hover color and outline interactions

### 8. Border Radius
- Border radius values (none, sm, md, lg, full)
- Usage guidelines for different component types

### 9. Opacity & Transparency
- Opacity levels for disabled states, overlays, etc.
- Background opacity values
- Usage guidelines

### 10. Icons
- Use Lucide icons for JavaScript with 1.5 strokeWidth
- Avoid gradient containers for icons
- Icon sizing and spacing guidelines

### 11. Design Style Guidelines
- For tech, cool, futuristic: favor dark mode unless specified otherwise
- For modern, traditional, professional, business: favor light mode unless specified otherwise
- Design inspiration: Unless style is specified by user, design in the style of Linear, Stripe, Vercel, Tailwind UI (IMPORTANT: don't mention names)
- Be extremely accurate with fonts
- Add subtle dividers and outlines where appropriate

### 12. Common Tailwind CSS Usage in Project
- Most frequently used utility classes
- Custom Tailwind configuration
- Commonly combined utility patterns
- **Important**: Avoid setting Tailwind config or CSS classes, use Tailwind directly in HTML tags
- Don't put Tailwind classes in the html tag, put them in the body tags

### 13. Responsive Design
- Make it responsive
- Breakpoint guidelines
- Mobile-first considerations

### 14. Images & Media
- If no images are specified, use Unsplash images like: faces, 3d, render, etc.
- Be creative with fonts, layouts, be extremely detailed and make it functional
- Image sizing and aspect ratio guidelines

### 15. Charts & Data Visualization
- Use Chart.js for charts (avoid bug: if your canvas is on the same level as other nodes: h2 p canvas div = infinite grows. h2 p div>canvas div = as intended)

### 16. Code Structure & Implementation
- Only code in HTML/Tailwind in a single code block
- Any CSS styles should be in the style attribute
- Start with a response, then code and finish with a response
- Don't mention about tokens, Tailwind or HTML
- Always include the html, head and body tags
- If design, code or html is provided: **IMPORTANT**: respect the original design, fonts, colors, style as much as possible

### 17. Example Component Reference Design Code
Provide code examples showing how to implement common components using the style guide, such as:
- A styled button with variants
- A card component
- A form input
- A navigation item
- Interactive elements with hover states

## Critical Instructions

- Analyze the existing codebase to extract actual design patterns being used
- Provide specific values (not just placeholders)
- Include visual examples or code snippets where helpful
- Ensure consistency across all sections
- Make it comprehensive so developers can reference it without guessing
- Document any edge cases or special considerations
- Follow all animation, interaction, and technical implementation rules strictly
- Respect all font weight, icon, and styling guidelines

## Output Format

Create this as a well-structured markdown file saved as STYLE_GUIDE.md in the project root or /docs folder.
