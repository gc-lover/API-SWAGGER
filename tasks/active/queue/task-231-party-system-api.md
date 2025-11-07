# Task ID: API-TASK-231
**Тип:** API Generation
**Приоритет:** высокий
**Статус:** queued
**Создано:** 2025-11-08 05:25
**Создатель:** GPT-5 Codex (API Task Creator)
**Зависимости:** API-TASK-228, API-TASK-227, API-TASK-224

---

## 📋 Краткое описание

Создать спецификацию API для системы групп: создание party, управление участниками, настройка ролей и распределения лута, синхронизация квестов и интеграция с чатом.

**Что нужно сделать:** Подготовить `api/v1/party/party-system.yaml`, описав REST/WS контракты по документу `.BRAIN/05-technical/backend/party-system.md`.

---

## 🎯 Цель задания

Обеспечить устойчивую backend-платформу party, поддерживающую кооперативный геймплей, рейды, данджи и социальное взаимодействие.

**Зачем это нужно:**
- Управлять жизненным циклом party (create → manage → disband)
- Поддерживать роли, лидерство, голосования, ready-check
- Синхронизировать квесты, лут, опыт, приглашения
- Интегрировать party с матчмейкингом, voice/chat, клановыми событиями

---

## 📚 Источники информации

### Основной документ

**Путь:** `.BRAIN/05-technical/backend/party-system.md`
**Версия:** v1.0.0 (2025-11-07)
**Статус:** approved, api-readiness: ready

**Ключевые разделы:**
- Party lifecycle, leadership, roles
- Invite/join flow, поиск группы
- Loot distribution modes (need/greed, personal, master)
- Shared quest progress, synchronization
- Ready check, vote-kick, party status
- Integrations: chat, voice, matchmaking

### Дополнительные источники

- `.BRAIN/05-technical/backend/friend-system.md`
- `.BRAIN/05-technical/backend/matchmaking/matchmaking-queue.md`
- `.BRAIN/05-technical/backend/quest-engine-backend.md`
- `.BRAIN/05-technical/backend/loot-system/part2-advanced-loot.md`
- `.BRAIN/05-technical/backend/realtime-server/part1-architecture-zones.md`
- `.BRAIN/05-technical/backend/notification-system.md`

### Связанные документы

- `API-SWAGGER/tasks/active/queue/task-228-friend-system-api.md`
- `API-SWAGGER/tasks/active/queue/task-227-combat-session-api.md`
- `API-SWAGGER/tasks/active/queue/task-224-progression-backend-api.md`

---

## 📁 Целевая структура API

- **Файл:** `api/v1/party/party-system.yaml`
- **Версия API:** v1
- **Формат:** OpenAPI 3.0.3

```
API-SWAGGER/api/v1/party/
 ├── party-system.yaml      ← создать/обновить
 ├── party-components.yaml
 └── party-examples.yaml
```

---

## 🏗️ Целевая архитектура (⚠️ ОБЯЗАТЕЛЬНО)

### Backend
- **Микросервис:** social-service (party module) или gameplay-service (party)
- **Порт:** 8093
- **API Base Path:** `/api/v1/party`
- **Зависимости:**
  - auth-service – удостоверение игроков
  - friend-service – приглашения друзей
  - matchmaking-service – поиск группы/подбор
  - combat-service – синхронизация боёв
  - loot-service – распределение лута
  - quest-service – совместный прогресс
  - notification-service – уведомления (invites, ready check)
  - realtime-service – обновления состояния party
  - chat-service – party чат и голос

### Frontend
- **Модуль:** `modules/social/party`
- **State Store:** `usePartyStore`
- **State:** `partyInfo`, `members`, `roles`, `lootSettings`, `readyCheck`, `queueStatus`
- **UI компоненты:** `PartyPanel`, `InviteDialog`, `LootSettingsModal`, `ReadyCheckBanner`, `PartyMemberCard`, `PartyQuestProgress`
- **Формы:** `PartyCreateForm`, `PartyInviteForm`, `LootSettingsForm`, `VoteKickForm`
- **Хуки:** `useParty`, `usePartyInvites`, `useLootSettings`, `useReadyCheck`, `usePartyQueue`

### Комментарий для YAML

```yaml
# Target Architecture:
# - Microservice: party module (port 8093)
# - API Base: /api/v1/party
# - Dependencies: auth, friend, matchmaking, combat, loot, quest, notification, realtime, chat
# - Frontend Module: modules/social/party (usePartyStore)
# - UI: PartyPanel, InviteDialog, LootSettingsModal, ReadyCheckBanner, PartyMemberCard, PartyQuestProgress
# - Forms: PartyCreateForm, PartyInviteForm, LootSettingsForm, VoteKickForm
# - Hooks: useParty, usePartyInvites, useLootSettings, useReadyCheck, usePartyQueue
```

---

## ✅ Что нужно сделать (детальный план)

1. Определить модели party, участника, роли, приглашений, настроек лута, ready-check.
2. Добавить эндпоинты для создания, конфигурации, распуска party.
3. Реализовать управление приглашениями, join/leave, vote-kick.
4. Описать настройки лута, голосование, master looter approvals.
5. Поддержать shared quest trackers, синхронизацию событий.
6. Реализовать ready check, queue join, party matchmaking.
7. Добавить realtime события и WebSocket стрим.
8. Подготовить примеры, сценарии, чеклист.

---

## 🔀 Endpoints

1. **POST `/api/v1/party`** – создать party (leader, параметры, loot settings).
2. **GET `/api/v1/party/{partyId}`** – состояние party, члены, настройки.
3. **PATCH `/api/v1/party/{partyId}`** – обновить настройки (название, режим, loot rules).
4. **DELETE `/api/v1/party/{partyId}`** – распустить группу (leader/GM, audit).
5. **GET `/api/v1/party/{partyId}/members`** – список участников, роли, статусы.
6. **POST `/api/v1/party/{partyId}/members`** – добавление (по приглашению, авто-join).
7. **PATCH `/api/v1/party/{partyId}/members/{memberId}`** – смена роли, лидера, фокус-таргета.
8. **DELETE `/api/v1/party/{partyId}/members/{memberId}`** – выход/кик (с vote-kick logic).
9. **GET `/api/v1/party/{partyId}/invites`** – активные приглашения, ссылки.
10. **POST `/api/v1/party/{partyId}/invites`** – отправить приглашение (playerId, code, cross-platform).
11. **POST `/api/v1/party/invites/{inviteId}/accept`** – принять приглашение.
12. **POST `/api/v1/party/invites/{inviteId}/decline`** – отклонить.
13. **GET `/api/v1/party/{partyId}/loot`** – текущие настройки лута, master looter, история.
14. **POST `/api/v1/party/{partyId}/loot`** – обновление настроек (need/greed, round-robin, threshold).
15. **POST `/api/v1/party/{partyId}/loot/distribute`** – распределение предмета (голосование/мастер).
16. **POST `/api/v1/party/{partyId}/ready-check`** – запуск ready-check (таймер, уведомления).
17. **POST `/api/v1/party/{partyId}/ready-check/respond`** – ответ участника (ready/not-ready).
18. **POST `/api/v1/party/{partyId}/vote-kick`** – инициировать vote-kick.
19. **POST `/api/v1/party/{partyId}/queue`** – поставить группу в очередь (подбор контента).
20. **DELETE `/api/v1/party/{partyId}/queue`** – отменить очередь.
21. **GET `/api/v1/party/{partyId}/quests`** – совместный прогресс, активные задачи.
22. **POST `/api/v1/party/{partyId}/quests/{questId}/sync`** – синхронизация шагов, шэринг.
23. **GET `/api/v1/party/{partyId}/status`** – текущий статус (в бою, в очереди, idle).
24. **GET `/api/v1/party/search`** – поиск открытых групп (фильтры по контенту, роли).
25. **WS `/api/v1/party/{partyId}/stream`** – события: `member-joined`, `member-left`, `role-changed`, `loot-updated`, `ready-check`, `vote-kick`, `queue-status`, `quest-sync`.

---

## 🧱 Модели данных

- **Party** – `partyId`, `leaderId`, `name`, `mode`, `maxMembers`, `lootSettings`, `status`, `createdAt`.
- **PartyMember** – `memberId`, `playerId`, `role`, `isLeader`, `readyState`, `voiceChannel`, `stats`.
- **Invite** – `inviteId`, `partyId`, `senderId`, `targetId`, `code`, `expiresAt`, `status`.
- **LootSettings** – `mode`, `threshold`, `masterLooter`, `roundRobinIndex`, `autoDistribute`.
- **ReadyCheck** – `readyCheckId`, `initiatorId`, `expiresAt`, `responses`.
- **VoteKick** – `voteId`, `targetMemberId`, `initiatorId`, `votes`, `result`, `expiresAt`.
- **PartyQueueStatus** – `queueId`, `contentType`, `estimatedWait`, `matchId`, `state`.
- **QuestSync** – `questId`, `step`, `progress`, `sharedObjectives`, `lastUpdated`.
- **RealtimeEventPayload** – `memberJoined`, `memberLeft`, `roleChanged`, `lootUpdated`, `readyCheck`, `voteKick`, `queueStatus`, `questSync`.
- **Error Schema (`PartyError`)** – codes (`PARTY_FULL`, `INVITE_INVALID`, `ROLE_LOCKED`, `NOT_LEADER`, `QUEUE_CONFLICT`, `READY_TIMEOUT`, `VOTE_FAILED`).

---

## 🧭 Принципы и правила

- Авторизация: `BearerAuth`; лидерские действия требуют `LeaderScope`; `ServiceToken` для матчмейкинга.
- Rate Limit: ограничить invites, ready-check, vote-kick.
- Idempotency: join/invite/loot события должны поддерживать `idempotencyKey`.
- Persistence: хранить party state в Redis+DB, синхронизация с realtime.
- Audit: кик/loot/leader смены логировать, доступно moderation.
- Localization: тексты уведомлений через notification-service.
- Scalability: поддерживать гибрид (instanced party vs. world party), планировать шардирование.

---

## 🧪 Примеры

- Создание party и приглашение друга с cross-platform кодом.
- Настройка Need/Greed, распределение эпического предмета после рейда.
- Ready-check перед входом в дандж, обработка not-ready.
- Vote-kick токсичного игрока и логирование результата.
- Синхронизация прогресса квеста, автозачёт шага для группы.

---

## 🔗 Связности и зависимости

- Интеграция с friend, matchmaking, combat, loot, quest, notification, realtime, chat, voice.
- Взаимодействие с guild/clan событиями и raid scheduler.
- Использование UI `PartyPanel`, `InviteDialog`, `LootSettingsModal`.

---

## ✅ Критерии приемки

1. `party-system.yaml` покрывает создание, управление, очереди, лут и синхронизацию.
2. Описаны модели, события, ошибки, интеграции.
3. Указаны требования к авторизации, rate limits, idempotency.
4. Примеры и тест-кейсы подготовлены, чеклист закрыт.

---

## 📎 Checklist

- [ ] Использован шаблон `api-generation-task-template.md`
- [ ] Определены микросервис, UI модуль, зависимости
- [ ] Эндпоинты и события покрывают party lifecycle, loot, quests, queue
- [ ] Добавлены модели, ошибки, примеры, критерии
- [ ] Обновить `tasks/config/brain-mapping.yaml`

---

## ❓FAQ

**Q:** Нужна ли поддержка open parties (public)?**
**A:** Да, предусмотреть поле `visibility` (`PRIVATE|FRIENDS|PUBLIC`) и фильтрацию в поиске.

**Q:** Как синхронизировать party chat?**
**A:** Использовать chat-service с отдельным каналом `party-{partyId}`; описать взаимодействие в интеграциях.


