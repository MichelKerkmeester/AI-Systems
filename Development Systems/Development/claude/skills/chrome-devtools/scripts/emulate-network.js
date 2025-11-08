#!/usr/bin/env node
/**
 * Emulate network conditions (throttling, offline mode)
 * Usage:
 *   node emulate-network.js --profile "Slow 3G"
 *   node emulate-network.js --profile "Offline"
 *   node emulate-network.js --download 1500000 --upload 750000 --latency 40
 *   node emulate-network.js --profile "No emulation"
 */
import { getBrowser, getPage, closeBrowser, parseArgs, outputJSON, outputError } from './lib/browser.js';

// Network profiles matching official MCP implementation
const NETWORK_PROFILES = {
  'No emulation': {
    offline: false,
    downloadThroughput: -1,
    uploadThroughput: -1,
    latency: 0
  },
  'Offline': {
    offline: true,
    downloadThroughput: 0,
    uploadThroughput: 0,
    latency: 0
  },
  'Slow 3G': {
    offline: false,
    downloadThroughput: (1.6 * 1024 * 1024) / 8, // 1.6 Mbps
    uploadThroughput: (750 * 1024) / 8,           // 750 Kbps
    latency: 150                                    // 150ms RTT
  },
  'Fast 3G': {
    offline: false,
    downloadThroughput: (1.6 * 1024 * 1024) / 8, // 1.6 Mbps
    uploadThroughput: (750 * 1024) / 8,           // 750 Kbps
    latency: 75                                     // 75ms RTT
  },
  'Slow 4G': {
    offline: false,
    downloadThroughput: (4 * 1024 * 1024) / 8,   // 4 Mbps
    uploadThroughput: (3 * 1024 * 1024) / 8,      // 3 Mbps
    latency: 50                                     // 50ms RTT
  },
  'Fast 4G': {
    offline: false,
    downloadThroughput: (10 * 1024 * 1024) / 8,  // 10 Mbps
    uploadThroughput: (5 * 1024 * 1024) / 8,      // 5 Mbps
    latency: 20                                     // 20ms RTT
  }
};

async function emulateNetwork() {
  const args = parseArgs(process.argv.slice(2));

  try {
    const browser = await getBrowser({
      headless: args.headless !== 'false'
    });

    const page = await getPage(browser);

    let conditions;

    // Use profile or custom settings
    if (args.profile) {
      if (!NETWORK_PROFILES[args.profile]) {
        const availableProfiles = Object.keys(NETWORK_PROFILES).join(', ');
        outputError(new Error(`Invalid profile: ${args.profile}. Available: ${availableProfiles}`));
        return;
      }
      conditions = NETWORK_PROFILES[args.profile];
    } else if (args.download || args.upload || args.latency) {
      // Custom settings
      conditions = {
        offline: args.offline === 'true',
        downloadThroughput: args.download ? parseInt(args.download) : -1,
        uploadThroughput: args.upload ? parseInt(args.upload) : -1,
        latency: args.latency ? parseInt(args.latency) : 0
      };
    } else {
      outputError(new Error('Either --profile or custom settings (--download, --upload, --latency) required'));
      return;
    }

    // Apply network conditions
    const client = await page.createCDPSession();
    await client.send('Network.emulateNetworkConditions', conditions);

    const result = {
      success: true,
      profile: args.profile || 'custom',
      conditions: {
        offline: conditions.offline,
        downloadThroughput: conditions.downloadThroughput === -1 ? 'unlimited' : conditions.downloadThroughput,
        uploadThroughput: conditions.uploadThroughput === -1 ? 'unlimited' : conditions.uploadThroughput,
        latency: conditions.latency,
        downloadMbps: conditions.downloadThroughput > 0
          ? ((conditions.downloadThroughput * 8) / (1024 * 1024)).toFixed(2)
          : 'unlimited',
        uploadMbps: conditions.uploadThroughput > 0
          ? ((conditions.uploadThroughput * 8) / (1024 * 1024)).toFixed(2)
          : 'unlimited'
      },
      active: true
    };

    // Navigate if URL provided
    if (args.url) {
      await page.goto(args.url, {
        waitUntil: args['wait-until'] || 'networkidle2',
        timeout: parseInt(args.timeout || '60000') // Longer timeout for slow connections
      });
      result.url = page.url();
      result.title = await page.title();
    }

    outputJSON(result);

    if (args.close !== 'false') {
      await closeBrowser();
    }
  } catch (error) {
    outputError(error);
  }
}

emulateNetwork();
