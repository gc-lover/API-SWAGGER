# Task ID: API-TASK-228
**Тип:** API Generation
**Приоритет:** высокий
**Статус:** queued
**Создано:** 2025-11-08 04:40
**Создатель:** GPT-5 Codex (API Task Creator)
**Зависимости:** API-TASK-211, API-TASK-219, API-TASK-224

---

## 📋 Краткое описание

Разработать спецификацию API социальной системы друзей: управление запросами, списком друзей, присутствием, игнором и recent players.

**Что нужно сделать:** Создать `api/v1/social/friends/friend-system.yaml`, описав REST/WS контракты по `.BRAIN/05-technical/backend/friend-system.md`.

---

## 🎯 Цель задания

Обеспечить надёжную социальную инфраструктуру для взаимодействия игроков.

**Зачем это нужно:**
- Управлять дружескими связями, заявками и блокировками
- Показывать присутствие, статусы, активность
- Поддерживать cross-platform invites, recent players
- Дать данные UI модулям и аналитике, синхронизировать с notification и realtime

---

## 📚 Источники информации

### Основной документ

**Путь:** `.BRAIN/05-technical/backend/friend-system.md`
**Версия:** v1.0.0 (2025-11-07)
**Статус:** approved, api-readiness: ready

**Ключевые разделы:**
- Friend list lifecycle (add, confirm, remove)
- Requests, invitations, throttling
- Presence/online status, platforms, activities
- Ignore/block list, privacy уровни
- Recent players, suggestions, social graph

### Дополнительные источники

- `.BRAIN/05-technical/backend/notification-system.md`
- `.BRAIN/05-technical/backend/session-management/README.md`
- `.BRAIN/05-technical/backend/leaderboard-system.md`
- `.BRAIN/05-technical/backend/guild-system-backend.md`
- `.BRAIN/05-technical/backend/social-presence.md` *(если доступен)*

### Связанные документы

- `API-SWAGGER/tasks/active/queue/task-211-leaderboards-ui-api.md`
- `API-SWAGGER/tasks/active/queue/task-219-achievement-tracking-api.md`
- `API-SWAGGER/tasks/active/queue/task-224-progression-backend-api.md`

---

## 📁 Целевая структура API

- **Файл:** `api/v1/social/friends/friend-system.yaml`
- **Версия API:** v1
- **Формат:** OpenAPI 3.0.3

```
API-SWAGGER/api/v1/social/friends/
 ├── friend-system.yaml     ← создать/обновить
 ├── friend-components.yaml
 └── friend-examples.yaml
```

---

## 🏗️ Целевая архитектура (⚠️ ОБЯЗАТЕЛЬНО)

### Backend
- **Микросервис:** social-service (friends module)
- **Порт:** 8090
- **API Base Path:** `/api/v1/social/friends`
- **Зависимости:**
  - auth-service – верификация пользователя, платформы
  - session-service – presence, last activity, game session invites
  - notification-service – push, inbox сообщения
  - realtime-service – WebSocket presence updates
  - analytics-service – метрики social interactions
  - moderation-service – отчёты на игроков, auto-block

### Frontend
- **Модуль:** `modules/social/friends`
- **State Store:** `useFriendsStore`
- **State:** `friends`, `requests`, `incoming`, `presence`, `blocks`, `recent`
- **UI компоненты:** `FriendsList`, `FriendRequestsPanel`, `PresenceIndicator`, `BlockList`, `RecentPlayers`, `InviteFriendModal`
- **Формы:** `FriendSearchForm`, `SendRequestForm`, `InviteToPartyForm`
- **Хуки:** `useFriends`, `usePresence`, `useFriendRequests`, `useFriendInvites`

### Комментарий для YAML

```yaml
# Target Architecture:
# - Microservice: social-service (port 8090)
# - API Base: /api/v1/social/friends
# - Dependencies: auth, session, notification, realtime, analytics, moderation
# - Frontend Module: modules/social/friends (useFriendsStore)
# - UI: FriendsList, FriendRequestsPanel, PresenceIndicator, BlockList, RecentPlayers, InviteFriendModal
# - Forms: FriendSearchForm, SendRequestForm, InviteToPartyForm
# - Hooks: useFriends, usePresence, useFriendRequests, useFriendInvites
```

---

## ✅ Что нужно сделать (детальный план)

1. Описать модели друзей, запросов, присутствия, блоков, recent players.
2. Реализовать эндпоинты отправки, принятия, отклонения запросов, удаления друзей.
3. Добавить управление присутствием, статусами, активностями.
4. Описать блокировки, mute, privacy настройки.
5. Поддержать recent players, social suggestions, party invite hooks.
6. Настроить real-time события, rate limits, throttling, audit.
7. Подготовить примеры, тест-кейсы, чеклист.

---

## 🔀 Endpoints

1. **GET `/api/v1/social/friends`** – список друзей с presence, статусами, платформой.
2. **POST `/api/v1/social/friends`** – отправить запрос в друзья (по playerId, nickname, externalId).
3. **GET `/api/v1/social/friends/requests`** – входящие и исходящие заявки.
4. **POST `/api/v1/social/friends/requests/{requestId}/accept`** – принять запрос.
5. **POST `/api/v1/social/friends/requests/{requestId}/decline`** – отклонить/игнорировать запрос.
6. **DELETE `/api/v1/social/friends/{friendId}`** – удалить из друзей.
7. **GET `/api/v1/social/friends/presence`** – presence-feed (real-time fallback / polling).
8. **POST `/api/v1/social/friends/presence`** – обновить собственный presence (activity, availability).
9. **GET `/api/v1/social/friends/recent`** – список недавних игроков.
10. **GET `/api/v1/social/friends/suggestions`** – предложения друзей (общие друзья, кланы, матчмейкинг).
11. **GET `/api/v1/social/friends/blocks`** – список блокировок/игнор.
12. **POST `/api/v1/social/friends/blocks`** – добавить в блок/игнор (параметры: тип, причина, срок).
13. **DELETE `/api/v1/social/friends/blocks/{blockId}`** – снять блокировку.
14. **POST `/api/v1/social/friends/invites`** – отправить приглашение в сессию/клан/party.
15. **WS `/api/v1/social/friends/stream`** – события: `friend-request`, `request-accepted`, `friend-removed`, `presence-update`, `block-added`, `invite-received`.

---

## 🧱 Модели данных

- **Friend** – `playerId`, `nickname`, `platform`, `relationship`, `presence`, `favorite`, `metadata`.
- **FriendRequest** – `requestId`, `from`, `to`, `message`, `createdAt`, `status`, `expiresAt`.
- **Presence** – `state` (`ONLINE|AWAY|IN_MATCH|OFFLINE`), `activity`, `sessionId`, `platform`, `lastSeen`.
- **BlockEntry** – `blockId`, `targetId`, `type` (`BLOCK|MUTE|REPORT`), `reason`, `expiresAt`.
- **RecentPlayer** – `playerId`, `metAt`, `context` (`MATCH|TRADE|CLAN`), `score`.
- **Suggestion** – `playerId`, `source`, `mutualFriends`, `relevance`.
- **Invite** – `inviteId`, `from`, `to`, `context`, `payload`, `expiresAt`.
- **RealtimeEventPayload** – `friendRequest`, `requestAccepted`, `friendRemoved`, `presenceUpdate`, `blockAdded`, `inviteReceived`.
- **Error Schema (`FriendError`)** – codes (`REQUEST_LIMIT`, `ALREADY_FRIENDS`, `BLOCKED`, `PRIVACY_RESTRICTED`, `RATE_LIMITED`, `INVITE_FAILED`).

---

## 🧭 Принципы и правила

- Авторизация: `BearerAuth`; отдельный `ServiceToken` для internal events.
- Rate Limiting: отправка заявок и приглашений ограничена, использовать shared throttle responses.
- Idempotency: повторные запросы дружбы с `idempotencyKey`.
- Privacy: уважаем настройки (visibility, search opt-out), возвращаем маскированные данные.
- Audit: операции логируются, нарушения передаются в moderation-service.
- Localization: все message templates через shared localization.

---

## 🧪 Примеры

- Поиск друга по nickname и отправка запроса.
- Приём запроса, обновление списка друзей, пуш уведомления.
- Обновление presence и получение realtime событий.
- Добавление игрока в блок после жалобы.
- Получение recent players из последнего матча и приглашение в party.

---

## 🔗 Связности и зависимости

- Интегрировано с session-service (presence) и notification-service (push, email).
- Используется UI Leaderboards/Friends (Task 211) и Clan/Guild системы.
- Данные влияют на matchmaking, achievements (social milestones), analytics.

---

## ✅ Критерии приемки

1. `friend-system.yaml` содержит все CRUD операции, presence, блокировки, invites.
2. Прописаны модели, события, ошибки, ограничения.
3. Примеры и тест-кейсы подготовлены, чеклист закрыт.

---

## 📎 Checklist

- [ ] Использован шаблон `api-generation-task-template.md`
- [ ] Определены микросервис, UI модуль, зависимости
- [ ] Эндпоинты и события покрывают дружеские сценарии
- [ ] Добавлены модели, ошибки, примеры, критерии
- [ ] Обновить `tasks/config/brain-mapping.yaml`

---

## ❓FAQ

**Q:** Нужна ли поддержка offline сообщений?**
**A:** Нет в первой версии, но предусмотреть расширение через notification inbox.

**Q:** Как обрабатывать cross-platform идентификаторы?**
**A:** Использовать unified `PlayerIdentifier` (platform + externalId) и `lookup` endpoint в shared components; упомянуть в описании.


