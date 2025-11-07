# Task ID: API-TASK-204
**Тип:** API Generation
**Приоритет:** критический
**Статус:** queued
**Создано:** 2025-11-07 23:05
**Создатель:** GPT-5 Codex (API Task Creator)
**Зависимости:** none

---

## 📋 Краткое описание

Создать OpenAPI спецификацию для системы клановых войн, территорий и осад (`clan-war-system`).

**Что нужно сделать:** Разработать `api/v1/gameplay/clans/clan-war-system.yaml`, покрыв объявление войн, фазы, осады, контроль территорий, награды и аналитику.

---

## 🎯 Цель задания

Обеспечить кланам полный набор API-инструментов для ведения войн за территории, отслеживания прогресса и распределения наград, а также дать Ops/LiveOps контроль над событиями и балансом.

**Зачем это нужно:**
- Поддержать масштабное PvP endgame, влияющее на экономику и мир
- Синхронизировать управление территорией между gameplay-service, economy, notification
- Обеспечить справедливые награды/штрафы и трекинг показателей войны
- Предоставить аналитику и глобальные события для LiveOps/Esports

---

## 📚 Источники информации

### Основной документ

**Путь:** `.BRAIN/05-technical/backend/clan-war/clan-war-system.md`
**Версия:** v1.0.0 (2025-11-07 02:34)
**Статус:** approved (api-readiness: ready)

**Ключевые блоки:**
- Структура войны: объявление, подготовка, битвы (осады), послевоенные эффекты
- Таблицы: кланы, союзники, уязвимости, территория, war events, siege timers
- Territory control (districts, ресурсные бонусы), scheduled wars, календарь
- Alliance система, ограничения (макс союзников, стоимость войны)
- Награды: ресурсы, косметика, престиж, глобальные баффы
- Penalty система (defeat penalties, deserter логика)

### Дополнительные источники

- `.BRAIN/05-technical/backend/guild-system-backend.md`
- `.BRAIN/05-technical/backend/party-system.md`
- `.BRAIN/05-technical/backend/economy-system.md`
- `.BRAIN/05-technical/backend/notification-system.md`
- `.BRAIN/05-technical/backend/incident-response/incident-response.md`
- `.BRAIN/05-technical/backend/realtime-server/part1-architecture-zones.md`

### Связанные документы

- `.BRAIN/05-technical/backend/progression-backend.md` (clan XP, prestige)
- `.BRAIN/02-gameplay/world/events/world-events-framework.md`

---

## 📁 Целевая структура API

- **Файл:** `api/v1/gameplay/clans/clan-war-system.yaml`
- **Версия API:** v1
- **Тип:** OpenAPI 3.0.3

```
API-SWAGGER/api/v1/gameplay/clans/
 └── clan-war-system.yaml  ← создать/заполнить
```

---

## 🏗️ Целевая архитектура (⚠️ ОБЯЗАТЕЛЬНО)

### Backend
- **Микросервис:** gameplay-service
- **Порт:** 8083
- **API Base Path:** `/api/v1/gameplay/clans`
- **Зависимости:** auth-service, guild-service (clan data), economy-service, notification-service, analytics-service, incident-service, realtime-service (battle orchestration)

### Frontend
- **Модуль:** `modules/clans/war`
- **State Store:** `useClanWarStore`
- **State:** `wars`, `territories`, `siegeTimers`, `alliances`, `rewards`
- **UI компоненты:** `ClanWarDashboard`, `WarDeclarationForm`, `SiegeTimeline`, `TerritoryMap`, `AlliancePanel`, `WarRewardsModal`
- **Формы:** `DeclareWarForm`, `ScheduleSiegeForm`, `AllianceInviteForm`, `RewardDistributionForm`
- **Layouts:** `ClanHQLayout`, `WarOperationsLayout`
- **Хуки:** `useWarTimeline`, `useTerritoryControl`, `useSiegeStatus`

### Комментарий для YAML

```yaml
# Target Architecture:
# - Microservice: gameplay-service (port 8083)
# - API Base: /api/v1/gameplay/clans
# - Dependencies: auth-service, guild-service, economy-service, notification-service, analytics-service, incident-service, realtime-service
# - Frontend Module: modules/clans/war (useClanWarStore)
# - UI: ClanWarDashboard, WarDeclarationForm, SiegeTimeline, TerritoryMap, AlliancePanel, WarRewardsModal
# - Forms: DeclareWarForm, ScheduleSiegeForm, AllianceInviteForm, RewardDistributionForm
# - Layouts: ClanHQLayout, WarOperationsLayout
# - Hooks: useWarTimeline, useTerritoryControl, useSiegeStatus
```

---

## ✅ Что нужно сделать (детальный план)

1. Описать войну от создания до завершения: declare → preparation → battles → resolution → cooldown.
2. Создать endpoints для управления территориями, осадами, расписанием, союзами.
3. Определить награды, penalties и логику распределения.
4. Включить аналитические endpoints (winrate, territory dominance, war history).
5. Задокументировать события (event bus) и уведомления игроков/кланов.
6. Указать анти-абуз (стоимость объявлений, защитные окна, max wars simultaneously).
7. Подготовить JSON-примеры, тест-план; пройти чеклист.

---

## 🔀 Endpoints

1. **POST `/api/v1/gameplay/clans/{clanId}/wars/declare`** – объявить войну другому клану (условия, стоимость, союзники).
2. **GET `/api/v1/gameplay/clans/wars/pending`** – список войн в подготовительной фазе.
3. **POST `/api/v1/gameplay/clans/wars/{warId}/accept`** – принять/отклонить войну (для защищающегося клана).
4. **GET `/api/v1/gameplay/clans/wars/{warId}`** – детали войны (фазы, участники, миссии, таймеры).
5. **POST `/api/v1/gameplay/clans/wars/{warId}/schedule-siege`** – запланировать осаду (территория, время, условия).
6. **GET `/api/v1/gameplay/clans/wars/{warId}/sieges`** – текущие/завершённые осады, результаты.
7. **POST `/api/v1/gameplay/clans/wars/{warId}/alliances`** – пригласить союзников, принять или отклонить помощь.
8. **GET `/api/v1/gameplay/clans/territories`** – карта территорий, владельцы, бонусы, contest status.
9. **POST `/api/v1/gameplay/clans/territories/{territoryId}/fortify`** – укрепить/улучшить защиту (стоимость, cooldown).
10. **POST `/api/v1/gameplay/clans/wars/{warId}/report`** – зарегистрировать результаты боя (kills, objectives, control).
11. **POST `/api/v1/gameplay/clans/wars/{warId}/resolve`** – завершить войну, распределить награды и штрафы.
12. **GET `/api/v1/gameplay/clans/wars/history`** – история войн (фильтры по клану, периоду, территории).
13. **GET `/api/v1/gameplay/clans/wars/analytics`** – winrate, territory dominance, экономическое влияние.
14. **POST `/api/v1/gameplay/clans/wars/{warId}/penalties`** – применить штрафы (defeat, deserter, exploitation).
15. **POST `/api/v1/gameplay/clans/wars/{warId}/broadcast`** – отправить уведомления участникам/всему серверу (опционально).

---

## 🧱 Модели данных

- **WarDeclarationRequest/Response** – attackerClanId, defenderClanId, targetTerritories[], proposedTime, cost, allies.
- **ClanWar** – warId, status (`DECLARED|PREPARATION|IN_PROGRESS|RESOLVED|CANCELLED`), phases, schedules, score, casualties.
- **SiegePlan** – siegeId, territoryId, startTime, duration, objectives, attackerForces, defenderForces.
- **SiegeResult** – outcome, captured, damageReport, rewardsIssued.
- **Territory** – territoryId, name, region, bonuses, currentOwner, contestStatus, vulnerabilityWindow.
- **AllianceInvitation** – inviterClanId, inviteeClanId, status, rights (support, reinforcements, sharedRewards).
- **WarReward** – rewardId, rewardType (currency/item/buff/title), deliveredTo, distributionRules.
- **Penalty** – penaltyType (`ECONOMIC`, `COOLDOWN`, `RESTRICTION`), value, duration.
- **WarAnalyticsResponse** – warsPerWeek, winRate, territoryControl %, economicImpact, topClans.
- **WarHistoryEntry** – warId, start/end, participants, outcome, territoryChanges.
- **FortifyRequest** – investmentAmount, upgradeLevel, buffType.
- **BroadcastRequest** – channel (`server|participants|allies`), message, attachments.
- **Error schemas** – `ClanWarError` (`ALREADY_IN_WAR`, `INVALID_TERRITORY`, `INSUFFICIENT_FUNDS`, `PROTECTED_PERIOD`, `ALLY_LIMIT_REACHED`).
- **Event payloads** – `ClanWarDeclaredEvent`, `SiegeScheduledEvent`, `TerritoryCapturedEvent`, `ClanWarResolvedEvent`, `ClanWarPenaltyAppliedEvent`.

Каждая схема должна иметь описание, `required`, ограничения (enum, min/max), примеры JSON.

---

## 🧭 Принципы и правила

- Использовать `BearerAuth` (клан лидеры/офицеры), `ServiceToken` для системных событий.
- Подключать общие ответы/ошибки из `api/v1/shared/common/responses.yaml`.
- Указать лимиты: max wars per clan, preparation window, territory immunity после поражения.
- Прописать интеграции с economy (стоимость войны, награды), notification (оповещения), incident (эксплойты).
- Учесть timezones и global schedule.

---

## 🧪 Примеры

- Объявление войны (attacker vs defender, 24h подготовка).
- План осады и итоговый отчет с наградами.
- Карта территорий с бонусами и contest статусом.
- Аналитика за неделю (wars, победители, контроль).
- Сообщение о войне для broadcast.

---

## 🔗 Связности и зависимости

- Служит источником для world events (глобальные новости).
- Влияет на экономику (налоги, бонусы, рынок).
- Взаимодействует с progression (clan XP, ранги).
- Подключается к realtime battles (осады на instance-серверах).

---

## ✅ Критерии приемки

1. Файл `clan-war-system.yaml` создан с архитектурным комментарием.
2. Задокументированы все ключевые эндпоинты и сценарии.
3. Модели данных охватывают войны, территории, осады, награды и аналитику.
4. Описаны события, интеграции, ограничения и penalty правила.
5. Добавлены примеры JSON и тест-план с особыми кейсами (массовая война, ничья, exploit).
6. Пройден чеклист `tasks/config/checklist.md`, задание самодостаточно.

---

## ❓ FAQ

- **Можно ли отменить войну?** – Только до начала осады (описать в responses).
- **Как работает защита новичков?** – Territory immunity/war eligibility условия.
- **Сколько союзников можно подключить?** – Ограничение M, указать в `settings`.
- **Что если обе стороны не приходят на осаду?** – Описать outcome (ничья/штраф).
- **Можно ли перекупить территорию?** – Нет, только через войны (описать в FAQ).

---

## 🕓 История выполнения

- 2025-11-07 23:05 — Задание создано (GPT-5 Codex)

---

**Примечание:** Перед handoff пройти чеклист `tasks/config/checklist.md`.

