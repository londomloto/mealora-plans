# Mealora — Product & Technical Assessment

> Status: Draft baseline for implementation with ChatGPT Codex  
> Date: 2026-11-03  
> Product codename/name: **Mealora**  
> MVP strategy: **Local-first, offline-first, no mandatory account, no backend required**

---

## 1. Executive Summary

Mealora is a mobile nutrition companion focused on helping users understand and record daily calorie and nutrition intake with as little friction as possible.

The initial MVP will be built as a **fully local Flutter application**. Core calculations, food logging, nutrition targets, weight tracking, and analytics will run on-device. Structured data will be stored in **SQLite**, preferably through **Drift**.

The MVP intentionally does **not** require a backend, cloud database, login, subscription system, or AI food recognition. This keeps development cost and infrastructure cost close to zero while validating whether the core product is useful.

However, the local architecture must be designed from day one so that a later version can add optional cloud synchronization, multi-device login, AI-assisted food input, barcode scanning, and a Go backend without rewriting the core application.

The intended evolution is:

```text
MVP 1 — LOCAL FIRST
Flutter
   ↓
Domain / Nutrition Engine
   ↓
Repository
   ↓
Drift
   ↓
SQLite

          ↓ future evolution ↓

MVP 2+ — LOCAL FIRST + CLOUD SYNC
Flutter
   ↓
SQLite ←→ Sync Engine ←→ Go API
                         ↓
                     PostgreSQL
                     Supabase
```

---

# 2. Product Vision

Mealora should not feel like a spreadsheet for calories.

The product should answer three simple questions:

1. **How much energy/nutrition do I approximately need today?**
2. **What have I eaten today?**
3. **How am I progressing toward my goal?**

Long-term, Mealora can evolve from a calorie tracker into a personal nutrition companion capable of understanding natural-language meal descriptions, food photos, barcodes, eating patterns, weight trends, and personalized nutrition insights.

### Proposed positioning

**Mealora — Your daily nutrition companion.**

Alternative tagline:

**Know what you eat. Understand your day.**

The product should avoid presenting calorie estimates as medical diagnoses or exact physiological measurements. Calculations are estimates and should be communicated as such.

---

# 3. Product Principles

## 3.1 Local-first

The device database is the source of truth for MVP 1.

Users must be able to:

- open the application without internet;
- complete onboarding offline;
- calculate calorie targets offline;
- search locally available foods;
- log meals offline;
- edit/delete logs offline;
- view today's nutrition summary offline;
- track body weight offline;
- view historical summaries offline.

No core MVP feature should require an internet connection.

## 3.2 No mandatory account

The first launch should not force users to create an account.

Target onboarding:

```text
Install Mealora
      ↓
Welcome
      ↓
Personal Profile
      ↓
Goal
      ↓
Activity Level
      ↓
Calculated Daily Target
      ↓
Dashboard
```

Cloud account creation will become optional when Backup & Sync is introduced.

## 3.3 Privacy by default

For MVP 1, personal nutrition and weight data stays on the user's device.

Future cloud synchronization must be opt-in.

## 3.4 Estimates, not medical claims

Energy expenditure formulas and food calorie values are estimates.

The UI should use language such as:

- Estimated daily target
- Estimated calories
- Approximate serving

Avoid language implying diagnosis or guaranteed weight outcomes.

## 3.5 Low-friction logging

Logging food must require as few interactions as practical.

Future versions should progressively reduce input friction through recent foods, favorites, barcode scanning, natural-language entry, and AI photo analysis.

---

# 4. Target Users

Initial target:

- adults who want simple calorie awareness;
- users trying to maintain, lose, or gain weight;
- users who dislike complicated fitness applications;
- users who want offline/private tracking;
- Indonesian users should be well supported, particularly with common Indonesian foods.

The MVP is not intended as a clinical nutrition management system.

Special populations or users with medical conditions may require professional nutritional guidance and should not receive aggressive automated calorie recommendations.

---

# 5. Core User Journey

```text
FIRST INSTALL

Welcome
   ↓
Profile Setup
   ├─ Age / birth date
   ├─ Biological input required by selected energy equation
   ├─ Height
   └─ Weight
   ↓
Activity Level
   ↓
Goal
   ├─ Lose weight
   ├─ Maintain weight
   └─ Gain weight
   ↓
Nutrition Engine
   ├─ Estimate resting energy requirement
   ├─ Estimate daily energy expenditure
   └─ Determine daily calorie target
   ↓
Dashboard
```

Daily journey:

```text
Dashboard
   ↓
+ Log Meal
   ↓
Breakfast / Lunch / Dinner / Snack
   ↓
Search Food
   ↓
Select Food
   ↓
Choose Serving / Quantity
   ↓
Review Nutrition
   ↓
Save
   ↓
Dashboard recalculates totals
```

---

# 6. MVP 1 — MUST HAVE

This section defines the actual first releasable product.

## 6.1 Onboarding

Collect only information required for calculations and personalization.

Candidate fields:

- display name (optional);
- date of birth or age;
- height;
- current weight;
- biological input required by the chosen BMR/REE equation;
- activity level;
- goal: lose / maintain / gain;
- optional target weight.

The application calculates an estimated daily calorie target after onboarding.

## 6.2 Nutrition / Calorie Engine

The nutrition engine must be isolated from Flutter widgets and persistence.

Responsibilities:

```text
estimateRestingEnergy()
estimateDailyEnergyExpenditure()
calculateDailyCalorieTarget()
calculateMacroTargets()
```

Initial candidate equation: **Mifflin–St Jeor** for resting energy expenditure.

Do not hard-code scientific rules directly inside UI widgets.

All constants, activity multipliers, minimum safeguards, and goal adjustments should be centralized and documented.

Before production release, the exact target-calorie policy and safety limits must receive a dedicated nutrition-domain review.

## 6.3 Dashboard

Minimum dashboard:

```text
Mealora

Today

1,420 / 2,100 kcal
█████████████░░░░

Remaining
680 kcal

Protein     72 / 110 g
Carbs      180 / 250 g
Fat         48 / 70 g

Breakfast        420 kcal
Lunch            650 kcal
Snack            150 kcal
Dinner            200 kcal

[ + Log Meal ]
```

Dashboard requirements:

- target calories;
- consumed calories;
- remaining calories;
- macro progress;
- meal grouping;
- quick action to log food.

## 6.4 Food Database

The application needs a local food catalog.

Each food should ideally support:

```text
name
brand (optional)
category
serving description
serving amount
serving unit
calories
protein
carbohydrate
fat
fiber (optional MVP)
sugar (optional)
sodium (optional)
source/reference metadata
```

The MVP database should include common foods, with deliberate coverage of Indonesian foods.

Nutrition values should eventually come from credible food-composition sources. Avoid inventing nutritional values.

## 6.5 Food Search

Users can search the local database.

Example:

```text
Search: "nasi"

Nasi putih
Nasi merah
Nasi goreng
Nasi uduk
...
```

Requirements:

- case-insensitive search;
- reasonable response time offline;
- results show food name and serving;
- allow quantity adjustment before saving.

## 6.6 Custom Food

Users can create food that is not available in the catalog.

Minimum fields:

- name;
- serving size;
- calories;
- protein;
- carbs;
- fat.

## 6.7 Meal Logging / Food Diary

Meal types:

```text
BREAKFAST
LUNCH
DINNER
SNACK
```

User can:

- add food;
- select serving;
- change quantity;
- edit entry;
- delete entry;
- move/correct meal type;
- view daily history.

## 6.8 Recent Foods

Foods recently logged should appear before a full search.

This is an important UX optimization and should be included in MVP if implementation cost remains small.

## 6.9 Favorite Foods

User can favorite frequently eaten foods.

Possible UI:

```text
Add Food

Recent
  Nasi putih
  Telur rebus
  Ayam bakar

Favorites
  ★ Kopi susu
  ★ Oatmeal
```

## 6.10 Weight Tracking

Users can record body weight by date.

Minimum capabilities:

- add weight;
- edit/delete weight;
- see latest weight;
- simple history/chart;
- compare against starting weight and optional target weight.

## 6.11 History

User can select previous dates and see:

- calorie consumption;
- macro totals;
- meals;
- weight when available.

## 6.12 Settings

Initial settings:

- metric units;
- update profile;
- update activity level;
- update goal;
- recalculate target;
- app information;
- delete/reset local data.

---

# 7. MVP 1 — SHOULD HAVE

Implement after the essential flow is stable:

- favorite foods;
- recent meals;
- duplicate previous meal;
- reusable meal templates;
- water tracking;
- simple weekly summary;
- streaks;
- nutrition score;
- basic local reminders.

Do not delay the first working MVP merely to implement these.

---

# 8. Explicitly NOT in MVP 1

Do not implement initially:

- user registration;
- Google login;
- Apple login;
- cloud synchronization;
- backend API;
- Supabase integration;
- Go backend;
- AI photo recognition;
- AI recommendations;
- natural-language AI parsing;
- barcode scanning;
- subscriptions/payment;
- social/community features;
- smartwatch integrations;
- Apple Health / Health Connect;
- microservices;
- Kubernetes.

These belong to later milestones.

---

# 9. Recommended MVP Technology Stack

## Mobile

```text
Flutter / Dart
```

Targets initially:

```text
Android
+ iOS-ready architecture
```

Android can be prioritized during development if only one physical testing device/platform is available.

## Local database

Recommended:

```text
SQLite
  ↑
Drift
```

Drift provides a type-safe persistence layer, migrations, transactions, and reactive queries over SQLite.

## State management

Select one predictable solution and use it consistently.

Recommended candidate:

```text
Riverpod
```

Do not mix several state-management architectures without a concrete reason.

## IDs

Do NOT use database auto-increment IDs as domain identifiers.

Use globally unique identifiers, preferably:

```text
UUID v7
```

or UUID v4 if library/platform support makes it simpler.

This prepares records for future multi-device synchronization.

---

# 10. Proposed Flutter Architecture

Use feature-oriented clean boundaries without overengineering.

```text
lib/
│
├── app/
│   ├── app.dart
│   ├── router.dart
│   └── theme/
│
├── core/
│   ├── constants/
│   ├── errors/
│   ├── extensions/
│   ├── utils/
│   └── units/
│
├── database/
│   ├── app_database.dart
│   ├── tables/
│   ├── daos/
│   └── migrations/
│
├── domain/
│   ├── nutrition/
│   │   ├── entities/
│   │   ├── services/
│   │   └── value_objects/
│   ├── food/
│   ├── meal/
│   ├── profile/
│   └── weight/
│
├── data/
│   ├── repositories/
│   ├── local/
│   └── mappers/
│
├── features/
│   ├── onboarding/
│   ├── dashboard/
│   ├── food_search/
│   ├── meal_log/
│   ├── history/
│   ├── weight/
│   └── settings/
│
└── main.dart
```

Important dependency rule:

```text
UI
 ↓
Application / State
 ↓
Domain
 ↓
Repository interface

Data layer implements repository interface
 ↓
Drift / SQLite
```

The nutrition domain must not import Flutter UI packages or know how SQLite works.

---

# 11. Proposed Local Database Model

The schema below is a starting point and should be refined during implementation.

## profiles

```text
id UUID PK
name TEXT NULL
birth_date DATE NULL
age INTEGER NULL
sex_for_equation TEXT
height_cm REAL
current_weight_kg REAL
activity_level TEXT
goal_type TEXT
target_weight_kg REAL NULL
created_at DATETIME
updated_at DATETIME
```

MVP supports one active local profile, but retaining an ID makes future cloud migration easier.

## nutrition_goals

```text
id UUID PK
profile_id UUID
estimated_bmr REAL
estimated_tdee REAL
daily_calorie_target REAL
protein_target_g REAL
carb_target_g REAL
fat_target_g REAL
calculation_method TEXT
created_at DATETIME
updated_at DATETIME
```

Store the calculated result and method so historical behavior is explainable when algorithms change.

## foods

```text
id UUID PK
name TEXT
brand TEXT NULL
category TEXT NULL
is_custom BOOLEAN
source TEXT NULL
created_at DATETIME
updated_at DATETIME
```

## food_servings

```text
id UUID PK
food_id UUID
label TEXT
amount REAL
unit TEXT
gram_weight REAL NULL
is_default BOOLEAN
```

## food_nutrients

For MVP a wide table is acceptable:

```text
food_id UUID
serving_id UUID
calories REAL
protein_g REAL
carbs_g REAL
fat_g REAL
fiber_g REAL NULL
sugar_g REAL NULL
sodium_mg REAL NULL
```

A generalized nutrient model can be considered later if micronutrient coverage becomes a product requirement.

## meal_entries

```text
id UUID PK
profile_id UUID
entry_date DATE
meal_type TEXT
created_at DATETIME
updated_at DATETIME
deleted_at DATETIME NULL
sync_status TEXT DEFAULT 'local'
```

## meal_items

```text
id UUID PK
meal_entry_id UUID
food_id UUID
serving_id UUID NULL
quantity REAL

food_name_snapshot TEXT
serving_label_snapshot TEXT
calories_snapshot REAL
protein_snapshot_g REAL
carbs_snapshot_g REAL
fat_snapshot_g REAL

created_at DATETIME
updated_at DATETIME
deleted_at DATETIME NULL
sync_status TEXT DEFAULT 'local'
```

### Why nutrition snapshots?

If a food's nutritional data changes later, a meal logged six months ago should not unexpectedly change its historical calorie total.

Therefore meal items should retain the nutritional values used when the food was logged.

## weight_logs

```text
id UUID PK
profile_id UUID
recorded_at DATETIME
weight_kg REAL
note TEXT NULL
created_at DATETIME
updated_at DATETIME
deleted_at DATETIME NULL
sync_status TEXT DEFAULT 'local'
```

## favorite_foods

```text
id UUID PK
profile_id UUID
food_id UUID
created_at DATETIME
```

---

# 12. Future Sync Readiness

Even though MVP 1 has no cloud, write local records as though synchronization may exist later.

Recommended metadata on user-generated records:

```text
id
created_at
updated_at
deleted_at
sync_status
```

Possible future states:

```text
LOCAL
PENDING
SYNCING
SYNCED
CONFLICT
FAILED
```

MVP 1 only needs `LOCAL`, but the repository/domain should not depend heavily on that implementation detail.

Use soft deletion for entities expected to synchronize later so a deletion can eventually propagate to other devices.

Do NOT build the actual sync engine in MVP 1.

---

# 13. Nutrition Calculation Assessment

Energy needs cannot be known exactly from a simple questionnaire. Mealora therefore provides an estimate.

Initial conceptual flow:

```text
User profile
     ↓
Resting Energy Estimate
     ↓
Activity adjustment
     ↓
Estimated Total Daily Energy Expenditure
     ↓
Goal adjustment
     ↓
Estimated Daily Calorie Target
```

Mifflin–St Jeor is the initial candidate for resting energy estimation.

Typical equation form:

```text
Male:
10 × weight(kg)
+ 6.25 × height(cm)
- 5 × age(years)
+ 5

Female:
10 × weight(kg)
+ 6.25 × height(cm)
- 5 × age(years)
- 161
```

This should live in a dedicated domain service such as:

```text
NutritionCalculator
```

Example API concept:

```dart
abstract interface class EnergyCalculator {
  EnergyEstimate calculate(Profile profile);
}
```

Result concept:

```text
EnergyEstimate
├── restingEnergy
├── totalDailyEnergy
├── calorieTarget
├── proteinTarget
├── carbTarget
├── fatTarget
└── calculationMethod
```

### Important safety requirement

Do not implement arbitrary aggressive deficits/surpluses simply because a user enters an extreme target.

Before production, define evidence-based guardrails for:

- calorie deficit;
- calorie surplus;
- minimum recommended intake handling;
- rate-of-weight-change goals;
- age restrictions;
- pregnancy/breastfeeding handling;
- conditions where the app should decline automatic recommendations.

This is a **production-readiness requirement**, not something Codex should invent.

---

# 14. Daily Calculation Logic

Conceptually:

```text
Daily Target = 2,100 kcal

Breakfast = 420
Lunch     = 650
Snack     = 150
Dinner    = 200
-----------------
Consumed  = 1,420
Remaining = 680
```

Formula:

```text
consumedCalories = SUM(meal_items.calories_snapshot × quantity)

remainingCalories =
    dailyCalorieTarget - consumedCalories
```

Macro totals follow the same pattern.

Do not persist values that can trivially and safely be derived unless caching becomes necessary. Historical target values may be snapshotted when needed so past summaries remain stable after a user's goal changes.

---

# 15. UX / Screen Inventory for MVP

Minimum screens:

```text
01 Splash
02 Welcome
03 Profile Setup
04 Activity Level
05 Goal Selection
06 Target Result
07 Dashboard
08 Add Food
09 Food Search
10 Food Detail / Serving
11 Meal Detail
12 History / Calendar
13 Weight Tracker
14 Add Weight
15 Settings
16 Edit Profile / Goal
17 Custom Food
```

Potential bottom navigation:

```text
Today | History | Weight | Profile
```

Primary CTA:

```text
+ Log Meal
```

---

# 16. Suggested Dashboard UX

```text
┌─────────────────────────────┐
│ Mealora                     │
│ Good morning 👋             │
│                             │
│ TODAY                       │
│                             │
│       1,420 / 2,100         │
│           kcal              │
│     ███████████░░░░         │
│                             │
│       680 remaining         │
│                             │
│ Protein   72 / 110 g        │
│ Carbs    180 / 250 g        │
│ Fat       48 / 70 g         │
│                             │
│ Breakfast          420      │
│ Lunch              650      │
│ Snack              150      │
│ Dinner             200      │
│                             │
│       + Log Meal            │
│                             │
│ Today History Weight Profile│
└─────────────────────────────┘
```

Visual direction:

- clean;
- calm;
- modern;
- health-oriented without looking clinical;
- generous spacing;
- clear typography;
- calorie progress visually prominent;
- macro information secondary;
- avoid excessive gamification in MVP.

---

# 17. Food Input Evolution

The long-term objective is to make logging progressively easier.

## Level 1 — MVP

```text
Search food
   ↓
Choose serving
   ↓
Save
```

## Level 2

```text
Recent / Favorite / Meal Template
   ↓
One tap
```

## Level 3

Barcode:

```text
Scan barcode
   ↓
Product lookup
   ↓
Nutrition
   ↓
Confirm
```

## Level 4

Natural language:

```text
"Tadi makan nasi satu piring,
ayam bakar satu dan tempe dua."
             ↓
       Food Parser / AI
             ↓
Nasi putih     1 serving
Ayam bakar     1 piece
Tempe          2 pieces
             ↓
           Confirm
```

## Level 5

Photo recognition:

```text
Camera
  ↓
Food Image
  ↓
AI Vision
  ↓
Detected foods
  ↓
Estimated portions
  ↓
Nutrition matching
  ↓
User confirmation
```

AI results must always be presented as estimates and remain editable before logging.

---

# 18. MVP 2 — Optional Cloud / Multi-device

This is explicitly **NOT MVP 1**, but must remain documented.

Goal:

> Allow users to optionally create an account, back up their local data, and use Mealora across multiple devices.

Proposed architecture:

```text
                  Flutter
                     │
                     │ local reads/writes
                     ▼
                  SQLite
                     │
                Sync Engine
                     │
                     ▼
                  Go API
                     │
          ┌──────────┴──────────┐
          ▼                     ▼
   Supabase PostgreSQL    Supabase Storage
          ▲
          │
     Supabase Auth
 Google / Apple / Email
```

Important principle:

**SQLite remains useful even after cloud is introduced.**

The cloud is synchronization/backup, not a reason to make the app unusable offline.

---

# 19. Online Infrastructure Assessment

## Supabase

Potential responsibilities:

```text
Supabase
├── PostgreSQL
├── Authentication
│   ├── Google
│   ├── Apple
│   └── Email
└── Object Storage
```

Advantages:

- managed PostgreSQL;
- managed authentication;
- social login support;
- object storage;
- reduced DevOps;
- PostgreSQL data remains relatively portable.

Risks:

- vendor coupling increases if application logic is placed in Supabase-specific features everywhere;
- RLS/auth/storage design requires care;
- cloud cost grows with usage;
- synchronization introduces conflict-resolution complexity.

Decision:

**Do not use Supabase for MVP 1. Keep it as the preferred candidate for MVP 2 cloud infrastructure.**

## Backend language

Options assessed:

```text
Spring Boot
Go
Rust
```

Preferred future backend:

**Go**

Reasons:

- small runtime footprint;
- simple deployment;
- strong HTTP/network ecosystem;
- good PostgreSQL ecosystem;
- suitable for a modular monolith;
- no need for Rust-level complexity for this workload.

Potential future stack:

```text
Go
├── chi or Gin
├── pgx
├── sqlc
├── migrations
├── JWT validation
└── OpenTelemetry
```

Start as a **modular monolith**, not microservices.

Potential modules:

```text
internal/
├── auth/
├── users/
├── foods/
├── nutrition/
├── meals/
├── goals/
├── weight/
├── sync/
├── insights/
└── ai/
```

---

# 20. Future Cloud Hosting Assessment

Preferred Go deployment candidate:

```text
Google Cloud Run
```

Alternative:

```text
Railway
```

Cloud Run is attractive because a stateless Go API can scale based on demand without the team maintaining a VM/server.

Future architecture:

```text
Flutter
   ↓
Local SQLite
   ↓ sync
Go API / Cloud Run
   ↓
Supabase PostgreSQL
```

No Kubernetes should be introduced unless future scale/operational requirements actually justify it.

---

# 21. Authentication & Multi-device Assessment

No authentication in MVP 1.

For MVP 2:

```text
Settings
   ↓
Backup & Sync
   ↓
"Sign in to sync your Mealora data"

[ Continue with Google ]
[ Continue with Apple  ]
[ Continue with Email  ]
```

The same account should map to the same cloud user ID across devices.

Example:

```text
Android
   ↓
Google account
   ↓
Cloud User A
   ↓
Mealora cloud data
   ↑
iPhone
```

A user should not need to manually export/import data merely to move between devices once cloud sync exists.

---

# 22. Sync Strategy — Future Design Notes

Do not implement yet, but preserve these assumptions.

Local write:

```text
User logs meal
     ↓
SQLite write succeeds immediately
     ↓
UI updates
     ↓
record marked PENDING
     ↓
background sync when online
```

Successful sync:

```text
PENDING
  ↓
Go API
  ↓
PostgreSQL
  ↓
SYNCED
```

Future conflict strategy needs explicit design.

Potential baseline:

- server records revisions/version numbers;
- `updated_at` alone should not be trusted as the only conflict mechanism;
- deletions propagate through tombstones/soft deletes;
- user-generated records have globally unique IDs;
- idempotent API operations should be preferred.

---

# 23. AI Feature Assessment — Future

AI should reduce input friction rather than become a requirement for basic usage.

Potential capabilities:

### Natural-language meal input

```text
User:
"makan nasi 150 gram, ayam bakar satu,
tempe dua dan es teh manis"

AI output:
- Nasi putih — 150 g
- Ayam bakar — 1 serving
- Tempe — 2 pieces
- Sweet iced tea — 1 glass
```

User confirms before saving.

### Photo food recognition

AI may identify foods but cannot reliably know all hidden ingredients, cooking oils, recipes, or exact portion weight from a single image.

Therefore:

```text
AI detection
   ↓
ESTIMATE
   ↓
User review
   ↓
Correction
   ↓
Save
```

Never silently save AI estimates as exact nutrition values.

AI inference may become one of the largest variable operating costs, so image recognition can later be usage-limited or premium.

---

# 24. Barcode Assessment — Future

Potential flow:

```text
Camera
  ↓
Barcode
  ↓
Product database/API
  ↓
Nutrition label
  ↓
Serving selection
  ↓
Save
```

This feature requires an external or maintained product database and therefore belongs after the offline core is validated.

---

# 25. Potential Future Features

After MVP validation:

- optional cloud backup;
- multi-device synchronization;
- Google/Apple login;
- barcode scanning;
- natural-language food entry;
- AI food photo recognition;
- water tracking;
- meal templates;
- weekly insights;
- calorie adherence trends;
- macro insights;
- weight trend analysis;
- adaptive target suggestions;
- Health Connect integration;
- Apple Health integration;
- reminders;
- premium features/subscriptions.

These must not contaminate MVP scope unless explicitly promoted into a milestone.

---

# 26. Non-functional Requirements

## Offline

All MVP functions must operate without network connectivity.

## Performance

- dashboard should load from local storage quickly;
- food search should feel immediate for normal catalog sizes;
- database operations should not block UI rendering;
- aggregate calculations should remain efficient.

## Reliability

A failed operation must not leave partial meal records.

Use database transactions when creating/updating a meal and its items.

## Data integrity

- quantity > 0;
- weight > 0;
- height > 0;
- nutrition values cannot be nonsensical negative values;
- meal item snapshots must be immutable except when the user edits that logged item.

## Accessibility

- readable text sizes;
- sufficient contrast;
- don't communicate nutrition status by color alone;
- touch targets suitable for mobile use.

## Privacy

No analytics SDK, ad SDK, or third-party tracking should be added to MVP without an explicit decision.

---

# 27. Testing Strategy

## Unit tests

Highest priority:

```text
NutritionCalculator
DailyNutritionSummary
Serving calculations
Macro calculations
Repository behavior
```

Nutrition calculations should be deterministic and heavily tested.

## Database tests

Test:

- migrations;
- inserts;
- meal transactions;
- aggregate queries;
- soft deletion behavior;
- food search;
- history retrieval.

Use in-memory/local test databases where practical.

## Widget tests

Important flows:

- onboarding;
- dashboard states;
- adding food;
- editing meal;
- deleting meal item;
- weight entry.

## Integration test

Critical happy path:

```text
Fresh install
→ onboarding
→ target generated
→ add breakfast
→ dashboard updates
→ restart app
→ data still exists
→ open history
→ data correct
```

---

# 28. MVP Acceptance Criteria

MVP can be considered functionally complete when a fresh user can:

1. install Mealora;
2. complete onboarding without internet;
3. receive an estimated daily calorie target;
4. reach the dashboard;
5. search a local food catalog;
6. choose a serving and quantity;
7. log food under a meal;
8. see calories and macros update immediately;
9. edit/delete logged foods;
10. close and reopen the application without losing data;
11. browse previous daily logs;
12. record body weight;
13. edit their profile/goal and intentionally recalculate their target;
14. use all above features without an account or backend.

---

# 29. Development Milestones

## Milestone 0 — Foundation

- create Flutter project;
- establish architecture;
- configure linting/formatting;
- set up Drift/SQLite;
- set up state management;
- define theme/design tokens;
- establish test structure.

## Milestone 1 — Domain Engine

- profile entities;
- activity level model;
- goal model;
- energy calculation engine;
- macro target model;
- unit tests.

No polished UI required yet.

## Milestone 2 — Onboarding

- welcome;
- profile input;
- activity selection;
- goal selection;
- target result;
- persist profile/goal.

## Milestone 3 — Food Catalog

- food schema;
- serving schema;
- nutrition schema;
- seed/import local foods;
- food search;
- custom foods.

## Milestone 4 — Food Diary

- daily meal model;
- add meal item;
- serving quantity;
- edit/delete;
- nutrition snapshots;
- daily aggregates.

## Milestone 5 — Dashboard

- calories consumed;
- remaining calories;
- macros;
- meal sections;
- navigation between dates.

## Milestone 6 — Weight & History

- weight log;
- simple chart;
- daily history;
- historical nutrition summary.

## Milestone 7 — UX Improvements

- recent foods;
- favorites;
- duplicate meal;
- empty/error states;
- accessibility;
- polish.

## Milestone 8 — MVP Hardening

- unit/integration tests;
- migration tests;
- validation;
- performance check;
- offline verification;
- release build.

Only after Milestone 8 should cloud MVP work begin.

---

# 30. MVP 2 Development Milestones

Future only.

## Cloud Foundation

- Supabase project;
- PostgreSQL schema;
- authentication;
- Go API;
- Cloud Run/Railway deployment;
- secrets/environment management.

## Sync

- local sync metadata;
- push queue;
- pull changes;
- idempotency;
- conflict handling;
- retry strategy;
- offline behavior;
- account logout behavior.

## Multi-device

Validate:

```text
Device A
→ create data
→ sync
→ Device B login
→ data appears
→ Device B edits
→ Device A syncs
→ deterministic result
```

---

# 31. Codex Implementation Rules

When using ChatGPT Codex or another coding agent, provide these constraints.

### Architecture

1. MVP is **local-first and offline-first**.
2. Do not add backend/cloud dependencies unless explicitly requested.
3. Keep nutrition calculation logic out of widgets.
4. UI must access persistence through repositories/services, not direct ad-hoc SQL.
5. Use UUIDs for domain records.
6. Design user-generated records to be syncable later.
7. Do not implement premature microservices/cloud abstractions.
8. Prefer readable code over clever abstractions.

### Nutrition

1. Never invent nutrition science rules.
2. Calculation constants must be named and documented.
3. Every formula requires unit tests.
4. UI must describe calculated energy values as estimates.
5. Do not create unsafe deficit/surplus logic without an approved specification.

### Database

1. Schema changes require migrations.
2. Meal writes involving multiple records must use transactions.
3. Logged nutrition values use snapshots.
4. User-generated syncable records use timestamps and soft-delete readiness.
5. Do not use SQLite integer auto-increment as cross-device identity.

### Scope

If a feature is marked future/MVP 2, do not implement it while working on MVP 1 unless the product owner explicitly changes scope.

---

# 32. Suggested First Codex Tasks

Do not ask Codex to "build Mealora" in one prompt.

Start incrementally.

### Task 1

```text
Initialize a production-quality Flutter project for Mealora.

Requirements:
- local-first / offline-first architecture
- Drift + SQLite
- Riverpod
- feature-oriented folder structure described in the Mealora assessment
- no authentication
- no backend
- no Supabase
- no AI
- configure linting and tests
- create only the application skeleton and database foundation

Do not implement product features yet.
```

### Task 2

```text
Implement the Mealora nutrition domain model and energy calculation engine.

Requirements:
- pure Dart domain code
- no Flutter widget dependency
- calculation strategy must be replaceable
- implement approved Mifflin-St Jeor calculation
- model activity level separately
- model user goal separately
- return a structured EnergyEstimate
- comprehensive unit tests

Do not invent deficit/surplus safety limits. Leave goal-adjustment policy behind an interface/configuration until approved.
```

### Task 3

```text
Implement Mealora onboarding using the existing domain engine and repository architecture.

The flow must work fully offline and persist the local profile and calculated nutrition goal in Drift/SQLite.
```

Continue milestone by milestone rather than generating the entire product at once.

---

# 33. Open Product Decisions

These items are intentionally unresolved and should be decided before their milestone:

- final logo and brand identity;
- exact macro target methodology;
- exact activity multipliers;
- safe deficit/surplus policy;
- minimum age policy;
- handling pregnancy/breastfeeding;
- authoritative Indonesian food data source;
- whether water tracking belongs in MVP 1.1;
- whether meal templates belong in MVP 1.1;
- state management final confirmation;
- UUID v7 package choice;
- local food seed/import format;
- cloud conflict resolution strategy;
- AI provider;
- barcode product database;
- monetization strategy.

Do not silently make these decisions in implementation code.

---

# 34. Current Decisions

Decisions agreed during initial assessment:

| Area | Decision |
|---|---|
| Product name | **Mealora** |
| Product type | Personal calorie/nutrition tracker |
| Initial platform | Flutter mobile |
| MVP philosophy | **Local-first / offline-first** |
| MVP account | None required |
| MVP backend | None |
| MVP database | SQLite |
| SQLite abstraction | Drift preferred |
| Core logic | Dart domain layer |
| Primary key strategy | UUID, sync-ready |
| Food input MVP | Search + serving + custom food |
| Quick logging | Recent/Favorites after core flow |
| Weight tracking | MVP |
| Cloud sync | Future MVP 2 |
| Future Auth | Supabase Auth candidate |
| Future cloud DB | Supabase PostgreSQL candidate |
| Future backend | Go preferred |
| Future backend hosting | Google Cloud Run preferred; Railway alternative |
| Future AI | Natural-language + food photo analysis |
| AI result policy | Estimate + user confirmation |
| Architecture future | Modular monolith; no microservices initially |

---

# 35. Product Roadmap Summary

```text
MEALORA
│
├── MVP 1 — OFFLINE CORE
│   ├── Flutter
│   ├── Drift / SQLite
│   ├── Onboarding
│   ├── Nutrition Engine
│   ├── Calorie Target
│   ├── Food Database
│   ├── Food Search
│   ├── Custom Food
│   ├── Food Diary
│   ├── Daily Dashboard
│   ├── Macro Tracking
│   ├── History
│   └── Weight Tracking
│
├── MVP 1.1 — CONVENIENCE
│   ├── Favorites
│   ├── Recent Foods
│   ├── Meal Templates
│   ├── Weekly Summary
│   └── Water Tracking
│
├── MVP 2 — CLOUD
│   ├── Supabase Auth
│   ├── Go API
│   ├── PostgreSQL
│   ├── Cloud Sync
│   ├── Backup
│   └── Multi-device
│
├── MVP 3 — SMART INPUT
│   ├── Barcode
│   ├── Natural Language
│   └── AI Food Photo
│
└── FUTURE
    ├── Personalized Insights
    ├── Adaptive Targets
    ├── Health Connect
    ├── Apple Health
    └── Premium Features
```

---

# 36. Definition of the First Goal

The first goal is **not** to build the smartest calorie application.

The first goal is:

> Build a reliable, pleasant, completely offline Mealora application where a user can calculate an estimated nutrition target, record what they eat, understand today's calorie/macronutrient progress, and track weight without creating an account or depending on a server.

Once that experience is genuinely useful, add cloud synchronization and intelligent input as separate layers rather than rebuilding the product around them.

---

## Reference notes used during assessment

- Flutter documentation recognizes on-device SQLite as an appropriate choice for structured local data that does not need a cloud backend by default.
- Drift is a reactive persistence library for Dart/Flutter built on SQLite and supports type-safe queries and schema migrations.
- Mifflin–St Jeor is a commonly used predictive equation for resting energy expenditure; predictive equations remain estimates and can vary in accuracy between individuals.

These references should be replaced/expanded with authoritative nutrition sources before Mealora makes production nutrition recommendations.
