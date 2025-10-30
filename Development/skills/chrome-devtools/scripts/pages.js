#!/usr/bin/env node
/**
 * Multi-page management - List, create, switch, and close browser pages/tabs
 * Usage:
 *   node pages.js --action list
 *   node pages.js --action new --url https://example.com
 *   node pages.js --action switch --index 1
 *   node pages.js --action close --index 1
 *   node pages.js --action front --index 0
 */
import { getBrowser, closeBrowser, parseArgs, outputJSON, outputError, listPages, switchPage } from './lib/browser.js';

async function managePages() {
  const args = parseArgs(process.argv.slice(2));

  if (!args.action) {
    outputError(new Error('--action is required (list|new|switch|close|front)'));
    return;
  }

  const validActions = ['list', 'new', 'switch', 'close', 'front'];
  if (!validActions.includes(args.action)) {
    outputError(new Error(`Invalid action: ${args.action}. Must be one of: ${validActions.join(', ')}`));
    return;
  }

  try {
    const browser = await getBrowser({
      headless: args.headless !== 'false'
    });

    let result = {
      success: true,
      action: args.action
    };

    switch (args.action) {
      case 'list': {
        // List all open pages
        const pages = await listPages(browser);
        result.pageCount = pages.length;
        result.pages = pages;
        break;
      }

      case 'new': {
        // Create new page
        const newPage = await browser.newPage();

        // Navigate if URL provided
        if (args.url) {
          await newPage.goto(args.url, {
            waitUntil: args['wait-until'] || 'networkidle2',
            timeout: parseInt(args.timeout || '30000')
          });
        }

        const pages = await listPages(browser);
        const pageIndex = pages.length - 1;

        result.pageIndex = pageIndex;
        result.url = newPage.url();
        result.title = await newPage.title();
        result.totalPages = pages.length;
        break;
      }

      case 'switch': {
        // Switch to page by index
        if (args.index === undefined) {
          outputError(new Error('--index is required for switch action'));
          return;
        }

        const index = parseInt(args.index);
        const page = await switchPage(browser, index);

        result.pageIndex = index;
        result.url = page.url();
        result.title = await page.title();
        break;
      }

      case 'close': {
        // Close page by index
        if (args.index === undefined) {
          outputError(new Error('--index is required for close action'));
          return;
        }

        const index = parseInt(args.index);
        const pages = await browser.pages();

        if (index < 0 || index >= pages.length) {
          outputError(new Error(`Page index ${index} out of range (0-${pages.length - 1})`));
          return;
        }

        // Don't allow closing the last page
        if (pages.length === 1) {
          outputError(new Error('Cannot close the last page'));
          return;
        }

        const pageToClose = pages[index];
        const urlClosed = pageToClose.url();
        await pageToClose.close();

        result.pageIndex = index;
        result.urlClosed = urlClosed;
        result.remainingPages = pages.length - 1;
        break;
      }

      case 'front': {
        // Bring page to front
        if (args.index === undefined) {
          outputError(new Error('--index is required for front action'));
          return;
        }

        const index = parseInt(args.index);
        const page = await switchPage(browser, index);

        result.pageIndex = index;
        result.url = page.url();
        result.title = await page.title();
        break;
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

managePages();
