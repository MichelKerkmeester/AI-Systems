#!/usr/bin/env node
/**
 * Drag element from source to target (drag & drop)
 * Usage:
 *   node drag.js --from ".draggable-item" --to ".drop-zone"
 *   node drag.js --from "#source" --to "#target" --url https://example.com
 */
import { getBrowser, getPage, closeBrowser, parseArgs, outputJSON, outputError } from './lib/browser.js';

async function dragAndDrop() {
  const args = parseArgs(process.argv.slice(2));

  if (!args.from) {
    outputError(new Error('--from (source selector) is required'));
    return;
  }

  if (!args.to) {
    outputError(new Error('--to (target selector) is required'));
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

    // Wait for both elements to be visible
    await page.waitForSelector(args.from, {
      visible: true,
      timeout: parseInt(args.timeout || '5000')
    });

    await page.waitForSelector(args.to, {
      visible: true,
      timeout: parseInt(args.timeout || '5000')
    });

    // Get source and target elements
    const source = await page.$(args.from);
    const target = await page.$(args.to);

    if (!source) {
      outputError(new Error(`Source element not found: ${args.from}`));
      return;
    }

    if (!target) {
      outputError(new Error(`Target element not found: ${args.to}`));
      return;
    }

    // Perform drag and drop
    // Note: Puppeteer's drag/drop API requires both drag() and drop()
    await source.drag(target);
    await source.drop(target);

    const result = {
      success: true,
      from: args.from,
      to: args.to,
      dragged: true,
      url: page.url()
    };

    // Wait for optional selector after drag (e.g., confirmation message)
    if (args['wait-for']) {
      await page.waitForSelector(args['wait-for'], {
        timeout: parseInt(args.timeout || '5000')
      });
      result.appearedAfterDrag = args['wait-for'];
    }

    // Optional: Get positions of elements
    if (args.details === 'true') {
      const sourceBox = await source.boundingBox();
      const targetBox = await target.boundingBox();

      if (sourceBox && targetBox) {
        result.positions = {
          source: {
            x: sourceBox.x,
            y: sourceBox.y,
            width: sourceBox.width,
            height: sourceBox.height
          },
          target: {
            x: targetBox.x,
            y: targetBox.y,
            width: targetBox.width,
            height: targetBox.height
          },
          distance: {
            x: targetBox.x - sourceBox.x,
            y: targetBox.y - sourceBox.y
          }
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

dragAndDrop();
