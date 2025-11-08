# Task ID: API-TASK-138
**Тип:** API Generation | **Приоритет:** критический | **Статус:** queued
**Создано:** 2025-11-07 10:36 | **Создатель:** AI Agent | **Зависимости:** API-TASK-127

---

## 📋 Описание

**MVP БЛОКЕР!** Создать API для Quest Engine backend. Без квестового движка нет контента!

---

## 📚 Источник

**Документ:** `.BRAIN/05-technical/backend/quest-engine-backend.md` (v1.0.0, ready)

**Ключевые механики:**
- Quest state machine (tracking quest states)
- Dialogue tree execution (branching dialogues)
- Skill check processing (D&D dice rolls)
- Branch selection (player choices)
- Condition evaluation (quest requirements)
- Reward distribution
- Quest instance management

---

## 📁 Целевой файл

`api/v1/quests/quest-engine.yaml`

---

## 🏗️ Целевая архитектура

### Backend (микросервис):

**Микросервис:** narrative-service  
**Порт:** 8087  
**API пути:** /api/v1/quests/*

### OpenAPI (обязательно)

- Заполни `info.x-microservice` (name, port, domain, base-path, package) по данным целевого микросервиса.
- В секции `servers` оставь Production gateway `https://api.necp.game/v1` и пример локальной разработки `http://localhost:8080/api/v1`.
- WebSocket маршруты публикуй только через `wss://api.necp.game/v1/...`.

### Frontend (модуль):

**Модуль:** narrative  
**Путь:** modules/narrative/quests  
**State Store:** useNarrativeStore (activeQuests, questProgress, dialogueState)

### Frontend (библиотеки):

**UI компоненты (@shared/ui):**
- QuestCard, DialogueBox, ChoiceButton, SkillCheckDisplay

**Готовые формы (@shared/forms):**
- QuestAcceptForm, ChoiceSelectionForm

**Layouts (@shared/layouts):**
- GameLayout

**Хуки (@shared/hooks):**
- useDebounce
- useRealtime (для quest updates)

---

## ✅ Endpoints (план)

1. **POST /api/v1/quests/{quest_id}/start** - Начать квест
2. **POST /api/v1/quests/{quest_id}/progress** - Обновить прогресс
3. **POST /api/v1/quests/{quest_id}/complete** - Завершить квест
4. **POST /api/v1/quests/{quest_id}/dialogue/{node_id}** - Выполнить dialogue node
5. **POST /api/v1/quests/{quest_id}/skill-check** - Выполнить skill check (D&D)
6. **POST /api/v1/quests/{quest_id}/choice** - Сделать выбор
7. **GET /api/v1/quests/instances/active** - Активные квесты персонажа

**Models:**
- QuestInstance, DialogueState, SkillCheckResult, QuestChoice

---

## 🔍 Критерии

✅ State machine ✅ D&D checks ✅ Branching ✅ Rewards ✅ Instance management

---

**Источник:** `.BRAIN/05-technical/backend/quest-engine-backend.md`

