#!/usr/bin/env node
/**
 * Hover over an element to trigger CSS :hover states and dropdowns
 * Usage:
 *   node hover.js --selector ".dropdown-trigger"
 *   node hover.js --selector "#menu-item" --url https://example.com
 *   node hover.js --selector ".tooltip-trigger" --wait-for ".tooltip-content"
 */
import { getBrowser, getPage, closeBrowser, parseArgs, outputJSON, outputError } from './lib/browser.js';

async function hoverElement() {
  const args = parseArgs(process.argv.slice(2));

  if (!args.selector) {
    outputError(new Error('--selector is required'));
    return;
  }

  try {
    const browser = await getBrowser({
      headless: args.headless !== 'false'
    });

    const page = await getPage(browser);

    // Navigate if URL provided
    if (args.url) {
      await page.goto(args.url, {
        waitUntil: args['wait-until'] || 'networkidle2',
        timeout: parseInt(args.timeout || '30000')
      });
    }

    // Wait for element to be visible
    await page.waitForSelector(args.selector, {
      visible: true,
      timeout: parseInt(args.timeout || '5000')
    });

    // Hover over element
    await page.hover(args.selector);

    const result = {
      success: true,
      selector: args.selector,
      hovered: true,
      url: page.url()
    };

    // Wait for optional selector after hover (e.g., dropdown menu appears)
    if (args['wait-for']) {
      await page.waitForSelector(args['wait-for'], {
        visible: true,
        timeout: parseInt(args.timeout || '5000')
      });
      result.appearedAfterHover = args['wait-for'];
    }

    // Optional: Get element position
    if (args.details === 'true') {
      const element = await page.$(args.selector);
      const box = await element.boundingBox();

      if (box) {
        result.position = {
          x: box.x,
          y: box.y,
          width: box.width,
          height: box.height
        };
      }
    }

    outputJSON(result);

    if (args.close !== 'false') {
      await closeBrowser();
    }
  } catch (error) {
    outputError(error);
  }
}

hoverElement();
