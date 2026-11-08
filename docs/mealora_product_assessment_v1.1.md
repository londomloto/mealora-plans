# Mealora — Product & Technical Assessment v1.1

> Status: Revised implementation baseline for ChatGPT Codex / OpenSpec  
> Original date: 2026-11-03  
> Revised: 2026-11-08  
> Product codename/name: **Mealora**  
> MVP strategy: **Local-first, offline-first, no mandatory account, no backend required**

---

## v1.1 Revision Notice

This revision preserves the complete v1.0 assessment and promotes **Program Management** to a mandatory part of **MVP 1 local-first**. It adds four programs—**Weight Loss, Weight Gain, Maintenance, and Healthy Eating**—together with program onboarding, a `ProgramEngine` separate from `NutritionCalculator`, scientifically validated target guardrails, full lifecycle management, progress/history, Drift/SQLite schema and migration requirements, use cases, acceptance criteria, tests, milestones, and Codex/OpenSpec instructions.

The architecture remains Flutter + Drift/SQLite with no mandatory account or backend. The existing **MVP 2 online roadmap remains unchanged in intent**: optional Supabase Auth, PostgreSQL, Go API, cloud sync, backup, and multi-device support.

Where earlier text uses “goal” as a simple profile field, v1.1 interprets it through the Program Management domain specified in Sections 37–48. Those sections are normative when there is a conflict with older shorthand.

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
   ├─ Weight Loss
   ├─ Weight Gain
   ├─ Maintenance
   └─ Healthy Eating
   ↓
Nutrition Engine
   ├─ Estimate resting energy requirement
   └─ Estimate daily energy expenditure
   ↓
Program Engine
   ├─ Validate eligibility and guardrails
   ├─ Propose program-specific targets
   └─ Create the active local program
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

`NutritionCalculator` must calculate neutral physiological estimates only. In v1.1, selection of a deficit, surplus, maintenance policy, Healthy Eating targets, lifecycle state, and progress rules belongs to the separate `ProgramEngine` described in Section 39.

## 6.2A Program Management — Mandatory MVP 1

Program Management is a required core module, not a convenience feature.

MVP 1 must provide:

- selection and onboarding for Weight Loss, Weight Gain, Maintenance, and Healthy Eating;
- program target preview and explicit user confirmation;
- create, change, pause, resume, complete, and cancel behavior;
- at most one current active/paused program per local profile;
- dated progress and complete program history;
- preserved food and weight history when a program changes;
- explainable calculation inputs, `calculator_version`, and `policy_version`;
- safe refusal when the profile or policy is unsupported or unvalidated.

The detailed normative requirements are in Sections 37–48.

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

Also include:

- My Program;
- change, pause/resume, and complete program;
- program history;
- explanation of target calculation, assumptions, warnings, and versions.

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

Program Management is **not** in this exclusion list. It is mandatory MVP 1. Automatic adaptive target adjustment, medical programs, AI coaching, and cloud program sync remain future work.

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
│   ├── program/
│   └── weight/
│
├── data/
│   ├── repositories/
│   ├── local/
│   └── mappers/
│
├── features/
│   ├── onboarding/
│   ├── program/
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

# v1.1 Normative Addendum — Program Management

# 37. Program Catalog and Product Semantics

MVP 1 ships exactly four built-in program definitions:

| Code | Display name | Primary intent | Weight target required? |
|---|---|---|---|
| `weight_loss` | Weight Loss | Reduce body weight using an approved guarded target | Yes, subject to policy |
| `weight_gain` | Weight Gain | Increase body weight using an approved guarded target | Yes, subject to policy |
| `maintenance` | Maintenance | Maintain weight/energy balance within an approved range | No fixed target required |
| `healthy_eating` | Healthy Eating | Improve nutrition quality and consistency | No |

Catalog definitions are stable reference data. A user program is a separate enrollment record containing the accepted target snapshot and lifecycle state.

Healthy Eating must not fabricate a weight-progress percentage when no target weight exists. It can use approved nutrition/consistency measures such as diary completeness or nutrient-range adherence, once those measures are explicitly specified.

# 38. Program Selection and Onboarding

## Common input

- local profile and age/date of birth;
- biological input required by the approved energy equation;
- height, current weight, activity level, units, locale, and time zone;
- acknowledgment that results are estimates;
- screening inputs required by the approved eligibility policy.

## Program-specific input

- **Weight Loss / Weight Gain:** current weight, target weight or approved pace choice, and optional target date only when the policy supports it.
- **Maintenance:** current weight and optional preferred maintenance range.
- **Healthy Eating:** nutrition/habit focus; target weight is not required.

Flow:

```text
Select program
  → collect/validate inputs
  → NutritionCalculator estimate
  → ProgramEngine proposal/typed refusal
  → show values, assumptions, warnings and versions
  → explicit confirmation
  → atomic activation
```

A requested target date never overrides safety rules. If the requested outcome conflicts with approved policy, Mealora must explain the conflict and request a safer input rather than silently clipping the target.

# 39. Separation of NutritionCalculator and ProgramEngine

## NutritionCalculator

A deterministic pure-Dart component that:

- validates calculation inputs;
- estimates resting energy/BMR using the approved versioned equation;
- estimates TDEE using the approved activity model;
- returns assumptions, warnings, rounding behavior, and `calculator_version`.

It must not know Flutter widgets, Drift/SQLite, repositories, program status, or deficit/surplus policy.

## ProgramEngine

A deterministic pure-Dart policy component that consumes profile facts plus a `NutritionEstimate` and returns a `ProgramTargetProposal` or typed non-approved result.

It:

- validates program-specific required input and eligibility;
- applies approved Weight Loss, Weight Gain, Maintenance, or Healthy Eating policy;
- proposes daily energy and approved nutrient targets;
- enforces lower/upper bounds and approved rate-of-change rules;
- reports reason codes and `policy_version`;
- creates target revisions without rewriting history.

Required result states:

```text
approved
needs_user_correction
needs_professional_review
unsupported_profile
missing_validated_policy
```

Codex must not invent missing numeric values. A missing or unapproved rule fails closed with `missing_validated_policy`.

# 40. Scientific Validation and Nutritional Guardrails

This document defines engineering boundaries, not clinical values. Before public production use, a qualified nutrition/medical reviewer must approve and version:

- target population and age eligibility;
- equation and required input semantics;
- activity multipliers/descriptions;
- deficit/surplus ranges and maximum weight-change pace;
- minimum/maximum energy guardrails;
- protein, carbohydrate, fat, fiber, and other target logic;
- BMI/screening use, if any;
- rounding, tolerance bands, and recalculation cadence;
- exclusions/referral for minors, pregnancy/breastfeeding, eating disorders, diabetes, kidney/liver disease, medications, rapid weight change, and other relevant conditions.

Safety rules:

1. Unsupported/excluded profiles cannot activate an automatic deficit/surplus.
2. The UI must say “estimate,” not diagnosis, guarantee, or prescription.
3. Every accepted target stores its input snapshot, `calculator_version`, and `policy_version`.
4. Policy updates apply only after a user accepts a new target revision; they never alter history.
5. A target that is refused/limited must expose a user-safe reason.
6. Medical nutrition therapy and emergency/symptom guidance are outside MVP scope.

# 41. Program Lifecycle and Invariants

```text
draft → active ↔ paused → completed
                    └──→ changed
draft → cancelled
active/paused → cancelled
```

`changed` means superseded by a newly activated program. Terminal states cannot resume.

Normative rules:

1. A profile may have many historical programs but at most one current `active` or `paused` program.
2. A draft does not affect the current program.
3. Activation requires an approved proposal and explicit confirmation.
4. Activating another program atomically marks the current active/paused record `changed`, sets `ended_at`, links both records, inserts lifecycle events, and activates the new record.
5. Pause records its start/event and excludes paused time from active-day progress; food and weight logging remain available.
6. Resume is invalid for terminal states. Recalculation occurs only under an approved staleness/profile-change rule, and changed targets require confirmation.
7. Complete records a reason and final progress snapshot and preserves all data.
8. Program changes never delete or re-parent food diary and weight history.
9. Repeated commands must be idempotent where meaningful; invalid transitions return typed errors.
10. Program catalog rows referenced by history are retired with `is_available = false`, never deleted.

# 42. Drift / SQLite Data Design

All domain IDs are UUID/UUIDv7 text. Store instants in UTC, retain the IANA time-zone ID and the local date used for diary/progress grouping. Sync-eligible mutable rows use `created_at`, `updated_at`, nullable `deleted_at`, `sync_status`, and `revision`.

Existing v1.0 tables stay intact. The following tables are added.

## `programs`

```text
id TEXT PK
code TEXT UNIQUE NOT NULL
name TEXT NOT NULL
description TEXT NOT NULL
requires_weight_target INTEGER NOT NULL
is_available INTEGER NOT NULL
sort_order INTEGER NOT NULL
definition_version INTEGER NOT NULL
created_at INTEGER NOT NULL
updated_at INTEGER NOT NULL
```

Seed stable rows for the four program codes. Seeding must be idempotent.

## `user_programs`

```text
id TEXT PK
profile_id TEXT FK NOT NULL
program_id TEXT FK NOT NULL
status TEXT NOT NULL CHECK (...)
started_at INTEGER NULL
paused_at INTEGER NULL
ended_at INTEGER NULL
baseline_weight_kg REAL NULL
target_weight_kg REAL NULL
target_date TEXT NULL
daily_energy_target_kcal REAL NULL
protein_target_g REAL NULL
carbohydrate_target_g REAL NULL
fat_target_g REAL NULL
fiber_target_g REAL NULL
input_snapshot_json TEXT NOT NULL
calculator_version TEXT NOT NULL
policy_version TEXT NOT NULL
pause_reason TEXT NULL
completion_reason TEXT NULL
supersedes_user_program_id TEXT NULL FK
superseded_by_user_program_id TEXT NULL FK
created_at INTEGER NOT NULL
updated_at INTEGER NOT NULL
deleted_at INTEGER NULL
sync_status TEXT NOT NULL DEFAULT 'local'
revision INTEGER NOT NULL DEFAULT 1
```

At minimum, add partial indexes for one live active row and one live paused row per profile. Because the product invariant spans both statuses, enforce it in the same activation transaction and preferably through a tested SQLite trigger.

```sql
CREATE UNIQUE INDEX user_programs_one_active_per_profile
ON user_programs(profile_id)
WHERE status = 'active' AND deleted_at IS NULL;

CREATE UNIQUE INDEX user_programs_one_paused_per_profile
ON user_programs(profile_id)
WHERE status = 'paused' AND deleted_at IS NULL;
```

## `program_progress`

```text
id TEXT PK
user_program_id TEXT FK NOT NULL
recorded_local_date TEXT NOT NULL
recorded_at INTEGER NOT NULL
weight_kg REAL NULL
weight_change_kg REAL NULL
target_progress_ratio REAL NULL
consumed_energy_kcal REAL NULL
energy_adherence_ratio REAL NULL
protein_g REAL NULL
carbohydrate_g REAL NULL
fat_g REAL NULL
logged_meals_count INTEGER NOT NULL DEFAULT 0
diary_complete INTEGER NOT NULL DEFAULT 0
active_day_number INTEGER NOT NULL
metrics_json TEXT NOT NULL DEFAULT '{}'
calculation_version TEXT NOT NULL
created_at INTEGER NOT NULL
updated_at INTEGER NOT NULL
deleted_at INTEGER NULL
sync_status TEXT NOT NULL DEFAULT 'local'
revision INTEGER NOT NULL DEFAULT 1
```

Create a unique live index on `(user_program_id, recorded_local_date)`. Rebuilding a date is an idempotent upsert. Raw weight and diary records remain authoritative; snapshots are derived/cache/history aids.

## Recommended `program_events`

```text
id TEXT PK
user_program_id TEXT FK NOT NULL
event_type TEXT NOT NULL
occurred_at INTEGER NOT NULL
from_status TEXT NULL
to_status TEXT NULL
reason_code TEXT NULL
metadata_json TEXT NOT NULL DEFAULT '{}'
created_at INTEGER NOT NULL
sync_status TEXT NOT NULL DEFAULT 'local'
revision INTEGER NOT NULL DEFAULT 1
```

This supports pause intervals, audits, target acceptance, and future deterministic sync. If omitted, equivalent lifecycle fidelity must be proven elsewhere.

# 43. Migration to Schema v1.1

1. Increment Drift `schemaVersion` once for this change.
2. Create the program tables, constraints, indexes, and recommended event table in a tested migration.
3. Seed four catalog rows with stable IDs/codes and idempotent upserts/inserts.
4. Preserve every existing profile, nutrition goal, food, serving, diary item/snapshot, favorite, and weight record.
5. Do not auto-enroll existing users. After migration, offer “Choose your program” without blocking access to old data.
6. If an old nutrition goal is converted, require review/confirmation and record provenance `migrated_confirmed` plus the original snapshot.
7. Run catalog validation and `PRAGMA foreign_key_check` in migration verification.
8. Document downgrade as unsupported unless the release strategy explicitly requires a reverse migration.

Required fixtures:

- empty database;
- direct fresh creation at v1.1;
- populated v1.0 with diary, favorites, and weight history;
- migration retry/interrupted seed;
- invalid legacy goal data;
- foreign keys enabled.

# 44. Application Use Cases

Program selection/onboarding:

```text
ListAvailablePrograms
GetProgramOnboardingRequirements
PreviewProgramTarget
CreateProgramDraft
ActivateProgram
```

Lifecycle/history:

```text
GetCurrentProgram
ChangeProgram
PauseProgram
ResumeProgram
CompleteProgram
CancelProgram
ListProgramHistory
GetProgramDetails
```

Targets/progress:

```text
RecalculateProgramTarget
AcceptProgramTargetRevision
RecordWeight
RebuildProgramProgressForDate
GetProgramProgressSummary
ListProgramProgress
```

Each use case returns typed outcomes. `ActivateProgram` must reload current facts, reproduce/verify the accepted proposal and versions, then supersede any current program, activate the new one, insert events, and create the initial progress snapshot in one transaction. Failure leaves the previous program unchanged.

# 45. Program UX Requirements

## My Program

- program name/status;
- baseline, latest, and target weight where applicable;
- estimated calorie/macronutrient target;
- progress and honest missing-data states;
- last calculation date and “How calculated” detail;
- pause/resume/change/complete controls;
- program history.

## Change program

Preview the replacement before confirmation. State clearly that the current program moves to history and that food/weight records remain. Cancelling changes nothing.

## Paused program

Clearly label the paused state, stop active-day/adherence accumulation, and continue to allow food/weight logging. Resume/change remain available.

## Missing/unsafe states

Provide deliberate UI for: no program, incomplete profile, no weight, incomplete/unknown diary, unsupported profile, unavailable validated policy, and inputs changed since preview.

# 46. Acceptance Criteria — Program Management

1. **Offline:** all program onboarding, lifecycle, progress, and history work without login/network.
2. **Four programs:** the catalog contains exactly the four required codes and correct onboarding rules.
3. **Separation:** `NutritionCalculator` and `ProgramEngine` run in pure-Dart tests without Flutter/Drift/network; the calculator has no lifecycle logic.
4. **Fail closed:** unsupported profiles and missing policy cannot be activated even by bypassing UI.
5. **Confirmation:** activation requires review of targets, assumptions, warnings, and versions.
6. **Single current program:** retries/concurrent attempts cannot leave more than one active/paused current program.
7. **Atomic change:** old status/link and new activation either all commit or all roll back; diary/weight history is unchanged.
8. **Pause/resume:** paused days are excluded; terminal statuses cannot resume; invalid transitions are typed.
9. **Complete/history:** completed programs remain viewable with original inputs/targets/versions.
10. **Progress:** missing diary data remains null/unknown, not zero or failure; rebuilding a date does not double-count.
11. **Healthy Eating:** activation needs no target weight and shows no fake weight progress.
12. **Migration:** populated v1.0 data is preserved and no existing profile is auto-enrolled.
13. **Units/time:** canonical kg/kcal/g and UTC storage survive display-unit/time-zone changes without changing historical local dates.
14. **Explainability:** every program exposes accepted inputs, calculator/policy versions, targets, and guardrail reasons.

# 47. Tests and Milestone Changes

## Required tests

- Golden BMR/TDEE fixtures from approved references.
- Boundary tests just below/at/above every approved guardrail.
- All four program policies and required-input combinations.
- Unsupported, excluded, and missing-policy outcomes.
- Complete lifecycle transition matrix and idempotent repeat behavior.
- Weight progress for loss/gain/maintenance/overshoot/regression/no target.
- Paused-time and missing-diary semantics.
- Property tests: targets never exceed configured bounds; no NaN/infinity; lifecycle never creates two current programs.
- Database constraints, indexes, atomic rollback, idempotent seeds/upserts, history ordering.
- All migration fixtures in Section 43.
- Integration: onboarding→activation; pause→log→resume; Weight Loss→Maintenance change; complete→new program; profile-change→new accepted target; restart in every lifecycle state; airplane-mode critical flow.
- Accessibility: large text, screen readers, contrast, non-color status, metric/imperial display, localization-safe layout.

## Revised MVP milestones

### Milestone 0 — Specification and scientific gate

Approve eligibility, formulas, policy, guardrails, terminology, copy, golden fixtures, OpenSpec changes, and ADRs. No production numeric policy may remain an unreviewed guess.

### Milestone 1 — Local foundation

Keep the original foundation scope and add injected clock/ID generation, migration harness, sync-ready metadata, and program schema planning.

### Milestone 2 — Nutrition and program domain

Implement pure-Dart `NutritionCalculator`, `ProgramEngine`, value objects, typed outcomes, state machine, and tests.

### Milestone 3 — Program persistence and use cases

Implement program tables/DAOs/repositories/events/progress and atomic create/change/pause/resume/complete/history use cases.

### Milestone 4 — Program and diary user flows

Implement profile/program onboarding, My Program, history, food catalog/search/diary, weight entry, and daily dashboard.

### Milestone 5 — Hardening/release candidate

Run migration rehearsal, offline/accessibility/performance/privacy/export/delete checks, and scientific/product sign-off against all acceptance criteria.

The original food, diary, dashboard, weight, convenience, and hardening work remains required; reorder it behind the Program domain rather than removing it.

# 48. Codex and OpenSpec Execution Instructions

## Codex rules added by v1.1

1. Read this assessment and the active OpenSpec change before editing.
2. Work one narrow change/milestone at a time; do not build the full roadmap in one pass.
3. Never invent nutrition constants, eligibility rules, medical wording, or “safe” boundaries.
4. Keep domain Dart independent of Flutter, Drift, network, global clocks, and random ID creation.
5. Do not calculate targets inside widgets, providers/view models, DAOs, or SQL.
6. Use repositories and explicit transactions for lifecycle mutations.
7. Every schema change needs a migration, fixture, migration test, and version note.
8. Preserve historical diary, weight, program inputs, targets, and versions.
9. Use typed enums/value objects/failures instead of magic strings and generic exceptions.
10. Store canonical units and convert only at boundaries.
11. MVP 1 must not require Supabase, Go, authentication, or connectivity.
12. MVP 2 is implemented only through a separate approved change.
13. Before completion, run formatting, static analysis, unit, database/migration, and relevant integration tests and report results/risks.

## OpenSpec structure

Recommended sequence:

```text
openspec/changes/
├── add-program-domain/
├── add-program-persistence/
├── add-program-onboarding/
├── add-program-lifecycle/
├── add-program-progress-history/
└── prepare-cloud-sync-metadata/
```

Every proposal must include:

- problem/user outcome and in/out scope;
- domain terms and state transitions;
- normative MUST/SHOULD/MAY requirements;
- Given/When/Then scenarios;
- schema/migration/rollback impact;
- approved scientific evidence reference and policy version;
- offline, privacy, safety, and accessibility impact;
- idempotency and transaction/failure behavior;
- test plan, risks, dependencies, and unresolved decisions.

A numeric nutrition-policy update must be its own change with a new version, approved evidence, golden fixtures, and documented target-revision behavior. Sync remains a separate MVP 2 proposal and cannot make local repositories depend on a server.

Suggested first three Codex tasks:

1. Program domain only: value objects, statuses, transitions, engine interfaces/results, and fail-closed tests; no UI/database.
2. Program persistence: Drift tables, seeds, indexes/trigger, v1.0→v1.1 migration, fixtures, and tests; no UI.
3. Activation: preview/confirm/atomic activation and single-current-program tests; onboarding UI follows in a later change.

# 49. Roadmap Consistency After v1.1

```text
MEALORA
│
├── MVP 1 — OFFLINE CORE (mandatory)
│   ├── Flutter + Drift/SQLite
│   ├── Profile and Program onboarding
│   ├── NutritionCalculator
│   ├── ProgramEngine + validated guardrails
│   ├── Weight Loss / Weight Gain / Maintenance / Healthy Eating
│   ├── Program lifecycle, progress, history
│   ├── Food catalog/search/custom food
│   ├── Food diary/dashboard/macros/history
│   └── Weight tracking
│
├── MVP 1.x — CONVENIENCE
│   ├── Favorites / Recent / Templates
│   ├── Weekly summary
│   └── Water tracking
│
├── MVP 2 — OPTIONAL ONLINE
│   ├── Supabase Auth
│   ├── Supabase PostgreSQL
│   ├── Go modular-monolith API
│   ├── Cloud backup/sync
│   └── Multi-device
│
├── MVP 3 — SMART INPUT
│   ├── Barcode
│   ├── Natural language
│   └── AI food photo
│
└── FUTURE
    ├── Validated adaptive targets
    ├── Personalized insights
    ├── Health integrations
    └── Premium features
```

MVP 2 remains additive: Flutter reads/writes SQLite immediately, then an opt-in sync engine communicates with a Go modular monolith that validates Supabase Auth JWTs and persists to Supabase PostgreSQL. Multi-device convergence, account linking, anonymous-to-account migration, conflicts, tombstones, authorization/RLS, deletion, export, encryption, and telemetry consent require a dedicated OpenSpec design before implementation.

# 50. MVP 1 Amendment — Barcode, Nutrition Label, and Food Photo AI

This amendment supersedes older statements in Sections 6–8, 17, 23–25, 29, 31–35, 47, and 49 that place barcode scanning or food photo recognition solely in a later MVP. Both are **mandatory MVP 1 input paths**. Natural-language free-text input remains later scope. The manual catalog and custom-food paths remain available.

## 50.1 Packaged food: barcode plus label

The barcode is a product identifier, not a source of nutritional values. The user scans the barcode; Mealora searches a locally cached/bundled product first and may query an approved product-data source when online. It shows product name, brand, package size, serving size, servings per package, calories, and macros with source and last-verified date. The user chooses how much was eaten and confirms before logging.

When the product is absent, incomplete, or conflicts with its current packaging, the user photographs the **Informasi Nilai Gizi** panel. OCR/vision extracts serving size, servings per package, energy, protein, carbohydrate, and fat with units and confidence. The review screen displays the original photo beside editable extracted fields. The user confirms or corrects each essential value. Never silently treat OCR output as verified nutrition data. A confirmed entry is stored locally for repeat use, with barcode, package variant, provenance, verification date, and a nutrition snapshot in the meal log.

Calculate whole-package consumption from per-serving values multiplied by servings consumed. Do not confuse per-100-g, per-serving, and per-package values. Preserve the label's basis and normalize to canonical units. A missing value remains unknown, not zero.

## 50.2 Plated-food photo AI

The user photographs a meal. Vision proposes food components and possible catalog matches. The user reviews each component, cooking method, portion/weight, hidden ingredients or sauces, and nutrition estimate before saving. If recognition is uncertain, ask for correction or let the user search/select manually. A photo cannot reliably determine exact oil, recipe, ingredients, or mass; show estimated values and never present them as measurements. Do not infer nutritional numbers directly from visual appearance when a credible food/recipe record is unavailable.

The photo flow must support multiple foods in one image, removal/addition of components, quantity editing, and cancellation without creating a log. Store the accepted food IDs/recipe data and nutrient snapshots; retain or discard the source image according to an explicit privacy setting and retention policy.

## 50.3 AI service and local-first behavior

The initial implementation uses a **replaceable vision-provider interface**. Evaluate **Gemini API** first for a prototype because eligible models have a limited free tier; compare **Qwen VL** (including label-text extraction) and **DeepSeek Flash** (which supports image input). GPT-4o remains an optional comparison, not the default: its API has no guaranteed free tier. Free quotas, promotional credits, supported models, regions, rate limits, pricing, image handling, and terms must be checked in the actual project account before use. ChatGPT access does not fund application API calls. Configure strict spend/request caps. Avoid embedding a secret API key in the Flutter client; a minimal secure proxy or an on-device model is required for a production cloud-AI path. That proxy is scoped to AI inference only and does not change the MVP 1 local SQLite source of truth or introduce mandatory login/cloud sync.

AI photo and label extraction are network-assisted when a cloud model is selected. Offline, the user can still scan a barcode against cached products, enter/correct label values manually, and log photographed food through catalog selection. The core diary/program flows remain fully offline. The UI must clearly state when AI extraction requires connectivity, ask for consent before uploading a food/label image, and offer the offline path. No image is uploaded automatically.

## 50.4 Product data and provenance

Use a curated local catalog for common foods and selected packaged products. An online barcode source such as Open Food Facts may supplement it, subject to its ODbL and image-license obligations; community records require review. Product variants and reformulations can change values, so current packaging takes precedence when the user corrects it. Do not redistribute TKPI data in the bundled catalog until its reuse rights are confirmed. Track `source_type`, `source_id`, `source_version`, `verified_at`, `barcode`, `serving_basis`, and `user_corrected` on product records or a related provenance table.

## 50.5 Acceptance criteria and tests

1. Scan a known cached barcode offline, review serving quantity, confirm, and see correct diary totals.
2. Unknown barcode leads to label-photo extraction when online or manual label entry offline; neither path blocks logging.
3. A two-serving package logged in full multiplies per-serving nutrients by two; per-100-g labels use consumed grams.
4. OCR errors, missing fields, ambiguous units, and low-confidence results require correction/confirmation; unknown is never treated as zero.
5. Food photo proposes multiple components, and the user can change matches and portions before any log is written.
6. Cloud AI unavailable, out of credits, timed out, or offline returns a useful manual fallback without losing the draft.
7. Images are uploaded only with consent; API secrets never ship in the app; accepted records persist locally after restart.
8. Historical nutrient snapshots remain unchanged when a product catalog entry or AI provider result later changes.

Test barcode parsing and lookup, serving-basis conversion, label OCR fixture review, image recognition review UI, cancellation/rollback, offline fallback, provider failure and rate-limit handling, image consent, and persistence after restart. Use real packaged-food label fixtures with permission and varied Indonesian formats for evaluation; measure extraction accuracy before release.

## 50.6 Model evaluation gate

Use a representative, permission-cleared fixture set of at least 30–50 Indonesian packaged-food labels and 30–50 plated-food photos. Compare Gemini, Qwen VL, and DeepSeek Flash on serving-size/servings-per-package extraction, calories/protein and unit accuracy, food-component identification, portion uncertainty, correction burden, latency, and cost per accepted log. Record model version, prompt/schema version, test date, provider region, and failure cases. Choose a provider only after this evaluation; a free tier is a development aid, not a production capacity guarantee. Never use model-generated nutrient numbers without a matched catalog, recipe, or confirmed label source.

References for implementation planning: [Gemini billing](https://ai.google.dev/gemini-api/docs/billing/), [Qwen Model Studio pricing and free quotas](https://help.aliyun.com/en/model-studio/model-pricing), [DeepSeek vision](https://api-docs.deepseek.com/guides/vision/), and [GPT-4o API model limits](https://developers.openai.com/api/docs/models/gpt-4o). Recheck before implementation because offerings change.

## 50.7 Milestones and Codex/OpenSpec changes

Promote these tasks into MVP 1 before release: barcode camera/lookup and product cache; label image capture and extraction/review; food photo recognition/review; provenance schema and migration; consent/security/cost controls; fixture-driven evaluation and integration tests. A photo-AI prototype may use an available free tier or actual promotional credits, but production acceptance requires an operationally viable provider and documented cost cap.

Add separate OpenSpec changes `add-packaged-food-barcode`, `add-nutrition-label-extraction`, and `add-food-photo-input`. Each specifies online/offline behavior, image consent/retention, provider interface, product-data license, serving math, correction flow, error fallback, acceptance scenarios, and tests. Codex must not hard-code an assumed free tier or put provider credentials in the mobile app.

Updated MVP 1 definition: users can log food manually, scan a packaged product's barcode, capture and confirm its nutrition label, and capture a meal photo for AI-assisted component identification with user correction. All accepted diary data is stored in Drift/SQLite. MVP 2 still adds Supabase Auth/PostgreSQL, Go API for account data, cloud sync, backup, and multi-device.

---

## Reference notes used during assessment

- Flutter documentation recognizes on-device SQLite as an appropriate choice for structured local data that does not need a cloud backend by default.
- Drift is a reactive persistence library for Dart/Flutter built on SQLite and supports type-safe queries and schema migrations.
- Mifflin–St Jeor is a commonly used predictive equation for resting energy expenditure; predictive equations remain estimates and can vary in accuracy between individuals.

These references should be replaced/expanded with authoritative nutrition sources before Mealora makes production nutrition recommendations.
