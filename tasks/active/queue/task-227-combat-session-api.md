# Task ID: API-TASK-227
**Тип:** API Generation
**Приоритет:** критический
**Статус:** queued
**Создано:** 2025-11-08 04:24
**Создатель:** GPT-5 Codex (API Task Creator)
**Зависимости:** API-TASK-224, API-TASK-215, API-TASK-219

---

## 📋 Краткое описание

Определить OpenAPI для боевых сессий: создание инстансов боя, управление ходами, расчёт урона, события смерти, награды и синхронизация с realtime.

**Что нужно сделать:** Создать `api/v1/combat/combat-session.yaml`, покрыв REST/WS контракты из `.BRAIN/05-technical/backend/combat-session-backend.md`.

---

## 🎯 Цель задания

Предоставить серверный API для всех боевых активностей (PvE, PvP, Raid), поддерживающий turn-based и action элементы, интеграцию с progression, loot, achievements.

**Зачем это нужно:**
- Управлять инстансами боя, синхронизацией игроков и мобов
- Расчитывать урон, эффекты, статусы, контроль толпы
- Выдавать опыт, лут, обновлять достижения и квесты
- Обеспечить лаг-компенсацию, события realtime и аналитические данные

---

## 📚 Источники информации

### Основной документ

**Путь:** `.BRAIN/05-technical/backend/combat-session-backend.md`
**Версия:** v1.0.0 (2025-11-07)
**Статус:** approved, api-readiness: ready

**Ключевые разделы:**
- Combat instance lifecycle (init, engage, resolve, cleanup)
- Turn order / action queue / tick system
- Damage calculation pipeline (base → modifiers → resistances → shields)
- Death, revive, respawn, combat end rewards
- Integration hooks: quest, achievements, clan war, analytics

### Дополнительные источники

- `.BRAIN/05-technical/backend/progression-backend.md`
- `.BRAIN/05-technical/backend/inventory-system/part2-advanced-features.md`
- `.BRAIN/05-technical/backend/loot-system/part2-advanced-loot.md`
- `.BRAIN/05-technical/backend/achievement/achievement-tracking.md`
- `.BRAIN/05-technical/backend/realtime-server/part1-architecture-zones.md`

### Связанные документы

- `API-SWAGGER/tasks/active/queue/task-215-loot-advanced-api.md`
- `API-SWAGGER/tasks/active/queue/task-219-achievement-tracking-api.md`
- `API-SWAGGER/tasks/active/queue/task-224-progression-backend-api.md`

---

## 📁 Целевая структура API

- **Файл:** `api/v1/combat/combat-session.yaml`
- **Версия API:** v1
- **Формат:** OpenAPI 3.0.3

```
API-SWAGGER/api/v1/combat/
 ├── combat-session.yaml        ← создать/обновить
 ├── combat-session-components.yaml
 └── combat-session-examples.yaml
```

---

## 🏗️ Целевая архитектура (⚠️ ОБЯЗАТЕЛЬНО)

### Backend
- **Микросервис:** combat-service
- **Порт:** 8088
- **API Base Path:** `/api/v1/combat`
- **Зависимости:**
  - progression-service – XP, skill триггеры
  - inventory-service – предметы, consumables
  - loot-service – таблицы лута, roll logic
  - achievement-service – события боёв
  - quest-service – прогресс квестов
  - realtime-service – WebSocket/UDP синхронизация
  - analytics-service – боевые отчёты
  - incident-service – анормалии, античит
  - notification-service – уведомления (kill feed, rewards)

### Frontend
- **Модуль:** `modules/combat/session`
- **State Store:** `useCombatStore`
- **State:** `session`, `participants`, `timeline`, `effects`, `loot`, `metrics`
- **UI компоненты:** `CombatHUD`, `TurnOrderTimeline`, `DamageLog`, `StatusEffectBar`, `CombatResultModal`, `RespawnPrompt`
- **Формы:** `AbilityCastForm`, `ConsumableUseForm`, `RespawnChoiceForm`
- **Хуки:** `useCombatSession`, `useTurnManager`, `useDamagePreview`, `useLagCompensation`

### Комментарий для YAML

```yaml
# Target Architecture:
# - Microservice: combat-service (port 8088)
# - API Base: /api/v1/combat
# - Dependencies: progression, inventory, loot, achievement, quest, realtime, analytics, incident, notification
# - Frontend Module: modules/combat/session (useCombatStore)
# - UI: CombatHUD, TurnOrderTimeline, DamageLog, StatusEffectBar, CombatResultModal, RespawnPrompt
# - Forms: AbilityCastForm, ConsumableUseForm, RespawnChoiceForm
# - Hooks: useCombatSession, useTurnManager, useDamagePreview, useLagCompensation
```

---

## ✅ Что нужно сделать (детальный план)

1. Описать модели боевой сессии, участников, способностей, эффектов, журнала событий.
2. Реализовать эндпоинты создания, обновления и завершения боёв.
3. Добавить контракты для действий (abilities, items), расчёта урона, применения эффектов.
4. Описать систему ходов/таймингов, лаг-компенсацию, синхронизацию.
5. Описать выдачу наград (loot, XP, achievements), аудит, incident reporting.
6. Предусмотреть GM/Designer API для симуляции, реплеев, тестов.
7. Подготовить примеры и тест-кейсы для PvE, PvP, raid.

---

## 🔀 Endpoints

1. **POST `/api/v1/combat/sessions`** – создать бой (режим, карта, участники, правила).
2. **GET `/api/v1/combat/sessions/{sessionId}`** – состояние боя, таймлайн, активные эффекты.
3. **POST `/api/v1/combat/sessions/{sessionId}/join`** – подключение игрока/бота (late join, spectate).
4. **POST `/api/v1/combat/sessions/{sessionId}/actions`** – выполнение действия (ability, item, move).
5. **POST `/api/v1/combat/sessions/{sessionId}/turn/end`** – завершение хода, переход следующему.
6. **POST `/api/v1/combat/sessions/{sessionId}/damage/preview`** – расчёт предварительного урона (client prediction).
7. **POST `/api/v1/combat/sessions/{sessionId}/lag-compensation`** – запрос пересчёта события (hit registration).
8. **POST `/api/v1/combat/sessions/{sessionId}/revive`** – воскрешение игрока (условия, таймеры).
9. **POST `/api/v1/combat/sessions/{sessionId}/surrender`** – сдача команды (голосование, условия).
10. **POST `/api/v1/combat/sessions/{sessionId}/complete`** – завершение боя, выдача наград, отчёты.
11. **POST `/api/v1/combat/sessions/{sessionId}/abort`** – аварийное завершение (incident, rollback).
12. **GET `/api/v1/combat/sessions/{sessionId}/log`** – журнал событий, урон, способности.
13. **GET `/api/v1/combat/sessions/{sessionId}/metrics`** – аналитика: DPS, HPS, taken damage, uptime.
14. **POST `/api/v1/combat/sessions/{sessionId}/simulate`** – симуляция боя (AI test, balance).
15. **WS `/api/v1/combat/sessions/{sessionId}/stream`** – события: `action-executed`, `turn-start`, `damage-applied`, `status-updated`, `participant-dead`, `session-completed`.

---

## 🧱 Модели данных

- **CombatSession** – `sessionId`, `mode`, `map`, `status`, `startTime`, `rules`, `settings`.
- **Participant** – `participantId`, `playerId|npcId`, `team`, `class`, `stats`, `resources`, `position`.
- **Action** – `actionId`, `type`, `abilityId`, `caster`, `target`, `cooldown`, `castTime`, `channeling`.
- **DamagePacket** – `base`, `critical`, `resistance`, `final`, `overkill`, `source`, `tags`.
- **StatusEffect** – `effectId`, `type`, `duration`, `stacks`, `source`, `modifiers`.
- **CombatLogEntry** – `timestamp`, `eventType`, `payload`.
- **RewardBundle** – `xp`, `currency`, `items`, `achievements`, `ratingChange`, `reputation`.
- **LagCompensationRequest** – `eventId`, `clientTimestamp`, `position`, `latency`, `result`.
- **RealtimeEventPayload** – `actionExecuted`, `turnStart`, `damageApplied`, `statusUpdated`, `participantDead`, `sessionCompleted`.
- **Error Schema (`CombatError`)** – codes (`SESSION_NOT_FOUND`, `ACTION_DENIED`, `OUT_OF_TURN`, `LAG_COMPENSATION_FAILED`, `REVIVE_BLOCKED`, `SURRENDER_PENDING`, `SIMULATION_ERROR`).

---

## 🧭 Принципы и правила

- Авторизация: `BearerAuth`; сервисные токены для GM/analytics.
- Idempotency: действие и лаг-компенсация должны поддерживать повтор.
- Anti-cheat: server authoritative, incident-запись и verification.
- Лаг-компенсация: хранить историю состояний, применять rewinds.
- Баланс: симуляции должны логироваться.
- DRY: использовать shared компоненты (responses, pagination, events).

---

## 🧪 Примеры

- Создание рейдовой сессии с 10 игроками и боссом.
- Выполнение ability с DoT эффектом и применением лаг-компенсации.
- Сдача команды с голосованием и расчётом штрафов.
- Завершение боя и выдача лута/опыта/ачивок.
- Симуляция боя для QA с анализом метрик.

---

## 🔗 Связности и зависимости

- Интеграция с progression, loot, quest, achievement, realtime, analytics.
- Используется UI Combat HUD и Realtime клиентом.
- Триггерит события для clan wars, leaderboards, daily quests.

---

## ✅ Критерии приемки

1. `combat-session.yaml` описывает полный жизненный цикл боёв.
2. Добавлены модели, события, ошибки, интеграции.
3. Подготовлены примеры, тест-кейсы, чеклист.

---

## 📎 Checklist

- [ ] Использован шаблон `api-generation-task-template.md`
- [ ] Определены микросервис, UI модуль, зависимости
- [ ] Эндпоинты и события покрывают все сценарии боёв
- [ ] Добавлены модели, ошибки, примеры, критерии
- [ ] Обновить `tasks/config/brain-mapping.yaml`

---

## ❓FAQ

**Q:** Поддерживается ли asynchronous combat?**
**A:** Да, предусмотреть режим `async` (play-by-mail), описать в настройках сессии и endpoint `turn/end`.

**Q:** Как хранить реплеи?**
**A:** Логировать combat log и state snapshots; описать ссылку на `replayId` в `CombatSession`.


