# Task ID: API-TASK-361
**Тип:** API Update
**Приоритет:** критический
**Статус:** queued
**Создано:** 2025-11-08 21:45
**Создатель:** AI Agent (GPT-5 Codex)
**Зависимости:** [API-TASK-074], [API-TASK-173]

---

## 📋 Краткое описание

Обновить спецификацию `api/v1/technical/global-state.yaml`, чтобы она отражала актуальный контур синхронизации глобального состояния (REST + WebSocket) после перехода на gateway `https://api.necp.game/v1` и новые стратегии конфликтов.

**Что нужно сделать:** Переработать спецификацию Global State Sync, добавить модели конфликтов, persistence (WAL + outbox), event replay, а также задокументировать новые WebSocket каналы (`/ws/player`, `/ws/world`, `/ws/economy`, `/ws/combat`).

---

## 🎯 Цель задания

Синхронизировать backend и документацию по глобальному состоянию, чтобы девопс-команда и геймплей сервисы имели единый интерфейс для чтения/записи состояния, воспроизведения событий и подписки на обновления.

**Зачем это нужно:**
- Гарантировать, что `world-service` обрабатывает все типы состояний (server-wide, player-specific, phased) с корректной конфликтной логикой.
- Обеспечить надежное восстановление состояния через WAL/Event Replay и документировать идемпотентность.
- Предоставить администраторам API для безопасного запуска replay/sync операций и мониторинга прогресса через WebSocket.

---

## 📚 Источники информации

### Основной источник концепции

**Репозиторий:** `.BRAIN`

**Путь к документу:** `.BRAIN/05-technical/global-state/global-state-sync.md`

**Версия документа:** v1.0.0

**Дата последнего обновления:** 2025-11-08 12:20

**Статус документа:** approved (api-readiness: ready)

**Что важно из этого документа:**
- Три модели состояния (server-wide, player-specific, phased) и их характеристики (consistency, visibility).
- Четыре стратегии разрешения конфликтов (Last Write Wins, Voting, Event Versioning, Merge).
- Persistence: WAL, transactional outbox, идемпотентность (таблицы `event_outbox`, `processed_events`).
- Event Replay (use cases, batch engine) и WebSocket каналы (`/ws/player/{playerId}`, `/ws/world/{serverId}`, `/ws/economy/{serverId}`, `/ws/combat/{sessionId}`).
- Новый Production домен `wss://api.necp.game/v1` и требование синхронизации с gateway.

### Дополнительные источники

- `.BRAIN/05-technical/global-state/global-state-core.md` — базовые сущности и домены состояния.
- `.BRAIN/05-technical/global-state/global-state-events.md` — каталог событий и их payload.
- `.BRAIN/05-technical/global-state/global-state-management.md` — процедуры администрирования и SLA.
- `.BRAIN/05-technical/global-state/global-state-operations.md` — эксплуатационные сценарии и алерты.
- `API-SWAGGER/api/v1/technical/global-state-extended.yaml` — расширенное API, нужно сохранить совместимость.

### Связанные документы

- `API-SWAGGER/api/v1/technical/realtime-server.yaml` — взаимодействие с realtime-сервером.
- `API-SWAGGER/api/v1/world/world-interaction-suite.yaml` — потребители мировых событий.
- `API-SWAGGER/tasks/active/queue/task-241-world-interaction-suite-api.md` — контекст World Pulse.

---

## 📁 Целевая структура API

### Репозиторий: `API-SWAGGER`

**Целевой файл:** `api/v1/technical/global-state.yaml`
> ⚠️ Существующий файл необходимо обновить. Увеличить `info.version` (например, `1.1.0`), сохранить базовые пути, расширив функциональность.

**API версия:** v1 (minor bump)

**Тип файла:** OpenAPI 3.0.3 (YAML)

**Структура директории:**
```
API-SWAGGER/
└── api/
    └── v1/
        └── technical/
            ├── global-state.yaml      ← обновить
            └── global-state-extended.yaml
```

**Важно:**
- Использовать только gateway URLs (`https://api.necp.game/v1`, `http://localhost:8080/api/v1`).
- Вынести крупные схемы в `api/v1/technical/components/`, если файл превысит 400 строк.

---

## 🏗️ Целевая архитектура (⚠️ ОБЯЗАТЕЛЬНО)

### Backend (микросервис)

- **Целевой микросервис:** `world-service`
- **Порт:** 8086
- **API Base Path:** `/api/v1/technical/global-state/*`
- **Домен:** мировое состояние и синхронизация (world domain)
- **Зависимости:** `auth-service` (JWT), `gameplay-service` (combat), `economy-service` (рынок), Kafka topics (`world.unrest.updates`, `economy.price.changed`), Redis (session cache)

### Frontend (модуль)

- **Целевой модуль:** `modules/world/state-sync`
- **State Store:** `useWorldStore` (globalState slice)
- **UI компоненты (@shared/ui):** `StateSyncDashboard`, `StateTimeline`, `ConflictResolutionCard`, `ReplayJobTile`
- **Формы (@shared/forms):** `StateReplayForm`, `ConflictPolicyForm`
- **Layouts (@shared/layouts):** `WorldOpsLayout`
- **Хуки (@shared/hooks):** `useRealtime`, `usePolling`, `useToast`

### Комментарий для OpenAPI файла

Добавить в начале файла:
```
# Target Architecture:
# - Microservice: world-service (port 8086)
# - Base Path: /api/v1/technical/global-state
# - Frontend Module: modules/world/state-sync
# - UI: @shared/ui (StateSyncDashboard, StateTimeline, ConflictResolutionCard, ReplayJobTile)
# - Forms: @shared/forms (StateReplayForm, ConflictPolicyForm)
# - Layout: WorldOpsLayout | Hooks: useWorldStore, useRealtime, usePolling
# - WebSocket: wss://api.necp.game/v1/ws/world/{serverId}
```

`info.x-microservice` обязательно обновить:
```
info:
  x-microservice:
    name: world-service
    port: 8086
    domain: world
    base-path: /api/v1/technical/global-state
    package: com.necpgame.worldservice
```

---

## ✅ Что нужно сделать (детальный план)

1. **Анализ текущей спецификации**  
   Просмотреть текущий `global-state.yaml`, определить устаревшие части (старые URL, отсутствие WebSocket описаний, конфликтных стратегий).  
   _Результат:_ список изменений, согласованный с документом `.BRAIN`.

2. **Расширение ресурсов и моделей**  
  Добавить сущности `ServerWideState`, `PlayerState`, `PhasedState`, `ConflictPolicy`, `ReplayJob`, `OutboxRecord`, `ProcessedEvent`, `StateEvent`. Обновить примеры, описать enum стратегий.  
  _Результат:_ обновлённый `components/schemas` с валидными `required`, `enum`, `format`, `example`.

3. **Актуализация endpoints**  
  Дополнить/создать маршруты для чтения снапшотов, применения событий, управления конфликтами, запуска replay, запросов по фазам и подписки на WebSocket. Документировать параметры (`stateDomain`, `phaseId`, `version`).  
  _Результат:_ секция `paths` с расширенной функциональностью и ссылками на общие ответы.

4. **Документация realtime**  
  Описать WebSocket каналы (`/ws/player/{playerId}`, `/ws/world/{serverId}`, `/ws/economy/{serverId}`, `/ws/combat/{sessionId}`), payload `StateChangedEvent`, `ReplayProgressEvent`. Добавить ссылку `x-websocket` и указать `security` (Keycloak scopes).  
  _Результат:_ документация realtime каналов в OpenAPI (`components/messages` или `x-websocket` секция).

5. **Валидация и совместимость**  
  Обновить `servers`, убедиться, что `shared/common/responses.yaml` используется для ошибок, провести `validate-swagger.ps1`, проверить, что `global-state-extended.yaml` остаётся совместимым (ссылки/`$ref`).  
  _Результат:_ валидный YAML ≤400 строк, структура соответствует генератору.

---

## 🔀 Endpoints (ожидаемые изменения)

- **GET `/technical/global-state/domains`** — возвращает список доступных доменов состояния и их описание (server-wide, player, phased). Ответ `200` с `StateDomainList`.

- **GET `/technical/global-state/server`** — получает snapshot серверного состояния (территории, глобальные события, economy). Поддерживает фильтры `region`, `includeMetrics`. Ответ `200` с `ServerWideState`.

- **POST `/technical/global-state/server/events`** — применяет событие (payload `StateEvent`) к глобальному состоянию, учитывая стратегию конфликта. Возвращает `202` с `EventAck` (содержит `version`, `conflictResolution`). Ошибки `409` (конфликт версии), `422` (неизвестный domain).

- **GET `/technical/global-state/player/{playerId}`** — возвращает состояние игрока (quests, flags, inventory, skills). Может использовать query `includePhases=true`. Ответ `200` с `PlayerState`.

- **POST `/technical/global-state/player/{playerId}/events`** — атомарно обновляет состояние игрока с optimistic locking (`expectedVersion`). Ответ `200` с `PlayerState`.

- **POST `/technical/global-state/phases/{phaseId}/transition`** — переводит игрока или группу в новую фазу. Тело `PhaseTransitionRequest`, ответ `202` с `PhaseTransitionJob`.

- **POST `/technical/global-state/conflicts/resolve`** — явное разрешение конфликтов (например, голосование). Тело `ConflictResolutionRequest`, ответ `200` с `ConflictResolutionResult` (содержит результаты голосования, применённую стратегию).

- **POST `/technical/global-state/events/replay`** — запускает replay (payload `ReplayRequest`). Ответ `202` с `ReplayJob` (jobId, статус, прогресс). Прогресс транслируется через WebSocket `StateReplayEvent`.

- **GET `/technical/global-state/events/replay/{jobId}`** — статус replay job, ответ `200` с `ReplayJob`. Ошибка `404`.

- **GET `/technical/global-state/outbox`** — пагинированный список записей outbox (`shared/pagination.yaml#/CursorPagination`). Ответ `200` с `OutboxRecordPage`.

- **DELETE `/technical/global-state/processed-events/{eventId}`** — очистка идемпотентных записей (admin). Ответ `204`.

Все ошибки ссылаться на `../../shared/common/responses.yaml`. Для листингов использовать `shared/common/pagination.yaml`.

---

## 🧱 Модели данных

- **StateDomain** — `key` (enum `server`, `player`, `phased`), `description`, `consistencyModel` (`eventual`, `strong`), `websocketChannel`.
- **ServerWideState** — `territories`, `npcFates`, `economy`, `globalEvents`, `version`, `updatedAt`.
- **PlayerState** — `playerId`, `quests`, `flags`, `inventory`, `attributes`, `skills`, `version`, `lastSync`.
- **PhasedState** — `phaseId`, `players`, `phaseSnapshot`, `visibility`, `version`.
- **StateEvent** — `eventId` (UUID), `domain`, `stateKey`, `payload`, `strategy` (enum `LAST_WRITE_WINS`, `VOTING`, `EVENT_VERSIONING`, `MERGE`), `expectedVersion`, `metadata`.
- **ConflictResolutionRequest** — `eventId`, `strategy`, `votes`, `mergeOperands`.
- **ConflictResolutionResult** — `resolution`, `appliedStrategy`, `finalValue`, `versionAfter`, `auditTrail`.
- **ReplayRequest** — `serverId`, `from`, `to`, `batchSize`, `dryRun`.
- **ReplayJob** — `jobId`, `status` (enum `queued`, `running`, `completed`, `failed`), `processedEvents`, `totalEvents`, `startedAt`, `completedAt`, `errors`.
- **OutboxRecord** — `id`, `eventId`, `eventType`, `stateChanges`, `createdAt`, `publishedAt`, `isPublished`.
- **ProcessedEvent** — `eventId`, `processedAt`, `processorId`, `retentionUntil`.
- **StateChangedEvent (WebSocket)** — `messageType`, `timestamp`, `stateDomain`, `stateKey`, `previousValue`, `newValue`, `version`, `eventId`, `affectedPlayers`.
- **ReplayProgressEvent (WebSocket)** — `jobId`, `processedEvents`, `totalEvents`, `percentage`, `status`, `lastEventId`.

Везде добавить `example`, `format`, `required`, использовать `allOf` при наследовании.

---

## ⚖️ Принципы и правила

- OpenAPI 3.0.3, ошибки через `shared/common/responses.yaml`, пагинация через `shared/common/pagination.yaml`.
- Обновить `servers` (только gateway), удалить прямые URL сервисов.
- Обязательные описания enum значений (включая конфликтные стратегии).
- WebSocket Каналы документировать в `components/x-websocket` (или через `x-webhooks`), payload описывать в `components/schemas`.
- Соблюдать лимит 400 строк; при необходимости вынести схемы.
- Поддержать обратную совместимость для клиентов (`paths` не ломать), новые операции добавлять без удаления существующих.
- Указать OAuth2 scopes (`world.state:read`, `world.state:write`, `world.state:admin`) из `shared/common/security.yaml`.

---

## ✅ Критерии приемки

1. `api/v1/technical/global-state.yaml` обновлён, `info.version` повышен, `info.x-microservice` соответствует `world-service` (порт 8086, base-path `/api/v1/technical/global-state`).
2. В `servers` присутствуют только `https://api.necp.game/v1` и `http://localhost:8080/api/v1`.
3. Добавлены/актуализированы endpoints для server/player/phased state, управления конфликтами, replay, outbox, processed events.
4. Все новые модели (`StateEvent`, `ConflictResolutionResult`, `ReplayJob`, `StateChangedEvent`) описаны с `required`, `enum`, `examples`.
5. WebSocket каналы (`/ws/player/{playerId}`, `/ws/world/{serverId}`, `/ws/economy/{serverId}`, `/ws/combat/{sessionId}`) задокументированы, payload вынесен в `components/schemas`.
6. Конфликтные стратегии отражены и в REST (`strategy` поле) и в примерах (Last Write Wins, Voting, Event Versioning, Merge).
7. Persistence слой (WAL, outbox, processed_events) описан через соответствующие модели и endpoints (outbox list, processed events cleanup).
8. Replay механика документирована (POST `/events/replay`, GET `/events/replay/{jobId}`, WS `ReplayProgressEvent`).
9. Все ответы об ошибках используют `$ref` на `shared/common/responses.yaml`.
10. Пагинация outbox реализована через `shared/common/pagination.yaml#/CursorPagination`.
11. Спецификация валидируется `validate-swagger.ps1`, generator `generate-openapi-microservices.ps1` успешно проходит блок `world-service`.
12. Примеры payload используют реальные значения из `.BRAIN` (топики `world.unrest.updates`, структура stateChange и т.д.).

---

## ❓ FAQ

**Q:** Нужно ли описывать все WebSocket события из документа?  
**A:** Да, опишите базовые payload (`STATE_CHANGED`, `REPLAY_PROGRESS`) и приведите перечень eventType (`world.territory.captured`, `economy.price.changed`, `combat.damage.dealt`).

**Q:** Что делать с существующими endpoint'ами?  
**A:** Не удалять. Расширяйте описания, добавляйте новые параметры (`expectedVersion`, `strategy`). Если endpoint устарел — пометьте `deprecated: true`, указав замену.

**Q:** Как отражать голосование (voting)?  
**A:** Используйте `ConflictResolutionRequest` с массивом `votes` и укажите в результатах победившее значение, проценты и quorum. Добавьте пример.

**Q:** Нужно ли описывать Kafka топики в спецификации?  
**A:** Да, в моделях (`StateEvent`, `OutboxRecord`) перечислите ожидаемые топики и укажите pattern. Для WebSocket отметьте, что события также публикуются в Kafka.

**Q:** Как документировать ограничения по batch размерам?  
**A:** Укажите `minimum`/`maximum` (например, `batchSize` 100–5000) и добавьте описание в параметрах Replay API и в FAQ.
