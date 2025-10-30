#!/usr/bin/env node
/**
 * Upload file via file input element
 * Usage:
 *   node upload.js --selector "input[type='file']" --file /path/to/document.pdf
 *   node upload.js --selector "#avatar" --file /tmp/photo.jpg --url https://example.com
 */
import { getBrowser, getPage, closeBrowser, parseArgs, outputJSON, outputError } from './lib/browser.js';
import fs from 'fs';
import path from 'path';

async function uploadFile() {
  const args = parseArgs(process.argv.slice(2));

  if (!args.selector) {
    outputError(new Error('--selector is required'));
    return;
  }

  if (!args.file) {
    outputError(new Error('--file is required'));
    return;
  }

  try {
    // Validate file exists
    const filePath = path.resolve(args.file);
    if (!fs.existsSync(filePath)) {
      outputError(new Error(`File not found: ${filePath}`));
      return;
    }

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

    // Wait for file input element
    await page.waitForSelector(args.selector, {
      visible: args.hidden !== 'true', // Allow hidden file inputs
      timeout: parseInt(args.timeout || '5000')
    });

    // Get file input element
    const fileInput = await page.$(args.selector);

    if (!fileInput) {
      outputError(new Error(`Element not found: ${args.selector}`));
      return;
    }

    // Upload file
    await fileInput.uploadFile(filePath);

    // Wait for optional selector after upload
    if (args['wait-for']) {
      await page.waitForSelector(args['wait-for'], {
        timeout: parseInt(args.timeout || '5000')
      });
    }

    const result = {
      success: true,
      selector: args.selector,
      file: filePath,
      fileName: path.basename(filePath),
      fileSize: fs.statSync(filePath).size,
      uploaded: true,
      url: page.url()
    };

    outputJSON(result);

    if (args.close !== 'false') {
      await closeBrowser();
    }
  } catch (error) {
    outputError(error);
  }
}

uploadFile();
