# Task ID: API-TASK-137
**Тип:** API Generation | **Приоритет:** средний | **Статус:** queued
**Создано:** 2025-11-07 10:34 | **Создатель:** AI Agent | **Зависимости:** none

---

## 📋 Описание

Создать API для системы рейтингов. Global/seasonal/friend/guild leaderboards, multiple categories.

---

## 📚 Источник

**Документ:** `.BRAIN/05-technical/backend/leaderboard-system.md` (v1.0.0, ready)

**Ключевые механики:**
- Global leaderboards (все игроки)
- Seasonal leaderboards (сброс каждый сезон)
- Friend leaderboards (только друзья)
- Guild leaderboards (гильдии)
- Multiple categories (level, PvP rating, wealth, raid clears, achievements)
- Redis sorted sets (real-time updates)
- Caching для performance
- Pagination (top 100, around me)

---

## 📁 Целевой файл

`api/v1/leaderboards/leaderboards.yaml`

---

## ✅ Endpoints (план)

1. **GET /api/v1/leaderboards/{category}** - Топ игроков по категории
2. **GET /api/v1/leaderboards/{category}/me** - Позиция игрока + around
3. **GET /api/v1/leaderboards/{category}/friends** - Friend leaderboard
4. **GET /api/v1/leaderboards/{category}/guild** - Guild leaderboard
5. **GET /api/v1/leaderboards/categories** - Список категорий
6. **GET /api/v1/leaderboards/seasonal** - Seasonal leaderboards

**Models:**
- Leaderboard, LeaderboardEntry, LeaderboardCategory, LeaderboardPosition

---

## 🔍 Критерии

✅ Redis sorted sets ✅ Categories ✅ Seasonal ✅ Friends filter ✅ Pagination ✅ Caching

---

**Источник:** `.BRAIN/05-technical/backend/leaderboard-system.md`

