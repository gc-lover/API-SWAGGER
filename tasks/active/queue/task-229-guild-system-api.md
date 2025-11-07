# Task ID: API-TASK-229
**Тип:** API Generation
**Приоритет:** высокий
**Статус:** queued
**Создано:** 2025-11-08 04:55
**Создатель:** GPT-5 Codex (API Task Creator)
**Зависимости:** API-TASK-225, API-TASK-223, API-TASK-228

---

## 📋 Краткое описание

Подготовить OpenAPI спецификацию системы гильдий: создание/управление гильдиями, ранги, банк, события, прогрессия, связи с клановыми войнами и соц. сервисами.

**Что нужно сделать:** Создать `api/v1/guilds/guild-system.yaml`, описав REST/WS контракты согласно `.BRAIN/05-technical/backend/guild-system-backend.md`.

---

## 🎯 Цель задания

Дать полноценный backend для гильдий, обеспечивающий социальный каркас MMO и интеграцию с другими системами.

**Зачем это нужно:**
- Управление жизненным циклом гильдий, членством и правами
- Поддержка гильдейского банка, событий, прогрессии
- Интеграция с клановыми войнами, клановыми рейтингами, квестами
- Уведомления, аналитика, социальные интеграции

---

## 📚 Источники информации

### Основной документ

**Путь:** `.BRAIN/05-technical/backend/guild-system-backend.md`
**Версия:** v1.0.0 (2025-11-07)
**Статус:** approved, api-readiness: ready

**Ключевые разделы:**
- Guild lifecycle (create, approve, disband)
- Membership flows (invite, apply, join, leave, kick, transfer)
- Ranks & permissions, role-based access
- Guild bank, contributions, ledger
- Guild progression (levels, perks, research)
- Events & scheduling, attendance tracking
- War integration, alliances, diplomacy

### Дополнительные источники

- `.BRAIN/05-technical/backend/clan-war/clan-war-system.md`
- `.BRAIN/05-technical/backend/leaderboard-system.md`
- `.BRAIN/05-technical/backend/friend-system.md`
- `.BRAIN/05-technical/backend/economy-system.md`
- `.BRAIN/05-technical/backend/notification-system.md`

### Связанные документы

- `API-SWAGGER/tasks/active/queue/task-223-clan-war-system-api.md`
- `API-SWAGGER/tasks/active/queue/task-225-leaderboard-system-api.md`
- `API-SWAGGER/tasks/active/queue/task-228-friend-system-api.md`

---

## 📁 Целевая структура API

- **Файл:** `api/v1/guilds/guild-system.yaml`
- **Версия API:** v1
- **Формат:** OpenAPI 3.0.3

```
API-SWAGGER/api/v1/guilds/
 ├── guild-system.yaml        ← создать/обновить
 ├── guild-components.yaml
 └── guild-examples.yaml
```

---

## 🏗️ Целевая архитектура (⚠️ ОБЯЗАТЕЛЬНО)

### Backend
- **Микросервис:** social-service (guilds module)
- **Порт:** 8091
- **API Base Path:** `/api/v1/guilds`
- **Зависимости:**
  - auth-service – авторизация, платформа
  - friend-service – social graph, invites
  - clan-war-service – войны, территории
  - progression-service – guild XP, perks
  - economy-service – guild bank, валюта
  - notification-service – уведомления, рассылки
  - analytics-service – отчётность, KPI
  - realtime-service – live события
  - moderation-service – жалобы, санкции

### Frontend
- **Модуль:** `modules/social/guilds`
- **State Store:** `useGuildStore`
- **State:** `guildInfo`, `members`, `ranks`, `bank`, `events`, `applications`, `wars`
- **UI компоненты:** `GuildDashboard`, `GuildMemberList`, `GuildRankEditor`, `GuildBankPanel`, `GuildEventsCalendar`, `GuildWarStatus`
- **Формы:** `GuildCreateForm`, `GuildApplicationForm`, `GuildRankForm`, `GuildBankTransactionForm`, `GuildEventForm`
- **Хуки:** `useGuild`, `useGuildMembers`, `useGuildBank`, `useGuildEvents`, `useGuildWars`

### Комментарий для YAML

```yaml
# Target Architecture:
# - Microservice: social-service (guilds module, port 8091)
# - API Base: /api/v1/guilds
# - Dependencies: auth, friend, clan-war, progression, economy, notification, analytics, realtime, moderation
# - Frontend Module: modules/social/guilds (useGuildStore)
# - UI: GuildDashboard, GuildMemberList, GuildRankEditor, GuildBankPanel, GuildEventsCalendar, GuildWarStatus
# - Forms: GuildCreateForm, GuildApplicationForm, GuildRankForm, GuildBankTransactionForm, GuildEventForm
# - Hooks: useGuild, useGuildMembers, useGuildBank, useGuildEvents, useGuildWars
```

---

## ✅ Что нужно сделать (детальный план)

1. Описать модели гильдии, участника, рангов, разрешений, банка, событий, заявок.
2. Реализовать CRUD гильдий, управление членством и заявками.
3. Добавить управление рангами, правами, шаблонами разрешений.
4. Описать гильдейский банк (депозиты, выплаты, лимиты, аудит).
5. Реализовать систему гильдейской прогрессии, перков, исследований.
6. Добавить планировщик событий, attendance, уведомления.
7. Интегрировать с клан-войнами, лидербордами, аналитикой.
8. Настроить realtime события, webhooks, audit.
9. Подготовить примеры и тест-кейсы.

---

## 🔀 Endpoints

1. **POST `/api/v1/guilds`** – создать гильдию (название, теги, эмблема, политика приглашений).
2. **GET `/api/v1/guilds/{guildId}`** – информация о гильдии, прогрессия, перки.
3. **PATCH `/api/v1/guilds/{guildId}`** – обновление настроек (описание, правила, политика).
4. **DELETE `/api/v1/guilds/{guildId}`** – распуск гильдии (с подтверждением и аудитом).
5. **GET `/api/v1/guilds/{guildId}/members`** – участники, ранги, статус, вклад.
6. **POST `/api/v1/guilds/{guildId}/members`** – приглашение/добавление (по кандидату, заявке).
7. **PATCH `/api/v1/guilds/{guildId}/members/{memberId}`** – изменение ранга, роли, заметок.
8. **DELETE `/api/v1/guilds/{guildId}/members/{memberId}`** – исключение, добровольный выход.
9. **GET `/api/v1/guilds/{guildId}/applications`** – заявки, статусы, фильтрация.
10. **POST `/api/v1/guilds/{guildId}/applications`** – подача заявки.
11. **POST `/api/v1/guilds/{guildId}/applications/{applicationId}/approve`** – одобрение/отклонение заявки.
12. **GET `/api/v1/guilds/{guildId}/ranks`** – список рангов, разрешения.
13. **PUT `/api/v1/guilds/{guildId}/ranks`** – обновление рангов (bulk, шаблоны).
14. **GET `/api/v1/guilds/{guildId}/bank`** – баланс, транзакции, лимиты.
15. **POST `/api/v1/guilds/{guildId}/bank/transactions`** – вклад/вывод, утверждения, квоты.
16. **GET `/api/v1/guilds/{guildId}/progression`** – уровень гильдии, XP, перки, исследования.
17. **POST `/api/v1/guilds/{guildId}/progression/upgrade`** – разблокировка перка/исследования.
18. **GET `/api/v1/guilds/{guildId}/events`** – расписание, attendance, напоминания.
19. **POST `/api/v1/guilds/{guildId}/events`** – создать событие (рейд, собрание).
20. **POST `/api/v1/guilds/{guildId}/events/{eventId}/attendance`** – отметиться/подтвердить участие.
21. **GET `/api/v1/guilds/{guildId}/wars`** – текущие войны, статус, развертывание.
22. **POST `/api/v1/guilds/{guildId}/alliances`** – заявка на союз, подтверждение.
23. **GET `/api/v1/guilds/search`** – поиск гильдий (фильтры по языку, режиму, активности).
24. **GET `/api/v1/guilds/{guildId}/audit`** – журнал действий, транзакций, наказаний.
25. **WS `/api/v1/guilds/{guildId}/stream`** – события: `member-joined`, `member-left`, `rank-changed`, `bank-updated`, `event-created`, `war-status`, `perk-unlocked`.

---

## 🧱 Модели данных

- **Guild** – `guildId`, `name`, `tag`, `description`, `language`, `policy`, `level`, `xp`, `perks`, `emblem`, `createdAt`.
- **GuildMember** – `memberId`, `playerId`, `rank`, `role`, `joinDate`, `contribution`, `status`, `lastOnline`.
- **GuildRank** – `rankId`, `name`, `priority`, `permissions[]`, `limits`.
- **GuildPermission** – `permission`, `description`, `scope`.
- **GuildApplication** – `applicationId`, `applicant`, `message`, `status`, `submittedAt`, `decision`.
- **GuildBankAccount** – `currency`, `balance`, `softCap`, `hardCap`, `withdrawPolicy`.
- **GuildBankTransaction** – `transactionId`, `type`, `amount`, `item`, `initiator`, `approvedBy`, `timestamp`, `notes`.
- **GuildProgression** – `level`, `xp`, `nextLevelXp`, `perksUnlocked`, `research`.
- **GuildEvent** – `eventId`, `title`, `type`, `schedule`, `location`, `maxParticipants`, `attendance`.
- **GuildWarStatus** – `warId`, `opponent`, `phase`, `territory`, `score`, `startAt`, `endAt`.
- **AllianceRequest** – `requestId`, `guildId`, `allyGuildId`, `status`, `terms`.
- **RealtimeEventPayload** – `memberJoined`, `memberLeft`, `rankChanged`, `bankUpdated`, `eventCreated`, `warStatus`, `perkUnlocked`.
- **Error Schema (`GuildError`)** – codes (`NAME_TAKEN`, `LIMIT_REACHED`, `PERMISSION_DENIED`, `BANK_LIMIT`, `APPLICATION_DUPLICATE`, `WAR_LOCK`, `ALLY_CONFLICT`).

---

## 🧭 Принципы и правила

- Авторизация: `BearerAuth` для игроков; `GuildOfficerToken` (scope) для управления; `ServiceToken` для интеграций.
- Permissions: RBAC, проверять каждый endpoint на разрешения ранга.
- Rate limits: на создание гильдий, заявки, bank операции.
- Audit: критические операции логируются и доступны moderation.
- Webhooks: предусмотреть события для внешних интеграций (Discord, web).
- Localization: названия, описания, сообщения – через shared localization refs.
- Scalability: использовать caching (guild info), eventual consistency для банок/прогрессии.

---

## 🧪 Примеры

- Создание гильдии, настройка рангов и выдача ролей офицерам.
- Приём заявки и назначение игрока на роль рейд-лидера.
- Внесение средств в банк, выдача ресурсов с одобрением офицера.
- Создание события рейда и отметка присутствия участников.
- Просмотр войны и изменение стратегии через guild war статус.

---

## 🔗 Связности и зависимости

- Интеграция с clan-war, leaderboards, friends/social, progression, economy.
- Используется UI модулем `GuildDashboard`, `GuildWarStatus` и др.
- Взаимодействует с notification (приглашения, события), analytics (вклад).

---

## ✅ Критерии приемки

1. `guild-system.yaml` покрывает весь цикл управления гильдиями.
2. Описаны модели, разрешения, события, интеграции, аудит.
3. Подготовлены примеры и тест-кейсы, чеклист закрыт.

---

## 📎 Checklist

- [ ] Использован шаблон `api-generation-task-template.md`
- [ ] Определены микросервис, UI модуль, зависимости
- [ ] Эндпоинты и события покрывают управление гильдиями, банк, прогрессию, войны
- [ ] Добавлены модели, ошибки, примеры, критерии
- [ ] Обновить `tasks/config/brain-mapping.yaml`

---

## ❓FAQ

**Q:** Как обрабатывать переименование гильдии?**
**A:** Предусмотреть ограничение по времени/стоимости, approve workflow; описать в PATCH endpoint и модели аудита.

**Q:** Требуются ли API для межсерверных гильдий?**
**A:** Указать флаг/поле `shard` и описать возможное расширение для cross-shard состояний.


