# Task ID: API-TASK-230
**Тип:** API Generation
**Приоритет:** высокий
**Статус:** queued
**Создано:** 2025-11-08 05:10
**Создатель:** GPT-5 Codex (API Task Creator)
**Зависимости:** API-TASK-228, API-TASK-224, API-TASK-219

---

## 📋 Краткое описание

Спроектировать OpenAPI спецификацию системы уведомлений: in-game, WebSocket push, email, предпочтения и история.

**Что нужно сделать:** Создать `api/v1/notifications/notifications.yaml`, описав REST/WS контракты и модели по `.BRAIN/05-technical/backend/notification-system.md`.

---

## 🎯 Цель задания

Обеспечить надёжную платформу уведомлений для всех игровых событий и сервисов.

**Зачем это нужно:**
- Поддержать многоформатные уведомления (toast, inbox, email, push)
- Позволить игрокам управлять предпочтениями и подписками
- Обеспечить бэкенды батч рассылок, шаблонов, локализации
- Интегрировать уведомления с progression, quests, friends, guilds, economy

---

## 📚 Источники информации

### Основной документ

**Путь:** `.BRAIN/05-technical/backend/notification-system.md`
**Версия:** v1.0.0 (2025-11-07)
**Статус:** approved, api-readiness: ready

**Ключевые разделы:**
- Типы уведомлений и каналы доставки
- Preference center, opt-in/out, тихие часы
- Шаблоны, локализация, контент
- История уведомлений, поиск, фильтры
- Batch обработки, приоритеты, ретраи
- Интеграция с другими системами (achievements, quests, friends, guild, economy)

### Дополнительные источники

- `.BRAIN/05-technical/backend/friend-system.md`
- `.BRAIN/05-technical/backend/quest-engine-backend.md`
- `.BRAIN/05-technical/backend/achievement/achievement-tracking.md`
- `.BRAIN/05-technical/backend/economy-system.md`
- `.BRAIN/05-technical/backend/session-management/README.md`
- `.BRAIN/05-technical/backend/realtime-server/part2-protocol-optimization.md`

### Связанные документы

- `API-SWAGGER/tasks/active/queue/task-228-friend-system-api.md`
- `API-SWAGGER/tasks/active/queue/task-219-achievement-tracking-api.md`
- `API-SWAGGER/tasks/active/queue/task-224-progression-backend-api.md`

---

## 📁 Целевая структура API

- **Файл:** `api/v1/notifications/notifications.yaml`
- **Версия API:** v1
- **Формат:** OpenAPI 3.0.3

```
API-SWAGGER/api/v1/notifications/
 ├── notifications.yaml      ← создать/обновить
 ├── notifications-components.yaml
 └── notifications-examples.yaml
```

---

## 🏗️ Целевая архитектура (⚠️ ОБЯЗАТЕЛЬНО)

### Backend
- **Микросервис:** notification-service
- **Порт:** 8092
- **API Base Path:** `/api/v1/notifications`
- **Зависимости:**
  - auth-service – авторизация, каналы (email, phone)
  - session-service – online presence, device tokens
  - realtime-service – WebSocket fanout
  - template-service – шаблоны, локализация
  - analytics-service – доставляемость, CTR
  - economy-service – внутриигровые вознаграждения за уведомления
  - mail-service – SMTP/ESP integration
  - push-gateway – мобильные push
  - moderation-service – фильтрация контента

### Frontend
- **Модуль:** `modules/system/notifications`
- **State Store:** `useNotificationStore`
- **State:** `inbox`, `unreadCount`, `preferences`, `channels`, `history`, `muted`
- **UI компоненты:** `NotificationCenter`, `NotificationToast`, `NotificationPreferences`, `QuietHoursForm`, `NotificationHistory`, `NotificationChannelBadge`
- **Формы:** `PreferenceUpdateForm`, `SubscribeChannelForm`, `QuietHoursForm`, `NotificationSearchForm`
- **Хуки:** `useNotifications`, `useNotificationPreferences`, `useNotificationSocket`, `useQuietHours`

### Комментарий для YAML

```yaml
# Target Architecture:
# - Microservice: notification-service (port 8092)
# - API Base: /api/v1/notifications
# - Dependencies: auth, session, realtime, template, analytics, economy, mail, push-gateway, moderation
# - Frontend Module: modules/system/notifications (useNotificationStore)
# - UI: NotificationCenter, NotificationToast, NotificationPreferences, QuietHoursForm, NotificationHistory, NotificationChannelBadge
# - Forms: PreferenceUpdateForm, SubscribeChannelForm, QuietHoursForm, NotificationSearchForm
# - Hooks: useNotifications, useNotificationPreferences, useNotificationSocket, useQuietHours
```

---

## ✅ Что нужно сделать (детальный план)

1. Описать модели уведомлений, каналов, предпочтений, шаблонов, расписаний.
2. Определить эндпоинты для отправки одиночных и батч уведомлений.
3. Реализовать управление предпочтениями, тихими часами, устройствами.
4. Добавить историю уведомлений, фильтры, поиск, пагинацию.
5. Настроить WebSocket события (новые уведомления, обновления статуса).
6. Поддержать шаблоны, тестовые отправки, локализацию.
7. Реализовать ретраи, дедупликацию, idempotency.
8. Обеспечить интеграции с внешними сервисами и аналитикой.
9. Подготовить примеры и тест-кейсы.

---

## 🔀 Endpoints

1. **GET `/api/v1/notifications/inbox`** – текущие уведомления игрока (фильтры по типу, статусу).
2. **GET `/api/v1/notifications/history`** – архив уведомлений с поиском и пагинацией.
3. **POST `/api/v1/notifications/send`** – отправка индивидуального уведомления (каналы, payload).
4. **POST `/api/v1/notifications/send/batch`** – массовая отправка (списки получателей, сегменты).
5. **POST `/api/v1/notifications/test`** – тестовая отправка шаблона (QA/GM, audit).
6. **GET `/api/v1/notifications/preferences`** – текущие настройки игрока.
7. **PUT `/api/v1/notifications/preferences`** – обновление предпочтений, подписок.
8. **GET `/api/v1/notifications/quiet-hours`** – тихие часы.
9. **PUT `/api/v1/notifications/quiet-hours`** – настройка тихих часов, timezone.
10. **GET `/api/v1/notifications/devices`** – зарегистрированные устройства/каналы.
11. **POST `/api/v1/notifications/devices`** – добавление устройства (token, platform, capabilities).
12. **DELETE `/api/v1/notifications/devices/{deviceId}`** – удаление/отключение устройства.
13. **GET `/api/v1/notifications/templates`** – список шаблонов, локализаций.
14. **POST `/api/v1/notifications/templates/render`** – предпросмотр шаблона с данными.
15. **GET `/api/v1/notifications/delivery`** – статус доставки, ретраи, метрики.
16. **POST `/api/v1/notifications/ack`** – подтверждение прочтения/получения.
17. **DELETE `/api/v1/notifications/{notificationId}`** – скрыть/удалить уведомление из inbox.
18. **POST `/api/v1/notifications/webhooks`** – конфигурация webhooks для внешних интеграций.
19. **POST `/api/v1/notifications/retry/{notificationId}`** – повторная отправка (GM/ops).
20. **WS `/api/v1/notifications/stream`** – события: `notification-received`, `notification-updated`, `delivery-status`, `preference-updated`, `device-updated`.

---

## 🧱 Модели данных

- **Notification** – `notificationId`, `type`, `title`, `message`, `channel`, `priority`, `payload`, `link`, `expiresAt`, `status`.
- **NotificationPayload** – `context`, `entities`, `cta`, `metadata`.
- **Preference** – `channel`, `enabled`, `quietHours`, `frequency`, `categories`.
- **QuietHours** – `start`, `end`, `timezone`, `suppressCritical`.
- **Device** – `deviceId`, `platform`, `token`, `capabilities`, `lastSeen`, `status`.
- **Template** – `templateId`, `name`, `category`, `locales`, `variables`, `version`.
- **DeliveryStatus** – `deliveryId`, `channel`, `state`, `attempts`, `lastAttemptAt`, `error`.
- **BatchRequest** – `batchId`, `recipients`, `segments`, `filters`, `scheduledAt`.
- **WebhookConfig** – `webhookId`, `url`, `events`, `secret`, `status`.
- **RealtimeEventPayload** – `notificationReceived`, `notificationUpdated`, `deliveryStatus`, `preferenceUpdated`, `deviceUpdated`.
- **Error Schema (`NotificationError`)** – codes (`CHANNEL_DISABLED`, `DEVICE_INVALID`, `QUIET_HOURS`, `TEMPLATE_MISSING`, `DELIVERY_FAILED`, `PAYLOAD_INVALID`, `RATE_LIMITED`, `WEBHOOK_ERROR`).

---

## 🧭 Принципы и правила

- Авторизация: `BearerAuth` (players); `ServiceToken` (internal producers); `GMToken` (ops).
- Idempotency: `Send` и `Batch` поддерживают `idempotencyKey`.
- Rate limiting: ограничить массовые отправки и устройство регистрации.
- Localization: использовать template-service, не хранить тексты в коде.
- Compliance: хранить доказательства согласия (GDPR, opt-in).
- Security: фильтровать контент, предотвращать injection.
- Observability: логировать метрики, публиковать события в analytics.

---

## 🧪 Примеры

- Отправка push уведомления о завершении квеста с CTA.
- Массовая рассылка email о новом сезоне с шаблоном и локализацией.
- Настройка тихих часов и обновление предпочтений.
- Удаление устаревших устройств и ретрай доставки.
- WebSocket событие `notification-received` с мгновенным отображением в UI.

---

## 🔗 Связности и зависимости

- Интегрируется с friends, guilds, quests, achievements, economy, battle pass.
– Использует realtime и session-service для live доставки.
- Передаёт данные в analytics-service и incident-service.
- Зависит от template-service для локализации, mail-service для email.

---

## ✅ Критерии приемки

1. `notifications.yaml` покрывает все каналы, сценарии отправки и управления.
2. Описаны модели, события, статусы доставки, ошибки.
3. Прописаны idempotency, rate limits, quiet hours, audit.
4. Реализованы примеры, тест-кейсы, чеклист.

---

## 📎 Checklist

- [ ] Использован шаблон `api-generation-task-template.md`
- [ ] Определены микросервис, UI модуль, зависимости
- [ ] Эндпоинты и события покрывают отправку, предпочтения, историю
- [ ] Добавлены модели, ошибки, примеры, критерии
- [ ] Обновить `tasks/config/brain-mapping.yaml`

---

## ❓FAQ

**Q:** Нужно ли поддерживать критические уведомления вне тихих часов?**
**A:** Да, предусмотреть override для системных событий (`priority=CRITICAL`) с логированием и уведомлением игрока о нарушении тихих часов.

**Q:** Как обрабатывать повторную отправку при ошибках?**
**A:** Ввести `delivery` ресурс со статусами; ретраи через endpoint `/retry/{notificationId}`, ограничивая количество попыток и логируя причины.


