#!/usr/bin/env node

/**
 * Pixel-Perfect Style Extractor
 *
 * Extracts computed styles from a website using Puppeteer for pixel-perfect replication.
 * This script replaces the need for Chrome DevTools MCP integration.
 *
 * Usage: node extract-styles.js <url> [output-dir]
 * Example: node extract-styles.js https://google.com ./site-copy-google
 */

const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');

// Breakpoints for responsive design analysis
const BREAKPOINTS = [
  { name: 'mobile', width: 320, height: 568 },
  { name: 'mobile-large', width: 375, height: 667 },
  { name: 'tablet', width: 768, height: 1024 },
  { name: 'desktop', width: 1024, height: 768 },
  { name: 'desktop-large', width: 1440, height: 900 },
  { name: 'desktop-xl', width: 1920, height: 1080 }
];

// CSS properties to extract for comprehensive style guide
const STYLE_PROPERTIES = [
  // Typography
  'font-family', 'font-size', 'font-weight', 'line-height', 'letter-spacing',
  'text-align', 'text-transform', 'text-decoration', 'font-style',

  // Colors
  'color', 'background-color', 'border-color', 'opacity',

  // Box Model
  'width', 'height', 'margin', 'margin-top', 'margin-right', 'margin-bottom', 'margin-left',
  'padding', 'padding-top', 'padding-right', 'padding-bottom', 'padding-left',
  'border', 'border-width', 'border-style', 'border-radius',

  // Layout
  'display', 'position', 'top', 'right', 'bottom', 'left', 'z-index',
  'flex-direction', 'flex-wrap', 'justify-content', 'align-items', 'align-content',
  'flex-grow', 'flex-shrink', 'flex-basis', 'gap', 'row-gap', 'column-gap',
  'grid-template-columns', 'grid-template-rows', 'grid-gap',

  // Visual Effects
  'box-shadow', 'text-shadow', 'filter', 'backdrop-filter', 'transform',
  'transition', 'animation',

  // Overflow & Visibility
  'overflow', 'overflow-x', 'overflow-y', 'visibility'
];

/**
 * Extract computed styles for a specific element
 */
function getComputedStylesForElement(element, properties) {
  const computed = window.getComputedStyle(element);
  const styles = {};

  properties.forEach(prop => {
    const value = computed.getPropertyValue(prop);
    if (value && value !== 'none' && value !== 'auto') {
      styles[prop] = value;
    }
  });

  return styles;
}

/**
 * Identify semantic component type based on element characteristics
 */
function identifyComponentType(element) {
  const tagName = element.tagName.toLowerCase();
  const classList = Array.from(element.classList);
  const role = element.getAttribute('role');

  // Header/Navigation
  if (tagName === 'header' || role === 'banner') return 'header';
  if (tagName === 'nav' || role === 'navigation') return 'navigation';

  // Main content areas
  if (tagName === 'main' || role === 'main') return 'main';
  if (tagName === 'footer' || role === 'contentinfo') return 'footer';
  if (tagName === 'aside' || role === 'complementary') return 'aside';

  // Interactive elements
  if (tagName === 'button' || role === 'button') return 'button';
  if (tagName === 'a') return 'link';
  if (tagName === 'input') return 'input';
  if (tagName === 'form') return 'form';

  // Content sections
  if (tagName === 'article') return 'article';
  if (tagName === 'section') return 'section';

  // Check class names for common patterns
  const classStr = classList.join(' ').toLowerCase();
  if (classStr.includes('hero')) return 'hero';
  if (classStr.includes('card')) return 'card';
  if (classStr.includes('modal') || classStr.includes('dialog')) return 'modal';
  if (classStr.includes('dropdown') || classStr.includes('menu')) return 'dropdown';

  return 'generic';
}

/**
 * Extract all styles from the page
 */
async function extractPageStyles(page, url) {
  console.log(`Extracting styles from ${url}...`);

  const pageData = await page.evaluate((properties) => {
    const data = {
      url: window.location.href,
      title: document.title,
      viewport: {
        width: window.innerWidth,
        height: window.innerHeight
      },
      components: [],
      colors: new Set(),
      fonts: new Set(),
      spacing: new Set(),
      shadows: new Set()
    };

    // Select all significant elements (not every single node)
    const selectors = [
      'header', 'nav', 'main', 'footer', 'aside', 'section', 'article',
      'button', 'a', 'input', 'textarea', 'select',
      'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'p',
      '[class*="hero"]', '[class*="card"]', '[class*="container"]',
      '[class*="button"]', '[class*="nav"]', '[class*="menu"]'
    ];

    const elements = document.querySelectorAll(selectors.join(', '));

    elements.forEach((element, index) => {
      const computed = window.getComputedStyle(element);
      const styles = {};

      // Extract specified properties
      properties.forEach(prop => {
        const value = computed.getPropertyValue(prop);
        if (value && value !== 'none' && value !== 'auto' && value !== 'normal') {
          styles[prop] = value;

          // Collect unique values for design system
          if (prop === 'color' || prop === 'background-color' || prop === 'border-color') {
            if (value.startsWith('rgb')) data.colors.add(value);
          }
          if (prop === 'font-family') {
            data.fonts.add(value);
          }
          if (prop.includes('margin') || prop.includes('padding') || prop === 'gap') {
            if (value.match(/^\d+(\.\d+)?px$/)) data.spacing.add(value);
          }
          if (prop === 'box-shadow' || prop === 'text-shadow') {
            data.shadows.add(value);
          }
        }
      });

      // Only include elements with meaningful styles
      if (Object.keys(styles).length > 0) {
        data.components.push({
          index,
          tag: element.tagName.toLowerCase(),
          id: element.id || null,
          classes: Array.from(element.classList),
          text: element.textContent?.substring(0, 50).trim() || null,
          styles,
          boundingBox: element.getBoundingClientRect()
        });
      }
    });

    // Convert Sets to Arrays for JSON serialization
    data.colors = Array.from(data.colors);
    data.fonts = Array.from(data.fonts);
    data.spacing = Array.from(data.spacing).sort((a, b) => parseFloat(a) - parseFloat(b));
    data.shadows = Array.from(data.shadows);

    return data;
  }, STYLE_PROPERTIES);

  return pageData;
}

/**
 * Convert RGB to Hex color
 */
function rgbToHex(rgb) {
  const match = rgb.match(/^rgba?\((\d+),\s*(\d+),\s*(\d+)(?:,\s*(\d+(?:\.\d+)?))?\)$/);
  if (!match) return rgb;

  const r = parseInt(match[1]);
  const g = parseInt(match[2]);
  const b = parseInt(match[3]);
  const a = match[4] ? parseFloat(match[4]) : 1;

  const hex = '#' + [r, g, b].map(x => x.toString(16).padStart(2, '0')).join('');
  return a < 1 ? `${hex} (${Math.round(a * 100)}% opacity)` : hex;
}

/**
 * Generate style guide markdown from extracted data
 */
function generateStyleGuide(allData, url) {
  const domain = new URL(url).hostname.replace('www.', '');

  let markdown = `# Style Guide: ${domain}\n\n`;
  markdown += `**Source**: ${url}\n`;
  markdown += `**Extracted**: ${new Date().toISOString()}\n\n`;

  // Color Palette
  markdown += `## Color Palette\n\n`;
  const allColors = new Set();
  allData.forEach(data => data.colors.forEach(c => allColors.add(c)));
  Array.from(allColors).forEach(color => {
    markdown += `- \`${rgbToHex(color)}\` - ${color}\n`;
  });
  markdown += `\n`;

  // Typography
  markdown += `## Typography\n\n`;
  const allFonts = new Set();
  allData.forEach(data => data.fonts.forEach(f => allFonts.add(f)));
  markdown += `### Font Families\n`;
  Array.from(allFonts).forEach(font => {
    markdown += `- ${font}\n`;
  });
  markdown += `\n`;

  // Spacing System
  markdown += `## Spacing System\n\n`;
  const allSpacing = new Set();
  allData.forEach(data => data.spacing.forEach(s => allSpacing.add(s)));
  const spacingArray = Array.from(allSpacing).sort((a, b) => parseFloat(a) - parseFloat(b));
  markdown += `Detected spacing values:\n`;
  spacingArray.forEach(space => {
    markdown += `- ${space}\n`;
  });
  markdown += `\n`;

  // Shadows
  markdown += `## Shadows & Elevation\n\n`;
  const allShadows = new Set();
  allData.forEach(data => data.shadows.forEach(s => allShadows.add(s)));
  Array.from(allShadows).forEach((shadow, index) => {
    markdown += `### Shadow ${index + 1}\n\`\`\`css\nbox-shadow: ${shadow};\n\`\`\`\n\n`;
  });

  // Responsive Breakpoints
  markdown += `## Responsive Breakpoints\n\n`;
  markdown += `Analyzed at the following breakpoints:\n`;
  BREAKPOINTS.forEach(bp => {
    markdown += `- **${bp.name}**: ${bp.width}x${bp.height}px\n`;
  });
  markdown += `\n`;

  markdown += `## Component Details\n\n`;
  markdown += `See \`styles-data.json\` for complete component-level style extraction.\n\n`;

  markdown += `---\n\n`;
  markdown += `*Generated by Pixel-Perfect Style Extractor*\n`;

  return markdown;
}

/**
 * Main extraction function
 */
async function extractSiteStyles(url, outputDir) {
  const domain = new URL(url).hostname.replace('www.', '');
  const output = outputDir || `./site-copy-${domain}`;

  // Create output directories
  const dirs = {
    root: output,
    original: path.join(output, 'original'),
    replica: path.join(output, 'replica'),
    comparison: path.join(output, 'comparison'),
    data: path.join(output, 'data')
  };

  Object.values(dirs).forEach(dir => {
    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, { recursive: true });
    }
  });

  console.log(`Starting extraction for ${url}`);
  console.log(`Output directory: ${output}`);

  const browser = await puppeteer.launch({
    headless: 'new',
    args: ['--no-sandbox', '--disable-setuid-sandbox']
  });

  try {
    const allData = [];

    for (const breakpoint of BREAKPOINTS) {
      console.log(`\nAnalyzing ${breakpoint.name} (${breakpoint.width}x${breakpoint.height})...`);

      const page = await browser.newPage();
      await page.setViewport({
        width: breakpoint.width,
        height: breakpoint.height
      });

      await page.goto(url, { waitUntil: 'networkidle2', timeout: 30000 });

      // Extract styles
      const styleData = await extractPageStyles(page, url);
      styleData.breakpoint = breakpoint.name;
      allData.push(styleData);

      // Take screenshot
      const screenshotPath = path.join(dirs.original, `${breakpoint.name}-${breakpoint.width}px.png`);
      await page.screenshot({
        path: screenshotPath,
        fullPage: true
      });
      console.log(`Screenshot saved: ${screenshotPath}`);

      // Save breakpoint-specific data
      const dataPath = path.join(dirs.data, `${breakpoint.name}-styles.json`);
      fs.writeFileSync(dataPath, JSON.stringify(styleData, null, 2));

      await page.close();
    }

    // Generate combined style guide
    const styleGuide = generateStyleGuide(allData, url);
    const styleGuidePath = path.join(dirs.root, 'STYLE_GUIDE.md');
    fs.writeFileSync(styleGuidePath, styleGuide);
    console.log(`\nStyle guide generated: ${styleGuidePath}`);

    // Save complete data
    const completeDataPath = path.join(dirs.data, 'complete-extraction.json');
    fs.writeFileSync(completeDataPath, JSON.stringify(allData, null, 2));
    console.log(`Complete data saved: ${completeDataPath}`);

    // Create README
    const readme = `# Site Copy: ${domain}\n\n` +
      `**Source**: ${url}\n` +
      `**Extracted**: ${new Date().toISOString()}\n\n` +
      `## Structure\n\n` +
      `- \`original/\` - Screenshots of original site at various breakpoints\n` +
      `- \`replica/\` - Screenshots of your replica implementation\n` +
      `- \`comparison/\` - Side-by-side comparisons and notes\n` +
      `- \`data/\` - Extracted style data in JSON format\n` +
      `- \`STYLE_GUIDE.md\` - Generated style guide with design system\n\n` +
      `## Workflow\n\n` +
      `1. Review \`STYLE_GUIDE.md\` for design system details\n` +
      `2. Review \`data/complete-extraction.json\` for component-level styles\n` +
      `3. Implement replica using Tailwind CSS\n` +
      `4. Take screenshots of replica and save to \`replica/\`\n` +
      `5. Compare original vs replica screenshots\n` +
      `6. Document differences in \`comparison/notes.md\`\n`;

    fs.writeFileSync(path.join(dirs.root, 'README.md'), readme);

    console.log('\n✅ Extraction complete!');
    console.log(`\nNext steps:`);
    console.log(`1. Review ${styleGuidePath}`);
    console.log(`2. Check data files in ${dirs.data}`);
    console.log(`3. Compare screenshots in ${dirs.original}`);

  } catch (error) {
    console.error('Error during extraction:', error);
    throw error;
  } finally {
    await browser.close();
  }
}

// CLI execution
if (require.main === module) {
  const args = process.argv.slice(2);

  if (args.length === 0) {
    console.error('Usage: node extract-styles.js <url> [output-dir]');
    console.error('Example: node extract-styles.js https://google.com ./site-copy-google');
    process.exit(1);
  }

  const url = args[0];
  const outputDir = args[1];

  extractSiteStyles(url, outputDir)
    .then(() => process.exit(0))
    .catch(error => {
      console.error('Fatal error:', error);
      process.exit(1);
    });
}

module.exports = { extractSiteStyles };
