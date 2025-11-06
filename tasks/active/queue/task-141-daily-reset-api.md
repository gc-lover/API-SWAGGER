# Task ID: API-TASK-141
**Тип:** API Generation | **Приоритет:** средний | **Статус:** queued
**Создано:** 2025-11-07 10:42 | **Создатель:** AI Agent | **Зависимости:** none

---

## 📋 Описание

Создать API для системы автоматических сбросов. Daily/weekly resets для quests, rewards, limits.

---

## 📚 Источник

**Документ:** `.BRAIN/05-technical/backend/daily-weekly-reset-system.md` (v1.0.0, ready)

**Ключевые механики:**
- Daily resets (ежедневные сбросы)
- Weekly resets (еженедельные сбросы)
- Reset scope (quests, rewards, limits, bonuses, currencies)
- Scheduled jobs (Spring @Scheduled, cron expressions)
- Timezone handling (UTC)
- Reset notifications (уведомления игрокам)

---

## 📁 Целевой файл

`api/v1/system/reset-system.yaml`

---

## ✅ Endpoints (план)

1. **GET /api/v1/system/reset/daily/next** - Время до daily reset
2. **GET /api/v1/system/reset/weekly/next** - Время до weekly reset
3. **GET /api/v1/system/reset/status** - Статус reset систем
4. **POST /api/v1/system/reset/trigger** - Trigger reset (admin/dev)

**Models:**
- ResetInfo, ResetStatus, ResetHistory

---

## 🔍 Критерии

✅ Cron jobs ✅ Timezone UTC ✅ Notifications ✅ Daily/weekly scopes

---

**Источник:** `.BRAIN/05-technical/backend/daily-weekly-reset-system.md`

