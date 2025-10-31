---
name: rapid-prototyping
description: This skill should be used when building MVPs, proofs-of-concept, or products within tight timelines (6-day cycles) - optimizes for speed while maintaining quality through strategic decisions about building vs using pre-built components, scope management, and quality gates that don't slow momentum.
---

# Rapid Prototyping

## Overview

Build functional products fast without sacrificing quality. This skill teaches systematic approaches to rapid development cycles, helping ship working software in days, not weeks.

**Core principle:** Speed comes from smart decisions about what NOT to build, not from cutting corners.

## When to Use

**Use this skill when:**
- Building MVPs or proofs-of-concept
- Working within 6-day development cycles
- Need to validate ideas quickly
- Prototyping before committing to full build
- Converting rough concepts into working software
- Time pressure requires strategic scope decisions

**Don't use for:**
- Mature products with established codebases
- Projects where performance/scale is primary concern
- Compliance-heavy or highly regulated domains (unless prototyping approach)

## The Rapid Prototyping Framework

### Phase 1: Ruthless Scoping (30 minutes)

**Goal:** Define the absolute minimum to prove the concept

#### Build vs Buy vs Integrate Decision

```
For EACH feature, ask:

1. Can I use an existing block/template?
   YES → shadcnblocks.com (829 blocks), templates, boilerplate

2. Can I integrate a service instead of building?
   YES → Supabase (auth/db), Clerk (auth), Stripe (payments), etc.

3. Must I build custom?
   YES → Add to scope, but use frameworks/libraries
   NO → Stop. Don't build it.
```

#### The 3-Feature Rule

**Core features only:**
1. Primary value proposition
2. One delighter/differentiator
3. Basic functionality to make #1 work

Everything else is post-MVP.

#### Scope Questions

- "What's the ONE thing this has to do?"
- "Can we fake this for now?" (Wizard of Oz testing)
- "Will users care about this on day 1?"
- "Can this be a manual process initially?"

**Output:** Clear list of 3-5 features max

### Phase 2: Tech Stack Selection (15 minutes)

**Proven fast stacks:**

#### Frontend - Go-to Stack
```typescript
Next.js 14+ (App Router)
+ TypeScript
+ Tailwind CSS
+ shadcn/ui (pre-built components)
+ shadcnblocks.com (829 ready sections)
```

**Why:** Hot reload, TypeScript safety, massive component library

#### Backend - Choose Based on Complexity

**Simple (CRUD, auth, basic logic):**
```
Supabase (Postgres + Auth + Realtime + Storage)
OR
Firebase (if real-time is critical)
```

**Medium (custom business logic):**
```
Next.js API Routes
OR
tRPC (type-safe APIs)
```

**Complex (heavy processing, background jobs):**
```
Node.js + Express/Fastify
OR
Python + FastAPI
```

#### Database Selection

| Use Case | Choose | Why |
|----------|--------|-----|
| Standard CRUD | Supabase (Postgres) | Managed, auth included, fast setup |
| Real-time data | Firebase Firestore | Native real-time, scales automatically |
| Document-heavy | MongoDB Atlas | Flexible schema, free tier |
| Analytics/reporting | Postgres + Prisma | Complex queries, data integrity |

#### Authentication - Don't Build It

| Provider | Use When |
|----------|----------|
| Supabase Auth | Already using Supabase |
| Clerk | Need beautiful pre-built components |
| Auth0 | Enterprise features needed |
| NextAuth.js | Maximum customization required |

**Never build auth from scratch in rapid prototyping.**

### Phase 3: Component Strategy (ongoing)

#### shadcnblocks.com First

**Before building ANY UI section, check shadcnblocks.com:**

```
Hero section needed?
  → shadcnblocks.com/blocks/hero (162 options)
  → Copy, customize, done in 10 minutes

Pricing page?
  → shadcnblocks.com/blocks/pricing (35 options)
  → Copy, adjust numbers, done

Testimonials?
  → shadcnblocks.com/blocks/testimonial (28 options)
  → Copy, plug in quotes, done
```

**Time saved:** Hours → Minutes per section

#### shadcn/ui Component Pattern

```typescript
// WRONG: Building from scratch
const MyButton = () => {
  // 50 lines of custom code
}

// RIGHT: Use shadcn/ui
import { Button } from "@/components/ui/button"

<Button variant="default">Click me</Button>
// Accessible, tested, done
```

#### The Component Decision Tree

```
Need UI component?
├─ Common pattern? (button, form, dialog, etc.)
│  └─ npx shadcn@latest add [component]
│
├─ Full section? (hero, pricing, features)
│  └─ shadcnblocks.com → copy → customize
│
└─ Truly unique?
   └─ Build with Tailwind + shadcn primitives
```

### Phase 4: Quality Gates That Don't Slow You Down

#### Must-Have Quality (non-negotiable)

- **TypeScript** - Catches bugs at compile time
- **Core user flow works** - Happy path functional
- **Data persists** - Not losing user work
- **Deploys successfully** - Actually accessible

#### Can-Wait Quality (post-MVP)

- **Edge case handling** - "What if user does X weird thing?"
- **Perfect responsive design** - Desktop works, mobile "good enough"
- **Comprehensive error messages** - Basic errors covered
- **Performance optimization** - Fast enough, not perfect
- **Extensive testing** - Happy path tested, edge cases later

#### The 80/20 Rule for Prototypes

**Spend time on:**
- Core feature functionality (80% of value)
- First-time user experience
- Data that can't be faked

**Don't spend time on:**
- Admin dashboards (build post-launch)
- Analytics (add after validation)
- Edge cases (handle when encountered)
- Perfect UX (good UX is enough)

### Phase 5: Development Velocity Patterns

#### Use Generators and Boilerplate

```bash
# Next.js with TypeScript, Tailwind, shadcn
npx create-next-app@latest my-app \
  --typescript --tailwind --app

cd my-app

# Initialize shadcn/ui
npx shadcn@latest init

# Add common components
npx shadcn@latest add button card dialog form input \
  toast table dropdown-menu
```

**Time saved:** 2 hours of configuration

#### API Development Pattern (Fast)

```typescript
// app/api/items/route.ts
import { NextRequest, NextResponse } from 'next/server'

export async function GET(request: NextRequest) {
  // Get from DB
  const items = await db.items.findMany()
  return NextResponse.json(items)
}

export async function POST(request: NextRequest) {
  const data = await request.json()
  // Validate with Zod
  // Save to DB
  const item = await db.items.create({ data })
  return NextResponse.json(item)
}
```

**Speed trick:** Start with Next.js API routes, move to separate backend only if needed

#### Database Pattern (Fast)

```typescript
// Use Prisma for type-safe database access
// schema.prisma
model User {
  id        String   @id @default(cuid())
  email     String   @unique
  name      String?
  createdAt DateTime @default(now())
}

// Generate types + client
// npx prisma generate
// npx prisma db push

// Usage - fully typed!
const user = await prisma.user.create({
  data: { email, name }
})
```

**Speed trick:** Prisma generates TypeScript types from schema

### Phase 6: Deployment Speed Runs

#### Fastest: Vercel (for Next.js)

```bash
# 1. Push to GitHub
git init && git add . && git commit -m "Initial"
gh repo create --public --push

# 2. Deploy via CLI
npm i -g vercel
vercel

# Done in <5 minutes
```

#### Fast: Fly.io (for any app)

```bash
# 1. Install flyctl
curl -L https://fly.io/install.sh | sh

# 2. Launch (creates fly.toml)
fly launch

# 3. Deploy
fly deploy

# Done in <10 minutes
```

#### Moderate: Hostinger VPS (for full control)

```bash
# Already have VPS access
ssh root@your-vps-ip

# Clone and run with docker-compose
git clone your-repo
cd your-repo
docker-compose up -d

# Done in <15 minutes (if docker-compose.yml ready)
```

**Strategy:** Start with Vercel/Fly.io for speed, move to VPS if needed

## Common Rapid Prototyping Patterns

### Pattern 1: The Landing Page MVP

**Goal:** Validate idea before building

**Stack:**
- Next.js
- shadcnblocks.com hero + features + pricing + CTA
- Email capture (Supabase or simple API)
- Deploy to Vercel

**Time:** 2-4 hours

### Pattern 2: The CRUD Dashboard

**Goal:** Internal tool or simple SaaS

**Stack:**
- Next.js + TypeScript
- Supabase (auth + database + realtime)
- shadcn/ui table + form + dialog components
- Deploy to Vercel

**Time:** 1-2 days

### Pattern 3: The AI-Powered Tool

**Goal:** Wrapper around AI API

**Stack:**
- Next.js API routes
- Claude API or OpenAI
- shadcn/ui for interface
- Supabase for data persistence
- Deploy to Vercel

**Time:** 2-3 days

### Pattern 4: The Mobile-First Web App

**Goal:** App-like experience

**Stack:**
- Next.js PWA
- Tailwind CSS (mobile-first)
- shadcnblocks.com mobile-optimized blocks
- Supabase for backend
- Deploy to Vercel

**Time:** 3-4 days

## Decision Frameworks

### Build vs Integrate Decision Matrix

| Feature | Build If... | Integrate If... |
|---------|------------|-----------------|
| Authentication | Never | Always (Supabase/Clerk/Auth0) |
| Payments | Unique flow required | Standard checkout (Stripe) |
| Email sending | Never | Always (Resend/SendGrid) |
| File storage | Never for MVP | Always (Supabase Storage/S3) |
| Search | Simple filter | Complex (Algolia/Typesense) |
| Analytics | Custom metrics needed | Standard metrics (PostHog/Plausible) |
| Forms | Custom validation | Standard forms (Tally/Typeform) |

### Database Selection Matrix

| Need | Use | Why |
|------|-----|-----|
| Relational data, complex queries | Postgres (Supabase) | ACID, joins, constraints |
| Real-time updates, collaborative | Firebase/Supabase | Built-in real-time |
| Document-based, flexible schema | MongoDB | Rapid schema evolution |
| Time-series data | TimescaleDB/InfluxDB | Optimized for time data |
| Graph relationships | Neo4j (later) | Start with Postgres |

### When to Stop Prototyping and Rebuild

**Stop and rebuild when:**
- Technical debt blocking new features
- Performance issues affecting UX
- Security concerns for production
- Scaling becomes expensive/impossible
- Code is "unfixable" due to hacks

**Keep iterating when:**
- Users are happy with core functionality
- Performance is "good enough"
- You can add features without major refactoring
- Deployment is still easy

## Speed Killers to Avoid

### 1. Perfect Design Before Code

❌ **Slow:** Design every screen in Figma before coding
✅ **Fast:** Use shadcnblocks.com + customize as you code

### 2. Custom Authentication

❌ **Slow:** Build auth from scratch (1-2 weeks)
✅ **Fast:** Supabase Auth or Clerk (1-2 hours)

### 3. Over-Engineering Database

❌ **Slow:** Perfect normalized schema upfront
✅ **Fast:** Start simple, refactor when needed

### 4. Premature Optimization

❌ **Slow:** Optimize before knowing bottlenecks
✅ **Fast:** Build, measure, then optimize

### 5. Building Admin Tools Early

❌ **Slow:** Admin dashboard before user-facing features
✅ **Fast:** Use database GUI, build admin later

### 6. Custom Components for Everything

❌ **Slow:** Build every button, form, modal from scratch
✅ **Fast:** shadcn/ui + customize as needed

## Quality Checklist for Prototypes

**Before showing to users:**
- [ ] Core user flow works end-to-end
- [ ] Data persists correctly
- [ ] Basic error handling (doesn't crash)
- [ ] TypeScript compiles without errors
- [ ] Deploys successfully
- [ ] Works on mobile (basic responsiveness)
- [ ] Looks professional (shadcnblocks helps here)

**Can ship without:**
- [ ] Perfect error messages
- [ ] Edge case handling
- [ ] Admin dashboards
- [ ] Analytics
- [ ] Perfect performance
- [ ] Comprehensive tests
- [ ] SEO optimization
- [ ] Perfect accessibility (good enough is okay)

## Resources

**Component Libraries:**
- shadcn/ui: https://ui.shadcn.com
- shadcnblocks.com: https://www.shadcnblocks.com/blocks (829 blocks)

**Backend Services:**
- Supabase: https://supabase.com
- Firebase: https://firebase.google.com
- Clerk: https://clerk.com

**Deployment:**
- Vercel: https://vercel.com
- Fly.io: https://fly.io
- Hostinger VPS: (your existing setup)

**Boilerplates:**
- create-next-app: Standard Next.js starter
- create-t3-app: Next.js + tRPC + Prisma + Auth

## Time Estimates (Solo Developer)

| Project Type | Prototype Time | With This Skill |
|--------------|---------------|-----------------|
| Landing page | 1 day | 4 hours |
| CRUD app | 1 week | 2 days |
| AI tool | 2 weeks | 3 days |
| SaaS MVP | 1 month | 1 week |
| Mobile web app | 3 weeks | 5 days |

**Key multiplier:** Using pre-built components and managed services

## Final Principles

1. **Ship fast, iterate faster** - Perfect is the enemy of done
2. **Use what exists** - 90% of features already have solutions
3. **TypeScript always** - Bugs caught at compile time save hours of debugging
4. **Mobile-first** - Easier to scale up than down
5. **Managed services** - Your time is more valuable than $20/month
6. **Measure before optimizing** - Fast enough beats perfectly fast
7. **User feedback > perfect code** - Real users find real problems

Success in rapid prototyping comes from knowing what NOT to build. Every feature you don't build is time saved for the features that matter.
