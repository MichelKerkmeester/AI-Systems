#!/usr/bin/env node
/**
 * Handle JavaScript dialogs (alert, confirm, prompt)
 * Usage:
 *   node dialog.js --action accept [--input "text for prompt"] [--url https://example.com]
 *   node dialog.js --action dismiss [--url https://example.com]
 *   node dialog.js --action wait [--timeout 5000]
 *
 * Note: Dialogs are auto-dismissed by default. This script provides manual control.
 */
import { getBrowser, getPage, closeBrowser, parseArgs, outputJSON, outputError, configurePage } from './lib/browser.js';

async function handleDialog() {
  const args = parseArgs(process.argv.slice(2));

  if (!args.action) {
    outputError(new Error('--action is required (accept|dismiss|wait)'));
    return;
  }

  const validActions = ['accept', 'dismiss', 'wait'];
  if (!validActions.includes(args.action)) {
    outputError(new Error(`Invalid action: ${args.action}. Must be one of: ${validActions.join(', ')}`));
    return;
  }

  try {
    const browser = await getBrowser({
      headless: args.headless !== 'false'
    });

    const page = await getPage(browser);

    // Don't auto-configure page for manual dialog control
    // configurePage(page) would auto-dismiss dialogs

    const result = {
      success: true,
      action: args.action
    };

    // Set up dialog handler
    const dialogPromise = new Promise((resolve, reject) => {
      const timeout = setTimeout(() => {
        reject(new Error('Dialog timeout - no dialog appeared'));
      }, parseInt(args.timeout || '30000'));

      page.once('dialog', async (dialog) => {
        clearTimeout(timeout);

        try {
          result.dialogType = dialog.type();
          result.dialogMessage = dialog.message();

          if (args.action === 'accept') {
            if (args.input && dialog.type() === 'prompt') {
              await dialog.accept(args.input);
              result.inputProvided = args.input;
            } else {
              await dialog.accept();
            }
          } else if (args.action === 'dismiss') {
            await dialog.dismiss();
          } else if (args.action === 'wait') {
            // Just record dialog info, don't handle it
            result.handled = false;
            await dialog.dismiss(); // Still dismiss to prevent hanging
          }

          result.handled = true;
          resolve(result);
        } catch (error) {
          reject(error);
        }
      });
    });

    // Navigate if URL provided (which may trigger dialog)
    if (args.url) {
      await page.goto(args.url, {
        waitUntil: args['wait-until'] || 'networkidle2',
        timeout: parseInt(args.timeout || '30000')
      });
    }

    // Wait for dialog to appear and be handled
    await dialogPromise;

    result.url = page.url();

    outputJSON(result);

    if (args.close !== 'false') {
      await closeBrowser();
    }
  } catch (error) {
    outputError(error);
  }
}

handleDialog();
