# Task ID: API-TASK-205
**Тип:** API Generation
**Приоритет:** высокий
**Статус:** queued
**Создано:** 2025-11-07 23:25
**Создатель:** GPT-5 Codex (API Task Creator)
**Зависимости:** none

---

## 📋 Краткое описание

Создать OpenAPI спецификацию для системы объявлений/новостей (`announcement-system`).

**Что нужно сделать:** Сформировать `api/v1/admin/announcements/announcement-system.yaml`, описав создание, планирование, публикацию и доставку анонсов (игровых, maintenance, событий).

---

## 🎯 Цель задания

Обеспечить команде LiveOps и комьюнити менеджменту полный API для управления объявлениями, их расписанием, каналами доставки и аналитикой охвата.

**Зачем это нужно:**
- Публиковать новости, patch notes, предупреждения об обслуживании и события
- Управлять каналами доставки (внутриигровые баннеры, email, push, социальные)
- Собирать аналитику (просмотры, клики, acknowledgements)
- Обеспечить гибкий планировщик и историю изменений

---

## 📚 Источники информации

### Основной документ

**Путь:** `.BRAIN/05-technical/backend/announcement/announcement-system.md`
**Версия:** v1.0.0 (2025-11-07 02:30)
**Статус:** approved, api-readiness: ready

**Ключевые разделы:**
- Типы объявлений: game news, patch notes, in-game alerts, maintenance, events
- Workflow: подготовка → предварительный просмотр → планирование → публикация → архивация
- Каналы: in-game banner, modal, chat broadcast, email, push, website
- Targeting: регион, платформа, уровень игрока, подписки
- Метрики: просмотры, acknowledgements, CTR, feedback
- Баннерные ассеты, перевод/локализация, emergency override

### Дополнительные источники

- `.BRAIN/05-technical/backend/notification-system.md`
- `.BRAIN/05-technical/backend/mail-system.md`
- `.BRAIN/05-technical/backend/incident-response/incident-response.md`
- `.BRAIN/05-technical/backend/api-gateway/api-gateway-architecture.md`
- `.BRAIN/05-technical/backend/maintenance/maintenance-mode-system.md`

### Связанные документы

- `.BRAIN/05-technical/api-tech-docs/api-tech-summary-part1.md`
- `.BRAIN/05-technical/backend/daily-weekly-reset-system.md`

---

## 📁 Целевая структура API

- **Файл:** `api/v1/admin/announcements/announcement-system.yaml`
- **Версия API:** v1
- **Формат:** OpenAPI 3.0.3

```
API-SWAGGER/api/v1/admin/announcements/
 └── announcement-system.yaml  ← создать/заполнить
```

---

## 🏗️ Целевая архитектура (⚠️ ОБЯЗАТЕЛЬНО)

### Backend
- **Микросервис:** admin-service
- **Порт:** 8088
- **API Base Path:** `/api/v1/admin/announcements`
- **Зависимости:** notification-service, mail-service, push-service, analytics-service, auth-service, translation-service, incident-service

### Frontend
- **Модуль:** `modules/admin/announcements`
- **State Store:** `useAnnouncementsStore`
- **State:** `drafts`, `scheduled`, `active`, `archived`, `analytics`
- **UI компоненты:** `AnnouncementComposer`, `ScheduleCalendar`, `AudienceSelector`, `ChannelTogglePanel`, `AnnouncementPreview`, `AnalyticsDashboard`
- **Формы:** `CreateAnnouncementForm`, `ScheduleAnnouncementForm`, `TranslationForm`, `EmergencyAlertForm`
- **Layouts:** `AdminConsoleLayout`, `LiveOpsDashboard`
- **Хуки:** `useAnnouncementDrafts`, `useAnnouncementAnalytics`, `useChannelAvailability`

### Комментарий для YAML

```yaml
# Target Architecture:
# - Microservice: admin-service (port 8088)
# - API Base: /api/v1/admin/announcements
# - Dependencies: notification-service, mail-service, push-service, analytics-service, auth-service, translation-service, incident-service
# - Frontend Module: modules/admin/announcements (useAnnouncementsStore)
# - UI: AnnouncementComposer, ScheduleCalendar, AudienceSelector, ChannelTogglePanel, AnnouncementPreview, AnalyticsDashboard
# - Forms: CreateAnnouncementForm, ScheduleAnnouncementForm, TranslationForm, EmergencyAlertForm
# - Layouts: AdminConsoleLayout, LiveOpsDashboard
# - Hooks: useAnnouncementDrafts, useAnnouncementAnalytics, useChannelAvailability
```

---

## ✅ Что нужно сделать (детальный план)

1. Описать жизненный цикл объявления: черновик → публикация → завершение → архив.
2. Создать эндпоинты для управления контентом, каналами, таргетингом и расписанием.
3. Добавить управление шаблонами, переводами, медиа-ассетами.
4. Описать метрики (views, clicks, acknowledgements, feedback).
5. Реализовать интеграции с уведомлениями и почтой.
6. Поддержать emergency alerts (немедленная публикация/override).
7. Подготовить примеры, FAQ, тест-план; пройти чеклист.

---

## 🔀 Endpoints

1. **POST `/api/v1/admin/announcements`** – создать черновик объявления.
2. **GET `/api/v1/admin/announcements`** – список объявлений (фильтры: статус, канал, период, автор).
3. **GET `/api/v1/admin/announcements/{announcementId}`** – детали объявления, версии, переводов.
4. **PATCH `/api/v1/admin/announcements/{announcementId}`** – обновить контент, таргетинг, каналы.
5. **POST `/api/v1/admin/announcements/{announcementId}/schedule`** – запланировать публикацию (startAt/endAt, timezones).
6. **POST `/api/v1/admin/announcements/{announcementId}/publish`** – опубликовать сразу.
7. **POST `/api/v1/admin/announcements/{announcementId}/cancel`** – отменить/отозвать объявление (с указанием причины).
8. **POST `/api/v1/admin/announcements/{announcementId}/channels`** – включить/выключить каналы (in-game, email, push, web).
9. **POST `/api/v1/admin/announcements/{announcementId}/audience`** – настроить таргетинг (регионы, уровни, платформы).
10. **POST `/api/v1/admin/announcements/{announcementId}/preview`** – получить превью (JSON + HTML/Markdown).
11. **GET `/api/v1/admin/announcements/{announcementId}/analytics`** – метрики (views, CTR, feedback, unsubscribes).
12. **POST `/api/v1/admin/announcements/{announcementId}/feedback`** – сохранить обратную связь игроков (полезно/не полезно, комментарии).
13. **POST `/api/v1/admin/announcements/{announcementId}/translation`** – добавить/обновить локализации.
14. **POST `/api/v1/admin/announcements/emergency`** – отправить экстренное сообщение (override расписания).
15. **GET `/api/v1/admin/announcements/history`** – история публикаций, версия, автор, изменения.

---

## 🧱 Модели данных

- **Announcement** – id, title, content (Markdown/HTML), type (`NEWS`,`PATCH_NOTES`,`MAINTENANCE`,`EVENT`,`EMERGENCY`), status, channels[], startAt, endAt, createdAt, updatedAt.
- **AnnouncementDraftRequest** – title, summary, body, mediaAssets, tags.
- **ScheduleRequest** – startAt, endAt, timezone, recurrence (optional), fallbackChannels.
- **AudienceRules** – regions, platforms, minLevel, maxLevel, subscriptionTags, excludeClans.
- **ChannelConfig** – inGameBanner, modal, chat, email, push, webPortal (each with templateId).
- **PreviewResponse** – renderings для разных каналов.
- **AnalyticsResponse** – viewsByChannel, openRate, clickThroughRate, ackCount, unsubscribeCount, feedbackStats.
- **FeedbackRequest** – playerId, rating (`useful|neutral|not_useful`), comment.
- **TranslationPayload** – locale, title, summary, body, assets.
- **EmergencyRequest** – message, channels, severity, requireAck.
- **HistoryEntry** – version, authorId, changeType, timestamp, comments.
- **Error schemas** – `AnnouncementError` (`INVALID_CHANNEL`, `SCHEDULE_CONFLICT`, `NOT_AUTHORIZED`, `ALREADY_PUBLISHED`, `TRANSLATION_MISSING`).
- **Event payloads** – `AnnouncementPublishedEvent`, `AnnouncementViewedEvent`, `AnnouncementAcknowledgedEvent`, `AnnouncementFeedbackReceivedEvent`.

Каждая схема должна иметь описание, список `required`, ограничения и примеры.

---

## 🧭 Принципы и правила

- Безопасность: `BearerAuth` (роль `LiveOps`, `CommunityManager`), `ServiceToken` для событий.
- Общие ответы и ошибки через `api/v1/shared/common/responses.yaml`.
- Лимиты: max активных emergency объявлений, ограничение на массовые email.
- Локализация: обязательна для ключевых регионов (указать в описаниях).
- Согласовать с incident-service: emergency override логируется.

---

## 🧪 Примеры

- Черновик patch notes с расписанием на завтра.
- Одновременное включение каналов (in-game + email) с таргетингом EU PC.
- Экстренное предупреждение об обслуживании (push + banner).
- Аналитика объявления (просмотры, CTR, acknowledgements).
- История версий с комментариями.

---

## 🔗 Связности и зависимости

- Интеграция с notification/mail/push сервисами (рассылка, ack обратная связь).
- Подписки и настройки игроков (unsubscribe, mute categories).
- Поддержка world events (анонсы событий, синхронизация с календарём).
- Incident escalation при emergency.

---

## ✅ Критерии приемки

1. Файл `announcement-system.yaml` создан с архитектурным комментарием.
2. Все перечисленные endpoints описаны с request/response и примерами.
3. Модели данных охватывают контент, расписание, аудиторию, каналы и аналитику.
4. Добавлены события, интеграции, лимиты и FAQ.
5. Чеклист выполнен, задание самодостаточно.

---

## ❓ FAQ

- **Можно ли редактировать объявление после публикации?** – Да, через PATCH, но автолог с версией.
- **Как игрок подтверждает прочтение?** – Endpoint ack (в будущем) и события `Acknowledged`.
- **Что если игрок отписался от email?** – Честь audience rules + попытка fallback каналов.
- **Можно ли повторять объявление?** – Использовать `history` + `schedule` новую версию.

---

## 🕓 История выполнения

- 2025-11-07 23:25 — Задание создано (GPT-5 Codex)

---

**Примечание:** Перед handoff пройти чеклист `tasks/config/checklist.md`.

