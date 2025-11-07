# Task ID: API-TASK-208
**Тип:** API Generation
**Приоритет:** высокий
**Статус:** queued
**Создано:** 2025-11-08 00:12
**Создатель:** GPT-5 Codex (API Task Creator)
**Зависимости:** API-TASK-207

---

## 📋 Краткое описание

Разработать OpenAPI спецификацию для выдачи наград и испытаний Battle Pass (`battle-pass-rewards-challenges`).

**Что нужно сделать:** Создать `api/v1/gameplay/battle-pass/battle-pass-rewards.yaml`, описав выдачу наград, управление челленджами, прогрессом испытаний и логикой сезонных бонусов.

---

## 🎯 Цель задания

Сформировать REST/WebSocket слой для обслуживания наград и испытаний Battle Pass, интегрированный с ядром прогресса.

**Зачем это нужно:**
- Позволить игрокам безопасно получать награды обоих треков (free/premium)
- Управлять расписанием дневных/недельных челленджей и отслеживать выполнение
- Включить LiveOps события с динамическими заданиями и двойным XP
- Предоставить аналитике данные о популярности наград и сложности испытаний

---

## 📚 Источники информации

### Основной документ

**Путь:** `.BRAIN/05-technical/backend/battle-pass/part2-rewards-challenges.md`
**Версия:** v1.0.1 (2025-11-07 02:41)
**Статус:** approved, api-readiness: ready

**Ключевые разделы:**
- Методы `claimReward`, `completeChallenge`, генерация недельных челленджей
- Типы наград (currency, item, cosmetic, xp boost) и связанные сервисы
- API-эндпоинты для наград, премиума, челленджей, лидербордов
- Логика прогресс-ивентов, бустов, аналитики

### Дополнительные источники

- `.BRAIN/05-technical/backend/battle-pass/part1-core-progression.md` – конфигурация сезонов и XP
- `.BRAIN/05-technical/backend/progression-backend.md` – глобальная система прогресса
- `.BRAIN/05-technical/backend/economy-system.md` – валюты и лимиты
- `.BRAIN/05-technical/backend/inventory-system/part1-core-system.md` – выдача предметов
- `.BRAIN/05-technical/backend/cosmetic/cosmetic-system.md` – разблокировка косметики
- `.BRAIN/05-technical/backend/analytics/analytics-events.md` – отслеживание событий (если доступно)

### Связанные документы

- `API-SWAGGER/tasks/active/queue/task-207-battle-pass-core-api.md` – зависимость по ядру прогресса
- `API-SWAGGER/tasks/active/queue/task-203-cosmetic-system-api.md` – интеграция косметических наград

---

## 📁 Целевая структура API

- **Файл:** `api/v1/gameplay/battle-pass/battle-pass-rewards.yaml`
- **Версия API:** v1
- **Формат:** OpenAPI 3.0.3

```
API-SWAGGER/api/v1/gameplay/battle-pass/
 ├── battle-pass-core.yaml (из API-TASK-207)
 └── battle-pass-rewards.yaml  ← создать/заполнить
```

---

## 🏗️ Целевая архитектура (⚠️ ОБЯЗАТЕЛЬНО)

### Backend
- **Микросервис:** gameplay-service
- **Порт:** 8083
- **API Base Path:** `/api/v1/gameplay/battle-pass`
- **Зависимости:**
  - auth-service – валидация токенов игроков
  - economy-service – списание валюты/выплаты
  - inventory-service – выдача предметов
  - cosmetic-service – разблокировка скинов
  - buff-service – применение XP boost
  - notification-service – уведомления о наградах и челленджах
  - analytics-service – сбор метрик по наградам/челленджам
  - progression-service – синхронизация достижений/прогресса

### Frontend
- **Модуль:** `modules/progression/battle-pass`
- **State Store:** `useBattlePassStore`
- **State:** `rewards`, `claimedLevels`, `challenges`, `boosts`, `leaderboard`
- **UI компоненты:** `RewardTrack`, `ChallengeList`, `RewardPreviewModal`, `BoostTimer`, `BattlePassLeaderboard`
- **Формы:** `ClaimRewardForm`, `ActivateBoostForm`, `ChallengeRerollForm`
- **Layouts:** `ProgressionHubLayout`
- **Хуки:** `useRewards`, `useChallenges`, `useBoosts`, `useBattlePassSocket`

### Комментарий для YAML

```yaml
# Target Architecture:
# - Microservice: gameplay-service (port 8083)
# - API Base: /api/v1/gameplay/battle-pass
# - Dependencies: auth-service, economy-service, inventory-service, cosmetic-service, buff-service, notification-service, analytics-service, progression-service
# - Frontend Module: modules/progression/battle-pass (useBattlePassStore)
# - UI: RewardTrack, ChallengeList, RewardPreviewModal, BoostTimer, BattlePassLeaderboard
# - Forms: ClaimRewardForm, ActivateBoostForm, ChallengeRerollForm
# - Layout: ProgressionHubLayout
# - Hooks: useRewards, useChallenges, useBoosts, useBattlePassSocket
```

---

## ✅ Что нужно сделать (детальный план)

1. Описать выдачу наград по уровням: запрос списка, проверка условий, выдача free/premium треков.
2. Задокументировать API покупки/конвертации наград (token bundles, reroll, bundles).
3. Настроить управление челленджами: генерация, активация бонусов, прогресс по действиям.
4. Добавить операции по XP boost (активация, длительность, эффекты).
5. Реализовать WebSocket/Server-Sent events для обновления прогресса челленджей в реальном времени.
6. Подготовить endpoints аналитики (claim rate, completion rate, boost usage).
7. Указать события event bus (reward claimed, challenge completed, boost activated).
8. Прописать ошибки, лимиты, анти-абуз проверки, интеграцию с incident-service.
9. Подготовить примеры, тест-план, отметить чеклист `tasks/config/checklist.md`.

---

## 🔀 Endpoints

1. **GET `/api/v1/gameplay/battle-pass/rewards`** – список наград сезона (free/premium, фильтры по уровню, редкости).
2. **POST `/api/v1/gameplay/battle-pass/rewards/claim`** – получение наград определённого уровня (проверка статуса, события).
3. **POST `/api/v1/gameplay/battle-pass/rewards/preview`** – предпросмотр награды (для UI и маркетинга).
4. **GET `/api/v1/gameplay/battle-pass/rewards/history`** – история полученных наград и источников.
5. **POST `/api/v1/gameplay/battle-pass/rewards/reroll`** – смена награды при наличии токена (лимиты, стоимость).
6. **GET `/api/v1/gameplay/battle-pass/challenges/daily`** – активные дневные челленджи и прогресс игрока.
7. **GET `/api/v1/gameplay/battle-pass/challenges/weekly`** – активные недельные челленджи, таймеры, награды.
8. **POST `/api/v1/gameplay/battle-pass/challenges/{challengeId}/progress`** – обновление прогресса (service token от матч/квест сервисов).
9. **POST `/api/v1/gameplay/battle-pass/challenges/{challengeId}/complete`** – завершение челленджа и выдача XP/награды.
10. **POST `/api/v1/gameplay/battle-pass/challenges/{challengeId}/reroll`** – смена челленджа (лимиты, стоимость).
11. **POST `/api/v1/gameplay/battle-pass/boosts/activate`** – активация XP boost (тип, длительность, источник).
12. **GET `/api/v1/gameplay/battle-pass/boosts`** – активные бусты, оставшееся время, бонусы.
13. **GET `/api/v1/gameplay/battle-pass/leaderboard`** – таблица лидеров по очкам челленджей/наградам.
14. **GET `/api/v1/gameplay/battle-pass/analytics/rewards`** – сводка по выдачам, популярности наград, оттоку.
15. **WS `/api/v1/gameplay/battle-pass/stream`** – realtime события: обновления прогресса челленджей, бустов, новых наград.

---

## 🧱 Модели данных

- **RewardDefinition** – level, track (`FREE|PREMIUM`), rewardType (`CURRENCY|ITEM|COSMETIC|XP_BOOST|BUNDLE`), rewardData, rarity, previewAsset.
- **RewardClaimRequest** – level, track, autoClaimExtras, clientContext.
- **RewardClaimResponse** – rewards[], xpEarned, premiumStatus, events[] (ссылки на event bus).
- **RewardHistoryEntry** – rewardId, claimedAt, rewardType, amount, source (`LEVEL|CHALLENGE|BONUS`).
- **Challenge** – id, challengeType (`DAILY|WEEKLY|SEASONAL`), description, objectives[], xpReward, rewardId, startAt, endAt, rerollCost.
- **ChallengeProgress** – challengeId, playerId, status (`IN_PROGRESS|COMPLETED`), progressValue, updatedAt.
- **ChallengeProgressUpdateRequest** – playerId, metric, amount, sourceEventId, allowOverflow.
- **BoostDefinition** – boostId, boostType (`XP|REWARD_RATE|DOUBLE_DROPS`), multiplier, duration, cooldown.
- **BoostActivationRequest** – boostId, activationSource (`TOKEN|EVENT|ADMIN`), cost.
- **RewardAnalyticsResponse** – totalClaims, premiumClaims, rerollUsage, challengeCompletionRate, boostActivationRate, topRewards[].
- **Error Schema (`BattlePassRewardError`)** – code (`LEVEL_LOCKED`, `ALREADY_CLAIMED`, `INSUFFICIENT_TOKEN`, `CHALLENGE_NOT_FOUND`, `BOOST_ACTIVE`, `REROLL_LIMIT`), message, traceId.
- **Events** – `battle-pass:reward-claimed`, `battle-pass:challenge-progressed`, `battle-pass:challenge-completed`, `battle-pass:boost-activated`, `battle-pass:reward-rerolled`.

---

## 🧭 Принципы и правила

- Авторизация: `BearerAuth` для клиентских вызовов; `ServiceToken` для обновления прогресса и генерации челленджей.
- Ограничения: лимит на количество рероллов, анти-спам задержки на прогресс, cooldown на бусты, ограничение выдачи наград per level.
- Инциденты: подозрительные операции отправлять в incident-service; хранить audit trail.
- Валидация валют/предметов через economy/inventory/cosmetic сервисы.
- Взаимодействие с ядром (API-TASK-207) для проверки статуса уровня и премиума.
- Использовать общие ошибки и ответы (`api/v1/shared/common/responses.yaml`).

---

## 🧪 Примеры

- Получение награды 25 уровня с выдачей косметики и валюты.
- Завершение недельного челленджа «Complete 5 daily quests» с начислением XP и предмета.
- Активация XP boost на 2 часа и realtime обновление прогресса.
- Аналитический отчёт по популярности наград премиум-трека.

---

## 🔗 Связности и зависимости

- Использует данные прогресса из `battle-pass-core` (API-TASK-207).
- Синхронизируется с economy/inventory/cosmetic/buff сервисами для выдачи наград.
- Отправляет события в notification-service и analytics-service.
- Поддерживает LiveOps инструменты (challenge generator, boost scheduler).

---

## ✅ Критерии приемки

1. Файл `battle-pass-rewards.yaml` создан с архитектурным комментарием и описанием всех эндпоинтов/WS канала.
2. Прописаны модели наград, челленджей, бустов, аналитики и ошибок.
3. Описаны бизнес-правила, лимиты, события и зависимости от других сервисов.
4. Добавлены примеры запросов/ответов, сценарии тестирования, ссылка на чеклист.
5. Задание самодостаточно и ссылается на API-TASK-207 как зависимость.

---

## 📎 Checklist

- [ ] Структура соответствует `tasks/templates/api-generation-task-template.md`
- [ ] Определён микросервис, фронтенд модуль и зависимости
- [ ] Эндпоинты покрывают выдачу наград, челленджи, бусты, аналитику
- [ ] Описаны модели данных, события, ограничения и безопасность
- [ ] После сохранения обновить `tasks/config/brain-mapping.yaml`

---

## ❓FAQ

**Q:** Можно ли класть WebSocket и REST в один файл?
**A:** Да, но указать, что WS используется для realtime прогресса и событий, с примером handshake и payloadов.

**Q:** Кто вызывает прогресс по челленджам?
**A:** Системные сервисы (quest-service, match-service, events) через `ServiceToken`, чтобы исключить подмену данных игроком.

**Q:** Как обрабатывать ситуацию «награда уже получена»?
**A:** Возвращать `409 Conflict` с ошибкой `ALREADY_CLAIMED`, записывать в аудит и уведомлять analytics-service.


