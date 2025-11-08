#!/usr/bin/env node

/**
 * Transform Claude Code JSONL transcript to save-context JSON format
 *
 * Usage: node transform-transcript.js <transcript-path> <output-path>
 *
 * Input: JSONL file with conversation messages
 * Output: JSON file in save-context expected format
 */

const fs = require('fs');
const path = require('path');

// ───────────────────────────────────────────────────────────────
// CONFIGURATION
// ───────────────────────────────────────────────────────────────

const MAX_OBSERVATIONS = 20;  // Limit observations to prevent huge files
const MAX_PROMPT_LENGTH = 5000;  // Truncate very long prompts
const SUMMARY_LENGTH = 200;  // Length for context summaries

// ───────────────────────────────────────────────────────────────
// MAIN TRANSFORMATION FUNCTION
// ───────────────────────────────────────────────────────────────

function transformTranscript(transcriptPath, outputPath) {
  try {
    // Read and parse JSONL transcript
    const transcriptContent = fs.readFileSync(transcriptPath, 'utf8');

    if (!transcriptContent.trim()) {
      console.error('⚠️  Empty transcript file');
      return false;
    }

    const transcript = transcriptContent
      .trim()
      .split('\n')
      .filter(line => line.trim())
      .map((line, idx) => {
        try {
          return JSON.parse(line);
        } catch (err) {
          console.error(`⚠️  Invalid JSON on line ${idx + 1}: ${err.message}`);
          return null;
        }
      })
      .filter(entry => entry !== null);

    if (transcript.length === 0) {
      console.error('⚠️  No valid messages in transcript');
      return false;
    }

    // Extract user prompts
    const userPrompts = extractUserPrompts(transcript);

    // Extract observations from assistant responses
    const observations = extractObservations(transcript);

    // Build recent context summary
    const recentContext = buildRecentContext(transcript, userPrompts);

    // Create final data structure
    const data = {
      recent_context: recentContext,
      observations: observations.slice(0, MAX_OBSERVATIONS),
      user_prompts: userPrompts
    };

    // Write output file
    fs.writeFileSync(outputPath, JSON.stringify(data, null, 2), 'utf8');

    console.log(`✓ Transformed ${transcript.length} messages`);
    console.log(`  • ${userPrompts.length} user prompts`);
    console.log(`  • ${observations.length} observations`);
    console.log(`  • Saved to: ${outputPath}`);

    return true;

  } catch (error) {
    console.error(`❌ Transformation failed: ${error.message}`);
    return false;
  }
}

// ───────────────────────────────────────────────────────────────
// EXTRACTION FUNCTIONS
// ───────────────────────────────────────────────────────────────

function extractUserPrompts(transcript) {
  return transcript
    .filter(entry => entry.type === 'user' && entry.message)
    .map(entry => {
      let content = entry.message.content || '';

      // Truncate if too long
      if (content.length > MAX_PROMPT_LENGTH) {
        content = content.substring(0, MAX_PROMPT_LENGTH) + '... [truncated]';
      }

      return {
        prompt: content,
        timestamp: entry.timestamp || new Date().toISOString()
      };
    });
}

function extractObservations(transcript) {
  const observations = [];

  // Extract from assistant messages
  const assistantMessages = transcript.filter(entry => entry.type === 'assistant' && entry.message);

  for (let i = 0; i < assistantMessages.length; i++) {
    const entry = assistantMessages[i];
    const content = entry.message.content;

    if (!content || !Array.isArray(content)) continue;

    // Extract text from content array
    const textParts = content
      .filter(part => part.type === 'text')
      .map(part => part.text)
      .join('\n');

    if (!textParts.trim()) continue;

    // Try to classify observation type based on content
    const type = classifyObservationType(textParts);

    // Extract title from first line or sentence
    const title = extractTitle(textParts);

    // Create narrative (first 500 chars)
    const narrative = textParts.substring(0, 500);

    observations.push({
      type: type,
      title: title,
      narrative: narrative,
      timestamp: entry.timestamp || new Date().toISOString(),
      files: extractFileReferences(textParts),
      facts: []
    });
  }

  return observations;
}

function buildRecentContext(transcript, userPrompts) {
  const firstPrompt = userPrompts[0];
  const lastPrompt = userPrompts[userPrompts.length - 1];

  if (!firstPrompt) {
    return [{
      request: 'No user prompts captured',
      completed: 'Conversation ended',
      learning: 'Context saved automatically',
      duration: 'Unknown',
      date: new Date().toISOString()
    }];
  }

  // Try to determine request and completion
  const request = firstPrompt.prompt.substring(0, SUMMARY_LENGTH);
  const completion = lastPrompt ?
    (lastPrompt.prompt.substring(0, SUMMARY_LENGTH) !== request ?
      lastPrompt.prompt.substring(0, SUMMARY_LENGTH) :
      'Conversation completed') :
    'Conversation completed';

  // Calculate approximate duration
  const startTime = new Date(firstPrompt.timestamp);
  const endTime = lastPrompt ? new Date(lastPrompt.timestamp) : new Date();
  const durationMs = endTime - startTime;
  const durationMin = Math.floor(durationMs / 60000);
  const duration = durationMin > 0 ? `${durationMin} minutes` : 'Less than 1 minute';

  return [{
    request: request,
    completed: completion,
    learning: `Captured ${userPrompts.length} user prompts and ${transcript.length} total messages`,
    duration: duration,
    date: firstPrompt.timestamp
  }];
}

// ───────────────────────────────────────────────────────────────
// HELPER FUNCTIONS
// ───────────────────────────────────────────────────────────────

function classifyObservationType(text) {
  const lowerText = text.toLowerCase();

  if (lowerText.includes('fix') || lowerText.includes('bug') || lowerText.includes('error')) {
    return 'bugfix';
  }
  if (lowerText.includes('add') || lowerText.includes('implement') || lowerText.includes('create')) {
    return 'feature';
  }
  if (lowerText.includes('refactor') || lowerText.includes('improve') || lowerText.includes('optimize')) {
    return 'refactor';
  }
  if (lowerText.includes('decide') || lowerText.includes('choice') || lowerText.includes('option')) {
    return 'decision';
  }
  if (lowerText.includes('change') || lowerText.includes('update') || lowerText.includes('modify')) {
    return 'change';
  }

  return 'discovery';
}

function extractTitle(text) {
  // Try to get first sentence or first 100 chars
  const firstSentence = text.match(/^[^.!?]+[.!?]/);
  if (firstSentence) {
    return firstSentence[0].trim().substring(0, 100);
  }

  const firstLine = text.split('\n')[0];
  return firstLine.trim().substring(0, 100);
}

function extractFileReferences(text) {
  const files = [];

  // Match common file path patterns
  const patterns = [
    /`([^`]+\.[a-zA-Z0-9]+)`/g,  // Backtick file references
    /\b(src\/[^\s]+)/g,           // src/ paths
    /\b(specs\/[^\s]+)/g,         // specs/ paths
    /\b([a-zA-Z0-9_-]+\.(js|ts|css|md|json|sh))\b/g  // Common file extensions
  ];

  for (const pattern of patterns) {
    const matches = text.matchAll(pattern);
    for (const match of matches) {
      const file = match[1];
      if (file && !files.includes(file) && file.length < 200) {
        files.push(file);
      }
    }
  }

  return files.slice(0, 10);  // Limit to 10 files per observation
}

// ───────────────────────────────────────────────────────────────
// CLI ENTRY POINT
// ───────────────────────────────────────────────────────────────

if (require.main === module) {
  const args = process.argv.slice(2);

  if (args.length !== 2) {
    console.error('Usage: node transform-transcript.js <transcript-path> <output-path>');
    process.exit(1);
  }

  const [transcriptPath, outputPath] = args;

  // Expand tilde in paths
  const expandedTranscriptPath = transcriptPath.replace(/^~/, process.env.HOME);
  const expandedOutputPath = outputPath.replace(/^~/, process.env.HOME);

  const success = transformTranscript(expandedTranscriptPath, expandedOutputPath);

  process.exit(success ? 0 : 1);
}

module.exports = { transformTranscript };
