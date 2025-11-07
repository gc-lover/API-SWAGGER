# Task ID: API-TASK-198
**Тип:** API Generation
**Приоритет:** критический
**Статус:** queued
**Создано:** 2025-11-07 21:05
**Создатель:** GPT-5 Codex (API Task Creator)
**Зависимости:** API-TASK-106 (session-management-core)

---

## 📋 Краткое описание

Создать детализированную спецификацию `session-management/lifecycle` (создание, heartbeat, таймауты, AFK, concurrent sessions) на основе Part 1 документа.

**Что нужно сделать:** Разделить существующий `session-management.yaml`, вынести lifecycle & heartbeat в отдельный файл `session-management/lifecycle.yaml` с подробными схемами и сценариями.

---

## 🎯 Цель задания

Уточнить и расширить API управления игровыми сессиями, чтобы backend и frontend получили точные контракты для создания/обновления сессий, heartbeat и AFK-логики.

**Зачем это нужно:**
- Поддержать массовые логины и контроль одновременных сессий
- Обеспечить корректную работу heartbeat, AFK и force-logout механизмов
- Документировать SLA и тайминги, необходимые для realtime и anti-cheat
- Подготовить основу для Part 2 (reconnection & monitoring)

---

## 📚 Источники информации

### Основной источник

**Репозиторий:** `.BRAIN`
**Путь:** `.BRAIN/05-technical/backend/session-management/part1-lifecycle-heartbeat.md`
**Версия:** v1.0.1
**Дата:** 2025-11-07
**Статус документа:** approved

**Ключевые элементы:**
- Процесс login → session create → heartbeat → logout
- Redis + PostgreSQL хранение, audit log, session tokens
- Heartbeat (30 секунд), AFK thresholds (3 мин), force timeout (5 мин)
- Concurrent session detection (single session per account, kick previous)
- AFK detection, статусные переходы (`ACTIVE`, `AFK`, `DISCONNECTED`, `TERMINATED`)
- Event bus (`session.created`, `session.terminated`, `session.afk`)

### Дополнительные источники

- `.BRAIN/05-technical/backend/session-management/part2-reconnection-monitoring.md`
- `.BRAIN/05-technical/backend/auth/auth-login-jwt.md`
- `.BRAIN/05-technical/backend/global-state/global-state-sync.md`
- `.BRAIN/05-technical/backend/anti-cheat/anti-cheat-compact.md`
- `.BRAIN/05-technical/backend/api-gateway/gateway-routing.md`

### Связанные документы

- `.BRAIN/05-technical/backend/realtime-server/part1-architecture-zones.md`
- `.BRAIN/05-technical/backend/voice-chat/voice-chat-system.md`

---

## 📁 Целевая структура API

- **Файл:** `api/v1/technical/session-management/lifecycle.yaml`
- **API версия:** v1
- **Тип:** OpenAPI 3.0.3

```
API-SWAGGER/api/v1/technical/session-management/
 ├── lifecycle.yaml          ← создать/заполнить
 ├── reconnection-monitoring.yaml (будет для Part 2)
 └── session-management.yaml (core/legacy)
```

При необходимости обновить `session-management.yaml`, оставив summary и $ref на новую секцию.

---

## 🏗️ Целевая архитектура (⚠️ ОБЯЗАТЕЛЬНО)

### Backend
- **Микросервис:** session-service
- **Порт:** 8082
- **API Base Path:** `/api/v1/technical/session-management`
- **Зависимости:** auth-service, account-service, global-state-service, incident-service, anti-cheat-service

### Frontend
- **Модуль:** `modules/player/session`
- **State Store:** `useSessionStore`
- **State:** `sessionInfo`, `heartbeatStatus`, `afkTimer`
- **UI компоненты:** `SessionStatusBadge`, `HeartbeatIndicator`, `AFKWarningModal`
- **Формы:** `ForceLogoutDialog`, `SessionDiagnosticsPanel`
- **Layouts:** `GameLayout`, `AccountDashboard`
- **Хуки:** `useHeartbeat`, `useAfkDetector`, `useSessionEvents`

### Комментарий для YAML

```yaml
# Target Architecture:
# - Microservice: session-service (port 8082)
# - API Base: /api/v1/technical/session-management
# - Dependencies: auth-service, account-service, global-state-service, incident-service, anti-cheat-service
# - Frontend Module: modules/player/session (useSessionStore)
# - UI: SessionStatusBadge, HeartbeatIndicator, AFKWarningModal
# - Forms: ForceLogoutDialog, SessionDiagnosticsPanel
# - Layouts: GameLayout, AccountDashboard
# - Hooks: useHeartbeat, useAfkDetector, useSessionEvents
```

---

## ✅ Что нужно сделать (детальный план)

1. **Декомпозировать сценарии:** login → create session, heartbeat, AFK, logout, concurrent session handling.
2. **Описать REST endpoints:** `/sessions`, `/sessions/{id}/heartbeat`, `/sessions/{id}/afk`, `/sessions/{id}/terminate`, `/sessions/force`.
3. **Добавить state machine:** enum статусов, transitions, события.
4. **Определить модели:** `Session`, `SessionCreateRequest`, `HeartbeatRequest`, `SessionStatus`, `AfkPolicy`, `ConcurrentSessionPolicy`, `SessionEvent`.
5. **Документировать SLA:** heartbeat 30s, grace period 10s, AFK threshold 180s, force timeout 300s.
6. **Включить события:** `session.created`, `session.heartbeat-missed`, `session.afk`, `session.terminated` (описать payload).
7. **Добавить monitoring endpoints:** статистика сессий, активных игроков, AFK rate.
8. **Подготовить примеры:** login flow, heartbeat OK, heartbeat missed, concurrent login, AFK auto logout.
9. **Пройти чеклист и подготовить FAQ/тест-план.**

---

## 🔀 Endpoints

1. **POST `/api/v1/technical/session-management/sessions`** – создать сессию (вход), возвращает sessionId, tokens, expiry.
2. **GET `/api/v1/technical/session-management/sessions/{sessionId}`** – получить состояние сессии.
3. **POST `/api/v1/technical/session-management/sessions/{sessionId}/heartbeat`** – heartbeat (30s, включает latency, client info).
4. **POST `/api/v1/technical/session-management/sessions/{sessionId}/afk`** – сообщить о возобновлении активности.
5. **PATCH `/api/v1/technical/session-management/sessions/{sessionId}/status`** – изменение статуса (`ACTIVE`, `AFK`, `DISCONNECTED`).
6. **DELETE `/api/v1/technical/session-management/sessions/{sessionId}`** – завершить сессию (logout).
7. **POST `/api/v1/technical/session-management/sessions/force`** – принудительно завершить существующие сессии (конкурентные логины).
8. **GET `/api/v1/technical/session-management/metrics/heartbeat`** – метрики SLA heartbeat, пропуски.
9. **GET `/api/v1/technical/session-management/policies`** – получить настройки AFK/timeout/heartbeat.

Использовать стандартные ответы (`200`, `201`, `202`, `204`, `400`, `401`, `403`, `404`, `409`, `410`, `422`, `429`, `500`).

---

## 🧱 Модели данных

- **Session** – sessionId, playerId, accountId, characterId, status, createdAt, lastHeartbeatAt, expiresAt, reconnectToken.
- **SessionCreateRequest/Response** – authToken, clientInfo, device, ip, location.
- **HeartbeatRequest** – clientTimestamp, latencyMs, gameVersion, activity.
- **SessionStatusUpdateRequest** – newStatus, reason, triggeredBy.
- **AfkPolicy** – afkThresholdSeconds, warningThresholdSeconds, disconnectTimeoutSeconds.
- **ConcurrentSessionPolicy** – allowMultiple (bool), action (`terminate_previous`, `reject_new`), notify.
- **SessionEvent** – eventType, timestamp, metadata (map).
- **HeartbeatMetrics** – missedHeartbeats, averageLatency, slaCompliance.
- **ForceLogoutRequest** – playerId/accountId, reason, notify, timeout.
- **Error schemas** – `SessionError` с кодами (`SESSION_NOT_FOUND`, `HEARTBEAT_TOO_SOON`, `CONCURRENT_SESSION_ACTIVE`).
- **Event payloads** – `SessionCreatedEvent`, `SessionTerminatedEvent`, `SessionAfkEvent`, `SessionHeartbeatMissedEvent`.

Все схемы снабдить `description`, `required`, `examples`, `enum`.

---

## 🧭 Принципы и правила

- Использовать `api/v1/shared/common/security.yaml` (`BearerAuth`, `ServiceToken`).
- Общие ответы из `api/v1/shared/common/responses.yaml`.
- Описать rate limits (heartbeat ~ 30s ±10s, force logout limited).
- Статусы и события синхронизировать с realtime/voice системами.
- Указать интеграцию с Redis (ключи `session:{token}`) и audit лог БД.

---

## 🧪 Примеры

- Создание сессии (пример запроса/ответа).
- Heartbeat успешный, heartbeat пропущен (HTTP 410 + событие).
- Concurrent login (force terminate предыдущей сессии).
- AFK переход и авто logout.
- Метрики heartbeat (sla 99%).

---

## 🔗 Связности и зависимости

- Скоординировать с `realtime` (tick rate, player presence) и `voice-chat` (disconnect).
- Указать интеграцию с `incident-service` для alert при массовых пропусках heartbeat.
- Связь с anti-cheat (валидировать клиентский timestamp, IP changes).

---

## ✅ Критерии приемки

1. Создан `lifecycle.yaml` с архитектурным комментарием и полным набором endpoints.
2. Содержит state machine статусов и описанные события.
3. Модели данных покрывают создание, heartbeat, AFK, concurrent sessions, метрики.
4. Используются общие компоненты (`security`, `responses`).
5. Указаны SLA, тайминги и policy значения из документа.
6. Включены примеры запросов/ответов и событий.
7. Обработаны ошибки/коды (`409` concurrent, `410` timeout).
8. Подготовлен тест-план (нагрузка heartbeat, резкие AFK, mass logout) и FAQ.
9. Чеклист пройден, задание самодостаточно.

---

## ❓ FAQ

- **Можно ли менять heartbeat на лету?** – Да, endpoint `policies` + событие `config.updated` (описать в задании).
- **Что если клиент отправляет heartbeat слишком часто?** – Возвращать `429` с кодом `HEARTBEAT_TOO_SOON`, фиксировать нарушение.
- **Как обрабатывать смену персонажа?** – Терминировать старую сессию и создать новую (описать в FAQ).
- **Как логируются AFK переходы?** – В events + incident-service (при массовых AFK).
- **Нужен ли WebSocket?** – Нет, heartbeat REST + события, realtime используется отдельно.

---

## 🕓 История выполнения

- 2025-11-07 21:05 — Задание создано (GPT-5 Codex)

---

**Примечание:** Перед handoff пройти чеклист `tasks/config/checklist.md`.

