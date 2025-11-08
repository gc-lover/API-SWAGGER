# Task ID: API-TASK-140
**Тип:** API Generation | **Приоритет:** критический | **Статус:** queued
**Создано:** 2025-11-07 10:40 | **Создатель:** AI Agent | **Зависимости:** API-TASK-127

---

## 📋 Описание

**MVP БЛОКЕР!** Создать API для Progression backend. Без системы прокачки нет прогрессии!

---

## 📚 Источник

**Документ:** `.BRAIN/05-technical/backend/progression-backend.md` (v1.0.0, ready)

**Ключевые механики:**
- Experience calculation/award
- Level up logic (формулы exp)
- Attribute points distribution
- Skill experience tracking
- Skill level up
- Class progression
- Rebirth system

---

## 📁 Целевой файл

`api/v1/progression/progression-engine.yaml`

---

## 🏗️ Целевая архитектура

### Backend (микросервис):

**Микросервис:** gameplay-service  
**Порт:** 8083  
**API пути:** /api/v1/progression/*

### OpenAPI (обязательно)

- Заполни `info.x-microservice` (name, port, domain, base-path, package) по данным целевого микросервиса.
- В секции `servers` оставь Production gateway `https://api.necp.game/v1` и пример локальной разработки `http://localhost:8080/api/v1`.
- WebSocket маршруты публикуй только через `wss://api.necp.game/v1/...`.

### Frontend (модуль):

**Модуль:** progression  
**Путь:** modules/progression/leveling  
**State Store:** useProgressionStore (level, experience, attributes, skills)

### Frontend (библиотеки):

**UI компоненты (@shared/ui):**
- ProgressBar (exp bar), LevelProgress, StatBlock, SkillTree

**Готовые формы (@shared/forms):**
- AttributeAssignmentForm, SkillUpgradeForm

**Layouts (@shared/layouts):**
- GameLayout

**Хуки (@shared/hooks):**
- useRealtime (для level up notification)

---

## ✅ Endpoints (план)

1. **POST /api/v1/progression/experience/award** - Начислить exp (internal)
2. **POST /api/v1/progression/level-up** - Level up персонажа
3. **POST /api/v1/progression/attributes/assign** - Распределить attribute points
4. **POST /api/v1/progression/skills/experience** - Начислить skill exp
5. **GET /api/v1/progression/character/{character_id}** - Прогресс персонажа
6. **GET /api/v1/progression/level-requirements** - Требования exp для уровней

**Models:**
- ProgressionData, ExperienceAward, LevelUpResult, AttributeAssignment, SkillProgress

---

## 🔍 Критерии

✅ Exp formulas ✅ Level up ✅ Attributes ✅ Skills ✅ Validation

---

**Источник:** `.BRAIN/05-technical/backend/progression-backend.md`

