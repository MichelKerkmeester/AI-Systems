#!/usr/bin/env node
/**
 * Emulate CPU throttling (1-20x slowdown)
 * Usage:
 *   node emulate-cpu.js --rate 4
 *   node emulate-cpu.js --rate 1  # Disable throttling
 *   node emulate-cpu.js --rate 6 --url https://example.com
 */
import { getBrowser, getPage, closeBrowser, parseArgs, outputJSON, outputError } from './lib/browser.js';

async function emulateCPU() {
  const args = parseArgs(process.argv.slice(2));

  if (!args.rate) {
    outputError(new Error('--rate is required (1-20, where 1 = no throttling)'));
    return;
  }

  const rate = parseInt(args.rate);

  if (rate < 1 || rate > 20) {
    outputError(new Error('--rate must be between 1 and 20'));
    return;
  }

  try {
    const browser = await getBrowser({
      headless: args.headless !== 'false'
    });

    const page = await getPage(browser);

    // Apply CPU throttling via CDP
    const client = await page.createCDPSession();
    await client.send('Emulation.setCPUThrottlingRate', { rate });

    const result = {
      success: true,
      throttleRate: rate,
      slowdownFactor: `${rate}x`,
      active: rate > 1,
      description: rate === 1
        ? 'No throttling (normal CPU speed)'
        : `CPU slowed down by ${rate}x (simulates ${rate}x slower device)`
    };

    // Navigate if URL provided
    if (args.url) {
      const startTime = Date.now();

      await page.goto(args.url, {
        waitUntil: args['wait-until'] || 'networkidle2',
        timeout: parseInt(args.timeout || '60000') // Longer timeout for slow CPU
      });

      const loadTime = Date.now() - startTime;

      result.url = page.url();
      result.title = await page.title();
      result.loadTime = loadTime;
      result.loadTimeSeconds = (loadTime / 1000).toFixed(2);
    }

    outputJSON(result);

    if (args.close !== 'false') {
      await closeBrowser();
    }
  } catch (error) {
    outputError(error);
  }
}

emulateCPU();
