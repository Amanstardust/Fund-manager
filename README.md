# AnalystOS — Zero-Cost SaaS MVP

A premium 4-semester Data Analyst career operating system built as a deployable, no-investment SaaS-style MVP.

## What this MVP includes

- Premium responsive web app UI
- 4-semester 12-month Data Analyst roadmap
- 52-week execution calendar
- Progress tracking
- Project tracker
- Weak-area detection
- Practice/GPA logic
- Career hub
- Job application tracker
- Database schema blueprint
- Local browser persistence using `localStorage`

## Why this version is zero-cost

This first version does not require a paid backend, database, server, or payment gateway. It runs as a static web app and can be deployed for free.

Best free deployment options:

1. **Netlify Free** — easiest for one HTML file
2. **Vercel Free** — good if you later upgrade to Next.js
3. **GitHub Pages Free** — completely free static hosting
4. **Cloudflare Pages Free** — fast global static hosting

## Fastest free deployment: Netlify Drop

1. Go to https://app.netlify.com/drop
2. Drag and drop this project folder or only `index.html`
3. Netlify gives you a free live URL
4. Rename the site from Netlify dashboard if needed

No credit card is required for basic static deployment.

## Free deployment with GitHub Pages

1. Create a GitHub account
2. Create a new public repository, for example `analystos`
3. Upload `index.html`, `README.md`, and optional files
4. Go to repository `Settings` → `Pages`
5. Under source, select `Deploy from branch`
6. Select `main` branch and `/root`
7. Your app will be live at:

```txt
https://your-username.github.io/analystos/
```

## Free deployment with Vercel

1. Push this folder to GitHub
2. Go to https://vercel.com
3. Import your GitHub repository
4. Framework preset: `Other`
5. Deploy

## Important limitation of this zero-cost MVP

This MVP stores user progress in the user's browser. That means:

- No account login yet
- Progress is saved only on the same browser/device
- Clearing browser data can delete progress
- Users cannot sync across devices yet

This is perfect for validation, demos, landing page traffic, and early users without spending money.

## Recommended SaaS growth path with no upfront investment

### Phase 1 — Free Static MVP

Use this current version.

Goal:

- Validate interest
- Collect feedback
- Share with students/job seekers
- Build waitlist
- Improve roadmap and UI

Cost: ₹0

### Phase 2 — Free Backend MVP

Add Supabase free tier.

Add:

- Login/signup
- Cloud progress sync
- User profiles
- Job application sync
- Project tracker sync

Cost: ₹0 on free tier until usage grows.

### Phase 3 — Revenue Before Paid Infrastructure

Start monetizing only after people want it.

Possible paid offers:

- Resume review
- Project review
- Mock interview pack
- Premium templates
- AI mentor add-on
- Cohort/community access

Use Razorpay Payment Links or Gumroad/Lemon Squeezy before building full payment automation.

Cost: Mostly ₹0 until revenue starts.

## Suggested product positioning

> AnalystOS is a career operating system for becoming a job-ready Data Analyst through structured learning, smart revision, portfolio building, and placement tracking.

## Suggested domain later

Only buy a domain after validation. Until then, use free URLs.

Possible future domains:

- analystos.in
- dataanalystos.com
- analysttrack.in
- datacareeros.com

## Future upgrade files

- `supabase_schema.sql` — database structure for the free backend version
- `deploy-guide.md` — step-by-step free deployment plan

## Current entry file

Open or deploy:

```txt
index.html
```
