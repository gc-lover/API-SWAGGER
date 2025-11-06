# Task ID: API-TASK-136
**Тип:** API Generation | **Приоритет:** средний | **Статус:** queued
**Создано:** 2025-11-07 10:32 | **Создатель:** AI Agent | **Зависимости:** none

---

## 📋 Описание

Создать API для системы достижений. Achievement definitions, progress tracking, unlock rewards.

---

## 📚 Источник

**Документ:** `.BRAIN/05-technical/backend/achievement-system.md` (v1.0.0, ready)

**Ключевые механики:**
- Achievement definitions (цели и требования)
- Progress tracking (event-driven)
- Unlock rewards (titles, badges, stats)
- Notifications при разблокировке
- Categories (combat, social, exploration, economy, quests)
- Rarity (common → legendary)
- Achievement points system

---

## 📁 Целевой файл

`api/v1/achievements/achievements.yaml`

---

## 🏗️ Целевая архитектура

### Backend (микросервис):

**Микросервис:** gameplay-service  
**Порт:** 8083  
**API пути:** /api/v1/achievements/*

### Frontend (модуль):

**Модуль:** progression  
**Путь:** modules/progression/achievements  
**State Store:** useProgressionStore (achievements, achievementProgress)

### Frontend (библиотеки):

**UI компоненты (@shared/ui):**
- Card, AchievementCard, Badge (rarity), ProgressBar (progress)

**Готовые формы (@shared/forms):**
- N/A (только просмотр)

**Layouts (@shared/layouts):**
- GameLayout

**Хуки (@shared/hooks):**
- useRealtime (для уведомлений о разблокировке)

---

## ✅ Endpoints (план)

1. **GET /api/v1/achievements** - Список всех достижений
2. **GET /api/v1/achievements/my** - Прогресс игрока по всем ачивкам
3. **GET /api/v1/achievements/{achievement_id}** - Детали достижения
4. **POST /api/v1/achievements/{achievement_id}/progress** - Обновить прогресс (internal)
5. **GET /api/v1/achievements/categories** - Достижения по категориям
6. **GET /api/v1/achievements/recent** - Недавно разблокированные

**Models:**
- Achievement, AchievementProgress, AchievementReward, AchievementCategory

---

## 🔍 Критерии

✅ Event-driven tracking ✅ Categories ✅ Rarity levels ✅ Rewards ✅ Notifications

---

**Источник:** `.BRAIN/05-technical/backend/achievement-system.md`

