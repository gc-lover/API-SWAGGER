# Task ID: API-TASK-199
**Тип:** API Generation
**Приоритет:** критический
**Статус:** queued
**Создано:** 2025-11-07 21:35
**Создатель:** GPT-5 Codex (API Task Creator)
**Зависимости:** API-TASK-198 (lifecycle)

---

## 📋 Краткое описание

Разработать спецификацию `session-management/reconnection-monitoring.yaml` для процессов быстрого переподключения, отслеживания disconnect событий и мониторинга стабильности сессий.

**Что нужно сделать:** На базе Part 2 документа описать REST/WebSocket контракты для reconnection flow, reconnect tokens, disconnect analytics и алертов стабильности.

---

## 🎯 Цель задания

Расширить систему управления сессиями, обеспечив надежное восстановление после обрывов и инструменты мониторинга для Ops-команды.

**Зачем это нужно:**
- Поддержать seamless reconnect (<=5 минут) без потери прогресса
- Автоматически выявлять нестабильные подключения и массовые disconnect события
- Реализовать аналитические отчеты по стабильности и повторным обрывам
- Подготовить события для realtime/voice сервисов при смене статуса connection

---

## 📚 Источники информации

### Основной источник

**Репозиторий:** `.BRAIN`
**Путь:** `.BRAIN/05-technical/backend/session-management/part2-reconnection-monitoring.md`
**Версия:** v1.0.1
**Дата:** 2025-11-07
**Статус:** approved

**Ключевые блоки:**
- Fast reconnect алгоритм (token, 5-минутное окно)
- Endpoint `POST /reconnect` с валидацией статуса и восстановлением сессии
- Event bus (`player.reconnected`, `session.disconnect`) и audit лог
- Monitoring dashboard: disconnect rate, avg downtime, unstable sessions
- Повторные disconnect события и оповещения

### Дополнительные источники

- `.BRAIN/05-technical/backend/session-management/part1-lifecycle-heartbeat.md`
- `.BRAIN/05-technical/backend/realtime-server/part1-architecture-zones.md`
- `.BRAIN/05-technical/backend/realtime-server/part2-protocol-optimization.md`
- `.BRAIN/05-technical/backend/incident-response/incident-response.md`
- `.BRAIN/05-technical/backend/anti-cheat/anti-cheat-compact.md`

### Связанные документы

- `.BRAIN/05-technical/backend/global-state/global-state-operations.md`
- `.BRAIN/05-technical/backend/voice-chat/voice-chat-system.md`

---

## 📁 Целевая структура API

- **Файл:** `api/v1/technical/session-management/reconnection-monitoring.yaml`
- **Версия:** v1
- **Тип:** OpenAPI 3.0.3 (REST + события)

```
API-SWAGGER/api/v1/technical/session-management/
 ├── lifecycle.yaml                  # (API-TASK-198)
 ├── reconnection-monitoring.yaml    # ← текущая задача
 └── session-management.yaml         # core/legacy
```

---

## 🏗️ Целевая архитектура (⚠️ ОБЯЗАТЕЛЬНО)

### Backend
- **Микросервис:** session-service
- **Порт:** 8082
- **Base Path:** `/api/v1/technical/session-management`
- **Зависимости:** lifecycle API, realtime-service, voice-service, incident-service, telemetry-service

### Frontend/Monitoring
- **Модуль:** `modules/ops/session-monitoring`
- **State Store:** `useOpsSessionStore`
- **State:** `disconnectEvents`, `reconnectQueue`, `instabilityAlerts`
- **UI:** `ReconnectTimeline`, `DisconnectRateChart`, `PlayerStabilityTable`
- **Формы:** `ReconnectDiagnosticsForm`, `MassDisconnectInvestigationForm`
- **Layouts:** `OpsConsoleLayout`, `IncidentDashboard`
- **Хуки:** `useReconnectStream`, `useSessionAnalytics`, `useIncidentAlerts`

### Комментарий для YAML

```yaml
# Target Architecture:
# - Microservice: session-service (port 8082)
# - API Base: /api/v1/technical/session-management
# - Dependencies: lifecycle API, realtime-service, voice-service, incident-service, telemetry-service
# - Frontend Module: modules/ops/session-monitoring (useOpsSessionStore)
# - UI: ReconnectTimeline, DisconnectRateChart, PlayerStabilityTable
# - Forms: ReconnectDiagnosticsForm, MassDisconnectInvestigationForm
# - Layouts: OpsConsoleLayout, IncidentDashboard
# - Hooks: useReconnectStream, useSessionAnalytics, useIncidentAlerts
```

---

## ✅ Что нужно сделать (детальный план)

1. **Спроектировать endpoints:** reconnect, disconnect tracking, analytics, unstable session handling.
2. **Описать модели reconnect token, status transitions и disconnect events.**
3. **Добавить monitoring endpoints:** rate metrics, downtime, incident triggers.
4. **Документировать события Event Bus/Webhook:** `session.disconnect`, `session.reconnect`, `session.instability`.
5. **Задать SLA:** reconnect within 5 minutes, max 3 attempts, downtime thresholds.
6. **Проработать интеграции:** уведомления realtime/voice, incident escalation.
7. **Подготовить примеры JSON и последовательности действий.**
8. **Пройти чеклист, сформировать FAQ и тест-план.**

---

## 🔀 Endpoints

1. **POST `/api/v1/technical/session-management/reconnect`** – выполнить reconnect по токену.
2. **POST `/api/v1/technical/session-management/reconnect/token`** – выдать reconnect токен (при disconnect).
3. **GET `/api/v1/technical/session-management/sessions/{sessionId}/disconnects`** – история disconnect событий.
4. **GET `/api/v1/technical/session-management/metrics/disconnect-rate`** – агрегированные метрики (по региону, ISP, времени).
5. **POST `/api/v1/technical/session-management/alerts/instability`** – зарегистрировать массовый disconnect (инцидент).
6. **GET `/api/v1/technical/session-management/monitoring/unstable`** – список игроков/сессий с повторными обрывами.
7. **POST `/api/v1/technical/session-management/sessions/{sessionId}/diagnostics`** – запрос диагностики (latency, packet loss) по конкретной сессии.
8. **POST `/api/v1/technical/session-management/sessions/{sessionId}/force-reconnect`** – инициировать повторное подключение (например, смена региона сервера).
9. **GET `/api/v1/technical/session-management/events/realtime`** – SSE/WebSocket канал для live-ивентов (опционально). 

Использовать стандартные ответы (`200`, `201`, `202`, `204`, `400`, `401`, `403`, `404`, `409`, `410`, `422`, `429`, `500`).

---

## 🧱 Модели данных

- **ReconnectTokenRequest/Response** – sessionId, disconnectReason, expiresAt, attemptsRemaining.
- **ReconnectRequest/Response** – reconnectToken, clientInfo, restoreState (inventory, location, party).
- **DisconnectEvent** – eventId, sessionId, playerId, timestamp, reason (network, server, client), duration.
- **SessionInstabilityRecord** – playerId, disconnectCount24h, averageDowntime, lastIncidentId.
- **DisconnectRateMetrics** – timeframe, totalDisconnects, rates by region/isp/platform, thresholds.
- **IncidentAlertRequest** – severity, affectedPlayers, suspectedCause, linkedServices.
- **DiagnosticsReport** – latencyHistory, packetLoss, reconnectAttempts, recommendedActions.
- **Event payloads** – `SessionDisconnectedEvent`, `SessionReconnectedEvent`, `MassDisconnectEvent`.
- **Error schemas** – `ReconnectError` (`TOKEN_EXPIRED`, `SESSION_NOT_FOUND`, `ALREADY_ACTIVE`), `MonitoringError`.

Обеспечить описания, обязательность полей, примеры и enum значений.

---

## 🧭 Принципы и правила

- Безопасность: `BearerAuth` + `ServiceToken` (`api/v1/shared/common/security.yaml`).
- Ответы и ошибки из `api/v1/shared/common/responses.yaml`.
- SLA: reconnect ≤ 5 минут, максимум 3 попытки, массовый disconnect → alert/incident.
- Указать интеграцию с telemetry/incident системами.
- Уточнить связь с voice/realtime (переселение игроков при reconnect).

---

## 🧪 Примеры

- Запрос reconnect токена при disconnect (ответ с expiry).
- Успешный reconnect с восстановлением state.
- История disconnect событий для игрока.
- Отчет disconnect-rate (heatmap по регионам).
- Alert о массовом disconnect (payload для incident-service).

---

## 🔗 Связности и зависимости

- Использует данные из lifecycle API (`sessionId`, statuses).
- Интеграция с realtime сервисом (переключение зон/серверов).
- Инцидент сервис для эскалации (incident_id).
- Telemetry-service для аналитики disconnect rate.

---

## ✅ Критерии приемки

1. Создан `reconnection-monitoring.yaml` с архитектурным комментарием.
2. Описаны все перечисленные endpoints с request/response схемами и примерами.
3. Определены модели reconnect token, disconnect event, instability metrics.
4. Добавлены события Event Bus и интеграции.
5. Прописаны SLA, лимиты попыток, действия при массовых обрывах.
6. Подготовлен набор примеров и FAQ.
7. Задание проходит чеклист, самодостаточно.

---

## ❓ FAQ

- **Что делать при истечении токена?** – Возвращать `410 Gone`, клиент должен авторизоваться заново.
- **Можно ли переносить игрока на другой сервер при reconnect?** – Да, через `force-reconnect` с указанием целевого region/server.
- **Как отслеживать нестабильных игроков?** – Использовать endpoint `monitoring/unstable`, анализировать `disconnectCount24h`.
- **Как подавать инцидент?** – `alerts/instability` → incident-service + уведомление Ops.
- **Есть ли интеграция с anti-cheat?** – Проверять неестественные паттерны (частые короткие disconnects по требованию).

---

## 🕓 История выполнения

- 2025-11-07 21:35 — Задание создано (GPT-5 Codex)

---

**Примечание:** Перед handoff пройти чеклист `tasks/config/checklist.md`.

