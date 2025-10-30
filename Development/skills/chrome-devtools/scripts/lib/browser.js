/**
 * Shared browser utilities for Chrome DevTools scripts
 */
import puppeteer from 'puppeteer';
import debug from 'debug';

const log = debug('chrome-devtools:browser');

let browserInstance = null;
let pageInstance = null;

/**
 * Launch or connect to browser
 */
export async function getBrowser(options = {}) {
  if (browserInstance && browserInstance.isConnected()) {
    log('Reusing existing browser instance');
    return browserInstance;
  }

  const launchOptions = {
    headless: options.headless !== false,
    args: [
      '--no-sandbox',
      '--disable-setuid-sandbox',
      '--disable-dev-shm-usage',
      ...(options.args || [])
    ],
    defaultViewport: options.viewport || {
      width: 1920,
      height: 1080
    },
    ...options
  };

  if (options.browserUrl || options.wsEndpoint) {
    log('Connecting to existing browser');
    browserInstance = await puppeteer.connect({
      browserURL: options.browserUrl,
      browserWSEndpoint: options.wsEndpoint
    });
  } else {
    log('Launching new browser');
    browserInstance = await puppeteer.launch(launchOptions);
  }

  return browserInstance;
}

/**
 * Get current page or create new one
 */
export async function getPage(browser) {
  if (pageInstance && !pageInstance.isClosed()) {
    log('Reusing existing page');
    return pageInstance;
  }

  const pages = await browser.pages();
  if (pages.length > 0) {
    pageInstance = pages[0];
  } else {
    pageInstance = await browser.newPage();
  }

  return pageInstance;
}

/**
 * Close browser
 */
export async function closeBrowser() {
  if (browserInstance) {
    await browserInstance.close();
    browserInstance = null;
    pageInstance = null;
  }
}

/**
 * Parse command line arguments
 */
export function parseArgs(argv, options = {}) {
  const args = {};

  for (let i = 0; i < argv.length; i++) {
    const arg = argv[i];

    if (arg.startsWith('--')) {
      const key = arg.slice(2);
      const nextArg = argv[i + 1];

      if (nextArg && !nextArg.startsWith('--')) {
        args[key] = nextArg;
        i++;
      } else {
        args[key] = true;
      }
    }
  }

  return args;
}

/**
 * Output JSON result
 */
export function outputJSON(data) {
  console.log(JSON.stringify(data, null, 2));
}

/**
 * Output error
 */
export function outputError(error) {
  console.error(JSON.stringify({
    success: false,
    error: error.message,
    stack: error.stack
  }, null, 2));
  process.exit(1);
}

/**
 * Configure page with default handlers
 * @param {Page} page - Puppeteer page instance
 * @param {Object} options - Configuration options
 * @param {string} options.dialogMode - Dialog handling mode: 'auto-dismiss' (default), 'auto-accept', 'manual'
 * @returns {Page} Configured page
 */
export function configurePage(page, options = {}) {
  const dialogMode = options.dialogMode || 'auto-dismiss';

  // Handle dialogs (alert, confirm, prompt)
  if (dialogMode !== 'manual') {
    page.on('dialog', async (dialog) => {
      log(`Dialog detected: ${dialog.type()} - ${dialog.message()}`);

      if (dialogMode === 'auto-dismiss') {
        await dialog.dismiss();
      } else if (dialogMode === 'auto-accept') {
        await dialog.accept();
      }
    });
  }

  return page;
}

/**
 * List all open pages in the browser
 * @param {Browser} browser - Puppeteer browser instance
 * @returns {Promise<Array>} Array of page info objects
 */
export async function listPages(browser) {
  const pages = await browser.pages();

  return await Promise.all(
    pages.map(async (page, index) => ({
      index,
      url: page.url(),
      title: await page.title(),
      isClosed: page.isClosed()
    }))
  );
}

/**
 * Switch to a specific page by index
 * @param {Browser} browser - Puppeteer browser instance
 * @param {number} index - Page index to switch to
 * @returns {Promise<Page>} The selected page
 */
export async function switchPage(browser, index) {
  const pages = await browser.pages();

  if (index < 0 || index >= pages.length) {
    throw new Error(`Page index ${index} out of range (0-${pages.length - 1})`);
  }

  const targetPage = pages[index];
  await targetPage.bringToFront();

  // Update global page instance
  pageInstance = targetPage;

  return targetPage;
}
