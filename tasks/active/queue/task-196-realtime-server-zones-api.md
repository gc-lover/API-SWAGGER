# Task ID: API-TASK-196
**Тип:** API Generation
**Приоритет:** критический
**Статус:** queued
**Создано:** 2025-11-07 17:05
**Создатель:** GPT-5 Codex (API Task Creator)
**Зависимости:** API-TASK-111 (базовый realtime-server.yaml)

---

## 📋 Краткое описание

Создать подробную спецификацию управления realtime-инстансами и зонами.

**Что нужно сделать:** Сформировать OpenAPI для сервиса распределения зон, регистрации realtime-инстансов, интерес-менеджмента и эвакуации игроков на основе документа `part1-architecture-zones.md`.

---

## 🎯 Цель задания

Расширить Realtime API, покрыв серверную архитектуру и управление зонами Night City:
- Регистрация и мониторинг `Game Server Instance`
- Автономное распределение зон и балансировку нагрузки
- Поддержку Area of Interest (cells) и snapshot-инструменты
- Процедуры эвакуации игроков при перезагрузке инстансов
- Интеграцию с Redis/Global State и Event Bus

**Зачем это нужно:**
- Подготовить backend для масштабируемого MMORPG геймплея (500-2000 игроков на инстанс)
- Дать Ops-команде API для живого управления зонами и анализом производительности
- Задокументировать контракты для генерации SDK и Orchestration UI

---

## 📚 Источники информации

### Основной источник концепции

**Репозиторий:** `.BRAIN`
**Путь к документу:** `.BRAIN/05-technical/backend/realtime-server/part1-architecture-zones.md`
**Версия документа:** v1.0.1
**Дата последнего обновления:** 2025-11-07
**Статус документа:** approved

**Что важно из этого документа:**
- Структура `Game Server Instance`, tick-rate 20-60/sec, pipeline действий
- Модели зон (`zones`), лимиты по игрокам, PVP/Safe-zone флаги
- Interest Management через `zone cells` (100x100 m, Redis)
- Процессы эвакуации, перераспределения зон, health-check
- Требования к метрикам и предупреждениям при превышении 50ms/tick

### Дополнительные источники

- `.BRAIN/05-technical/backend/realtime-server/part2-protocol-optimization.md` – сообщения протокола и лаг-компенсация
- `.BRAIN/05-technical/backend/session-management/part1-lifecycle-heartbeat.md` – контроль игровых сессий
- `.BRAIN/05-technical/backend/global-state/global-state-sync.md` – единый кэш состояний
- `.BRAIN/05-technical/backend/incident-response/incident-response.md` – уведомления об авариях
- `.BRAIN/05-technical/backend/party-system.md` – party переселения между зонами

### Связанные документы

- `.BRAIN/05-technical/backend/voice-lobby/voice-lobby-system.md` (события эвакуации)
- `.BRAIN/05-technical/backend/api-gateway/gateway-routing.md`
- `.BRAIN/05-technical/backend/matchmaking/matchmaking-queue.md`

---

## 📁 Целевая структура API

### Репозиторий: `API-SWAGGER`

**Целевой файл:** `api/v1/technical/realtime/server-zones.yaml`
**API версия:** v1
**Тип файла:** OpenAPI 3.0 Specification (YAML)

**Структура директории:**
```
API-SWAGGER/
└── api/
    └── v1/
        └── technical/
            └── realtime/
                ├── realtime-server.yaml            # существующий core
                ├── server-zones.yaml               # ← создать/заполнить
                └── realtime-protocol.yaml          # (будет для Part 2)
```

**Если файл уже существует:** Обновить в рамках этого задания, сохраняя версию (минимум 1.0.0 → 1.1.0 при расширении).

---

## 🏗️ Целевая архитектура (⚠️ ОБЯЗАТЕЛЬНО)

### Backend (микросервисная архитектура)

- **Целевой микросервис:** realtime-service
- **Порт:** 8089
- **API Base Path:** `/api/v1/technical/realtime/*`
- **Домен:** Управление realtime-инстансами, зонами и интерес-менеджментом
- **Зависимости:**
  - auth-service (валидация сервисных токенов)
  - session-service (активные игровые сессии)
  - global-state-service (Redis/PG sync)
  - incident-service (алерты по SLA)
  - matchmaking-service (нагрузка по очередям)

### Frontend (модульная архитектура)

- **Модуль:** `modules/ops/realtime-monitoring`
- **State Store:** `useOpsStore`
- **State:** `realtimeInstances`, `zoneAssignments`, `cellHeatmap`
- **UI компоненты:** `RealtimeInstanceCard`, `ZoneAllocationTable`, `TickRateChart`, `CellHeatmap`
- **Формы:** `ZoneTransferForm`, `InstanceRegistrationForm`, `EvacuationPlanForm`
- **Layouts:** `OpsConsoleLayout`, `GameMonitoringLayout`
- **Хуки:** `useRealtime`, `usePolling`, `useEventStream`

### Комментарий для OpenAPI файла

В начале файла добавить блок:

```yaml
# Target Architecture:
# - Microservice: realtime-service (port 8089)
# - API Base: /api/v1/technical/realtime
# - Dependencies: auth-service, session-service, global-state-service, incident-service, matchmaking-service
# - Frontend Module: modules/ops/realtime-monitoring (useOpsStore.realtimeInstances)
# - UI: RealtimeInstanceCard, ZoneAllocationTable, TickRateChart, CellHeatmap
# - Forms: ZoneTransferForm, InstanceRegistrationForm, EvacuationPlanForm
# - Layouts: OpsConsoleLayout, GameMonitoringLayout
# - Hooks: useRealtime, usePolling, useEventStream
```

---

## ✅ Что нужно сделать (детальный план)

### Шаг 1: Сбор требований
- Разобрать разделы Game Server Instance, Zone Management, Interest Management, Player Sync
- Зафиксировать все параметры, лимиты и статусы (tick-rate, max players, статус зоны)
- Определить взаимодействия с Redis и Event Bus для дополнительных схем

### Шаг 2: Проектирование REST API
- Спроектировать набор `paths` под `/api/v1/technical/realtime`
- Выделить контракт для регистрации инстансов, heartbeat и метрик
- Описать управление зонами (просмотр, перенос, эвакуация, конфигурация)
- Добавить debug/ops endpoints (snapshot cell, performance alerts)

### Шаг 3: Модели данных
- Создать схемы `RealtimeInstance`, `RealtimeInstanceRegistration`, `RealtimeInstanceHeartbeat`, `RealtimeInstanceMetrics`
- Создать схемы `Zone`, `ZoneAssignment`, `ZoneTransferRequest`, `ZoneState`, `ZoneCellSummary`, `ZoneCellSnapshot`
- Описать `PlayerRelocationRequest`, `EvacuationPlan`, `InterestAreaConfig`

### Шаг 4: Документация и примеры
- Для каждого endpoint добавить подробный `description` с бизнес-логикой
- Включить примеры JSON (success/ошибки) с реальными значениями
- Указать SLA: tick > 50ms → warning, capacity > 85% → high load

### Шаг 5: Интеграции и события
- Добавить раздел `components/schemas` для событий (`realtime.instance.overloaded`, `realtime.zone.reassigned`, `realtime.player.evacuated`)
- Указать использование Redis ключей (`zone_cell:{zone}:{x}:{y}`), описать формат keys в комментариях
- Настроить `callbacks` или `x-events` для уведомлений Ops UI

### Шаг 6: Проверка и чеклист
- Пройти `tasks/config/checklist.md`
- Подготовить FAQ и тест-план (нагрузочное тестирование, симуляция эвакуации)
- Обновить версию и ссылки на связанные спецификации (`realtime-server.yaml`)

---

## 🔀 Endpoints

1. **POST `/api/v1/technical/realtime/instances`** – регистрация нового realtime-инстанса (instanceId, zones, tickRate)
2. **GET `/api/v1/technical/realtime/instances`** – список инстансов с фильтрами `status`, `region`, `tickRate`
3. **GET `/api/v1/technical/realtime/instances/{instanceId}`** – детальная информация, активные игроки, зоны, SLA
4. **PATCH `/api/v1/technical/realtime/instances/{instanceId}`** – обновить статус (`ONLINE`, `MAINTENANCE`, `DRAINING`), лимиты, приоритет
5. **POST `/api/v1/technical/realtime/instances/{instanceId}/heartbeat`** – heartbeat с текущей загрузкой, latency, warnings
6. **POST `/api/v1/technical/realtime/instances/{instanceId}/metrics`** – push-метрики (tickDuration, activePlayers, packetsPerSec)
7. **GET `/api/v1/technical/realtime/zones`** – список зон, фильтры: `status`, `assignedServerId`, `isPvpEnabled`
8. **GET `/api/v1/technical/realtime/zones/{zoneId}`** – подробности зоны (границы, load, weather, settings)
9. **PATCH `/api/v1/technical/realtime/zones/{zoneId}`** – обновить capacity, статус (ONLINE/MAINTENANCE), флаги PVP/safe
10. **POST `/api/v1/technical/realtime/zones/{zoneId}/transfer`** – план переназначения зоны на новый инстанс, с ETA и критериями
11. **POST `/api/v1/technical/realtime/zones/{zoneId}/evacuate`** – инициировать эвакуацию игроков, указать targetZone/instance, timeout
12. **GET `/api/v1/technical/realtime/zones/{zoneId}/cells`** – сводка по cell (число игроков, NPC, плотность)
13. **POST `/api/v1/technical/realtime/zones/{zoneId}/cells/{cellKey}/snapshot`** – получить snapshot для отладки (список игроков, timestamps)
14. **POST `/api/v1/technical/realtime/players/{playerId}/relocate`** – принудительный перенос игрока в другую зону/инстанс
15. **POST `/api/v1/technical/realtime/alerts`** – Ops endpoint для фиксации алертов (`TICK_OVER_50MS`, `ZONE_OVER_CAPACITY`)

Каждый endpoint должен использовать стандартные ответы (`200`, `202`, `204`, `400`, `401`, `403`, `404`, `409`, `422`, `429`, `500`).

---

## 🧱 Модели данных

- **RealtimeInstance** – id, region, status, tickRate, maxZones, maxPlayers, currentPlayers, cpuLoad, memoryUsage, startedAt, tags
- **RealtimeInstanceRegistrationRequest** – instanceId, region, supportedZoneTypes, tickRate, capacity, metadata
- **RealtimeInstanceHeartbeatRequest** – timestamp, activeZones, activePlayers, tickDurationAvg, warnings[], version
- **RealtimeInstanceMetrics** – percentileTick (p50/p95), packetsPerSecond, interestQueues, redisLatency
- **Zone** – zoneId, zoneName, zoneType, assignedServerId, maxPlayers, currentPlayers, boundaries, settings (pvp/safe/weather/time)
- **ZoneState** – status, stabilityScore, loadFactor, lastMigratedAt, scheduledMaintenanceAt
- **ZoneTransferRequest** – targetInstanceId, drainStrategy, priority, reason, scheduledFor
- **ZoneEvacuationPlan** – targetZoneId, batchSize, intervalMs, notifyPlayers (boolean)
- **ZoneCellSummary** – cellKey, playerCount, npcCount, averageLatency, lastUpdate
- **ZoneCellSnapshot** – list of `CellPlayerState` (playerId, position, velocity, status, equipment)
- **PlayerRelocationRequest** – targetZoneId, reason, preserveSession (boolean)
- **RealtimeAlertRequest** – alertType, severity, sourceInstanceId, zoneId, metrics, actions
- **Event schemas** – `RealtimeInstanceOverloaded`, `ZoneReassigned`, `PlayerEvacuated`

Все модели должны содержать `required`, enum значения, ограничения (`minimum`, `maximum`, `pattern`), а также примеры.

---

## 🧭 Принципы и правила

- Использовать `api/v1/shared/common/security.yaml` (BearerAuth + ServiceToken)
- Общие ошибки и ответы импортировать из `api/v1/shared/common/responses.yaml`
- Файлы должны быть < 400 строк; при необходимости разбить на компоненты
- Идентификаторы – UUID/строки формата `nightCity.watson`
- Метрики и timestamp – ISO 8601 / Unix milliseconds (согласовать в описании)

---

## 🧪 Примеры

- Регистрация инстанса с тремя зонами (Watson, Westbrook, City Center)
- Heartbeat с предупреждением `tickDurationMs=58`
- Transfer зоны `nightCity.cityCenter` на другой инстанс (с планом эвакуации)
- Snapshot cell `nightCity.watson:5:5` с 12 игроками
- Alert `ZONE_OVER_CAPACITY` с метриками (currentPlayers 230/200)

Все примеры оформить в `application/json`, значения брать из документа `.BRAIN`.

---

## 🔗 Связности и зависимости

- Ссылаться на `api/v1/technical/realtime/realtime-protocol.yaml` (будет создано по Part 2)
- Указать интеграцию с session-service (валидировать активные сессии)
- Описать публикацию событий в Event Bus (`topic: realtime.instance`, `realtime.zone`)
- Обозначить использование Redis ключей и Global State Manager

---

## ✅ Критерии приемки

1. Создан/обновлён файл `api/v1/technical/realtime/server-zones.yaml` (OpenAPI 3.0.3)
2. Добавлен архитектурный комментарий с microservice/module/hooks
3. Все 15 endpoints детально описаны с параметрами, requestBody и responses
4. Определены все перечисленные модели данных в `components/schemas`
5. Используются общие компоненты (`security.yaml`, `responses.yaml`)
6. Прописаны enum/валидации для статусов (`ONLINE`, `MAINTENANCE`, `DRAINING`) и типов зон
7. Описан Interest Management (cells) и формат Redis ключей
8. Добавлены события и интеграции с Event Bus/Incident Service
9. Подготовлены примеры JSON для ключевых сценариев (registration, transfer, snapshot, alert)
10. Указан тест-план (нагрузка, эвакуация, деградация tick rate) в описании задания
11. Задание проходит чеклист `tasks/config/checklist.md`

---

## ❓ FAQ

- **Как обрабатывать перегруженный инстанс?** – Использовать `alerts` → Ops → `zones/{id}/transfer`, описать auto-drain стратегию.
- **Что делать, если Redis недоступен?** – Реализовать fallback: возвращать `503` + alert, описать в responses.
- **Как пересчитывать interest area?** – См. `ZoneCellSummary` и `CELL_SIZE=100`, включить параметры override.
- **Можно ли частично эвакуировать игроков?** – Да, `ZoneEvacuationPlan.batchSize` + `intervalMs`.
- **Как валидировать tickRate?** – Допустить только 20, 30, 60 (enum), описать минимальный SLA.
- **Как синхронизировать с voice-lobby?** – Событие `PlayerEvacuated` передаёт новый zoneId для voice сервисов.

---

## 🕓 История выполнения

- 2025-11-07 17:05 — Задание создано (GPT-5 Codex)

---

**Примечание:** Перед handoff пройти чеклист `tasks/config/checklist.md`.

