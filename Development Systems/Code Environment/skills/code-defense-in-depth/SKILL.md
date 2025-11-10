---
name: code-defense-in-depth
description: Use when implementing forms, API calls, DOM manipulation, or any user input handling - validates at every layer data passes through (input, processing, output) to make JavaScript errors structurally impossible
allowed-tools: Read, Edit, Write
---

# Defense-in-Depth Validation - Frontend & JavaScript

When you fix a bug caused by invalid data, adding validation at one place feels sufficient. But that single check can be bypassed by different user actions, browser behaviors, or future code changes.

**Core principle**: Validate at EVERY layer data passes through. Make the bug structurally impossible.

---

## 1. 🎯 WHEN TO USE

**Use when implementing**:
- Form input handling (contact forms, newsletter signups, etc.)
- API calls and responses
- DOM manipulation (adding/removing/modifying elements)
- Local storage operations
- URL parameter parsing
- User-generated content display
- Third-party data integration
- Video/media element manipulation
- Navigation state management
- Any code that processes external data

**Symptoms that indicate need**:
- `Cannot read property 'X' of null` errors
- `undefined is not a function` errors
- DOM elements not found after querySelector
- Form submissions failing silently
- Unexpected values breaking calculations
- Race conditions in data access
- XSS or injection vulnerabilities
- Data type mismatches

**Core principle**: Multiple validation layers + early returns + safe defaults = crash-resistant code

---

## 2. 🛠️ THE FOUR LAYERS

### Layer 1: Entry Point Validation
**Purpose**: Reject obviously invalid input at function boundary

```javascript
function initializeVideo(videoElement, config) {
  // Layer 1: Entry validation
  if (!videoElement) {
    console.error('[Video] Element is required');
    return null;
  }

  if (!(videoElement instanceof HTMLVideoElement)) {
    console.error('[Video] Must be HTMLVideoElement, got:', videoElement);
    return null;
  }

  if (!config || typeof config !== 'object') {
    console.error('[Video] Config must be object, got:', config);
    return null;
  }

  // Proceed with initialization...
}
```

**Benefits**:
- Catches errors at source
- Provides clear error messages
- Prevents undefined behavior
- Easy to debug (fail fast)

### Layer 2: Processing Validation
**Purpose**: Ensure data makes sense for this operation

```javascript
function updateVideoSource(videoElement, newSource) {
  // Layer 1: Entry validation
  if (!videoElement || !newSource) {
    console.error('[Video] Missing required parameters');
    return false;
  }

  // Layer 2: Processing validation
  if (typeof newSource !== 'string' || newSource.trim() === '') {
    console.error('[Video] Source must be non-empty string');
    return false;
  }

  if (!newSource.match(/\.(mp4|webm|m3u8)$/i)) {
    console.error('[Video] Invalid video format:', newSource);
    return false;
  }

  // Safe to proceed
  videoElement.src = newSource;
  return true;
}
```

**Benefits**:
- Business logic validation
- Prevents invalid state
- Catches edge cases
- Domain-specific rules

### Layer 3: Output Validation
**Purpose**: Verify results before using them

```javascript
async function fetchUserData(userId) {
  // Layer 1: Entry validation
  if (!userId || typeof userId !== 'string') {
    throw new Error('Valid userId required');
  }

  try {
    const response = await fetch(`/api/users/${userId}`);

    // Layer 2: Response validation
    if (!response.ok) {
      throw new Error(`API error: ${response.status}`);
    }

    const data = await response.json();

    // Layer 3: Output validation
    if (!data || typeof data !== 'object') {
      throw new Error('Invalid response data structure');
    }

    if (!data.name || !data.email) {
      throw new Error('Required fields missing from response');
    }

    // Sanitize output before returning
    return {
      id: String(data.id),
      name: String(data.name).trim(),
      email: String(data.email).toLowerCase().trim(),
      avatar: data.avatar || '/default-avatar.png'
    };

  } catch (error) {
    console.error('[API] User fetch failed:', error);
    // Return safe default
    return null;
  }
}
```

**Benefits**:
- Validates external data
- Sanitizes output
- Provides safe defaults
- Prevents XSS vulnerabilities

### Layer 4: Safe Access Patterns
**Purpose**: Prevent crashes when accessing nested data

```javascript
// ❌ DANGEROUS: No validation
function displayUserAvatar(user) {
  const avatar = user.profile.avatar.url; // Crashes if any property null
  document.querySelector('[avatar]').src = avatar;
}

// ✅ SAFE: Multiple layers of validation
function displayUserAvatar(user) {
  // Layer 1: User object validation
  if (!user || typeof user !== 'object') {
    console.warn('[Avatar] Invalid user object');
    showDefaultAvatar();
    return;
  }

  // Layer 2: Profile validation
  if (!user.profile || typeof user.profile !== 'object') {
    console.warn('[Avatar] User has no profile');
    showDefaultAvatar();
    return;
  }

  // Layer 3: Avatar validation
  if (!user.profile.avatar || !user.profile.avatar.url) {
    console.warn('[Avatar] User has no avatar URL');
    showDefaultAvatar();
    return;
  }

  // Layer 4: DOM element validation
  const avatarElement = document.querySelector('[avatar]');
  if (!avatarElement) {
    console.error('[Avatar] Avatar element not found');
    return;
  }

  // Safe to proceed
  avatarElement.src = user.profile.avatar.url;
  console.log('[Avatar] Updated successfully');
}

function showDefaultAvatar() {
  const avatarElement = document.querySelector('[avatar]');
  if (avatarElement) {
    avatarElement.src = '/default-avatar.png';
  }
}
```

**Modern JavaScript alternatives**:

```javascript
// Optional chaining (?.)
const avatarUrl = user?.profile?.avatar?.url || '/default-avatar.png';

// Nullish coalescing (??)
const name = user.name ?? 'Anonymous';
```

---

## 3. 📋 VALIDATION PATTERNS

### Pattern 1: Form Input Validation

```javascript
/**
 * Contact Form - Multi-layer validation
 */

class ContactForm {
  constructor(formElement) {
    // Layer 1: Constructor validation
    if (!formElement) {
      throw new Error('[ContactForm] Form element required');
    }

    this.form = formElement;
    this.setupValidation();
  }

  setupValidation() {
    this.form.addEventListener('submit', (e) => {
      e.preventDefault();
      this.handleSubmit();
    });

    // Real-time validation
    const inputs = this.form.querySelectorAll('input, textarea');
    inputs.forEach(input => {
      input.addEventListener('blur', () => this.validateField(input));
    });
  }

  validateField(field) {
    // Layer 2: Field-level validation
    const value = field.value?.trim();
    const fieldName = field.name;

    // Clear previous errors
    this.clearFieldError(field);

    // Required field check
    if (field.hasAttribute('required') && !value) {
      this.showFieldError(field, `${fieldName} is required`);
      return false;
    }

    // Type-specific validation
    switch (field.type) {
      case 'email':
        if (value && !this.isValidEmail(value)) {
          this.showFieldError(field, 'Invalid email address');
          return false;
        }
        break;

      case 'tel':
        if (value && !this.isValidPhone(value)) {
          this.showFieldError(field, 'Invalid phone number');
          return false;
        }
        break;
    }

    // Length validation
    const minLength = field.getAttribute('minlength');
    if (minLength && value && value.length < parseInt(minLength)) {
      this.showFieldError(field, `Minimum ${minLength} characters required`);
      return false;
    }

    return true;
  }

  isValidEmail(email) {
    // Layer 3: Format validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  }

  isValidPhone(phone) {
    // Remove common formatting
    const cleaned = phone.replace(/[\s\-\(\)]/g, '');
    // Check if digits only and reasonable length
    return /^\d{10,15}$/.test(cleaned);
  }

  async handleSubmit() {
    console.log('[ContactForm] Submitting...');

    // Layer 2: Validate all fields
    const fields = this.form.querySelectorAll('input, textarea');
    let isValid = true;

    fields.forEach(field => {
      if (!this.validateField(field)) {
        isValid = false;
      }
    });

    if (!isValid) {
      console.warn('[ContactForm] Validation failed');
      return;
    }

    // Layer 3: Collect and sanitize data
    const formData = new FormData(this.form);
    const data = {
      name: this.sanitizeText(formData.get('name')),
      email: this.sanitizeEmail(formData.get('email')),
      message: this.sanitizeText(formData.get('message'))
    };

    // Final validation before sending
    if (!data.name || !data.email || !data.message) {
      console.error('[ContactForm] Sanitization removed all content');
      this.showFormError('Please check your input and try again');
      return;
    }

    // Submit
    try {
      const result = await this.submitToAPI(data);

      // Layer 4: Validate API response
      if (result && result.success) {
        this.showFormSuccess('Message sent successfully!');
        this.form.reset();
      } else {
        throw new Error(result?.message || 'Submission failed');
      }

    } catch (error) {
      console.error('[ContactForm] Submission failed:', error);
      this.showFormError('Failed to send message. Please try again.');
    }
  }

  sanitizeText(text) {
    if (!text || typeof text !== 'string') return '';

    return text
      .trim()
      .replace(/</g, '&lt;') // Prevent XSS
      .replace(/>/g, '&gt;')
      .slice(0, 1000); // Max length
  }

  sanitizeEmail(email) {
    if (!email || typeof email !== 'string') return '';

    return email
      .toLowerCase()
      .trim()
      .slice(0, 254); // Max email length
  }

  async submitToAPI(data) {
    const response = await fetch('/api/contact', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data)
    });

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }

    return response.json();
  }

  showFieldError(field, message) {
    field.classList.add('error');
    const errorEl = field.parentElement.querySelector('.error-message');
    if (errorEl) {
      errorEl.textContent = message;
    }
  }

  clearFieldError(field) {
    field.classList.remove('error');
    const errorEl = field.parentElement.querySelector('.error-message');
    if (errorEl) {
      errorEl.textContent = '';
    }
  }

  showFormSuccess(message) {
    const successEl = this.form.querySelector('[form-success]');
    if (successEl) {
      successEl.textContent = message;
      successEl.style.display = 'block';
    }
  }

  showFormError(message) {
    const errorEl = this.form.querySelector('[form-error]');
    if (errorEl) {
      errorEl.textContent = message;
      errorEl.style.display = 'block';
    }
  }
}

// Initialize
document.addEventListener('DOMContentLoaded', () => {
  const form = document.querySelector('[contact-form]');
  if (form) {
    new ContactForm(form);
  }
});
```

### Pattern 2: Safe DOM Manipulation

```javascript
/**
 * Safe DOM operations with validation at every layer
 */

class SafeDOM {
  static createElement(tag, attributes = {}, textContent = '') {
    // Layer 1: Input validation
    if (!tag || typeof tag !== 'string') {
      console.error('[SafeDOM] Invalid tag:', tag);
      return null;
    }

    try {
      const element = document.createElement(tag);

      // Layer 2: Attribute validation
      if (attributes && typeof attributes === 'object') {
        Object.entries(attributes).forEach(([key, value]) => {
          // Sanitize attribute values
          if (typeof value === 'string') {
            element.setAttribute(key, this.sanitizeAttribute(value));
          }
        });
      }

      // Layer 3: Content validation
      if (textContent) {
        element.textContent = this.sanitizeText(String(textContent));
      }

      return element;

    } catch (error) {
      console.error('[SafeDOM] Element creation failed:', error);
      return null;
    }
  }

  static querySelector(selector, context = document) {
    // Layer 1: Selector validation
    if (!selector || typeof selector !== 'string') {
      console.error('[SafeDOM] Invalid selector:', selector);
      return null;
    }

    try {
      const element = context.querySelector(selector);

      // Layer 2: Result validation
      if (!element) {
        console.warn(`[SafeDOM] Element not found: ${selector}`);
        return null;
      }

      return element;

    } catch (error) {
      console.error('[SafeDOM] Query failed:', error, 'selector:', selector);
      return null;
    }
  }

  static setHTML(element, html) {
    // Layer 1: Element validation
    if (!element || !(element instanceof Element)) {
      console.error('[SafeDOM] Invalid element');
      return false;
    }

    // Layer 2: Content validation
    if (html === null || html === undefined) {
      element.innerHTML = '';
      return true;
    }

    // Layer 3: Sanitize HTML (prevent XSS)
    const sanitized = this.sanitizeHTML(String(html));
    element.innerHTML = sanitized;
    return true;
  }

  static sanitizeText(text) {
    if (typeof text !== 'string') return '';

    return text
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#x27;');
  }

  static sanitizeAttribute(value) {
    if (typeof value !== 'string') return '';

    return value
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#x27;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;');
  }

  static sanitizeHTML(html) {
    // Basic XSS prevention (use DOMPurify in production)
    const temp = document.createElement('div');
    temp.textContent = html;
    return temp.innerHTML;
  }

  static addClass(element, className) {
    // Layer 1: Element validation
    if (!element || !(element instanceof Element)) {
      console.error('[SafeDOM] Invalid element for addClass');
      return false;
    }

    // Layer 2: Class name validation
    if (!className || typeof className !== 'string') {
      console.error('[SafeDOM] Invalid className');
      return false;
    }

    element.classList.add(className);
    return true;
  }

  static removeElement(element) {
    // Layer 1: Element validation
    if (!element || !(element instanceof Element)) {
      console.warn('[SafeDOM] Invalid element for removal');
      return false;
    }

    // Layer 2: Parent validation
    if (!element.parentElement) {
      console.warn('[SafeDOM] Element has no parent');
      return false;
    }

    element.remove();
    return true;
  }
}

// Usage examples
const button = SafeDOM.createElement('button', {
  'class': 'btn-primary',
  'data-action': 'submit'
}, 'Click Me');

const container = SafeDOM.querySelector('[container]');
if (container && button) {
  container.appendChild(button);
}
```

### Pattern 3: API Error Handling

```javascript
/**
 * Robust API client with error handling at every layer
 */

class APIClient {
  constructor(baseURL) {
    // Layer 1: Constructor validation
    if (!baseURL || typeof baseURL !== 'string') {
      throw new Error('[API] Base URL required');
    }

    this.baseURL = baseURL.replace(/\/$/, ''); // Remove trailing slash
  }

  async get(endpoint, params = {}) {
    return this.request('GET', endpoint, null, params);
  }

  async post(endpoint, data) {
    return this.request('POST', endpoint, data);
  }

  async request(method, endpoint, data = null, params = {}) {
    // Layer 1: Method validation
    const allowedMethods = ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'];
    if (!allowedMethods.includes(method)) {
      throw new Error(`[API] Invalid HTTP method: ${method}`);
    }

    // Layer 2: Endpoint validation
    if (!endpoint || typeof endpoint !== 'string') {
      throw new Error('[API] Endpoint required');
    }

    // Build URL
    const url = new URL(`${this.baseURL}${endpoint}`);

    // Add query parameters for GET requests
    if (method === 'GET' && params && typeof params === 'object') {
      Object.entries(params).forEach(([key, value]) => {
        if (value !== null && value !== undefined) {
          url.searchParams.append(key, String(value));
        }
      });
    }

    // Build request options
    const options = {
      method,
      headers: {
        'Content-Type': 'application/json',
      }
    };

    // Add body for POST/PUT/PATCH
    if (data && ['POST', 'PUT', 'PATCH'].includes(method)) {
      // Layer 3: Data validation
      if (typeof data !== 'object') {
        throw new Error('[API] Request data must be object');
      }

      options.body = JSON.stringify(data);
    }

    try {
      console.log(`[API] ${method} ${url}`);

      // Make request
      const response = await fetch(url, options);

      // Layer 4: Response validation
      if (!response) {
        throw new Error('[API] No response from server');
      }

      // Check HTTP status
      if (!response.ok) {
        const errorData = await this.parseErrorResponse(response);
        throw new Error(
          errorData.message || `HTTP ${response.status}: ${response.statusText}`
        );
      }

      // Layer 5: Response parsing
      const contentType = response.headers.get('content-type');

      if (contentType && contentType.includes('application/json')) {
        const json = await response.json();

        // Layer 6: JSON validation
        if (json === null || json === undefined) {
          throw new Error('[API] Empty JSON response');
        }

        return json;

      } else {
        // Non-JSON response
        const text = await response.text();
        return { data: text };
      }

    } catch (error) {
      // Layer 7: Error handling
      console.error(`[API] Request failed:`, error);

      // Rethrow with context
      throw new Error(`API request failed: ${error.message}`);
    }
  }

  async parseErrorResponse(response) {
    try {
      return await response.json();
    } catch {
      return {
        message: response.statusText || 'Unknown error'
      };
    }
  }
}

// Usage with error handling
async function loadUserData(userId) {
  const api = new APIClient('https://api.example.com');

  try {
    // Layer 1: Input validation
    if (!userId) {
      throw new Error('User ID required');
    }

    // Layer 2: API call
    const user = await api.get(`/users/${userId}`);

    // Layer 3: Response validation
    if (!user || typeof user !== 'object') {
      throw new Error('Invalid user data received');
    }

    if (!user.id || !user.name) {
      throw new Error('User data missing required fields');
    }

    // Layer 4: Sanitize output
    return {
      id: String(user.id),
      name: String(user.name).trim(),
      email: user.email ? String(user.email).toLowerCase() : null,
      avatar: user.avatar || '/default-avatar.png'
    };

  } catch (error) {
    console.error('[UserData] Load failed:', error);

    // Return safe default instead of crashing
    return {
      id: userId,
      name: 'Unknown User',
      email: null,
      avatar: '/default-avatar.png'
    };
  }
}
```

---

## 4. 📖 RULES

### ALWAYS

- Validate function parameters (null/undefined/type checks)
- Validate API responses before using data
- Validate DOM elements exist before manipulating
- Sanitize user input before storing or displaying
- Provide fallback values for missing data
- Use optional chaining (`?.`) for nested access
- Add `try/catch` around risky operations
- Log validation failures for debugging
- Return early when validation fails
- Test with invalid/missing data
- Validate at every layer data passes through

### NEVER

- Assume data exists without checking
- Trust external data (APIs, user input, URL params)
- Access nested properties without validation
- Use innerHTML with unsanitized data
- Ignore validation failures silently
- Chain property access without null checks (`user.profile.avatar.url`)
- Skip type checking function parameters
- Return undefined from functions (return null or safe default)
- Assume DOM elements exist
- Parse JSON without error handling

### ESCALATE IF

- Validation logic becoming too complex
- Same validation repeated in multiple places (needs abstraction)
- Security concerns with XSS or injection attacks
- Performance impact from excessive validation
- Third-party data structure constantly changing

---

## 5. ⚠️ COMMON MISTAKES

**Trusting external data**:
- **Problem**: `const name = apiResponse.user.name` crashes if user missing
- **Fix**: Validate each level: `const name = apiResponse?.user?.name || 'Unknown'`

**No input sanitization**:
- **Problem**: `element.innerHTML = userInput` allows XSS attacks
- **Fix**: Sanitize or use `textContent`: `element.textContent = userInput`

**Silent failures**:
- **Problem**: Validation fails but code continues
- **Fix**: Return early, throw errors, or log warnings

**Single layer validation**:
- **Problem**: Only validate at entry point
- **Fix**: Validate at entry, processing, and output

**Poor error messages**:
- **Problem**: `console.error('Error')` - what error?
- **Fix**: `console.error('[VideoPlayer] Element not found:', selector)`

---

## 6. 💡 EXAMPLE WORKFLOWS

### Example 1: Video Player with Multi-Layer Validation

```javascript
class VideoPlayer {
  constructor(config) {
    // Layer 1: Config validation
    if (!config || typeof config !== 'object') {
      throw new Error('[VideoPlayer] Configuration object required');
    }

    if (!config.selector) {
      throw new Error('[VideoPlayer] selector is required in config');
    }

    this.config = this.validateConfig(config);
    this.video = null;
    this.hls = null;
  }

  validateConfig(config) {
    // Layer 2: Individual property validation
    return {
      selector: String(config.selector),
      autoplay: Boolean(config.autoplay ?? true),
      muted: Boolean(config.muted ?? true),
      controls: Boolean(config.controls ?? true),
      source: config.source ? String(config.source) : null,
      fallback: config.fallback || null
    };
  }

  async initialize() {
    // Layer 3: Element validation
    this.video = document.querySelector(this.config.selector);

    if (!this.video) {
      console.error(`[VideoPlayer] Element not found: ${this.config.selector}`);
      return false;
    }

    if (!(this.video instanceof HTMLVideoElement)) {
      console.error('[VideoPlayer] Element is not a video element');
      return false;
    }

    // Layer 4: Source validation
    const source = this.config.source || this.video.dataset.src;

    if (!source) {
      console.error('[VideoPlayer] No video source provided');
      return false;
    }

    if (!this.isValidVideoURL(source)) {
      console.error('[VideoPlayer] Invalid video URL:', source);
      return false;
    }

    // Initialize video
    return this.loadVideo(source);
  }

  isValidVideoURL(url) {
    if (!url || typeof url !== 'string') return false;

    const validExtensions = /\.(mp4|webm|m3u8|mpd)$/i;
    return validExtensions.test(url) || url.includes('://');
  }

  async loadVideo(source) {
    try {
      // Layer 5: HLS detection
      if (source.endsWith('.m3u8')) {
        return await this.loadHLS(source);
      }

      // Native video
      this.video.src = source;
      return true;

    } catch (error) {
      console.error('[VideoPlayer] Load failed:', error);

      // Layer 6: Fallback handling
      if (this.config.fallback) {
        console.log('[VideoPlayer] Trying fallback source');
        this.video.src = this.config.fallback;
        return true;
      }

      return false;
    }
  }

  async loadHLS(source) {
    // Layer 7: HLS library validation
    if (typeof Hls === 'undefined') {
      console.error('[VideoPlayer] HLS.js not loaded');

      if (this.video.canPlayType('application/vnd.apple.mpegurl')) {
        // Safari native HLS
        this.video.src = source;
        return true;
      }

      return false;
    }

    if (!Hls.isSupported()) {
      console.warn('[VideoPlayer] HLS not supported');
      return false;
    }

    this.hls = new Hls();
    this.hls.loadSource(source);
    this.hls.attachMedia(this.video);

    return new Promise((resolve, reject) => {
      this.hls.on(Hls.Events.MANIFEST_PARSED, () => resolve(true));
      this.hls.on(Hls.Events.ERROR, (event, data) => {
        if (data.fatal) reject(new Error(data.type));
      });
    });
  }

  play() {
    // Layer 8: Playback validation
    if (!this.video) {
      console.error('[VideoPlayer] Video not initialized');
      return Promise.reject(new Error('Not initialized'));
    }

    if (this.video.readyState < 2) {
      console.warn('[VideoPlayer] Video not ready yet');
      return Promise.reject(new Error('Not ready'));
    }

    return this.video.play().catch(error => {
      console.error('[VideoPlayer] Playback failed:', error);
      throw error;
    });
  }

  destroy() {
    // Cleanup
    if (this.hls) {
      this.hls.destroy();
      this.hls = null;
    }

    this.video = null;
  }
}

// Usage
document.addEventListener('DOMContentLoaded', async () => {
  try {
    const player = new VideoPlayer({
      selector: '[video-hero]',
      autoplay: true,
      muted: true
    });

    const initialized = await player.initialize();

    if (initialized) {
      await player.play();
      console.log('[VideoPlayer] Playing successfully');
    }

  } catch (error) {
    console.error('[VideoPlayer] Initialization failed:', error);
    // Show error UI
  }
});
```

---

## 7. 🎓 SUCCESS CRITERIA

**Defense-in-depth is successful when**:
- ✅ All function parameters validated
- ✅ All DOM queries check for null
- ✅ All API responses validated before use
- ✅ All user input sanitized
- ✅ Safe defaults provided for missing data
- ✅ Early returns on validation failures
- ✅ Clear error messages logged
- ✅ No `Cannot read property of null/undefined` errors
- ✅ XSS vulnerabilities prevented
- ✅ Code handles edge cases gracefully

**Quality gates**:
- What happens if API returns null?
- What happens if DOM element doesn't exist?
- What happens if user input is empty/malicious?
- Are all code paths tested with invalid data?
- Do error messages help with debugging?

---

## 8. 🔗 INTEGRATION POINTS

### Pairs With
- **code-systematic-debugging** - Validation prevents many bugs
- **code-verification-before-completion** - Verify validation works
- **code-condition-based-waiting** - Validate after waiting completes
- **code-root-cause-tracing** - Trace where invalid data originates

### Browser APIs Used
- `instanceof` - Type checking
- `typeof` - Primitive type checking
- `?.` - Optional chaining
- `??` - Nullish coalescing
- `try/catch` - Error handling
- `element.classList` - Safe class manipulation
- `element.textContent` - Safe text insertion
- `FormData` - Form data handling

### Security Considerations
- XSS prevention (sanitize innerHTML)
- SQL injection (server-side concern)
- CSRF tokens (API integration)
- Input validation (client + server)

---

## 9. 📚 REFERENCES

### Security
- **OWASP Top 10** - https://owasp.org/www-project-top-ten/
- **XSS Prevention** - https://cheatsheetseries.owasp.org/cheatsheets/Cross_Site_Scripting_Prevention_Cheat_Sheet.html
- **DOMPurify** (HTML sanitization library)

### JavaScript Standards
- **MDN: Optional Chaining** - https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Optional_chaining
- **MDN: Nullish Coalescing** - https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Nullish_coalescing

### Project Standards
- AGENTS.md - Code quality standards
- Document Style Guide - Code documentation
