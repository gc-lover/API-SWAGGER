# Task ID: API-TASK-139
**Тип:** API Generation | **Приоритет:** критический | **Статус:** queued
**Создано:** 2025-11-07 10:38 | **Создатель:** AI Agent | **Зависимости:** API-TASK-128

---

## 📋 Описание

**MVP БЛОКЕР!** Создать API для Combat Session backend. Без боевых сессий нет геймплея!

---

## 📚 Источник

**Документ:** `.BRAIN/05-technical/backend/combat-session-backend.md` (v1.0.0, ready)

**Ключевые механики:**
- Combat instance creation
- Turn order management (PvE/PvP)
- Damage calculation (урон, критические удары)
- Death handling (respawn, loot drop)
- Combat rewards (experience, loot)
- Combat logs (для анализа)
- Combat zones (PvP/PvE areas)

---

## 📁 Целевой файл

`api/v1/combat/combat-session.yaml`

---

## 🏗️ Целевая архитектура

### Backend (микросервис):

**Микросервис:** gameplay-service  
**Порт:** 8083  
**API пути:** /api/v1/combat/*

### OpenAPI (обязательно)

- Заполни `info.x-microservice` (name, port, domain, base-path, package) по данным целевого микросервиса.
- В секции `servers` оставь Production gateway `https://api.necp.game/v1` и пример локальной разработки `http://localhost:8080/api/v1`.
- WebSocket маршруты публикуй только через `wss://api.necp.game/v1/...`.

### Frontend (модуль):

**Модуль:** combat  
**Путь:** modules/combat/session  
**State Store:** useCombatStore (session, participants, combatLog)

### Frontend (библиотеки):

**UI компоненты (@shared/ui):**
- HealthBar, ActionButton, CharacterCard, CombatLog, TurnIndicator

**Готовые формы (@shared/forms):**
- N/A (action buttons)

**Layouts (@shared/layouts):**
- CombatLayout

**Хуки (@shared/hooks):**
- useRealtime (для обновления боя)

---

## ✅ Endpoints (план)

1. **POST /api/v1/combat/session/start** - Начать бой
2. **POST /api/v1/combat/session/{session_id}/action** - Выполнить действие
3. **POST /api/v1/combat/session/{session_id}/end** - Закончить бой
4. **GET /api/v1/combat/session/{session_id}** - Состояние боя
5. **GET /api/v1/combat/session/{session_id}/participants** - Участники
6. **GET /api/v1/combat/session/{session_id}/logs** - Логи боя

**Models:**
- CombatSession, CombatParticipant, CombatAction, CombatLog, CombatReward

---

## 🔍 Критерии

✅ Turn order ✅ Damage calculation ✅ Death handling ✅ Rewards ✅ Logs

---

**Источник:** `.BRAIN/05-technical/backend/combat-session-backend.md`

