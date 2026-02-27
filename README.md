# UmojaAgri-Org

---

# UmojaAgri 🌾

**AI-Driven Agricultural Logistics Platform**

A logistics intelligence platform that helps farmers and transporters monitor produce freshness, predict delivery delays, and reduce post-harvest losses using rule-based AI.
With the collaboration of the twam we could bring the mobile app to life.
---

#  Project Overview

UmojaAgri is an MVP designed to address a major challenge in African agriculture: **food spoilage due to unpredictable transportation**.

The platform calculates a **Freshness Window** — a real-time countdown that determines whether produce will arrive at its destination before spoilage risk becomes critical.

It combines logistics tracking, rule-based intelligence, and supply-chain visibility into a single system.

---

#  Problem Statement

A significant percentage of agricultural produce in Africa spoils before reaching markets due to:

* Poor road conditions
* Unpredictable travel times
* Lack of real-time freshness tracking
* Inefficient logistics coordination

UmojaAgri provides predictive insights so farmers and transporters can make smarter decisions and reduce waste.

---

#  Core Features

##  Produce Tracking

* Monitor produce lifecycle from harvest to delivery
* Track ownership and storage locations

##  Freshness Window Calculation

* Determines spoilage risk based on crop type and time
* Sends alerts when delivery risk becomes critical

##  Delivery & Transport Management

* Assign vehicles and transporters
* Track delivery status and events

##  Rule-Based AI Predictions

* Adjust ETA based on:

  * Road quality
  * Traffic
  * Weather
  * Checkpoints

##  Notifications System

* Alerts for delays and spoilage risk

---

#  MVP Scope

The initial rollout focuses on validating the core logistics model.

### 🌍 Regions

* Nigeria
* Egypt
* South Africa
* Ethiopia
* Kenya

###  Key Hubs

* Lagos
* Cairo
* Johannesburg

### 👥 Target Users

* Independent farmers
* Transport operators
* Market Sellers

---

# 🛠 Tech Stack

## Backend

* Node.js
* Express (or similar framework)
* Prisma ORM
* PostgreSQL

## DevOps

* GitHub Actions (CI/CD)
* Render (cloud hosting)

## Architecture

* RESTful API
* Rule-based prediction engine
* Relational data model

---

# 🗄 Database Design

Core entities include:

* Users & Roles
* Produce
* Deliveries
* Storage Locations
* Vehicles
* Transport Assignments
* AI Results
* Notifications

The schema enables full lifecycle tracking of produce from harvest through delivery.

---

#  How It Works

1️⃣ User enters crop, harvest time, and destination
2️⃣ System calculates travel time using rule-based logic
3️⃣ Freshness limit is applied
4️⃣ If ETA exceeds freshness window → alert generated

---

# Local Development Setup

## 1️ Clone repository

```bash
git clone https://github.com/Innovators-UmojaAgri-Org/UmojaAgri-Org.git
cd UmojaAgri-Org
```

## 2️ Switch to dev branch

```bash
git checkout dev
```

## 3️ Install dependencies

```bash
cd backend
npm install
```

## 4️ Configure environment variables

Create `.env`:

```
DATABASE_URL=your_postgres_connection_string
PORT=5000
```

## 5️ Run Prisma

```bash
npx prisma generate
npx prisma migrate dev
```

## 6️ Start server

```bash
npm run dev
```

---

#  Deployment

The backend is deployed on **Render** with CI/CD automation via GitHub Actions.

### Deployment Flow

* `dev` → staging/testing
* `main` → production
* `cyber` → security testing

---

#  Security & DevSecOps

The project integrates:

* Branch protection rules
* CI pipelines
* Dependency scanning
* Security experimentation branch (`cyber`)

---

#  Project Status

 MVP in active development

Current focus:

* Core logistics logic
* Deployment stability
* Security hardening

---

#  Contribution Guidelines

1. Fork the repository
2. Create a feature branch
3. Submit a pull request

All changes must pass CI checks before merging.

---

#  Roadmap

## Phase 1 — MVP

* Freshness tracking
* Delivery prediction
* Alerts

## Phase 2 — Intelligence

* Machine learning ETA improvements
* Route optimization

## Phase 3 — Platform Expansion

* Mobile app
* Real-time GPS tracking
* Marketplace integration

---

#  License

This project is licensed under the MIT License.

---

# 👩 Team & Vision

UmojaAgri is built to empower farmers, reduce food waste, and modernize agricultural logistics across Africa through accessible technology.

