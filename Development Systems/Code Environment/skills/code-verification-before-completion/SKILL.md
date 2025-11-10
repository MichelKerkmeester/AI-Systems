---
name: code-verification-before-completion
description: Use when about to claim frontend work is complete, fixed, or passing in browser - requires running verification in actual browsers across viewports and confirming animations/interactions before making any success claims; evidence before assertions always
allowed-tools: Bash, Read
---

# Verification Before Completion - Frontend & Browser Testing

Claiming work is complete without browser verification is dishonesty, not efficiency. "Works on my machine" is not verification.

**Core principle**: Evidence in browser before claims, always.

**Violating the letter of this rule is violating the spirit of this rule.**

---

## 1. 🎯 WHEN TO USE

**Use BEFORE claiming**:
- Animation is working correctly
- Layout issue is fixed
- JavaScript feature is complete
- Video/media loads properly
- Form submission works
- Navigation functions correctly
- Mobile responsive layout is correct
- Cross-browser compatibility achieved
- Performance meets standards
- Any statement of completion or success

**The Iron Law**:
```
NO COMPLETION CLAIMS WITHOUT FRESH BROWSER VERIFICATION EVIDENCE
```

If you haven't opened the browser and tested in this message, you cannot claim it works.

**Core principle**: Browser evidence + viewport testing + animation verification = trustworthy claims

---

## 2. 🛠️ THE GATE FUNCTION

**BEFORE claiming any status or expressing satisfaction**:

```markdown
1. IDENTIFY: What command or action proves this claim?
2. OPEN: Launch actual browser (not just reading code)
3. TEST: Execute the user interaction or view the result
4. VERIFY: Does browser show expected behavior?
   - Visual: Does it look correct?
   - Interactive: Do clicks/hovers work?
   - Animation: Does timing feel right?
   - Console: No errors in DevTools?
   - Responsive: Works on all viewport sizes?
5. VERIFY: Multi-viewport check (mobile + desktop minimum)
6. VERIFY: Cross-browser check (if critical fix)
7. RECORD: Note what you saw ("tested in Chrome at 1920px, animation smooth, no console errors")
   - If NO: State actual status with evidence
   - If YES: State claim WITH evidence
8. ONLY THEN: Make the claim
```

Skip any step = lying, not verifying.

---

## 3. 📋 VERIFICATION REQUIREMENTS

### Required For Every Claim

| Claim | Requires | Not Sufficient |
|-------|----------|----------------|
| Animation works | Browser test showing smooth animation, correct timing, no jank | Code review, "should work" |
| Layout fixed | Screenshot/description of correct layout at key breakpoints | CSS looks correct, linter passed |
| Feature complete | Browser test of full user flow, no console errors | Implementation matches spec |
| Video loads | Video playing in browser, correct quality, no buffering issues | HLS.js code looks correct |
| Mobile responsive | Tested at 320px, 768px viewports minimum | Looks good at 1920px |
| Cross-browser | Tested in Chrome + Firefox + Safari (or note limitation) | Works in Chrome only |
| Form submits | Form successfully submits in browser, see success state | JavaScript code complete |
| No console errors | DevTools console clear, no warnings | Code looks clean |
| Performance acceptable | Animations at 60fps, page loads < 3s | Code refactored |
| Click handlers work | Clicked in browser, saw expected result | Event listener attached |

### Browser Testing Matrix

**Minimum verification for any frontend claim**:
```markdown
□ Chrome Desktop (1920px) - Primary browser
□ Mobile emulation (375px) - iPhone viewport
□ DevTools Console - No errors
```

**Standard verification for production-ready work**:
```markdown
□ Chrome Desktop (1920px)
□ Firefox Desktop (1920px)
□ Safari Desktop (1920px) - if macOS available
□ Mobile Chrome (375px) - via DevTools emulation
□ Mobile Safari (375px) - via DevTools emulation
□ Tablet (768px) - iPad viewport
□ DevTools Console clear in all browsers
□ Network tab shows no failed requests
□ Performance acceptable (no jank, smooth animations)
```

**Critical fixes require**:
```markdown
□ All standard verification above
□ Real mobile device testing (not just emulation)
□ Edge cases tested (slow network, ad blockers, etc.)
□ Animations tested at different viewport transitions
```

---

## 4. 📖 RULES

### ALWAYS

- Open actual browser to verify (not just code review)
- Test in Chrome at minimum (primary browser)
- Test mobile viewport (375px minimum)
- Check DevTools console for errors
- Test interactive elements by clicking them
- Watch full animation cycle to verify timing
- Test at key responsive breakpoints (320px, 768px, 1920px)
- Note what you tested in your claim ("tested in Chrome/Firefox at 1920px and 375px, no console errors, animation smooth")
- Take screenshot if visual change
- Record any limitations ("tested Chrome only, needs Safari verification")

### NEVER

- Claim "works" without opening browser
- Say "should work" or "probably works" - test it
- Trust code review alone for visual/interactive features
- Test only at one viewport size
- Ignore console warnings as "not important"
- Skip animation timing verification
- Assume desktop testing covers mobile
- Claim "cross-browser" without testing multiple browsers
- Express satisfaction before verification ("Great!", "Perfect!", "Done!")
- Use phrases implying success without evidence

### ESCALATE IF

- Cannot test in required browsers (e.g., no Safari access)
- Real device testing required but unavailable
- Issue only reproduces in production environment
- Performance testing requires specialized tools
- Accessibility testing needed but not equipped

---

## 5. ⚠️ RED FLAGS - STOP

If you catch yourself thinking:
- "Quick fix for now, test later"
- "Code looks correct, should work"
- "Tested desktop, mobile probably fine"
- "One browser is enough for this"
- "Animation looks close enough"
- "That console warning isn't important"
- "Can verify after deploy"
- "Looks good to me" (without testing)
- "**About to use words like 'Done', 'Complete', 'Fixed', 'Working', 'Ready' without having just tested**"

**ALL of these mean: STOP. Open browser and verify.**

---

## 6. 💡 KEY PATTERNS

### Pattern 1: Layout Changes
```markdown
✅ CORRECT:
"Opened Chrome DevTools, tested at 320px/768px/1920px.
Header spacing now 24px at mobile (tested at 375px),
32px at desktop (tested at 1920px). Transitions smooth at
all breakpoints. No console errors. Layout matches design."

❌ INCORRECT:
"CSS updated, spacing looks correct"
"Should be 24px on mobile now"
```

### Pattern 2: Animation Implementation
```markdown
✅ CORRECT:
"Tested in Chrome at 1920px. Page loader fades out over 800ms,
timing feels natural. Tested page refresh 5 times, animation
consistent. No jank detected. DevTools Performance shows 60fps
throughout. No console errors."

❌ INCORRECT:
"Animation code looks good"
"Timing should be correct now"
"Works in my browser"
```

### Pattern 3: Interactive Features
```markdown
✅ CORRECT:
"Tested in Chrome/Firefox at desktop and mobile viewports.
Navigation dropdown opens on click, closes on outside click.
Menu items navigate correctly. Mobile hamburger menu works.
All tested interactions successful. DevTools console clear."

❌ INCORRECT:
"Event handlers attached correctly"
"Navigation should work now"
"Code implements all interactions"
```

### Pattern 4: Video/Media
```markdown
✅ CORRECT:
"Tested in Chrome at 1920px and Safari at 1920px.
Hero video loads and plays automatically. HLS.js switches
quality appropriately. Video poster shows before playback.
Mobile (375px): Video plays on interaction. No console errors
in any browser. Network tab shows successful HLS manifest loads."

❌ INCORRECT:
"HLS.js configured correctly"
"Video code looks good"
"Should autoplay now"
```

### Pattern 5: Cross-Browser
```markdown
✅ CORRECT:
"Tested in Chrome/Firefox/Safari all at 1920px and 375px:
✓ Chrome: Animations smooth, no console errors
✓ Firefox: Animations smooth, no console errors
✓ Safari: Animations smooth, no console errors
All viewport transitions clean. Feature works identically
across all tested browsers."

❌ INCORRECT:
"Cross-browser compatible"
"Works in Chrome so should work everywhere"
"Used standard JavaScript, compatible"
```

---

## 7. 💡 EXAMPLE WORKFLOWS

### Example 1: Animation Fix

```text
User: "Fix the page loader animation timing"

Claude: [Makes code changes]

❌ WRONG APPROACH:
"I've updated the animation duration to 800ms. The page loader
should now fade out smoothly. The timing looks correct in the code."

✅ CORRECT APPROACH:
"I've updated the animation duration to 800ms. Let me verify this works:

[Opening Chrome browser at localhost:8080]
[Hard refresh with Cmd+Shift+R to bypass cache]
[Watching page load sequence...]

VERIFIED:
- Page loader appears immediately on load
- Fades out over 800ms (counted: "one-mississippi, two-mississip..." - timing feels natural)
- Transition smooth, no jank
- Content fades in correctly after loader exits
- Tested 3 page refreshes - consistent behavior
- DevTools Console: No errors
- DevTools Performance tab: 60fps maintained during animation

[Testing mobile viewport at 375px in DevTools]
- Animation timing identical at mobile size
- No layout shift during animation
- Console clear

The page loader animation now fades out over 800ms smoothly at both
desktop (1920px) and mobile (375px) viewports with no console errors."
```

### Example 2: Responsive Layout

```text
User: "Fix the navigation menu overlap on mobile"

Claude: [Makes CSS changes]

❌ WRONG APPROACH:
"I've added margin-top to the main content. The navigation overlap
should be fixed now."

✅ CORRECT APPROACH:
"I've added responsive margin-top to the main content. Let me verify:

[Opening Chrome DevTools, enabling device emulation]

Testing at iPhone SE (375x667):
[Screenshot or description]
- Navigation fixed at top: 60px height
- Main content starts at 60px from top
- No overlap confirmed
- Scrolling smooth, no layout shift

Testing at iPad (768x1024):
- Navigation: 60px height
- Content: 60px top margin
- No overlap, spacing correct

Testing at Desktop (1920x1080):
- Navigation: 80px height
- Content: 80px top margin
- No overlap, clean transition

Breakpoint transitions:
[Slowly resizing browser from 320px to 1920px]
- 320px-767px: 60px spacing maintained
- 768px+: 80px spacing maintained
- No awkward spacing at breakpoint transitions
- No horizontal scroll at any width

DevTools Console: No errors at any viewport size

The navigation overlap is fixed. Main content now has appropriate
spacing on mobile (60px) and desktop (80px) with clean transitions
at all breakpoints."
```

### Example 3: Video Implementation

```text
User: "Implement HLS video player on hero section"

Claude: [Implements video player code]

❌ WRONG APPROACH:
"I've implemented the HLS video player with autoplay and quality
switching. The code follows HLS.js documentation and should work correctly."

✅ CORRECT APPROACH:
"I've implemented the HLS video player. Let me verify it works:

[Opening Chrome at localhost:8080/]
[Watching hero section load...]

DESKTOP (1920px) - Chrome:
✓ Video element visible
✓ HLS.js loads from CDN (Network tab confirms)
✓ Video starts playing automatically within 2s
✓ Quality switches appropriately (checked Network tab: HLS manifest loading segments)
✓ Video poster shows during initial load
✓ No console errors
✓ Controls work (pause/play tested)

MOBILE (375px) - Chrome DevTools:
✓ Video shows poster image
✓ Autoplay disabled (mobile restriction)
✓ Play button appears over poster
✓ Clicking play button starts video
✓ Video fills viewport correctly
✓ No console errors

[Testing in Firefox at 1920px]
✓ Video autoplays correctly
✓ HLS segments loading
✓ Quality switching functional
✓ No console errors

[Testing in Safari at 1920px - if available]
✓ Video autoplays (Safari allows muted autoplay)
✓ HLS native support (Safari uses native HLS, not HLS.js)
✓ No console errors

EDGE CASES TESTED:
- Slow network: Video shows loading state, starts playing when buffered
- Video completion: Loops correctly (as configured)
- Page reload: Consistent behavior across 3 refreshes

The HLS video player is working correctly across Chrome/Firefox/Safari
at both desktop (1920px) and mobile (375px) viewports. Autoplay works
on desktop, user-initiated play works on mobile. No console errors in
any tested browser."
```

---

## 8. 📋 COMMON RATIONALIZATIONS

| Excuse | Reality |
|--------|---------|
| "Code looks correct" | Code correctness ≠ browser behavior. Test it. |
| "Quick test later" | "Later" never comes. Test now. |
| "Works on my machine" | Your machine isn't production. Test properly. |
| "Linter passed" | Linter doesn't test browser behavior. |
| "Tested desktop" | Mobile is 50%+ of traffic. Test mobile too. |
| "One browser enough" | Users use different browsers. Test multiple. |
| "Animation close enough" | "Close enough" looks unprofessional. Get it right. |
| "Console warning not critical" | Warnings often indicate real problems. Don't ignore. |
| "Will verify after deploy" | Verify BEFORE deploy. Production is not testing. |
| "No time to test" | Time to fix after deploy > time to test now. |

---

## 9. 🎓 SUCCESS CRITERIA

**Verification is successful when**:
- ✅ Opened actual browser (not just reviewed code)
- ✅ Tested in multiple viewports (mobile + desktop minimum)
- ✅ Checked DevTools console (no errors)
- ✅ Tested interactions by actually clicking/hovering
- ✅ Watched full animation cycle (if applicable)
- ✅ Tested in multiple browsers (if claiming cross-browser)
- ✅ Documented what was tested in claim
- ✅ Can describe exactly what was seen in browser
- ✅ Noted any limitations or remaining work

**Quality gates**:
- Can you describe what you saw in browser?
- Did you test at mobile viewport?
- Is DevTools console clear?
- Did you test the actual user interaction?
- Did you verify animation timing by watching it?
- Can you confidently say it works because you saw it work?

---

## 10. 🔗 INTEGRATION POINTS

### Pairs With
- **code-systematic-debugging** - Verify fixes work after debugging
- **code-condition-based-waiting** - Verify async operations complete
- **code-defense-in-depth** - Verify validation prevents errors
- **code-root-cause-tracing** - Verify traced issue is resolved

### Browser Tools Used
- Chrome DevTools (primary)
- Firefox Developer Tools
- Safari Web Inspector
- Device Emulation
- Network Monitor
- Performance Profiler
- Console

### Testing Contexts
- Local development server
- Staging environment
- Production (for verification only)
- Webflow preview
- Published Webflow site

---

## 11. 🔧 TROUBLESHOOTING

### "Can't Open Browser in Claude Code Context"

**Solution**:
- Describe verification steps you would take
- Ask user to verify in their browser
- Provide specific testing checklist
- Never claim it works without verification
- State limitation explicitly: "Code implemented but requires browser verification"

### "Works Locally But Not in Production"

**Actions**:
1. Check browser cache (hard refresh)
2. Verify CDN propagation completed
3. Check console for different errors in production
4. Test in incognito mode (eliminates extensions)
5. Check Webflow publish status

### "Inconsistent Behavior Across Tests"

**Possible Causes**:
- Cache not cleared between tests
- Timing/race condition issues
- Browser extensions interfering
- Network conditions affecting load
- Animations dependent on window size

**Actions**:
1. Hard refresh between each test
2. Test in incognito mode
3. Add more console logging
4. Check Network tab for timing
5. Use consistent viewport sizes

---

## 12. 📚 REFERENCES

### Browser Testing Resources
- Chrome DevTools Documentation
- Firefox Developer Tools Documentation
- Safari Web Inspector Guide
- BrowserStack (cross-browser testing)
- LambdaTest (cross-browser testing)

### Performance Standards
- Core Web Vitals (LCP, FID, CLS)
- 60fps animation target
- 3s page load target
- Mobile-first responsive design

### Project Standards
- AGENTS.md - Verification requirements
- Document Style Guide - Documentation standards
- Browser support matrix (if defined)

---

## 13. 🚦 VERIFICATION CHECKLIST

**Before claiming any work complete, verify**:

```markdown
BROWSER TESTING:
□ Opened actual browser (not just code review)
□ Tested in Chrome (minimum requirement)
□ Tested in Firefox (if time permits)
□ Tested in Safari (if macOS available)

VIEWPORT TESTING:
□ Tested at mobile viewport (375px minimum)
□ Tested at tablet viewport (768px)
□ Tested at desktop viewport (1920px)
□ Verified responsive transitions smooth

FUNCTIONALITY:
□ Tested actual user interactions (clicks, hovers, etc.)
□ Watched full animation cycle if animations present
□ Verified form submissions if forms present
□ Tested video/media playback if media present

CONSOLE/ERRORS:
□ DevTools console checked - no errors
□ DevTools console checked - no warnings (or documented if expected)
□ Network tab checked - no failed requests

DOCUMENTATION:
□ Noted what was tested in claim statement
□ Documented any browser-specific behaviors
□ Noted any limitations or remaining work
□ Included viewport sizes tested

EVIDENCE:
□ Can describe exactly what was seen
□ Can state timing/behavior observed
□ Can confirm expected vs. actual behavior matched
```

**If you cannot check ALL boxes, your claim is premature. Verify first, claim second.**
