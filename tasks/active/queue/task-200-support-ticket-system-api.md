# Task ID: API-TASK-200
**Тип:** API Generation
**Приоритет:** высокий
**Статус:** queued
**Создано:** 2025-11-07 21:50
**Создатель:** GPT-5 Codex (API Task Creator)
**Зависимости:** none

---

## 📋 Краткое описание

Спроектировать OpenAPI спецификацию системы тикетов поддержки игроков.

**Что нужно сделать:** Создать `api/v1/admin/support/support-tickets.yaml`, описав создание тикетов, ответы, назначение агентов, SLA/эскалацию, метрики и интеграции с уведомлениями.

---

## 🎯 Цель задания

Предоставить REST API для полного жизненного цикла тикетов поддержки NECPGAME, чтобы Ops/Support команды могли обрабатывать обращения, контролировать SLA и вести аналитику.

**Зачем это нужно:**
- Обеспечить игроков прозрачной поддержкой, подтверждениями и статусами
- Дать support-агентам инструменты назначения, ответов и эскалаций
- Автоматизировать отчеты SLA, метрики качества и обратную связь
- Синхронизировать работу с email, нотификациями и incident management

---

## 📚 Источники информации

### Основной источник

**Репозиторий:** `.BRAIN`
**Путь:** `.BRAIN/05-technical/backend/support/support-ticket-system.md`
**Версия:** v1.0.0
**Дата последнего обновления:** 2025-11-07 02:27
**Статус документа:** approved (api-readiness: ready)

**Что важно из документа:**
- Структура `support_tickets`, `ticket_responses`, auto-priority, auto-assignment
- Категории, приоритеты, статусы тикетов; формат номера `NECPG-YYYYMMDD-XXXX`
- Процессы создания, ответа, назначения, эскалации и опроса удовлетворенности
- SLA менеджер, авто-эскалации, уведомления, автоматическое закрытие
- Интеграции (email, notificationService, incident escalation, analytics)

### Дополнительные источники

- `.BRAIN/05-technical/backend/incident-response/incident-response.md`
- `.BRAIN/05-technical/backend/notification-system.md`
- `.BRAIN/05-technical/backend/auth/auth-login-jwt.md`
- `.BRAIN/05-technical/backend/account/account-management.md` (если есть роли агент/супервизор)
- `.BRAIN/05-technical/backend/realtime-server/part2-protocol-optimization.md` (взаимодействие с report player/cheat)

### Связанные документы

- `.BRAIN/05-technical/backend/voice-chat/voice-chat-system.md` (уведомления)
- `.BRAIN/05-technical/backend/global-state/global-state-operations.md` (логирование событий)

---

## 📁 Целевая структура API

- **Репозиторий:** `API-SWAGGER`
- **Файл:** `api/v1/admin/support/support-tickets.yaml`
- **API версия:** v1
- **Тип файла:** OpenAPI 3.0.3 (REST)

```
API-SWAGGER/api/v1/admin/support/
 └── support-tickets.yaml  ← создать/заполнить
```

При необходимости обновить `api/v1/admin/README.md` (если существует) с ссылкой на новую спецификацию.

---

## 🏗️ Целевая архитектура (⚠️ ОБЯЗАТЕЛЬНО)

### Backend (микросервисы)
- **Микросервис:** admin-service
- **Порт:** 8088
- **API Base Path:** `/api/v1/admin/support/*`
- **Зависимости:** auth-service (аутентификация), account-service (роли агентов), notification-service, email-service, incident-service, analytics-service

### Frontend (модули)
- **Модуль:** `modules/admin/support`
- **State Store:** `useAdminSupportStore`
- **State:** `tickets`, `filters`, `agents`, `slaMetrics`, `feedback`
- **UI компоненты:** `TicketListTable`, `TicketDetailsDrawer`, `TicketResponseEditor`, `SlaHeatmap`, `AgentAssignmentPanel`
- **Формы:** `CreateTicketForm`, `AddResponseForm`, `AssignAgentForm`, `ResolveTicketForm`, `IncidentEscalationForm`
- **Layouts:** `SupportDashboardLayout`, `AdminConsoleLayout`
- **Хуки:** `useTicketFilters`, `useSlaMonitor`, `useNotificationBridge`

### Комментарий для YAML

```yaml
# Target Architecture:
# - Microservice: admin-service (port 8088)
# - API Base: /api/v1/admin/support
# - Dependencies: auth-service, account-service, notification-service, email-service, incident-service, analytics-service
# - Frontend Module: modules/admin/support (useAdminSupportStore)
# - UI: TicketListTable, TicketDetailsDrawer, TicketResponseEditor, SlaHeatmap, AgentAssignmentPanel
# - Forms: CreateTicketForm, AddResponseForm, AssignAgentForm, ResolveTicketForm, IncidentEscalationForm
# - Layouts: SupportDashboardLayout, AdminConsoleLayout
# - Hooks: useTicketFilters, useSlaMonitor, useNotificationBridge
```

---

## ✅ Что нужно сделать (детальный план)

1. Сформировать структуру `paths` для CRUD тикетов, ответов, назначения, SLA и аналитики.
2. Определить модели данных (Ticket, TicketResponse, SLAStatus, Assignment, Feedback, IncidentAlert).
3. Добавить фильтры, пагинацию и сортировку для списков тикетов.
4. Описать workflow: создание → авто-приоритизация → назначение → ответ → разрешение → закрытие/опрос.
5. Включить эндпоинты эскалации, массового назначения, повторного открытия, оценки качества.
6. Задокументировать события/уведомления (`ticket.created`, `ticket.assigned`, `ticket.sla.breach`, `ticket.resolved`).
7. Описать интеграции с email/notification/incident сервисами.
8. Прописать SLA и политики (таблицы времени ответа, авто-эскалация, авто-close).
9. Подготовить примеры запросов/ответов и отчетов.
10. Пройти чеклист `tasks/config/checklist.md` и добавить FAQ/test plan.

---

## 🔀 Endpoints

1. **POST `/api/v1/admin/support/tickets`** – создать тикет (player или support).
2. **GET `/api/v1/admin/support/tickets`** – список тикетов (фильтры: статус, приоритет, категория, агент, дату; пагинация, сортировка).
3. **GET `/api/v1/admin/support/tickets/{ticketId}`** – получить детали тикета с историей.
4. **PATCH `/api/v1/admin/support/tickets/{ticketId}`** – обновить параметры (приоритет, категорию, метаданные).
5. **POST `/api/v1/admin/support/tickets/{ticketId}/responses`** – добавить ответ (игрок/агент, attachments, internal flag).
6. **POST `/api/v1/admin/support/tickets/{ticketId}/assign`** – назначить/сменить агента.
7. **POST `/api/v1/admin/support/tickets/{ticketId}/resolve`** – завершить тикет, добавить resolution note, инициировать feedback.
8. **POST `/api/v1/admin/support/tickets/{ticketId}/reopen`** – повторно открыть тикет.
9. **POST `/api/v1/admin/support/tickets/{ticketId}/escalate`** – эскалация (смена приоритета, уведомления).
10. **POST `/api/v1/admin/support/tickets/{ticketId}/feedback`** – сохранить оценку игрока.
11. **GET `/api/v1/admin/support/metrics/sla`** – SLA отчеты (время ответа, breaches, по категориям).
12. **GET `/api/v1/admin/support/metrics/workload`** – загрузка агентов, открытые тикеты.
13. **POST `/api/v1/admin/support/incidents`** – регистрировать инцидент (массовые тикеты, критические события).
14. **POST `/api/v1/admin/support/tickets/{ticketId}/attachments`** – загрузка/удаление вложений.
15. **GET `/api/v1/admin/support/tickets/{ticketId}/timeline`** – полная хронология действий (audit trail).

Стандартизировать ответы и ошибки (`200`, `201`, `202`, `204`, `400`, `401`, `403`, `404`, `409`, `422`, `429`, `500`).

---

## 🧱 Модели данных

- **SupportTicket** – id, ticketNumber, playerId, category, subject, description, priority, status, assignedTo, timestamps, metadata.
- **CreateTicketRequest/Response** – player info, issue details, attachments, platform, gameVersion.
- **TicketListFilter** – статус, приоритет, категория, агент, период, search query.
- **TicketResponse** – id, ticketId, authorId, authorType (`PLAYER|AGENT|SYSTEM`), message, attachments, isInternal, createdAt.
- **AssignTicketRequest** – agentId, autoNotify, note.
- **ResolveTicketRequest** – resolutionNote, sendSurvey (bool).
- **ReopenTicketRequest** – reason, initiatedBy.
- **EscalateTicketRequest** – newPriority, escalateToRole, incidentId.
- **FeedbackRequest** – rating (1-5), comment.
- **SlaMetricsResponse** – byPriority, byCategory, responseTimes, breaches, trend.
- **WorkloadMetricsResponse** – openTickets, ticketsPerAgent, averageResponseTime, backlogTrend.
- **IncidentReport** – incidentId, severity, affectedPlayers, ticketIds, actionsTaken.
- **AttachmentMetadata** – id, filename, size, mimeType, uploadedBy, uploadedAt.
- **TimelineEntry** – type, author, timestamp, details (JSON object).
- **Error schemas** – `SupportTicketError` (codes: `TICKET_NOT_FOUND`, `INVALID_STATUS_TRANSITION`, `NO_AGENT_AVAILABLE`, `SLA_BREACH`), `AttachmentError`.
- **Event payloads** – `TicketCreatedEvent`, `TicketAssignedEvent`, `TicketResponseEvent`, `TicketSlaBreachEvent`, `TicketResolvedEvent`.

Каждая схема должна содержать `description`, список `required`, валидации (`enum`, `minLength`, `pattern`), а также примеры.

---

## 🧭 Принципы и правила

- Использовать `api/v1/shared/common/security.yaml` (BearerAuth + ServiceToken для сервисных вызовов).
- Общие ответы из `api/v1/shared/common/responses.yaml`.
- Обеспечить роли/permissions (`SUPPORT_AGENT`, `SUPPORT_SUPERVISOR`).
- Реализовать пагинацию по стандарту (limit/offset или page/size + links).
- Указать лимиты вложений (например, 10 файлов до 10MB).
- Описать webhook/event поток для интеграций (Slack, incident tooling).

---

## 🧪 Примеры

- Создание тикета игроком (пример запроса/ответа).
- Ответ агента с вложением и уведомлением игрока.
- SLA отчет по приоритетам (JSON aggregate).
- Incident отчет (массовые тикеты после обновления).
- Таймлайн тикета (список событий).

---

## 🔗 Связности и зависимости

- Взаимодействует с notification/email service для уведомлений.
- Интегрируется с incident response для критических кейсов.
- Может инициировать voice/realtime ограничения (например, временный бан при `REPORT_PLAYER`).
- Категории и приоритеты должны соответствовать документации `.BRAIN`.

---

## ✅ Критерии приемки

1. Файл `api/v1/admin/support/support-tickets.yaml` создан с архитектурным комментарием.
2. Все endpoints детально описаны (параметры, запросы, ответы, примеры).
3. Определены модели данных для тикетов, ответов, SLA, метрик, инцидентов и вложений.
4. Описаны события и интеграции (notification, incident).
5. Указаны правила ролей/permissions и rate limits.
6. Подготовлены примеры JSON (создание, ответ, отчеты, инцидент).
7. Прописан FAQ и тест-план (SLA нагрузки, массовый influx тикетов, вложения).
8. Пройден чеклист `tasks/config/checklist.md`, задание самодостаточно.

---

## ❓ FAQ

- **Кто может создавать тикеты?** – Игроки (через client API) и агенты (через админ интерфейс) – описать роли.
- **Как обрабатываются вложения?** – Через отдельный endpoint, хранение в CDN/S3, validation MIME.
- **Что делать при SLA breach?** – Возвращать событие и использовать endpoint `/escalate` с уведомлением supervisor.
- **Можно ли массово закрыть тикеты?** – В рамках задания предусмотреть `PATCH`/bulk endpoint? (описать ограничение/решение).
- **Как хранится feedback?** – `feedback` + `satisfaction_rating` поля, endpoint `/feedback`.

---

## 🕓 История выполнения

- 2025-11-07 21:50 — Задание создано (GPT-5 Codex)

---

**Примечание:** Перед handoff пройти чеклист `tasks/config/checklist.md`.

