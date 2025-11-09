# Task ID: API-TASK-143
**Тип:** API Generation | **Приоритет:** высокий | **Статус:** queued
**Создано:** 2025-11-07 10:47 | **Создатель:** AI Agent | **Зависимости:** API-TASK-138

---

## 📋 Описание

Создать API для Main Quest D&D Nodes (9 документов). Диалоговые деревья основных квестов.

---

## 📚 Источники (9 документов)

- `.BRAIN/04-narrative/quests/main/001-first-steps-dnd-nodes.md` (v0.1.0)
- `.BRAIN/04-narrative/quests/main/002-choose-path-dnd-nodes.md` (v0.1.0)
- `.BRAIN/04-narrative/quests/main/021-corporate-wars-choose-side-dnd-nodes.md` (v0.1.0)
- `.BRAIN/04-narrative/quests/main/022-corporate-wars-operation-dnd-nodes.md` (v0.1.0)
- `.BRAIN/04-narrative/quests/main/031-street-wars-choose-gang-dnd-nodes.md` (v0.1.0)
- `.BRAIN/04-narrative/quests/main/032-street-wars-operation-dnd-nodes.md` (v0.1.0)
- `.BRAIN/04-narrative/quests/main/041-simulation-first-clues-dnd-nodes.md` (v0.1.0)
- `.BRAIN/04-narrative/quests/main/042-black-barrier-heist-dnd-nodes.md` (v0.1.0)

**Общие элементы:** Dialogue nodes, skill checks, branches, consequences.

---

## 📁 Целевая структура

```
api/v1/narrative/main-quests/
├── 001-first-steps.yaml
├── 002-choose-path.yaml
├── 021-corporate-wars-choose-side.yaml
├── 022-corporate-wars-operation.yaml
├── 031-street-wars-choose-gang.yaml
├── 032-street-wars-operation.yaml
├── 041-simulation-first-clues.yaml
└── 042-black-barrier-heist.yaml
```

---

## 🏗️ Целевая архитектура

### Backend (микросервис):

**Микросервис:** narrative-service  
**Порт:** 8087  
**API пути:** /api/v1/narrative/main-quests/*

### OpenAPI (обязательно)

- Заполни `info.x-microservice` (name, port, domain, base-path, package) по данным целевого микросервиса.
- В секции `servers` оставь Production gateway `https://api.necp.game/v1` и пример локальной разработки `http://localhost:8080/api/v1`.
- WebSocket маршруты публикуй только через `wss://api.necp.game/v1/...`.

### Frontend (модуль):

**Модуль:** narrative  
**Путь:** modules/narrative/main-quests  
**State Store:** useNarrativeStore (mainQuests, currentNode, branches)

### Frontend (библиотеки):

**UI компоненты (@shared/ui):**
- QuestCard, DialogueBox, ChoiceButton, SkillCheckDisplay, BranchIndicator

**Готовые формы (@shared/forms):**
- DialogueChoiceForm

**Layouts (@shared/layouts):**
- GameLayout

**Хуки (@shared/hooks):**
- useDebounce
- useRealtime (для синхронизации состояния квеста)

---

## ✅ Endpoints (для каждого квеста)

1. **GET /api/v1/narrative/main-quests/{quest_id}/nodes** - Dialogue nodes
2. **POST /api/v1/narrative/main-quests/{quest_id}/node/{node_id}/execute** - Execute node
3. **GET /api/v1/narrative/main-quests/{quest_id}/branches** - Available branches

**Models:** QuestNode, DialogueChoice, SkillCheckNode, BranchCondition

---

**Источники:** 9 main quest D&D nodes документов

